//
//  Ext_Prod_Details_Actions.swift
//  Sell4Bids
//
//  Created by MAC on 24/07/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Firebase

extension ProductDetailTableVc {
  @IBAction func SharedIconPressed(_ sender: UIButton) {
    print("shared Icon Pressed")
    
    let textToShare = "Sell4Bids is awesome!  Check out this website about it!"
    
    if let myWebsite = NSURL(string: "https://www.sell4bids.com/") {
      let objectsToShare = [textToShare, myWebsite] as [Any]
      let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
      
      activityVC.popoverPresentationController?.sourceView = sender
      activityVC.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
      activityVC.popoverPresentationController?.sourceRect = sender.bounds
      self.present(activityVC, animated: true, completion: nil)
      
      
    }
    
  }
  
  @IBAction func ShareButtonPressed(_ sender: UIButton) {
    
    
    let textToShare = "Check out this item that i found on The Sell4Bids Marketplace."
    guard let cat = productData.categoryName , let auction = productData.auctionType, let state = productData.state, let prodId = productData.productKey else {
      showSwiftMessageWithParams(theme: .error, title: PromptMessages.title_We_cantShare, body: PromptMessages.msgIncompleteProductData)
      return
    }
    guard let catEncoded = cat.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
      return
    }
    var urlString = "https://www.sell4bids.com/item?cat=\(catEncoded)"
    urlString.append("&auction=\(auction)")
    urlString.append("&state=\(state)")
    urlString.append("&pid=\(prodId)")
    
    guard let url = URL.init(string: urlString ) else { return }
    
    let objectsToShare = [textToShare, url] as [Any]
    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
    
