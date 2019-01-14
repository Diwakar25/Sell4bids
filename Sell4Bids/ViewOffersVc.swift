//
//  ViewOffersVc.swift
//  Sell4Bids
//
//  Created by admin on 11/1/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import Cosmos
import GooglePlaces
class ViewOffersVc: UIViewController {
  
  //MARk: -Properties
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var emptyMessage: UILabel!
  @IBOutlet weak var fidgetImageView: UIImageView!
  
  ///location is approximate or seller has shared
  
  //MARK:-  Vairables
  var dbRef:DatabaseReference!
  var ordersArray = [OrderModel]()
  var buyerArray = [UserModel]()
  public var productDetail:ProductModel!
  
  //MARK:- View life cycle
  override func viewDidLoad() {
    
    super.viewDidLoad()
    ordersArray.removeAll()
    buyerArray.removeAll()
    
  }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchOrdersData()
        ordersArray.removeAll()
        buyerArray.removeAll()
     
    }
    
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dbRef = FirebaseDB.shared.dbRef
        // Do any additional setup after loading the view.
      
        fetchOrdersData()
        
        ordersArray.removeAll()
        buyerArray.removeAll()
      
      
        fidgetImageView.hide()
        fidgetImageView.toggleRotateAndDisplayGif()
        
        navigationItem.title = "Offers"
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    
  //MARK:- Private functions
  private func setupViews() {
    
  }
  
  func hideCollectionView(hideYesNo : Bool) {
    
    emptyMessage.text = "No Orders received "
    if hideYesNo == false {
      tableView.isHidden = false
      
      fidgetImageView.isHidden = false
      emptyMessage.isHidden = true
    }
    else  {
      fidgetImageView.isHidden = true
      tableView.isHidden = true
      
      emptyMessage.isHidden = false
    }
  }
  
  func fetchOrdersData(){
    print("fetching orders data")
    print("Product id == \(productDetail.productKey)")
    ordersArray.removeAll()
    buyerArray.removeAll()
    var downloadComplete = false
    Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self](timer) in
      guard let this = self else { return }
      if !downloadComplete { this.fidgetImageView.show() }
      
    }
    
    guard let productId = productDetail.productKey else {return}
    guard let category = productDetail.categoryName, let auctionType = productDetail.auctionType, let state = productDetail.state else {
      print("Invalid product data in \(self)")
      return
    }
    let ref = FirebaseDB.shared.dbRef.child("products").child(category).child(auctionType)
    
    ref.child(state).child(productId).observeSingleEvent(of : .value, with: { [weak self] (snapshot) in
      guard let this = self else { return }
      
       var newOrder: OrderModel?
      downloadComplete = true
      this.fidgetImageView.isHidden = true
      if let dictObjt = snapshot.value as? NSDictionary {
        
        if let ordersDict = dictObjt.value(forKey: "orders") as? NSDictionary
        {
          this.hideCollectionView(hideYesNo: false)
          
          for (keyUserId, valueOrderDict) in ordersDict {
            //let userId = ordersUserId.key
            guard let userOrderDict = valueOrderDict as? [String:AnyObject] else {
              print("Warning. Cound not get dictionary of orders in \(self as Any). Going to return")
              return
            }
            
            var checkName = "Sell4Bids User"
            if let name  =  userOrderDict["name"] as? String{
              checkName = name
            }
            let price  = userOrderDict["boughtPrice"] as? String
            var checkQuantity = "1"
            if let quantity = userOrderDict["boughtQuantity"]{
               
                print("quantity in Firebase == \(quantity)")
              checkQuantity = quantity as! String
            }
            var checkRating:String? = nil
            if let rating = userOrderDict["rating"] as? String {
              checkRating = rating
            }
            
            guard let userId = keyUserId as? String else {
              print("Warning. uid not found in order, going to return")
              return
            }
            
            
            var sellerMarkedPaid = false
            if let markedPaid = userOrderDict["seller_marked_paid"] as? String , markedPaid == "yes" {
              sellerMarkedPaid = true
            }
            //let intRating = (checkRating as NSString).integerValue
            newOrder = OrderModel(name: checkName, boughtPrice: price, boughtQuantity: checkQuantity, rating: checkRating, uid: userId, sellerMarkedPaid: sellerMarkedPaid)
            print("ordermodel1 = \(newOrder!.boughtPrice) \(newOrder!.boughtQuantity)")
            //if order node has key location, it means seller has shared location
          
            var addressFinal = ""
            if  let address = userOrderDict["address"] as? String,
                let latitude = userOrderDict["latitude"] as? Double,
                let longitude =  userOrderDict["longitude"] as? Double {
              
              addressFinal = address
              let dictLatLong = ["latiude": latitude, "longitude": longitude] as [String:Any]
              
                newOrder!.location = orderLocation(address: addressFinal, latitude: latitude, longitude: longitude, dictlatLong: dictLatLong)
                
               
              
            }
            this.ordersArray.append(newOrder!)
            print("Order Array Count = \(this.ordersArray.count)")

            DispatchQueue.main.async {
                this.tableView.reloadData()
                
            }
            
            
        
            ///Geting buyer data
//            this.dbRef.child("users").child(this.ordersArray[this.ordersArray.count].uid!).observe( .value, with: { (snapshot) in
//
//              let dictObj = snapshot.value as? NSDictionary
//              var checkRating = "0"
//              if let rating = dictObj?.value(forKey: "averagerating") {
//                checkRating = rating as! String
//
//              }
//              var checktotalRating = "0"
//              if let totalrating = dictObj?.value(forKey: "totalratings") {
//                checktotalRating = totalrating as! String
//
//              }
//              let ratingInt = (checkRating as NSString).floatValue
//              let totalratingInt = (checktotalRating as NSString).floatValue
//
//              let buyer:UserModel = UserModel(name: nil, image: nil , userId: nil, averageRating: ratingInt, totalRating: totalratingInt, email: "", zipCode: nil, state: "", watching: nil, follower: nil, following: nil, totalListing: nil, buying: nil, bought: nil, unReadMessage: nil, unReadNotify: nil)
//              this.buyerArray.append(buyer)
//
//           print("Buyer counter = \(this.buyerArray.count)")
//
//
//            })
//
            }
            
            DispatchQueue.main.async {
              this.fidgetImageView.isHidden = true
              this.tableView.reloadData()
            }
            
          
          
        }else {
          this.hideCollectionView(hideYesNo: true)
        }
      }
        
    })
    DispatchQueue.main.async {
        self.tableView.reloadData()
        
    }
  }
  
  
  //MARK:- IBActions and user interaction
  
  @objc fileprivate func btnMarkPaidTapped( _ sender: UIButton) {
    
    let index = sender.tag
    guard index < ordersArray.count else { return }
    //mark this order as paid now
    markOrderPaidOrUnPaid(orderIndex: index)
    
  }
  
  ///go to products -> category -> state -> auction -> state -> productKey -> orders -> buyerID ->
  func markOrderPaidOrUnPaid(orderIndex : Int, flagPaid: Bool = true) {
    
    let order = ordersArray[orderIndex]
    guard let cat = productDetail.categoryName, let state = productDetail.state,
    let auctionType = productDetail.auctionType, let prodId = productDetail.productKey,
    let orderUsersId = order.uid else {
      return
    }
    let strMarked = flagPaid ? "yes" : "no"
    var ref = FirebaseDB.shared.dbRef.child(str_Products_Node_Main).child(cat).child(auctionType)
    ref = ref.child(state).child(prodId).child("orders").child(orderUsersId)
    ref.child("seller_marked_paid").setValue(strMarked) { [weak self] (error, dbRef) in
      guard let this = self else { return }
      //debugPrint("db ref was : \(dbRef)")
      if error == nil {
        let strMarkedAs = "Marked as "
        let strPaidUnPaid = flagPaid ? "Paid " : "UnPaid "
        let message = strMarkedAs + strPaidUnPaid
        
        showSwiftMessageWithParams(theme: .success, title: message, body: "Successfully Marked this Item as \(strPaidUnPaid)")
        this.ordersArray[orderIndex].sellerMarkedPaid = flagPaid
        DispatchQueue.main.async {
            self!.ordersArray.removeAll()
            self!.buyerArray.removeAll()
            self?.fetchOrdersData()
          this.tableView.reloadData()
        }
        
        
      }else {
        this.showToast(message: "Sorry, Database Operation Failed")
      }
    }
  }
  
  @objc func btnAcceptTapped(_ sender : UIButton){
    //print("accpet btn tapped\(productDetail.startPrice)")
    let prodRef = self.dbRef.child("products").child(self.productDetail.categoryName!).child(self.productDetail.auctionType!).child(self.productDetail.state!).child(self.productDetail.productKey!)
    let order = ordersArray[sender.tag]
    if productDetail.quantity != nil {
      if let productQuantity = self.productDetail.quantity {
        let orderQuantity = (order.boughtQuantity! as NSString).integerValue
        print("order quantity == \(orderQuantity)")
        if productQuantity >= orderQuantity {
          
          let orderQuantity = (order.boughtQuantity! as NSString).integerValue
          // let totalQuantity = productDetail.quantity
          let remainingQuantity = (productQuantity - orderQuantity)
          prodRef.child("orders").child(order.uid!).child("rating").setValue("0")
          //setting rating to Ratings Node
          prodRef.child("ratings").child( order.uid!).child("rating").setValue("0")
          
          
          ordersArray[sender.tag].rating = "0"
        
          //setting SellerId to Ratings Node
          prodRef.child("ratings").child(  order.uid!).child("sellerid").setValue(self.productDetail.userId!)
          self.dbRef.child("products").child(self.productDetail.categoryName!).child(self.productDetail.auctionType!).child(self.productDetail.state!).child(self.productDetail.productKey!).child("quantity").setValue("\(remainingQuantity)")
          
          
          order.boughtQuantity = "\(orderQuantity)"
          
          
          DispatchQueue.main.async {
            self.tableView.reloadData()
          }
          //we also have to delete the counter offer for this item if any that was sent by seller to buyer.
          guard let id = order.uid else {
            print("guard let id = order.uid failed in \(self). so can't delete the counter offer for this user")
            return
            
          }
          prodRef.child("counterOffers").child(id).removeValue()
          
        }else {
          self.alert(message: "Sorry, No Item left in Stock", title: "Orders")
        }
      }
    }else {
      self.alert(message: "Sorry your Product Stock is out of limit", title: "Orders")
    }
  }
  
  @objc func rejectButtonTapped(_ sender : UIButton){
    print("reject Btnn tapped")
    let order = ordersArray[sender.tag]
    self.dbRef.child("products").child(self.productDetail.categoryName!).child(self.productDetail.auctionType!).child(self.productDetail.state!).child(self.productDetail.productKey!).child("orders").child(order.uid!).removeValue()
    self.alert(message: "Order has been deleted", title: "Orders")
    
  }
  
  @objc func sendCounterOfferBtnTapped(_ sender :UIButton){
    print("sendOfferButtonPressed")
    guard let controller = storyboard?.instantiateViewController(withIdentifier: "SendCounterOfferPopUp") as? SendCounterOfferPopUp else {
      print("could not instantiate a view controller in \(self). Going to return")
      return
      
    }
    controller.productData = productDetail
    print("sendCounterOfferBtnTapped : row : \(sender.tag)")
    guard sender.tag >= 0 else { return }
    controller.orderData = ordersArray[sender.tag]
    controller.modalPresentationStyle = .overCurrentContext
    self.present(controller, animated: true, completion: nil)
  }
  
  
}//end of class



