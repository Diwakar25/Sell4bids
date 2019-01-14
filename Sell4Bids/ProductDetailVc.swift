//  Edited by Osama Mansoori
//  ProductDetailTableViewController.swift
//  Sell4Bids
//
//  Created by admin on 9/20/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SwiftMessages


var chatwithseller : Bool = false
var chatwithsellermodel : ChatwithSeller?

class ProductDetailVc: UIViewController{
  
  //MARK:- Properties
  
  @IBOutlet weak var buttonStack: UIStackView!
  @IBOutlet weak var chatSellerBtn: DesignableButton!
  @IBOutlet weak var buyNowBtn: DesignableButton!
  @IBOutlet weak var offerNowBtn: DesignableButton!
  @IBOutlet weak var bidBtn: DesignableButton!
  @IBOutlet weak var containerView: UIView!
  
  @IBOutlet weak var heightContSendBuyItNowOfferOrOrder: NSLayoutConstraint!
  ///viewSendJobOffer
  @IBOutlet var viewSendJobOffer: UIView!
  @IBOutlet weak var tfExpectedSalaryForJobOffer: UITextField!
  
  @IBOutlet weak var imgVFidget: UIImageView!
  @IBOutlet weak var btnSendJobOffer: UIButton!
  //MARK:- variables
  var offerAccpet = "yes"
  var myId = ""
  var state = "WI"
  var productID = "-Kv1ndY33jEO6t-hiUIq"
  var visibility = "yes"
  var ordering = "yes"
  var isOffer = false
  var isBid = false
  var timeLeft: Bool = true
  var isMyProduct: Bool = true
  public var productDetail:ProductModel!
  var dbRef: DatabaseReference = FirebaseDB.shared.dbRef
  
  @IBOutlet weak var btnReject: UIButton!
  @IBOutlet weak var btnAccept: UIButton!
  @IBOutlet weak var btnSendCounterOffer: UIButton!
  //view send counter offer
  @IBOutlet weak var viewSendCounterOffer: UIView!
  @IBOutlet weak var textFieldQuantity: UITextField!
  @IBOutlet weak var textFOfferAmount: UITextField!
  @IBOutlet weak var viewCounterOfferInfoAndActions: UIView!
  
  @IBOutlet weak var btnCrossRed: UIButton!
  @IBOutlet weak var btnSendCounterOfferInViewSendOffer: UIButton!
  @IBOutlet weak var btnCrossViewCounterOffer: UIButton!
  @IBOutlet weak var viewDim: UIView!
  //MARK:- Life Cycle
  
  @IBOutlet weak var btnCloseSendJobOffer: UIButton!
  @IBOutlet weak var contSendBuyItNowOfferOrOrder: UIView!
  @IBOutlet weak var lblMessageCounterOffDetails: UILabel!
  @IBOutlet weak var lblExpectedMonthlySalary: UILabel!
  ///viewPlaceBid
  @IBOutlet var viewPlaceBid: UIView!
  @IBOutlet weak var lblBidAmntMustBeGreater: UILabel!
  @IBOutlet weak var tfBidAmount: UITextField!
  @IBOutlet weak var btnPlaceABid: UIButton!
  var updatedPrice  = "0"
  @IBOutlet weak var btnCloseViewPlaceBid: UIButton!
  var flagWasPushedFromSellerProfile = false
  var flagOpenedFromScheme = false
  var productInfoFromScheme : [String:String]?
  
