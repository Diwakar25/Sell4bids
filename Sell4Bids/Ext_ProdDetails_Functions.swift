//
//  Ext_ProdDetails_Functions.swift
//  Sell4Bids
//
//  Created by MAC on 24/07/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Firebase
import GoogleMaps


extension ProductDetailTableVc {
  
    
  func markItemPaidOrUnPaid(flagPaid: Bool ) {
    print("button pressed")
//   print("Product Refrences = \(self.prodReference)")
//
//    prodReference.child("orders").updateChildValues(["buyer_marked_paid": "Yes"])
//
//
    //let order = ordersArray[orderIndex]
    guard flagProductReferenceSet, let auctionType = productData.auctionType else {
      return
    }
    
    if auctionType.lowercased().contains("buy-it-now") {
        markBuyNowOrderPaidUnPaid(flagPaid: flagPaid)
          MarkPaidBuyer = true
    }else {
        self.markAuctionItemPaidUnPaid(flagPaid: flagPaid)
        
        self.MarkPaidBuyer = false
    }
    
    
  }
    
   
  ///only buyer
  func markAuctionItemPaidUnPaid ( flagPaid : Bool ) {
    print("Mark-AutionItemPaidunPaid Applied")
    guard flagProductReferenceSet else {
      return
    }
    
    let strYesNo = flagPaid ? "yes" : "no"
    let strPaidUnPaid = flagPaid ? "Paid" : "UnPaid"
    prodReference.child("bids").child("buyer_marked_paid").setValue(strYesNo) { [weak self] (error, dbRef) in
      guard let strongSelf = self else { return }
      if error == nil  {
        let flagPaid = strYesNo == "yes"
        DispatchQueue.main.async {
          strongSelf.viewYouMarkedPaid.isHidden = !flagPaid
          strongSelf.btnMarkPaid.isHidden = flagPaid
        }
        
      }else {
        strongSelf.showToast(message: "Could not Mark \(strPaidUnPaid)")
      }
    }
    
    
  }
  
  func markBuyNowOrderPaidUnPaid( flagPaid : Bool) {
    print("Mark-BuyNowOrdwePaidUnpaid Applied")
    let orderUsersId = SessionManager.shared.userId
    let state = productData.state! , prodKey = productData.productKey!, cat = productData.categoryName!, auctionType = productData.auctionType!
    let strMarked = flagPaid ? "yes" : "no"
    var ref = FirebaseDB.shared.dbRef.child("products").child(cat).child(auctionType)
    ref = ref.child(state).child(prodKey).child("orders").child(orderUsersId)
    print("firebase link = \(ref)")
    ref.child("buyer_marked_paid").setValue(strMarked) { [weak self] (error, dbRef) in
      guard let this = self else { return }
      //debugPrint("db ref was : \(dbRef)")
      if error == nil {
        let strMarkedAs = "Marked as "
        let message = strMarkedAs + ( flagPaid ? "Paid" : "UnPaid" )
        this.showToast(message: message)
        //this.ordersArray[orderIndex].sellerMarkedPaid = flagPaid
        DispatchQueue.main.async {
            print("value = \(flagPaid)")
          this.viewYouMarkedPaid.isHidden = !flagPaid
          this.btnMarkPaid.isHidden = flagPaid
        }
        
        
      }else {
        this.showToast(message: "Sorry, Database Operation Failed")
      }
    }
    
  }
  
  ///checks the buyer_marked_paid and seller_mark_paid in orders node of a product node. and updates button texts accordingly in tableViewCell
  func observerMarkedItemStatusAndUpdateUI() {
    
    guard flagProductReferenceSet , let auctionType = productData.auctionType else {
      
      return
    }
    
    if auctionType.lowercased().contains("buy") { handleMarkedStatusForBuyNow() }
    else { handleMarkedStatusForAuction() }
    
  }
  