//Mark: - UITableViewDataSource,UITableViewDelegate

extension ViewOffersVc: UITableViewDataSource,UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    print("Numbers of Order Count = \(ordersArray.count)")
    return ordersArray.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  //var orderData : [OrderModel] = []
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
    let orderData = ordersArray[indexPath.section]
    
    func setupViews() {
      
      cell.userNameLabel.text = orderData.name
      if let price = orderData.boughtPrice{
        cell.boughtPriceLabel.text =  "\((self.productDetail.currency_symbol ?? "$"))\(price)"
      }
      
      cell.quantityLabel.text = orderData.boughtQuantity
      cell.selectionStyle = UITableViewCellSelectionStyle.none
      //adds shadows and rounds
      cell.sendOfferBtn.makeRedAndRound()
      cell.rejectBtn.makeRedAndRound()
      cell.acceptBtn.addShadowAndRound()
      cell.btnShareLocation.addShadowAndRound()
      //cell.addShadowView()
      if orderData.location != nil {
        cell.lblLocationStatus.text = "You Successfully shared your location with Buyer."
        cell.btnShareLocation.setTitle("Update Location", for: .normal)
      }
      if orderData.sellerMarkedPaid {
        cell.btnMarkPaid.hide()
        cell.viewYouMarked.alpha = 1
        
        cell.btnYouMarkedPaid.tag = indexPath.section
        cell.btnYouMarkedPaid.addTarget(self, action: #selector(btnYouMarkedPaidTap), for: .touchUpInside)
      }else {
        //was not marked as paid.
        cell.btnMarkPaid.show()
        cell.viewYouMarked.alpha = 0
      }
    }
    setupViews()
    
    var flagIsOrderAccepted = false
    var flagRatingAvailable = false
    
    //if rating field is not present or if is == "" then the order is not accepted.
    //have to show the buttons accept offers, reject offers
    func setupCosmosForRatingAction() {
      
      cell.CosmosRatingOrders.settings.updateOnTouch = true
      
      cell.CosmosRatingOrders.didFinishTouchingCosmos = { rating in
        if self.productDetail.productKey != nil {
          self.dbRef.child("products").child(self.productDetail.categoryName!).child(self.productDetail.auctionType!).child(self.productDetail.state!).child(self.productDetail.productKey!).child("orders").child(orderData.uid!).child("rating").setValue("\(Int(rating))")
          //setting Average Rating and totall rating of Buyer
          flagRatingAvailable = true
          //orderData.rating = "\(rating)"
          //after rating has been set, show you rated and disable touch for
          cell.CosmosRatingOrders.settings.updateOnTouch = false
          showAppropriateView()
          //converting the all ratings value into Average rating and then set it to User table as Average rating
          if self.buyerArray[0].averageRating != nil {
            
            let UserAverageRating = Float(self.buyerArray[0].averageRating!)
            var userTotalRating =  Float(self.buyerArray[0].totalRating!)
            let currentRating = Float(rating)
            //_ = self.buyerArray[0].totalRating
            let getAverageRating = ((UserAverageRating * userTotalRating) + currentRating) / (userTotalRating + 1)
            print(getAverageRating)
            userTotalRating += 1
            
            let IntCount = Int(userTotalRating)
            //Seting values to users table, who upload the product
            self.dbRef.child("users").child(orderData.uid!).child("averagerating").setValue("\(getAverageRating)")
            self.dbRef.child("users").child(orderData.uid!).child("totalratings").setValue("\(IntCount)")
            
            self.alert(message: "Rating has been Updated", title: "MySell4Bids Rating")
            
          }
        }
      }
      
    }
    
    //if order is already accepted, we don't have to show buttons of accept, reject, instead have to show the rating stars to rate the user. If order
    ///checks the condition of the order and shows either rating view or view with buttons to accept, reject
    func showAppropriateView() {
      
      if let rating = orderData.rating {
        
        if rating == "0" {
          flagIsOrderAccepted = true
          flagRatingAvailable = false
          
        }else  {
          //rating is not zero and rating is not empty string. so rating available
          if rating != "" {
            flagRatingAvailable = true
            flagIsOrderAccepted = true
          }
          
        }
      }
      if flagIsOrderAccepted  {
        
        cell.viewShareLocation.show()
        cell.btnMarkPaid.addShadowAndRound()
        cell.btnMarkPaid.addTarget(self, action: #selector(btnMarkPaidTapped), for: .touchUpInside)
        cell.btnMarkPaid.tag = indexPath.section
        //rating is not available, order is only placed. so show buttons to accept, reject and send counter offers
        
        if flagRatingAvailable {
          //show the rating and the label that you rated this product
          DispatchQueue.main.async {
            cell.viewRating.isHidden = false
            cell.viewAcceptRejSendCountOffer.isHidden = true
            cell.rateUserLabel.text = "You rated this user."
            cell.CosmosRatingOrders.isUserInteractionEnabled = false
            if let rating = orderData.rating {
              cell.CosmosRatingOrders.rating = Double(rating) ?? 0
            }
            
          }
        }else {
          //order is accepted but rating is not available
          DispatchQueue.main.async {
            cell.viewRating.isHidden = false
            cell.viewAcceptRejSendCountOffer.isHidden = true
            cell.rateUserLabel.text = "Rate the User by Tapping on Stars."
          }
          setupCosmosForRatingAction()
        }
        //work on sharing loction
        cell.btnShareLocation.addTarget(self, action: #selector(self.btnShareLocationTapped(sender:)), for: .touchUpInside)
        cell.btnShareLocation.tag = indexPath.row
      }//end if flagIsOrderAccepted
      else  {
        //order is not accepted
        cell.viewAcceptRejSendCountOffer.show()
        cell.viewRating.hide()
        cell.viewShareLocation.hide()
        cell.btnMarkPaid.hide()
        cell.viewYouMarked.hide()
        
        
      }
    }
    
    showAppropriateView()
    
    func setupButtonActions() {
      
      cell.sendOfferBtn.tag = indexPath.section
      cell.acceptBtn.tag = indexPath.section
      cell.rejectBtn.tag = indexPath.section
      
      cell.acceptBtn.addTarget(self, action: #selector(self.btnAcceptTapped), for: .touchUpInside)
      
      cell.rejectBtn.addTarget(self, action: #selector(self.rejectButtonTapped), for: UIControlEvents.touchUpInside)
      
      cell.sendOfferBtn.addTarget(self, action: #selector(self.sendCounterOfferBtnTapped), for: UIControlEvents.touchUpInside)
      
      cell.selectionStyle = UITableViewCellSelectionStyle.none
    }
    //Button Selectors
    setupButtonActions()
    
    return cell
  }
  
  @objc func btnYouMarkedPaidTap(sender: UIButton) {
    
    let alert = UIAlertController(title: strMarkasUnPaid , message: strQuesYouWantToMarkUnPaid , preferredStyle: .alert)
    let actionYes = UIAlertAction(title: "Yes", style: .destructive) { (action) in
      //let order = ordersArray[sender.tag]
      self.markOrderPaidOrUnPaid(orderIndex: sender.tag, flagPaid: false)
    }
    let actionNo = UIAlertAction(title: "No", style: .default, handler: nil)
    
    alert.addAction(actionYes)
    alert.addAction(actionNo)
    
    self.present(alert, animated: true)
    
  }
  
  @objc func btnShareLocationTapped(sender: UIButton) {
    let gmsPlacePickerController = storyboard?.instantiateViewController(withIdentifier: "GMSPlacePickerController") as! GMSPlacePickerController
    let index = sender.tag
    guard index > -1 else {
      print("guard index > -1  failed in \(self). Going to return")
      return
    }
    gmsPlacePickerController.orderData = ordersArray[index]
    gmsPlacePickerController.placePickerDelegate = self
    self.navigationController?.pushViewController(gmsPlacePickerController, animated: true)
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //work on sharing loction
    let orderData = ordersArray[indexPath.section]
    let ipadAdd : CGFloat = 10 + 5
    if let rating = orderData.rating {
      if rating == ""  { //
        //order is not accepted yet
        return 160 + ipadAdd
      }else {
        //rating has 0, 1, 2, 3, or 4
        return 260 + ipadAdd
      }
    }else{
      //no rating node in order perhaps. show
      return 150 + ipadAdd
    }
    
    
    //    var flagshowLocationSharingView = false
    //    if indexPath.section % 2 == 0 {
    //      flagshowLocationSharingView = true
    //    }
    //    if flagshowLocationSharingView {
    //      return 250
    //    }else {
    //      return 150
    //    }
    //
    
    
    
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 10
  }
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = UIColor.clear
    return headerView
  }
}

extension ViewOffersVc: GMSPlacePickerContProtocol {
  func saveOrderDataInDB(orderData: OrderModel, place: GMSPlace) {
    var message = "Sorry, Could not share your location with buyer because your product's Details could not be fetched"
    if let productDetail = self.productDetail {
      let (success, prodRef ) = getProductReference(productModel: productDetail)
      if success {
        guard let userId = orderData.uid else {
          print("Warning guard let userId = orderData.uid failed in \(self).\n Going to return")
          message = "Sorry, could not share your location because buyers data could not be fetched"
          return
        }
        let address = place.formattedAddress ?? "No address String found"
        //latitude and longitude of address
        
        let locationDict = ["address": address, "latitude": place.coordinate.latitude,
                            "longitude": place.coordinate.longitude ]
          as [String : AnyObject]
        
        prodRef.child("orders").child(userId).updateChildValues(locationDict, withCompletionBlock: { (error_, ref) in
          DispatchQueue.main.async {
            self.fidgetImageView.isHidden = true
          }
          if let error = error_ {
            print(error.localizedDescription)
            message = "Sorry, could not share your location. Hint: Database operation failed"
          }else {
            message = "Successfully Shared your location with buyer"
            
          }
          
          self.alert(message: message)
          
        })
        
      }
    }
    
    
  }
  
  
  
}