    activityVC.popoverPresentationController?.sourceView = sender
    activityVC.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
    activityVC.popoverPresentationController?.sourceRect = sender.bounds
    self.present(activityVC, animated: true, completion: nil)
    
    
    
    
  }
  
  @IBAction func acceptOfferBtnAction(_ sender: UIButton) {
    
    guard let state = productData.state else{
      
      self.alert(message: "state is not found", title: "ERROR")
      return
    }
    
    guard let auctionType = productData.auctionType else{
      self.alert(message: "Auction type is not found", title: "ERROR")
      return
    }
    
    guard let productID = productData.productKey else{
      self.alert(message: "Product ID is not found", title: "ERROR")
      return
    }
    
    guard let category = productData.categoryName else{
      self.alert(message: "Product Category is not found", title: "ERROR")
      return
    }
    let ref = FirebaseDB.shared.dbRef.child("products").child(category).child(auctionType).child(state).child(productID)
    if acceptOffersBtn.titleLabel?.text == "Stop Accepting Offers" {
      
      let alertController = UIAlertController(title: "Offers", message: "Buyers will not be able to send you offers on different amount per item.", preferredStyle: .alert)
      
      // Create OK button
      let OKAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
        
        // Code in this block will trigger when OK button tapped.
        let dic = ["acceptOffers":"no"]
        ref.updateChildValues(dic)
        self.acceptOffer = "no"
        self.acceptOffersBtn.setTitle("Accept Offers", for: .normal)
        self.acceptOffersBtn.backgroundColor = UIColor.darkGray
        self.acceptOffersBtn.setTitleColor(UIColor.white, for: .normal)
        self.acceptOffersBtn.layer.borderColor = UIColor.darkGray.cgColor
        self.acceptOffersBtn.layer.cornerRadius = 5
        self.acceptOffersBtn.layer.borderWidth = 1
        
        self.alert(message: "Buyer will view your item send offers to on price per item set by you during listing", title: "Offers")
        
        
      }
      alertController.addAction(OKAction)
      
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
        print("Cancel button tapped")
      }
      alertController.addAction(cancelAction)
      
      // Present Dialog message
      self.present(alertController, animated: true, completion:nil)
      
      
    }
    else if acceptOffersBtn.titleLabel?.text == "Accept Offers" {
      
      let alertController = UIAlertController(title: "Offers", message: "Buyers will  be able to send you offers on different amount per item.", preferredStyle: .alert)
      
      // Create OK button
      let OKAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
        
        // Code in this block will trigger when OK button tapped.
        let dic = ["acceptOffers":"yes"]
        ref.updateChildValues(dic)
        self.acceptOffer = "yes"
        self.acceptOffersBtn.setTitle("Stop Accepting Offers", for: .normal)
        self.acceptOffersBtn.backgroundColor = UIColor.white
        self.acceptOffersBtn.setTitleColor(UIColor.darkGray, for: .normal)
        self.acceptOffersBtn.layer.borderColor = UIColor.darkGray.cgColor
        
        self.acceptOffersBtn.layer.cornerRadius = 5
        self.acceptOffersBtn.layer.borderWidth = 1
        self.alert(message: "You are now accepting offers on this item.", title: "Success")
        
        
        //self.blockedUsersData()
      }
      alertController.addAction(OKAction)
      
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
        print("Cancel button tapped")
      }
      alertController.addAction(cancelAction)
      
      // Present Dialog message
      self.present(alertController, animated: true, completion:nil)
    }
    
  }
  

  
  @IBAction func btnViewCounterOfferTapped(_ sender: UIButton) {
    getCounterOfferForBuyer { (counterOffer) in
      self.protocolForViewCounterOfferbtn?.viewCounterOfferTapped(counterOffer:counterOffer)
    }
    
  }
  ///gets the counter offer for this product for this buyer if any and stores in lazy var
  //'getCounterOfferForBuyer'
  private func getCounterOfferForBuyer( completion: @escaping (CounterModel) ->()  ) {
    //get the details of counter offer from product node and send to parent to show details in popup
    guard flagProductReferenceSet == true else {
      print("Database reference of product is not set. Going to return")
      return
    }
    guard let prodRef = self.prodReference else {
      print("Could not get database reference to the product. Going to return")
      return
    }
    prodRef.child("counterOffers").child(SessionManager.shared.userId).observeSingleEvent(of: .value) { [weak self] (counterOffersSnapShot) in
      guard let this = self else { return }
      guard let dictCounterOfferValue = counterOffersSnapShot.value as? [String:AnyObject] else {
        print("guard let dictCounterOfferValue = counterOffersSnapShot.value as? [String:AnyObject] failed in \(this)")
        
        completion(this.counterOfferForThisProductForBuyer)
        return
      }
      
      let userId = counterOffersSnapShot.key
      
      let counterOffer = CounterModel.init(userId: userId, counterDict: dictCounterOfferValue)
      this.counterOfferForThisProductForBuyer = counterOffer
      completion(counterOffer)
    }
    
    
  }
  
  @IBAction func btnSetSecondsTapped(_ sender: UIButton) {
    
    let alertController = UIAlertController(title: "Set time of this product", message: "Enter number of seconds", preferredStyle: .alert)
    alertController.addTextField { (textField : UITextField!) -> Void in
      textField.placeholder = "Enter Seconds here"
    }
    let doneAction = UIAlertAction(title: "Set", style: .default) { (action) in
      let textField = alertController.textFields![0] as UITextField
      guard let text = textField.text , !text.isEmpty else {
        return
      }
      print("set timer here ")
      guard let secondsInt = Int64(text) else { return }
      self.productData.endTime = Int64 (Date().timeIntervalSince1970 * 1000) + (secondsInt * 1000)
      //print("self.productData.endTime : \(self.productData.endTime)")
      self.timer.invalidate()
//      self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer(currentTime: )), userInfo: nil, repeats: true)
      self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: true)
    }
    
    alertController.addAction(doneAction)
    self.present(alertController, animated: true)
    
  }
  
  @IBAction func orderingBtnAction(_ sender: UIButton) {
    
    guard let state = productData.state else{
      
      self.alert(message: "state is not found", title: "ERROR")
      return
    }
    
    guard let auctionType = productData.auctionType else{
      self.alert(message: "Auction type is not found", title: "ERROR")
      return
    }
    
    guard let productID = productData.productKey else{
      self.alert(message: "Product ID is not found", title: "ERROR")
      return
    }
    
    guard let category = productData.categoryName else{
      self.alert(message: "Product Category is not found", title: "ERROR")
      return
    }
    
    
    
    
    
    
    
    
    let ref = FirebaseDB.shared.dbRef .child("products").child(category).child(auctionType).child(state).child(productID)
    
    
    if self.newOrderBtn.titleLabel?.text == "Stop New Orders" {
      
      let alertController = UIAlertController(title: "Ordering", message: "Are you sure you want to stop receiving new orders from buyer on this item?", preferredStyle: .alert)
      
      // Create OK button
      let OKAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
        
        // Code in this block will trigger when OK button tapped.
        let dic = ["ordering":"stopped"]
        ref.updateChildValues(dic)
        self.orderEnabled = "no"
        self.newOrderBtn.setTitle("Get New Orders", for: .normal)
        self.newOrderBtn.backgroundColor = UIColor.darkGray
        self.newOrderBtn.setTitleColor(UIColor.white, for: .normal)
        self.newOrderBtn.layer.borderColor = UIColor.darkGray.cgColor
        self.newOrderBtn.layer.cornerRadius = 5
        self.newOrderBtn.layer.borderWidth = 1
        self.alert(message: "Buyers will not be able to send  offers to you. You can continue receiving new offers by clicking 'Get New Orders' anytime.", title: "Ordering")
      }
      alertController.addAction(OKAction)
      
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
        print("Cancel button tapped")
      }
      alertController.addAction(cancelAction)
      
      // Present Dialog message
      self.present(alertController, animated: true, completion:nil)
      
    }
    else if newOrderBtn.titleLabel?.text == "Get New Orders" {
      
      
      
      let alertController = UIAlertController(title: "Ordering", message: "Get new orders from buyer on this item ?", preferredStyle: .alert)
      
      // Create OK button
      let OKAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
        
        // Code in this block will trigger when OK button tapped.
        let dic = ["ordering":"yes"]
        ref.updateChildValues(dic)
        self.orderEnabled = "yes"
        self.newOrderBtn.setTitle("Stop New Orders", for: .normal)
        self.newOrderBtn.backgroundColor = UIColor.white
        self.newOrderBtn.setTitleColor(UIColor.darkGray, for: .normal)
        self.newOrderBtn.layer.borderColor = UIColor.darkGray.cgColor
        
        self.newOrderBtn.layer.cornerRadius = 5
        self.newOrderBtn.layer.borderWidth = 1
        self.alert(message: "Buyer will view your item and send you offers.", title: "Ordering")
      }
      alertController.addAction(OKAction)
      
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
        print("Cancel button tapped")
      }
      alertController.addAction(cancelAction)
      
      // Present Dialog message
      self.present(alertController, animated: true, completion:nil)
      
      
    }
    
    
  }
  
  @IBAction func setStockQuantTapped(_ sender: UIButton) {
    
    
    let dic = ["category":productData.categoryName,"state":productData.state,"auctionType":productData.auctionType,"id":productData.productKey]
    
    self.performSegue(withIdentifier: "fromProductDetailTosetQuantity", sender: dic)
    
  }
  
  @IBAction func visibilityBtnAction(_ sender: UIButton) {
    
    guard let state = productData.state else{
      
      self.alert(message: "state is not found", title: "ERROR")
      return
    }
    
    guard let auctionType = productData.auctionType else{
      self.alert(message: "Auction type is not found", title: "ERROR")
      return
    }
    
    guard let productID = productData.productKey else{
      self.alert(message: "Product ID is not found", title: "ERROR")
      return
    }
    
    guard let category = productData.categoryName else{
      self.alert(message: "Product Category is not found", title: "ERROR")
      return
    }
    
    
    let ref = FirebaseDB.shared.dbRef.child("products").child(category).child(auctionType).child(state).child(productID)
    
    
    if self.productVisibilityBTn.titleLabel?.text == "Hide Item" {
      
      let alertController = UIAlertController(title: "Item visibility", message: "Hide: Item will be hidden from new viewers in search result but will apppear to old viewers, like in watch list", preferredStyle: .alert)
      
      // Create OK button
      let OKAction = UIAlertAction(title: "Hide", style: .default) { (action:UIAlertAction!) in
        
        // Code in this block will trigger when OK button tapped.
        
        let dic = ["visibility":"hidden"]
        ref.updateChildValues(dic)
        //orderEnabled = "no"
        self.productVisibilityBTn.setTitle("Show Item", for: .normal)
        
        self.productVisibilityBTn.backgroundColor = UIColor.darkGray
        self.productVisibilityBTn.setTitleColor(UIColor.white, for: .normal)
        self.productVisibilityBTn.layer.borderColor = UIColor.darkGray.cgColor
        self.productVisibilityBTn.layer.cornerRadius = 5
        self.productVisibilityBTn.layer.borderWidth = 1
        
        //  self.alert(message: "Buyer will view your item send offers to on price per item set by you during listing", title: "Offers")
        
        
      }
      alertController.addAction(OKAction)
      
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
        print("Cancel button tapped")
      }
      alertController.addAction(cancelAction)
      
      // Present Dialog message
      self.present(alertController, animated: true, completion:nil)
      
      
      
    }
    else if productVisibilityBTn.titleLabel?.text == "Show Item" {
      
      
      let alertController = UIAlertController(title: "Item visibility", message: "Show: Item will be visible to new users", preferredStyle: .alert)
      
      // Create OK button
      let OKAction = UIAlertAction(title: "Show", style: .default) { (action:UIAlertAction!) in
        
        // Code in this block will trigger when OK button tapped.
        
        let dic = ["visibility":"shown"]
        ref.updateChildValues(dic)
        //orderEnabled = "yes"
        self.productVisibilityBTn.setTitle("Hide Item", for: .normal)
        self.productVisibilityBTn.backgroundColor = UIColor.white
        self.productVisibilityBTn.setTitleColor(UIColor.darkGray, for: .normal)
        self.productVisibilityBTn.layer.borderColor = UIColor.darkGray.cgColor
        self.productVisibilityBTn.layer.cornerRadius = 5
        self.productVisibilityBTn.layer.borderWidth = 1
        
        // self.alert(message: "Buyer will view your item send offers to on price per item set by you during listing", title: "Offers")
        
        
      }
      alertController.addAction(OKAction)
      
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
        print("Cancel button tapped")
      }
      alertController.addAction(cancelAction)
      
      // Present Dialog message
      self.present(alertController, animated: true, completion:nil)
      
      
      
      
      
      
    }
  }
  
  @IBAction func relistBtnAction(_ sender: UIButton) {
    
    guard let state = productData.state else{
      
      self.alert(message: "state is not found", title: "ERROR")
      return
    }
    
    guard let auctionType = productData.auctionType else{
      self.alert(message: "Auction type is not found", title: "ERROR")
      return
    }
    
    guard let productID = productData.productKey else{
      self.alert(message: "Product ID is not found", title: "ERROR")
      return
    }
    
    guard let category = productData.categoryName else{
      self.alert(message: "Product Category is not found", title: "ERROR")
      return
    }
    
    let dic = ["state":state,"auctionType":auctionType,"productID":productID,"category":category]
    self.performSegue(withIdentifier: "fromDetailToRelistPopUp", sender: dic)
    
    
  }
  
  @IBAction func turbuChargeBtnAction(_ sender: UIButton) {
    
    guard let state = productData.state else{
      
      self.alert(message: "state is not found", title: "ERROR")
      return
    }
    
    guard let auctionType = productData.auctionType else{
      self.alert(message: "Auction type is not found", title: "ERROR")
      return
    }
    
    guard let productID = productData.productKey else{
      self.alert(message: "Product ID is not found", title: "ERROR")
      return
    }
    
    guard let category = productData.categoryName else{
      self.alert(message: "Product Category is not found", title: "ERROR")
      return
    }
    
    
    
    
    
    let ref = FirebaseDB.shared.dbRef.child("products").child(category).child(auctionType).child(state).child(productID)
    
    let dic = ["chargeTime":ServerValue.timestamp()]
    ref.updateChildValues(dic)
    self.alert(message: "Product is turbo charged", title: "Turbo Charge")
    
    
  }
  
  @IBAction func closeSliderPopUp(_ sender: UIButton) {
    
    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
      
      if let parent = self.parent as? ProductDetailVc {
        parent.dimBackground(flag: false)
      }
      
      self.sliderView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
      
    }) { (success) in
      self.sliderView.removeFromSuperview()
      
    }
    
  }
  
  
  
  //MARK: - IBActions and user interaction
  
  @IBAction func btnViewOfferHistoryTapped(_ sender: UIButton) {
    pushOfferHistoryTableVC()
  }
  
  @IBAction func btnRateSellerTapped(_ sender: UIButton) {
    updateSellerRatings()
  }
  
  @IBAction func btnYouMarkedPaidTapped(_ sender: UIButton) {
    
    let alert = UIAlertController(title: strMarkasUnPaid , message: strQuesYouWantToMarkUnPaid , preferredStyle: .alert)
    let actionYes = UIAlertAction(title: "Yes", style: .destructive) { (action) in
        
       
     // let order = ordersArray[sender.tag]
      
      self.markItemPaidOrUnPaid(flagPaid: true)
    }
    let actionNo = UIAlertAction(title: "No", style: .default, handler: nil)
    
    alert.addAction(actionYes)
    alert.addAction(actionNo)
   // self.markItemPaidOrUnPaid(flagPaid: false)
    self.present(alert, animated: true)
    
  }
  
  @IBAction func btnMarkPaidTapped(_ sender: UIButton) {
    markItemPaidOrUnPaid(flagPaid: true)
    
  }
  
  @IBAction func btnEndListingTapped(_ sender: Any) {
    self.performSegue(withIdentifier: "detailTableToEndListing", sender: self)
  }
  
  
  ///Deletes the counter offer node for this buyer for this product. take the quantity and offer amount from counter offer node and place in orders node. also //also place rating and note attribute.
  func acceptCounterOfferBtnTapped() {
    
    deleteCounterOfferNode()
    print("acceptCounterOfferBtnTapped. User going to accept the counter offer sent by seller ")
    
    //we already had stored the counter offer in lazy var getCounterOfferForBuyer
    print(counterOfferForThisProductForBuyer)
    //now take the price per item and quantity and place in orders node of this product
    
    //get the product reference
    guard flagProductReferenceSet else {
      print("(acceptCounterOfferBtnTapped) Product reference is not set. Going to return")
      self.alert(message: "Sorry, Something went wrong ")
      return
    }
    //force unwrap because prod reference already set
    let prodRef = prodReference!
    let pricePerItem = counterOfferForThisProductForBuyer.pricePerItem
    let quantity = counterOfferForThisProductForBuyer.quantity
    let orderRef = prodRef.child("orders").child(SessionManager.shared.userId)
    orderRef.child("boughtPrice").setValue("\(pricePerItem)")
    orderRef.child("boughtQuantity").setValue("\(quantity)")
    orderRef.child("rating").setValue("0")
    orderRef.child("note").setValue("The buyer accepted counter offer sent by seller.")
   
    self.alert(message: "Congrats! You accepted the counter offer sent by seller.")
    //send a message to detailVC to hide the counter offer view
    self.protocolForViewCounterOfferbtn?.offerRejectedHidePopup()
    flagShowViewCounterOffer = false
    tableViewProdDetails.beginUpdates()
    tableViewProdDetails.endUpdates()
    //write this product in bought and wins for this user
    
    //go to user id -> products -> bought and wins and write a new key value pair
    writeInBoughtAndWins(boughtPrice: pricePerItem, boughtQuantity: quantity)
    
    guard let prodKey = productData.productKey else {
      print("guard let id = productData.productKey failed in \(self)")
      return
    }
    //removeFromBuyingAndBids
    self.dbRef.child("users").child(SessionManager.shared.userId).child("products").child("buying").child(prodKey).removeValue()
  }
  
  
  func rejectCounterOfferBtnTapped(flagShowMessage:Bool = true) {
    print("rejectCounterOfferBtnTapped. User going to reject the counter offer sent by seller ")
    //delete the quantity and price per item from counter offers of that product
    
    guard let state = productData.state else{
      
      self.alert(message: "state is not found", title: "ERROR")
      return
    }
    
    guard let auctionType = productData.auctionType else{
      self.alert(message: "Auction type is not found", title: "ERROR")
      return
    }
    
    guard let productID = productData.productKey else{
      self.alert(message: "Product ID is not found", title: "ERROR")
      return
    }
    
    guard let category = productData.categoryName else{
      self.alert(message: "Product Category is not found", title: "ERROR")
      return
    }
    let ref = FirebaseDB.shared.dbRef.child("products").child(category).child(auctionType).child(state).child(productID).child("counterOffers").child(SessionManager.shared.userId)
    
    ref.child("pricePerItem").removeValue()
    ref.child("quantity").removeValue()
    
    flagShowViewCounterOffer = false
    
    tableViewProdDetails.beginUpdates()
    tableViewProdDetails.endUpdates()
    if flagShowMessage { self.alert(message: "You rejected the counter Offer sent by Seller.") }
    
    //send a message to detailVC to dismiss the popup view and toggle dim to false
    protocolForViewCounterOfferbtn?.offerRejectedHidePopup()
  }
  ///buyer wants to send counter offer to seller
  func sendCounterOfferBtnTapped(offerFromBuyerToSeller:[String:AnyObject]) {
    //update the orders node price per item and quantity of this product for this user
    //will have data at this point
    if flagProductReferenceSet {
      //go to orders
      prodReference.child("orders").child(SessionManager.shared.userId).setValue(offerFromBuyerToSeller)
      //If user wants to send counter offer to seller. basically, he/she rejected the previosu counter offer of seller
      rejectCounterOfferBtnTapped(flagShowMessage: false)
      self.alert(message: "Congrats. you Successfully sent counter offer to seller.")
      
    }
    
  }
  
  @IBAction func btnEditListingTapped(_ sender: UIButton) {
    let editListingVC = storyboard?.instantiateViewController(withIdentifier: storyBoardNames.EditListingVC) as! EditListingVC
    editListingVC.product = self.productData
    navigationController?.pushViewController(editListingVC, animated: true)
  }
  
}