  func handleMarkedStatusForBuyNow() {
    
    let orderUsersId = SessionManager.shared.userId
    //print("ordersUser id : \(orderUsersId)")
    let ref = prodReference.child("orders").child(orderUsersId)
    ref.observe(.value) {[weak self] (snapshot) in
      guard let strongSelf = self else { return }
      guard let ordersValueDict = snapshot.value as? [String:Any] else {
        strongSelf.flagShowCellMarkPaid = false
        print("going to reload 2 ")
        strongSelf.tableViewProdDetails.reloadUsingDispatch()
        return
      }
      if let sellerMarkedPaid = ordersValueDict["seller_marked_paid"] as? String {
        let flagSellerMarkedPaid = sellerMarkedPaid.lowercased() == "yes"
        DispatchQueue.main.async {
          strongSelf.viewSellerMarkedPaid.isHidden = !flagSellerMarkedPaid
            
          
        }
      }
      
      if let buyerMarkedPaid = ordersValueDict["buyer_marked_paid"] as? String {
        let flagBuyerMarkedPaid = buyerMarkedPaid.lowercased() == "yes"
        DispatchQueue.main.async {
          strongSelf.viewYouMarkedPaid.isHidden = !flagBuyerMarkedPaid
          strongSelf.btnMarkPaid.isHidden = flagBuyerMarkedPaid
        }
      }
      
    }
    
  }
  
  func handleMarkedStatusForAuction () {
    ///Check if logged in user is winner by matching winner id in bids with logged in userID
    func isLoggedInUserWinner ( completion: @escaping (Bool, Bool) -> ()  ) {
      let bidsRef = prodReference.child("bids")
      bidsRef.child("winner").observeSingleEvent(of: .value) { (snapShot) in
        guard let winnerID = snapShot.value as? String else {
          completion(false, false)
          return
        }
        let loggedInUserId = SessionManager.shared.userId
        let loggedInUserIsWinner =  loggedInUserId == winnerID
        completion(true, loggedInUserIsWinner)
      }
    }
    
    ///check ratings node of this product -> userID -> rating. if rating == 0 || 1 To 5, order is accepted
    func isOrderAccepted( completion :@escaping ( Bool, Bool ) -> () ) {
      let loggedInUserID = SessionManager.shared.userId
      let ref = prodReference.child("ratings").child(loggedInUserID)
      ref.child("rating").observeSingleEvent(of: .value
        , with: { (snapShot) in
          guard let ratingStr = snapShot.value as? String else {
            completion(false, false )
            return
          }
          let validRatingStrs : [String]  = ["0", "1", "2", "3", "4", "5"]
          let validRating =  validRatingStrs.contains(ratingStr)
          completion(true, validRating)
      })
    }
    ///checks if user buyer and seller has marked paid and shows the appropriate views.
    func handleShowingMarkedPaid() {
      
      isLoggedInUserWinner { [weak self] (success, isWinner) in
        guard let strongSelf = self else { return }
        guard success, isWinner else {
          strongSelf.flagShowCellMarkPaid = false
          return
        }
        //current Logged In User is winner
        isOrderAccepted(completion: { [weak self] (success, accepted) in
          guard let this = self else { return }
          this.flagShowCellMarkPaid = accepted
          print("going to reload 3 ")
          this.tableViewProdDetails.reloadUsingDispatch()
        })
        
        hasSellerMarkedPaid(completion: { [weak self] (Success, markedPaid) in
          guard let StrongInner = self else { return }
          DispatchQueue.main.async {
            StrongInner.viewSellerMarkedPaid.isHidden = !markedPaid
          }
        })
        hasBuyerMarkedPaid(completion: { [weak self] (Success, markedPaid) in
          guard let StrongInner = self else { return }
          DispatchQueue.main.async {
            StrongInner.viewYouMarkedPaid.isHidden = !markedPaid
            StrongInner.btnMarkPaid.isHidden = markedPaid
          }
        })
        
      }
      
    }
    
    func hasSellerMarkedPaid(completion: @escaping ( Bool, Bool) -> () ) {
      prodReference.child("bids").child("seller_marked_paid").observe(.value) { (snapShot) in
        guard let strSellerMarkedPaid = snapShot.value as? String, strSellerMarkedPaid == "yes" else {
          completion(false, false )
          return
        }
        completion(true, true)
        
      }
    }
    
    func hasBuyerMarkedPaid(completion: @escaping ( Bool, Bool) -> () ) {
      prodReference.child("bids").child("buyer_marked_paid").observe(.value) { (snapShot) in
        guard let strBuyerMarkedPaid = snapShot.value as? String, strBuyerMarkedPaid == "yes" else {
          completion(false, false )
          return
        }
        completion(true, true)
        
      }
    }
    ////Main execution
    
    handleShowingMarkedPaid()
    
    
  }
  