  @IBOutlet weak var heightBtnStack: NSLayoutConstraint!
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    tfBidAmount.placeholder = productDetail.currency_symbol ?? "$"
    tabBarController?.tabBar.isHidden = true
    if flagOpenedFromScheme && false {
      handleSchemeOpening()
      
    }else {
      performViewDidLoad()
    }
    
   
  }
  
  override func viewDidLayoutSubviews() {
  //  self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: 40)
   
    if Env.isIphoneSmall { heightBtnStack.constant = 60 }
    else if Env.isIphoneMedium { heightBtnStack.constant = 60 }
    else if Env.isIpad { heightBtnStack.constant = 60 }
  }
  func handleSchemeOpening() {
    guard let productInfo = productInfoFromScheme else {
      return
    }
    productDetail = ProductModel.init()
    guard let category = productInfo["cat"], let auction = productInfo["auction"],
    let state = productInfo["state"], let productID = productInfo["productID"] else {
      return
    }
    
    productDetail.categoryName = category
    productDetail.auctionType = auction
    productDetail.state = state
    productDetail.productKey = productID
    getProductData(for: productDetail) { [weak self] (success, productModel) in
      
      guard let strongSelf = self, success , let productData = productModel else {
        return
      }
      strongSelf.productDetail = productData
//      strongSelf.performViewDidLoad()
      strongSelf.referenceProdDetailTableVC.productData = productData
      strongSelf.referenceProdDetailTableVC.handleSchemeOpening()
    }
    
    
  }
  
  
  func performViewDidLoad() {
    
    
    if let cat = productDetail.categoryName  {
      if cat == "Jobs" {
        chatSellerBtn.setTitle("Chat w Employer", for: .normal)
      }
      
    }
    viewSendCounterOffer.alpha = 0
    dbRef = FirebaseDB.shared.dbRef
    
    getAndSaveOrderingStatusInSelfVariable()
    setupViews()
    handleButtons()
    observePriceInCaseOfBiddingAndUpdate()
    
  }
  
  func addShareBarButtonToNavigation() {
    let btnShare = UIBarButtonItem(image: UIImage(named: "ic_share_white"), style: .plain, target: self, action: #selector(self.btnShareTapped) ) // action:#selector(Class.MethodName) for swift 3
    self.navigationItem.rightBarButtonItem  = btnShare

  }
  
  @objc func btnShareTapped(sender : UIBarButtonItem) {
    
    let textToShare = "Check out this item that i found on The Sell4Bids Marketplace."
    guard let cat = productDetail.categoryName , let auction = productDetail.auctionType, let state = productDetail.state, let prodId = productDetail.productKey else {
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
      
      //activityVC.popoverPresentationController?.sourceView = sender
      activityVC.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
      //activityVC.popoverPresentationController?.sourceRect = sender.bounds
      if let popoverPresentationController = activityVC.popoverPresentationController {
              popoverPresentationController.barButtonItem = (sender)
        
        }
      self.present(activityVC, animated: true, completion: nil)
    
  
  }
  
    @IBOutlet weak var searchTabbar: UISearchBar!
   
    lazy var mikeImgForSpeechRec = UIImageView(frame: CGRect(x: 0, y: 0, width: 0,height: 0))
    
    
    private func setupViews() {
    //addLogoWithLeftBarButton()
    
    //customize the back button
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = UIColor.white
    
    self.navigationController?.navigationBar.tintColor = UIColor.white
    
    let imageView = UIImageView()
    imageView.toggleRotateAndDisplayGif()
    imageView.center = view.center
    view.addSubview(imageView)
   // addShareBarButtonToNavigation()
    addInviteBarButtonToTop()
    addLogoWithLeftBarButton()
    
    if let startPrice = productDetail.startPrice {
      DispatchQueue.main.async {
        self.lblBidAmntMustBeGreater.text = "Bid Amount must be greater than \((self.productDetail.currency_symbol ?? "$"))\(startPrice)"
      }
      viewPlaceBid.makeCornersRound()
    }
    btnCloseViewPlaceBid.makeRound()
    viewSendJobOffer.makeCornersRound()
    tfExpectedSalaryForJobOffer.makeRedAndRound()
    btnSendJobOffer.addShadowAndRound()
    btnCloseSendJobOffer.makeRound()
    contSendBuyItNowOfferOrOrder.makeCornersRound()
    btnAccept.addShadowAndRound()
    btnReject.addBorderWithColorAndWidth()
    btnReject.makeCornersRound()
    btnSendCounterOffer.addBorderWithColorAndWidth()
    btnSendCounterOffer.makeCornersRound()
    DispatchQueue.main.async {
      self.viewCounterOfferInfoAndActions.alpha = 0
    }
    btnCrossViewCounterOffer.makeRound()
    viewCounterOfferInfoAndActions.addShadowAndRound()
    textFOfferAmount.makeRedAndRound()
    textFieldQuantity.makeRedAndRound()
    btnCrossRed.makeRound()
    btnSendCounterOfferInViewSendOffer.addShadowAndRound()
    viewSendCounterOffer.makeCornersRound()
    //user actions. chat, bid, offer now, bu
    buyNowBtn.addShadowAndRound()
    chatSellerBtn.addShadowAndRound()
    offerNowBtn.addShadowAndRound()
    bidBtn.addShadowAndRound()
    tfBidAmount.makeRedAndRound()
    btnPlaceABid.addShadowAndRound()
        
       // navigationController?.navigationBar.backgroundColor = UIColor.clear
        
//        mikeImgForSpeechRec.image = UIImage(named: "mike")
//
//
//    searchTabbar.setImage(mikeImgForSpeechRec.image, for: .bookmark, state: .normal)
//
//
//    searchTabbar.showsBookmarkButton = true
//
//
//    navigationItem.titleView = searchTabbar
    
    
    
    
    
    
    setupButtonColors()
  }
  
  func setupButtonColors() {
    guard let endTime = productDetail.endTime else {
      return
    }
    
    getCurrentServerTime { [weak self] (success, currentTime) in
      guard let this = self else { return }
      let currentTimeInt64 = Int64(currentTime)
      
      if (endTime > currentTimeInt64 || endTime == -1) == false {
        this.offerNowBtn.isEnabled = false
        this.buyNowBtn.isEnabled = false
      }
    }
    
    if let quantity = productDetail.quantity , quantity <= 0 {
      self.buyNowBtn.isEnabled = false
      self.buyNowBtn.isEnabled = false
    }
    
  }
  //if product is of auction type, we have to constantly monitor the value of products price and keep users updated about latest bid price
  private func observePriceInCaseOfBiddingAndUpdate() {
    guard let catName = productDetail.categoryName, let auctionType = productDetail.auctionType, let productKey = productDetail.productKey, let stateName = productDetail.state else {
      return
    }
    var prodRef = Database.database().reference().child("products").child(catName).child(auctionType).child(stateName).child(productKey)
    if auctionType.lowercased().contains("buy") {
      
      prodRef = prodRef.child("startPrice")
    }else {
      //bidding products
      print(prodRef)
      prodRef = prodRef.child("bids").child("startPrice")
      print(prodRef)
    }
    
    prodRef.observe(.value) { [weak self] (snapshot) in
      guard let this = self else { return }
      if let price = snapshot.value as? String {
        this.updatedPrice = price
        DispatchQueue.main.async {
            this.lblBidAmntMustBeGreater.text = "Bid Amount must be greater than \(self!.productDetail.currency_symbol ?? "$")\(this.updatedPrice)"
          this.referenceProdDetailTableVC.priceLabel.text = "\(this.updatedPrice)"
        }
      }
    }
  }
  
  func handleButtons(){
    
    guard let categoryName = self.productDetail.categoryName, let auctionType = self.productDetail.auctionType, let stateName = self.productDetail.state,let productKey = self.productDetail.productKey else {
      
      return
    }
    //if this product belongs to the user running the app
    if SessionManager.shared.userId == productDetail.userId{ self.isMyProduct = true }
    else{   self.isMyProduct = false  }
    //getcurrentLocation()
    if productDetail.categoryName == "Jobs"{ buyNowBtn.setTitle("Apply Now", for: .normal) }else
    { buyNowBtn.setTitle("Buy Now", for: .normal) }
    
    //if not user's own product then fetch other data
    if !isMyProduct {
      guard let endTime = productDetail.endTime else {
        print("ERROR: geting endtime")
        return
      }
      getTime { [weak self] (currentTime, status) in
        if status {
          guard let thisOuter = self else { return }
          let ref = FirebaseDB.shared.dbRef
          let dif = Int64(endTime) - currentTime
          
            if dif > 0 || endTime == -1{
              thisOuter.timeLeft = true
              
              if thisOuter.productDetail.auctionType == "buy-it-now"{
                thisOuter.bidBtn.isHidden = true
                
                ref.child("products").child(categoryName).child(auctionType).child(stateName).child(productKey).child("acceptOffers").observe(.value, with: { [weak self] (acceptOfferSnapshot) in
                  guard let this = self else { return }
                  
                  guard let offerAccpet = acceptOfferSnapshot.value as? String else {
                    this.offerNowBtn.isHidden = true
                    this.isOffer = false
                    return
                  }
                  this.offerAccpet = offerAccpet
                  this.productDetail.isUserAcceptingOffers = this.offerAccpet
                  
                  if this.offerAccpet != "yes"{
                    this.offerNowBtn.isHidden = true
                    this.isOffer = false
                    
                  }
                  else if this.offerAccpet == "yes"{
                    this.offerNowBtn.isHidden = false
                    this.isOffer = true
                  }
                  
                })
              }//end if self.productDetail.auctionType == "buy-it-now"
              else{
                DispatchQueue.main.async {
                  thisOuter.bidBtn.isHidden = false
                  thisOuter.offerNowBtn.isHidden = true
                  thisOuter.buyNowBtn.isHidden = true
                  thisOuter.isBid = true
                }
                
              }
            }
          else{
            
            DispatchQueue.main.async {
              //time has passed so user can't order, offer, or place a bid
              
              //Show appropriate buttons for auction types
              if let auctionType = thisOuter.productDetail.auctionType {
                var productIsOfBuyNow = false
                if auctionType.lowercased().contains("buy-it-now") {
                  productIsOfBuyNow = true
                }
                
                //hide buy now and offer now if product is
                thisOuter.buyNowBtn.isHidden = !productIsOfBuyNow
                thisOuter.offerNowBtn.isHidden = !productIsOfBuyNow
                thisOuter.bidBtn.isHidden = productIsOfBuyNow
                
                //because time has passed
                thisOuter.buyNowBtn.isEnabled = false
                thisOuter.offerNowBtn.isEnabled = false
                thisOuter.bidBtn.isEnabled = false
                thisOuter.bidBtn.isHidden = true
                thisOuter.bidBtn.isUserInteractionEnabled = false
                
              }
              
            }
           
          }
          
        }
      }
    }
    
    
    //if seller reaches his own produc then we'll hide the buttons of buy now, offer now bid now etc
    DispatchQueue.main.async {
      self.buttonStack.isHidden = SessionManager.shared.userId == self.productDetail.userId
    }
    
    dbRef = Database.database().reference().child("products").child(categoryName).child("buy-it-now").child(stateName).child(productKey).child("orders").child(SessionManager.shared.userId)
    dbRef.observe(.value, with: { [weak self] (snapshot) in
      guard let this = self else { return }
      if snapshot.hasChildren(){
        this.offerNowBtn.isEnabled = false
        this.buyNowBtn.isEnabled = false
        //("Order Exist")
      }
      else{
        this.offerNowBtn.isEnabled = true
        this.buyNowBtn.isEnabled = true
        print("No order Exist")
      }
      
    })
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.isHidden = true
   // self.navigationItem.title = "Item Details"
  }
  //MARK:- Private functions
  
  private func showBidNowView() {
    
    var centerPoint = view.center
    centerPoint.y = centerPoint.y - 100
    //let width = Env.isIpad ? 400 : self.view.frame.width
    //let height = Env.isIpad ? 230 : 210
    //viewSendJobOffer.frame = CGRect(x: self.view.frame.minX, y: self.view.center.y, width: width , height: CGFloat(height))
    viewPlaceBid.center = centerPoint
    viewPlaceBid.alpha = 1
    viewPlaceBid.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
    
    
    
    self.view.addSubview(viewPlaceBid)
    
    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [],  animations: {
      self.viewDim.alpha = 0.8
      
      //go back to original form
      self.viewPlaceBid.transform = .identity
      DispatchQueue.main.async {
        self.tfBidAmount.becomeFirstResponder()
      }
    })
    
    
  }
  
  func showSendJobOfferView() {
    var centerPoint = view.center
    centerPoint.y = centerPoint.y - 100
    //let width = Env.isIpad ? 400 : self.view.frame.width
    //let height = Env.isIpad ? 230 : 210
    //viewSendJobOffer.frame = CGRect(x: self.view.frame.minX, y: self.view.center.y, width: width , height: CGFloat(height))
    viewSendJobOffer.center = centerPoint
    viewSendJobOffer.alpha = 1
    viewSendJobOffer.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
    DispatchQueue.main.async {
      self.tfExpectedSalaryForJobOffer.becomeFirstResponder()
    }
    
    self.view.addSubview(viewSendJobOffer)
    
    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [],  animations: {
      self.viewDim.alpha = 0.8
      //go back to original form
      self.viewSendJobOffer.transform = .identity
    })
  }
  
  private func sendJobOfferWithExpectedSalary(salary:Double) {
    
  }
  
  
  ///when user wants to place a buy now order of offer, first have to check if user has disable or enabled ordering on this product
  private func getOrderingStatusOfProduct(product : ProductModel, completion: @escaping (Bool) ->() ) {
    guard let categoryName = self.productDetail.categoryName ,
      let auctionType = productDetail.auctionType,
      let productKey = productDetail.productKey else {
        showSwiftMessageWithParams(theme: .error, title: "Internal Error", body: "Invalid Product Data")
        return
    }
    let ref = Database.database().reference().child("products").child(categoryName).child(auctionType).child(state).child(productKey).child("ordering")
    ref.observeSingleEvent(of: .value) { [weak self] (snap) in
      guard let this = self else { return }
      
      let value = snap.value as? String
      if value != nil{
        
        this.ordering = value!
        if this.ordering == "stopped" {
          completion(false)
          return
        }//end if self.ordering == "stopped"
        else{
          completion(true)
        }
      }//end if value != nil
      else{
        completion(true)
      }
    }
  }
  
  func getAndSaveOrderingStatusInSelfVariable(){
    
    guard let categoryName = productDetail.categoryName, let auctionType = productDetail.auctionType, let stateName = productDetail.state,let productKey = productDetail.productKey else {return}
    let ref = FirebaseDB.shared.dbRef.child("products").child(categoryName).child(auctionType).child(stateName).child(productKey)
    ref.child("ordering").observe(.value) { [weak self] (snapshot) in
      guard let this = self else { return }
      let value = snapshot.value as? String
      if value != nil{
        this.ordering = value!
      }
      
    }
    
  }
  var referenceProdDetailTableVC : ProductDetailTableVc!
  var refOfferPopupVC : OfferPopUpVc?
  var userTappedOnOrderNow = false
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if(segue.identifier == "embedSegue"){
      if let vc = segue.destination as? ProductDetailTableVc{
        //Giving ProductModel data to ProductDetailTableViewController
        referenceProdDetailTableVC = vc
        vc.productData = self.productDetail
        vc.protocolForViewCounterOfferbtn = self
      }
      else{
        print("could not unwrap vc")
      }
    }
    else if segue.identifier == "embedToBuyNowPopup"{
      let destination = segue.destination as! OfferPopUpVc
      //keep a reference for further usage
      refOfferPopupVC = destination
      
      destination.isBid = self.isBid
      destination.isOrder = userTappedOnOrderNow
      destination.isOffer = self.isOffer
      
    }
    else if segue.identifier == "fromProductDetailToChat"{
      
      
      let destination = segue.destination as! ChatLogVC
      let data = sender as! [String:Any]
      destination.previousData = data
      destination.hidesBottomBarWhenPushed = true
    }
    
  }
  
  //MARK:- IBActions
  
  @IBAction func tfExpectedSalaryChanged(_ sender: UITextField) {
    if !(sender.text?.isEmpty)! {
      let text = sender.text!
      if !text.contains("\(productDetail.currency_symbol ?? "$")") {
        DispatchQueue.main.async {
            sender.text = "\(self.productDetail.currency_symbol ?? "$")" + text
        }
      }
      
    }
  }
  // changes by Osama Mansoori
  @IBAction func tfPlaceBidEditingChanged(_ sender: UITextField) {
    
    DispatchQueue.main.async {
      
      guard !((self.tfBidAmount.text?.isEmpty)!) else {
        return
      }
      let text = self.tfBidAmount.text!
      if text.count == 1 {
        if !text.contains("\(self.productDetail.currency_symbol)") {
            self.tfBidAmount.text = "\(self.productDetail.currency_symbol!)" + text }
      }
    }
    
  } // change by Osama Mansoori
  @IBAction func btnPlaceBidTapped(_ sender: UIButton) {
    
    guard !(tfBidAmount.text?.isEmpty)! else {
      tfBidAmount.shake()
      showSwiftMessageWithParams(theme: .error, title: "Empty Text Field", body: "Please enter bid amount to place a bid")
      return
    }
    
    let amountInt = (tfBidAmount.text!.replacingOccurrences(of: "\(productDetail.currency_symbol)", with: "") as NSString).integerValue
    //guard let startPrice = productDetail.startPrice else { return }
    let startPrice = updatedPrice
    if amountInt <= (startPrice as NSString).integerValue {
      tfBidAmount.shake()
      showSwiftMessageWithParams(theme: .error, title: "Bid Amount Error", body: "Bid Amount must be greater than \((productDetail.currency_symbol ?? "$"))\(startPrice)")
    }else {
      placeBidOnProductWithValue(bidValue: amountInt, product: self.productDetail) { [weak self] (success:Bool, title: String, content:String) in
        guard let this = self else { return }
        let theme = success ? Theme.success : Theme.error
        
        showSwiftMessageWithParams(theme: theme, title: title, body: content, durationSecs: -1, layout: .cardView, position: .center)
        DispatchQueue.main.async {
          this.tfBidAmount.resignFirstResponder()
          this.view.endEditing(true)
          this.btnCloseViewPlaceBid(self as Any)
        }
      }
    }
    
  }
  @IBAction func btnCloseViewPlaceBid(_ sender: Any) {
    
    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
      self.viewDim.alpha = 0
      self.viewPlaceBid.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
      
    }) { (success) in
      self.viewPlaceBid.removeFromSuperview()
      
    }
    
  }
  @IBAction func btnHideSendJobOffer(_ sender: Any) {
    
    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
      self.viewDim.alpha = 0
      self.viewSendJobOffer.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
      
    }) { (success) in
      self.viewSendJobOffer.removeFromSuperview()
      
    }
  }
  
  @IBAction func btnSendJobOfferTapped(_ sender: Any) {
    guard !(tfExpectedSalaryForJobOffer.text?.isEmpty)! else {
      showSwiftMessageWithParams(theme: .error, title: "Error", body: "Please enter expected Salary Into text field.")
      tfExpectedSalaryForJobOffer.shake()
      return
    }
    guard let payPeriod = self.productDetail.payPeriod else {
      showSwiftMessageWithParams(theme: .error, title: "Error", body: "Sorry, Internal Error occured. Error Code: PDVC_BSJOTapped")
      return
    }
    guard let price = self.productDetail.startPrice else {
      showSwiftMessageWithParams(theme: .error, title: "Error", body: "Sorry, Internal Error occured. Error Code: PDVC_BSJOTapped")
      return
    }
    var message = "Are you sure you want to apply at \((productDetail.currency_symbol ?? "$"))\(price) \(payPeriod) ?"
    let alert = UIAlertController(title: "Apply Now", message: message, preferredStyle: .alert)
    let actionYes = UIAlertAction(title: "Yes", style: .default) { (action) in
      handleYesAction()
    }
    let actionLater = UIAlertAction(title: "Later", style: .default)
    alert.addAction(actionYes)
    alert.addAction(actionLater)
    self.present(alert, animated: true, completion: nil)
    
    func handleYesAction() {
      
      let expectedSalary = tfExpectedSalaryForJobOffer.text!.replacingOccurrences(of: "\(productDetail.currency_symbol)", with: "")
      
      let dictValue = ["boughtPrice": "\(expectedSalary)" ,
        "boughtQuantity": "1",
        "name": SessionManager.shared.name,
        "uid": SessionManager.shared.userId] as [String:Any]
      
      let (success, jobRef ) = getProductReference(productModel: self.productDetail)
      if success {
        DispatchQueue.main.async {
          
          self.btnHideSendJobOffer(UIButton())
          self.view.endEditing(true)
          self.tfExpectedSalaryForJobOffer.resignFirstResponder()
          
        }
        //print("Job Ref: \(jobRef)")
        
        
        jobRef.child("orders").child(SessionManager.shared.userId).setValue(dictValue, withCompletionBlock: { [weak self ] (error:Error?, dbRef_) in
          guard let this = self else { return }
          if error != nil {
            print("DbRef: \(dbRef_)")
            showSwiftMessageWithParams(theme: .error, title: "Error ", body: "Could not Send your job offer because database operation Failed. \(error!.localizedDescription)")
          }else {
            this.handleButtons()
            showSwiftMessageWithParams(theme: .success, title: "Success", body: "Your offer has been sent to the employer. Please wait for the employer to respond. You can also send a Chat Message directly to the Employer.")
            
          }
          
        })
      }else {
        showSwiftMessageWithParams(theme: .error, title: "Error", body: "Sorry, Internal Error occured. Error Code: PDVC_BSJO")
      }
    }
  }
  @IBAction func textFAmountTextChanged(_ sender: UITextField) {
    if !(sender.text?.isEmpty)! {
      let text = sender.text!
      if !text.contains("\(productDetail.currency_symbol ?? "$")") {
        DispatchQueue.main.async {
            sender.text = "\(self.productDetail.currency_symbol ?? "$")" + text
        }
      }
    }
  }
  
  
  @IBAction func btnOfferNowTapped(_ sender: DesignableButton) {
    //if it is a job
    guard let endTime = productDetail.endTime else {
      return
    }
    getCurrentServerTime {[weak self] (success, currentTime) in
      guard let this = self else { return }
      if success {
        let currentTimeInt64 = Int64(currentTime)
        if endTime > currentTimeInt64 || endTime == -1 {
          if let catName = this.productDetail.categoryName , catName.lowercased().contains("jobs") {
            this.showSendJobOfferView()
            
          }else {
            writeTime(id: SessionManager.shared.userId)
            guard let price = this.productDetail.startPrice, let productId = this.productDetail.productKey, let state = this.productDetail.state, let categoryName = this.productDetail.categoryName, let auctionType = this.productDetail.auctionType, let quantity = this.productDetail.quantity,let endTime = this.productDetail.endTime, let userId = this.productDetail.userId , let title = this.productDetail.title  else {
              print("product Data not found in \(this). Going to return")
              return
              
            }
            this.adjustPopupHeight(flagBuyNowOrOfferNow: false)
            this.getOrderingStatusOfProduct(product: this.productDetail) { [weak self] (userAcceptingOrders: Bool) in
              guard let this = self else { return }
              if userAcceptingOrders {
                
                this.destDicToBuyNowPopup = ["myId":SessionManager.shared.userId,"price":price,"productId":productId,"state":state,"category":categoryName,"auctionType":auctionType,"quantity": quantity,"endTime":endTime,"ownerID":userId , "title":title ]
                
                this.refOfferPopupVC?.isOffer = true
                this.refOfferPopupVC?.userAndProductData = this.destDicToBuyNowPopup
                this.refOfferPopupVC?.viewDidLoad()
                this.dimBackground(flag: true)
                DispatchQueue.main.async {
                  this.viewSendCounterOffer.isHidden = true
                  this.contSendBuyItNowOfferOrOrder.isHidden = false
                }
                this.dimBackground(flag: true)
              }
              else{
                
                this.alert(message: "Seller has stopped accepting Offers on this product.", title: "Offers Stopped")
              }
            }
            
          }
        }else{
          //time expired for this item
          showSwiftMessageWithParams(theme: Theme.error , title: PromptMessages.title_ListingEnded , body: PromptMessages.sorryYouMissedTime)
          this.offerNowBtn.isEnabled = false
        }
      }
    }
    

    
  }
  
  
  var destDicToBuyNowPopup = [String:Any]()
  @IBAction func btnBuyNowTapped(_ sender: DesignableButton) {
    
    //check time
    
    guard let price = productDetail.startPrice, let productKey = productDetail.productKey, let state = productDetail.state, let categoryName = productDetail.categoryName, let auctionType = productDetail.auctionType ,let endTime = productDetail.endTime, let userId = productDetail.userId, let title = productDetail.title,let quantity = productDetail.quantity else {
      showSwiftMessageWithParams(theme: .warning, title: "Something is Wrong", body: "Invalid product data")
      return
      
    }
    
    
    getCurrentServerTime { [weak self] (success, currentTime) in
      guard let this = self else { return }
      let currentTimeInt64 = Int64(currentTime)
      
      if endTime > currentTimeInt64 || endTime == -1 {
        
        if categoryName.lowercased().contains("jobs") {
          this.handleJobApply()
        }else {
          this.adjustPopupHeight(flagBuyNowOrOfferNow: true)
          if quantity != 0{
            writeTime(id: SessionManager.shared.userId)
            let ref = FirebaseDB.shared.dbRef.child("products").child(categoryName).child(auctionType).child(state).child(productKey).child("ordering")
            this.dimBackground(flag: true)
            
            ref.observeSingleEvent(of: .value) { [weak self] (snap) in
              guard let this = self else { return }
              let value = snap.value as? String
              if value != nil{
                
                this.ordering = value!
                if this.ordering == "stopped" {
                  this.alert(message: "Seller has stopped Accepting orders for this Product", title: "Sorry")
                  return
                }//end if self.ordering == "stopped"
                else{
                  
                  this.destDicToBuyNowPopup = ["myId":SessionManager.shared.userId,"price":price ,"productId":productKey,"state":state,"category":categoryName,"auctionType":auctionType,"quantity": quantity,"endTime":endTime ,"ownerID":userId , "title":title]
                  this.showBuyNowPopup(userAndproductData: this.destDicToBuyNowPopup)
                  
                }
              }//end if value != nil
              else{
                this.destDicToBuyNowPopup  = ["myId":this.myId,"price":price,"productId":productKey,"state":state,"category":categoryName,"auctionType":auctionType,"quantity": quantity,"endTime":endTime ,"ownerID":userId , "title":title]
                //it is a buy now order, have to show only quantity label, quantity text field and a button so decrease the height of popup
                
                this.showBuyNowPopup(userAndproductData: this.destDicToBuyNowPopup)
                
              }
            }
          }else {
            
            this.alert(message: "Currently, this item is out of stock. You can send a personal message to seller to inquire about more stock", title: "Out of Stock")
          }
        }
        
      }else {
        showSwiftMessageWithParams(theme: .error, title: "Time Expired", body: "Sorry, You missed out on this item")
        this.buyNowBtn.isEnabled = false
      }
    }
    
    
    
  }
  private func handleJobApply() {
    
    guard let price =  productDetail.startPrice ,
      let payPeriod = productDetail.payPeriod else {
        showSwiftMessageWithParams(theme: .error, title: "Internal Error", body: "Sorry, An internal Error occured. Code PDVC_HJA")
        return
    }
    DispatchQueue.main.async {
      self.lblExpectedMonthlySalary.text = "Expected \(payPeriod) Salary"
    }
    var message = "Are you sure you want to apply at \((productDetail.currency_symbol ?? "$"))\(price) \(payPeriod) ?"
    let alert = UIAlertController(title: "Apply Now", message: message, preferredStyle: .alert)
    let actionYes = UIAlertAction(title: "Yes", style: .default) { (action) in
      handleYesAction()
    }
    let actionLater = UIAlertAction(title: "Later", style: .default)
    alert.addAction(actionYes)
    alert.addAction(actionLater)
    self.present(alert, animated: true, completion: nil)
    
    func handleYesAction() {
      let (success, prodRef) = getProductReference(productModel: productDetail)
      if success {
        guard let price = productDetail.startPrice else {
          
          return
        }
        
        let dictValue = ["boughtPrice": "\(price)" ,
          "boughtQuantity": "1",
          "name": SessionManager.shared.name,
          "uid": SessionManager.shared.userId,
          "buyer_marked_paid" : "No"] as [String:Any]
        dimBackground(flag: true)
        fidget.toggleRotateAndDisplayView(fidgetView: self.imgVFidget, downloadcompleted: true)
        
        prodRef.child("orders").child(SessionManager.shared.userId).setValue(dictValue, withCompletionBlock: { [weak self] (error: Error?, dbRef_) in
          guard let this = self else { return }
          this.dimBackground(flag: false)
          print("DbRef : \(dbRef_)")
          DispatchQueue.main.async {
            this.imgVFidget.isHidden = true
          }
          if error != nil {
            //internal error occured
            showSwiftMessageWithParams(theme: .error, title: "Database Error", body: "Database Operation Failed: " + (error?.localizedDescription)!)
            print(error.debugDescription)
          }
          else {
            let mess = "Your offer has been sent to employer. Please wait for the employer to respond. You can also send a Chat Message directly to the Employer"
            showSwiftMessageWithParams(theme: .success, title: "Apply Now", body: mess, durationSecs: -1, layout: .cardView, position: .center)
          }
        })
      }else {
        showSwiftMessageWithParams(theme: .error, title: "Internal Error", body: "Sorry, An internal Error occured. Code PDVC_HJA")
      }
    }
  }
  
  ///if flagBuyNowOrOfferNow == true, adjust for buy now, else for offer now
  private func adjustPopupHeight(flagBuyNowOrOfferNow: Bool) {
    if flagBuyNowOrOfferNow {
      heightContSendBuyItNowOfferOrOrder.constant = Env.isIpad ? 250 : 200
    }else {
      heightContSendBuyItNowOfferOrOrder.constant = Env.isIpad ? 400 : 320
    }
  }
  
  private func showBuyNowPopup(userAndproductData:[String:Any]) {
    //  print("Dic: \(dic)")
    self.isOffer = false
    self.refOfferPopupVC?.isOffer = false
    self.refOfferPopupVC?.isOrder = true
    self.refOfferPopupVC?.isBid = false
    self.refOfferPopupVC?.userAndProductData = userAndproductData
    self.refOfferPopupVC?.viewDidLoad()
    DispatchQueue.main.async {
      self.viewSendCounterOffer.isHidden = true
      self.contSendBuyItNowOfferOrOrder.isHidden = false
    }
    self.dimBackground(flag: true)
    //self.contSendBuyItNowOffer.show()
  }
  
  @IBAction func chatSellerBtnAction(_ sender: DesignableButton) {
    print("selected chat")
    guard let ownerId = self.productDetail.userId else{
      print("ownerID not found")
      return
    }
    let myID = SessionManager.shared.userId
    let ownerRef = Database.database().reference().child("users").child(ownerId).child("name")
    
    var prodOwnerName = ""
    ownerRef.observeSingleEvent(of: .value) { [weak self] (snapshot) in
      guard let this = self else { return }
      
      if let name = snapshot.value as? String {
        prodOwnerName = name
      }else {
        prodOwnerName = "Sell4Bids User"
      }
        
        chatwithseller = true
        if (this.productDetail.auctionType != nil) || (this.productDetail.categoryName != nil) || (this.productDetail.productKey != nil) || (this.productDetail.imageUrl0 != nil ) || (this.productDetail.state != nil) || (this.productDetail.title != nil ) || (this.productDetail.startPrice != nil) {
            
            print("Product Details = \(this.productDetail.auctionType)")
            print("Product category = \(this.productDetail.categoryName)")
            print("Product auction type = \(this.productDetail.auctionType)")
            print("Product key = \(this.productDetail.productKey)")
            print("Product Details = \(this.productDetail.imageUrl0)")
            print("Product state = \(this.productDetail.state)")
            print("Product title = \(this.productDetail.title)")
            print("Product price = \(this.productDetail.startPrice)")
            
            if this.productDetail.imageUrl0 == nil {
                this.productDetail.imageUrl0 = ""
            }
          chatwithsellermodel = ChatwithSeller.init(itemAuctionType: (this.productDetail.auctionType)!, itemCategory: (this.productDetail.categoryName)!, itemID: (this.productDetail.productKey)!, itemImages: (this.productDetail.imageUrl0)!, itemState: (this.productDetail.state)!, itemTitle: (this.productDetail.title)! ,itemprice: "\(String(describing: this.productDetail.startPrice!))" )
        }else {
            
        }
        
      
      if prodOwnerName != ""{
        
        let myName = SessionManager.shared.name
        if myName != ""{
          let dic = ["myID":myID,"ownerID":ownerId,"ownerName":prodOwnerName,"myName":myName]
          
          let ownerInfo = ["name":prodOwnerName,"uid":ownerId] as [String:Any]
          let myInfo = ["name":myName,"uid":myID] as [String:Any]
          let ref3 = FirebaseDB.shared.dbRef.child("users").child(myID).child("chat").child(ownerId)
          let ref4 = FirebaseDB.shared.dbRef.child("users").child(ownerId).child("chat").child(myID)
          
          ref3.updateChildValues(ownerInfo)
          ref4.updateChildValues(myInfo)

          let chatSB = getStoryBoardByName(storyBoardNames.chat)
          let chatLogVC = chatSB.instantiateViewController(withIdentifier: "ChatLogVC") as! ChatLogVC
            chatLogVC.selectedproduct = self!.productDetail
          chatLogVC.previousData = dic
          chatLogVC.hidesBottomBarWhenPushed = true
          this.navigationController?.pushViewController(chatLogVC, animated: true)
          
//          DispatchQueue.main.async {
//            this.performSegue(withIdentifier: "fromProductDetailToChat", sender: dic)
//          }
        }
        
        
        
      }
      
    }
  }
  
  @IBAction func bidBtnAction(_ sender: DesignableButton) {
    guard let price = productDetail.startPrice, let productKey = productDetail.productKey, let state = productDetail.state, let categoryName = productDetail.categoryName, let auctionType = productDetail.auctionType ,let endTime = productDetail.endTime, let userId = productDetail.userId, let title = productDetail.title,let quantity = productDetail.quantity else {return}
    //let dic = ["myId":self.myId,"price":price,"productId":productKey,"state":state,"category":categoryName,"auctionType":auctionType,"quantity": quantity,"endTime":endTime,"ownerID":userId, "title":title] as [String:Any]
    showBidNowView()
    //self.performSegue(withIdentifier: "popUp", sender: dic)
    
    print("this is bid button action")
  }
  
  
  @IBAction func btnSendOfferToSellerTapped(_ sender: UIButton) {
    //user wants to send a counter offer to seller
    performValidation { (success, offerAmount, quantity) in
      if success {
        var messageStr = "Are you sure you want to send your Counter Offer to seller at "
        messageStr.append("\((productDetail.currency_symbol ?? "$"))\(offerAmount) ( \((productDetail.currency_symbol ?? "$"))\(offerAmount) x \(quantity) )?")
        let alert = UIAlertController(title: "Buy Now", message: messageStr, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Later", style: .default, handler: { (action) in
          self.toggleShowPopupSendCounterOffer(flag: false)
          self.dimBackground(flag: false)
          DispatchQueue.main.async {
            
            self.view.endEditing(true)
          }
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
          self.toggleShowPopupSendCounterOffer(flag: false)
          
          let offerDict =   [ "boughtPrice": "\(offerAmount)",
            "boughtQuantity": "\(quantity)",
            "name": "\(SessionManager.shared.name)",
            "note": "Buyer Sent counter offer to seller",
            "rating": "",
            "uid" : SessionManager.shared.userId ]
            as [String:AnyObject]
          
          
          self.referenceProdDetailTableVC.sendCounterOfferBtnTapped(offerFromBuyerToSeller: offerDict)
          
          self.toggleShowPopupSendCounterOffer(flag: false)
          self.dimBackground(flag: false)
          DispatchQueue.main.async {
            self.view.endEditing(true)
          }
        }))
        self.present(alert, animated: true, completion : nil)
      }
    }
    
    
  }
  
  @IBAction func btnCrossVSendCounterOfferTapped(_ sender: UIButton) {
    toggleShowPopupSendCounterOffer(flag: false)
    dimBackground(flag: false)
  }
  
  private func performValidation( completion: (Bool, Int, Int) ->() ) {
    
    if (textFOfferAmount.text?.isEmpty)! {
      self.alert(message: "Please enter price per item to continue.")
      completion(false, -1, -1 )
    }
    else if (textFieldQuantity.text?.isEmpty)! {
      self.alert(message: "Please enter quantity to continue")
      completion(false, -1, -1 )
    }
    else {
      let offerAmountPerItem = textFOfferAmount.text!.replacingOccurrences(of: "\(productDetail.currency_symbol ?? "$")", with: "")
      //offer Amount includes $ sign.
      let quantity = textFieldQuantity.text!
      if let offerAmountInt = Int(offerAmountPerItem), let quantityInt = Int(quantity) {
        completion(true, offerAmountInt, quantityInt)
      }else {
        completion(false, -1, -1)
      }
      
    }
  }
  
  func getTime(completion : @escaping (_ currentTime: Int64,_ status: Bool) -> () ){
    let dic = ["temporaryTimeStamp":ServerValue.timestamp()]
    print(ServerValue.timestamp())
    let reference = FirebaseDB.shared.dbRef
    reference.updateChildValues(dic)
    
    reference.child("temporaryTimeStamp").observeSingleEvent(of: .value) { (snapshot) in
      
      guard let time = snapshot.value as? Int64 else {
        completion(0, false)
        return
      }
      completion(time, true)
    }
    
  }
  
  @IBAction func btnCrossCounterOfferTapped(_ sender: UIButton) {
    
    toggleShowViewCounterOffer(flag: false)
  }
  
  @IBAction func btnAcceptCounterOfferTapped(_ sender: UIButton) {
    self.referenceProdDetailTableVC.acceptCounterOfferBtnTapped()
    
  }
  
  @IBAction func btnRejectCounterOfferTapped(_ sender: UIButton) {
    print("reject counter offer tapped")
    referenceProdDetailTableVC.rejectCounterOfferBtnTapped()
    
    
  }
  
  @IBAction func btnSendCounterOfferTapped(_ sender: UIButton) {
    toggleShowViewCounterOffer(flag: false)
    toggleShowPopupSendCounterOffer(flag: true)
    dimBackground(flag: true)
  }
  
  //End of ALi Code
  func toggleShowViewCounterOffer(flag : Bool) {
    if flag {
      DispatchQueue.main.async {
        self.viewCounterOfferInfoAndActions.alpha = 1
        self.viewDim.alpha = 0.3
      }
    }else {
      //hide view counter offer
      DispatchQueue.main.async {
        self.viewCounterOfferInfoAndActions.alpha = 0
        self.viewDim.alpha = 0
      }
    }
    
  }
  
  func dimBackground(flag: Bool) {
    if flag {
      DispatchQueue.main.async {
        self.viewDim.alpha = 0.3
        
      }
    }else {
      DispatchQueue.main.async {
        self.viewDim.alpha = 0
        
      }
    }
    
  }
  
  private func toggleShowPopupSendCounterOffer(flag : Bool) {
    DispatchQueue.main.async {
      if flag { self.viewSendCounterOffer.alpha = 1  }
      else { self.viewSendCounterOffer.alpha = 0 }
    }
    
    
  }
  
}


extension ProductDetailVc : ProductDetailTableVcProtocol {
  
  func viewCounterOfferTapped(counterOffer: CounterModel) {
    DispatchQueue.main.async {
      self.viewDim.alpha = 0.3
      guard let title = self.productDetail.title else {
        print("guard let title = productDetail.title failed in \(self). Going to return")
        return
      }
      var message = "You received counter offer for \(title). "
      message.append("Seller is ready to sell \(counterOffer.quantity) item(s) ")
      message.append("at \((self.productDetail.currency_symbol ?? "$"))\(counterOffer.pricePerItem) per item")
      self.lblMessageCounterOffDetails.text = message
      self.toggleShowViewCounterOffer(flag: true)
    }
    
    
  }
  
  func offerRejectedHidePopup() {
    dimBackground(flag: false)
    toggleShowViewCounterOffer(flag: false)
  }
  
  
}