  ///if product type is buy now, and its listing time is remaining or listing time is -1 (list indefinitely), add a button to the button stack to end the listing
  
  func checkAndEnableEndListingButton() {
    guard let auctionType = productData.auctionType else {
      print("guard let auctionType = productData.auctionType failed in \(self)")
      return
    }
    if auctionType.lowercased().contains("buy") {
      //check listing time
      guard let endTime = productData.endTime else {
        print("guard let endTime = productData.endTime failed. Going to return ")
        return
      }
      
      getCurrentServerTime(completion: { [weak self ] (success, currentTime) in
        guard let this = self else { return  }
        
        let timeRemaining = ( endTime - Int64(currentTime) ) > 0
        if endTime == -1 || timeRemaining {
          //show end listing button in a stack
         this.flagShowBtnEndListing = true
          this.btnEndListing.isHidden = false
            
        }else{
          this.flagShowBtnEndListing = false
          this.btnEndListing.isHidden = true
        }
        
        if (self!.isBid) {
            this.flagShowBtnEndListing = false
            this.btnEndListing.isHidden = true
            this.EditingDisablebtn.isHidden = true
            
        }
        
        
      })
      
      
    }
  }
  
   func updateIfSellerSharedLocation() {
    guard flagProductReferenceSet else {
      print("guard flagProductReferenceSet failed in \(self)")
      return
    }
    prodReference.child("orders").observe(.value, with: { [weak self] (ordersSnapShot) in
      guard let this = self else { return }
      guard let dictOrdersOnThisProduct = ordersSnapShot.value as? NSDictionary else {
        print("guard let dictOrdersOnThisProduct = ordersSnapShot.value as? [String:AnyObject] faiiled in \(this). Going to return")
        return
      }
        
        
        for key in dictOrdersOnThisProduct.allKeys {
        
            let Userkey = key as! String
        
            if  Userkey == SessionManager.shared.userId{
        print("Key Found")
        //this user has order on this product so now check if user has location node
        guard let valueOfOrder = dictOrdersOnThisProduct[SessionManager.shared.userId] as? NSDictionary else {
          print("guard let valueOfOrder = dictOrdersOnThisProduct[SessionManager.shared.userId] as ? [String:AnyObject] failed. Going to return")
          
          return
        }
                print("Dict == \(valueOfOrder.allKeys)")
       
            print("Seller Location find")
          //seller has shared location
                
                
        
          guard let address = valueOfOrder["address"] as? String else {
            print("address not found")
            return
          }
                
                this.cityLabel.text = address
                this.mapLocationMessage.text = "Seller has shared exact location to meet"
          
          guard let latitude = valueOfOrder["latitude"] as? Double  else {
            print("latitude not found")
            return
          }
                print("latitude = \(latitude)")
          guard let longitude = valueOfOrder["longitude"] as? Double else {
            print("londitude not found")
            return
          }
                
                
                print("latitude == \(latitude)")
                print("longitude == \(longitude)")
                
          let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
          
               
          this.mapView.camera = GMSCameraPosition(target: coordinate, zoom: 15, bearing: 0, viewingAngle: 0)

          let marker = GMSMarker(position: coordinate)
          marker.title = address
          marker.map = this.mapView
       
          
            
          
         
          
      }
        }
    }) { (error) in
      //self.alert(message: "Sorry, Could not ")
      print(error.localizedDescription)
    }
  }
  
  @objc func showFeedBackForm() {
    let feedbackVC = storyboard?.instantiateViewController(withIdentifier: "feedbackVC")
    self.navigationController?.pushViewController(feedbackVC!, animated: true)
  }
  
  //validates the product data and returns a Database reference to this product. If data is not correct, returns false and database reference points to
  func setProductReference() -> (Bool, DatabaseReference ) {
    
    var prodRef  = FirebaseDB.shared.dbRef.child("TempNode")
    guard let category = productData.categoryName else{
      return (false, prodRef)
    }
    
    guard let auctionType = productData.auctionType else{
      return (false, prodRef)
    }
    
    guard let state = productData.state else{
      return (false, prodRef)
    }
    
    guard let productID = productData.productKey else{
      return (false, prodRef)
    }
    
    
    
    prodRef = FirebaseDB.shared.dbRef.child("products").child(category).child(auctionType).child(state).child(productID)
    
    return (true, prodRef)
  }
  
  ///check if the sender has sent a counter offer to this user. Go to the counter offer node of this product and see if it exists. if exists,
   func hasThisProductCounterOfferForUser(completion: @escaping (Bool) ->() ) {
    
    guard let catName = productData.categoryName else {
      completion(false)
      return
    }
    guard let auctionType = productData.auctionType else {
      completion(false)
      return
    }
    guard let state = productData.state else {
      completion(false)
      return
    }
    guard let productKey =  productData.productKey else {
      completion(false)
      return
    }
    
    let query = dbRef.child("products").child(catName).child(auctionType).child(state).child(productKey).child("counterOffers")
    
    
    query.observeSingleEvent(of: .value) { [weak self] (snapshotCounterOffers: DataSnapshot) in
      guard let this = self else { return }
      
      if snapshotCounterOffers.childrenCount != 0 {
        //if there are no childs for counterOffers, don't have to do anything. button will be hidden by default
        
        guard let valueCounterOffers = snapshotCounterOffers.value as? [String: AnyObject] else {
          print("guard let valueCounterOffers = snapshotCounterOffers as? [String: AnyObject]  failed in \(this)")
          return
        }
        let dictCounterOffers = valueCounterOffers
        //now check if this users id exists in counterOffers Keys
        if dictCounterOffers.keys.contains(SessionManager.shared.userId) {
          print("Seller has sent a counter offer to this buyer. ")
          guard let counterOfferDetailsDict = dictCounterOffers[SessionManager.shared.userId] as? [String:AnyObject] else {
            print("Erro: could not get counter offer details in \(this)")
            return
          }
          //if counter offer details has key price per item and quantity
          if counterOfferDetailsDict.keys.contains("pricePerItem") &&
            counterOfferDetailsDict.keys.contains("quantity") {
            completion(true)
            
          }else {
            completion(false)
          }
        }
      }//end if snapshotCounterOffers.childrenCount != 0
      else {
        completion(false)
      }
    }
    
    
    
  }
  
  func pushOfferHistoryTableVC() {
    let prodDetailsSB = getStoryBoardByName(storyBoardNames.prodDetails)
    let offerHistoryTableVC = prodDetailsSB.instantiateViewController(withIdentifier: "offerHistoryTableVC") as! offerHistoryTableVC
    guard let _ = productData else {
      print("guard let productData = productData failed in pushOfferHistoryTableVC ")
      return
      
    }
    offerHistoryTableVC.product = self.productData
    navigationController?.pushViewController(offerHistoryTableVC, animated: true)
  }
  func performViewDidLoad() {
 
    dimView.alpha = 0
    //for rating
    guard let productData = productData, let startPrice = productData.startPrice else {return}
    priceLabel.text = "\(startPrice)"
    
    NotificationCenter.default.post(Notification(name: NSNotification.Name(rawValue: NSNotification.Name.RawValue("displayRatingsPromptIfRequired")), object: nil, userInfo: nil))
    
    
    fillImageUrlsArray()
    pageController.currentPage = 0
    pageController.numberOfPages = imageUrlStringsForProduct.count
    
    self.computeAndSetPostedTimeLabel()
    
    print("Product City = \(productData.city)")
  
    if productData.city != nil {
        DispatchQueue.main.async { [weak self ] in
            
            self!.geocoder.geocodeAddressString(productData.city!) { (placemarks, error) in
                // Process Response
                if error != nil {
                    print("Error = \(error) , city name = \(productData.city)")
                    
                    self!.processResponse(withPlacemarks: placemarks, error: error)
                }
               
            
            }
        }
        
    }else {
        DispatchQueue.main.async { [weak self ] in
            
            self!.geocoder.geocodeAddressString(city) { (placemarks, error) in
                // Process Response
                print("Error = \(error) , city name = \(city)")
                
                self!.processResponse(withPlacemarks: placemarks, error: error)
                self!.updateIfSellerSharedLocation()
            }
        }
    }
    
    
    if SessionManager.shared.userId == productData.userId{
      ownerButtonsStack.isHidden = false
    }
    else{
      ownerButtonsStack.isHidden = true
      flagShowBuyerButtons = true
      print("going to reload 1")
      tableViewProdDetails.reloadUsingDispatch()
    }
    print("view did load")
    //settingServentCurrentTime()
    displayProducDetail()
    handlingBiddingAndOffersList()
    checkWatchList()
    
    getUserData()
    setButtons()
    setupViews()
    
    //when start price will be chane because of bidding then this listner will updateh the value of price tag
    
    guard let categoryName = productData.categoryName, let auctionType = productData.auctionType, let stateName = productData.state,let productKey = productData.productKey else {return}
    self.dbRef.child("products").child(categoryName).child(auctionType).child(stateName).child(productKey).child("startPrice").observe(.value) { [weak self] (snapshot) in
      guard let this = self else { return }
      
      if let price = snapshot.value as? String {
        this.priceLabel.text = price
      }
    }
    //EndALiCode
    //addBarButtonItemToNav()
    
    
    hasThisProductCounterOfferForUser { [weak self] (success) in
      guard let this = self else { return }
      if success {
        this.flagShowViewCounterOffer = true
        this.btnViewCounterOfferTapped(UIButton() )
      }
      this.tableView.beginUpdates()
      this.tableView.endUpdates()
      
    }
    //observer for showing feedback form
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.showFeedBackForm), name: NSNotification.Name(rawValue: NSNotification.Name.RawValue("ShowFeedBackForm")), object: nil)
    //if user has bought or win this item, show ratings prompt
    //hasUserBoughtOrWinThisItem()
    ///update the map if seller has share exact location
    checkAndEnableEndListingButton()
    
    observerMarkedItemStatusAndUpdateUI()
    DispatchQueue.main.async {
      self.sliderCollView.reloadData()
      self.selectorCollView.reloadData()
      self.colViewProductImagesPopup.reloadData()
    }
    
  }
  
  func fillImageUrlsArray() {
    if let _ = productData {
      if let image0 = productData.imageUrl0 {
        imageUrlStringsForProduct.append(image0)
      }
      if let image1 = productData.imageUrl1 {
        imageUrlStringsForProduct.append(image1)
      }
      if let image2 = productData.imageUrl2 {
        imageUrlStringsForProduct.append(image2)
      }
      if let image3 = productData.imageUrl3 {
        imageUrlStringsForProduct.append(image3)
      }
      if let image4 = productData.imageUrl4 {
        imageUrlStringsForProduct.append(image4)
      }
    }
    
  }
  
  func updateTimeRemOfProductInDB(){
    guard let categoryName = productData.categoryName,
      let aucType = productData.auctionType, let productKey = productData.productKey,let state = productData.state, let endTime = productData.endTime else {return}
    let currentMili = Date().currentTimeInMiliseconds()
    let  TimeRemaining =  endTime - currentMili!
    print("current Mili = \(currentMili!) , End Time  = \(endTime) , time remaining = \(TimeRemaining)")
    
    dbRef.child("products").child(categoryName).child(aucType).child(state).child(productKey).child("timeRemaining").setValue(TimeRemaining)
    
  }
  
  func writeInBoughtAndWins(boughtPrice:Int, boughtQuantity: Int) {
    let currentUserId = SessionManager.shared.userId
    var category = "Others"
    if let cat = productData.categoryName {
      category = cat
    }
    var stateVar = "NY"
    if let state = productData.state {
      stateVar = state
    }
    let dictBoughtItem :Dictionary = ["auctionType": "buy-it-now",
                                      "boughtPrice":  "\(boughtPrice)",
      "boughtQuantity": "\(boughtQuantity)",
      "category": category,
      "state": stateVar]
    guard let prodKey = productData.productKey else {
      print("Warning. Could not get product key from product data . Returning")
      return
    }
    dbRef.child("users").child(currentUserId).child("products").child("bought").child(prodKey).setValue(dictBoughtItem) { (error, resp) in
      guard error == nil else {
        print("could not write bought item in users node. ")
        print(error as Any)
        return
      }
      print("no error writing bought item in users node. ")
      print(resp)
    }
    print("user id -> products -> bought and wins. written this bought item in bought and wins")
  }
  ///used in acceptCounterOfferBtnTapped
  func deleteCounterOfferNode( ) {
    //get the product reference
    let productRef = self.prodReference
    //go into -> counter offers node -> userId. and delete the node
    productRef?.child("counterOffers").child(SessionManager.shared.userId).removeValue()
    
  }
  
}
