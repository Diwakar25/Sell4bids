//
//  ProductDetailViewController.swift
//  Sell4Bids
//
//  Created by admin on 9/18/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import Cosmos
import Darwin
import CoreLocation
import GoogleMaps



class ProductDetailTableVc: UITableViewController, GMSMapViewDelegate,IsRelistItemDelegate,UISearchBarDelegate {
  
  //MARK: - Properties
    @IBOutlet weak var EditingDisablebtn: UILabel!
    
    @IBOutlet weak var PriceTagImage: UIImageView!
    @IBOutlet weak var selectorCollView: UICollectionView!
  @IBOutlet weak var sliderCollView: UICollectionView!
  //@IBOutlet weak var photoTitleLabel: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var pageController: UIPageControl!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var daysLabel: UILabel!
  @IBOutlet weak var hoursLabel: UILabel!
  @IBOutlet weak var minsLabel: UILabel!
  @IBOutlet weak var secondsLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var categoryNamelabel: UILabel!
  @IBOutlet weak var postedTimeLabel: UILabel!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var conditionLabel: UILabel!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var cosmosViewrating: CosmosView!
  @IBOutlet weak var totalratingLabel: UILabel!
  @IBOutlet weak var quantityLabel: UILabel!
  @IBOutlet weak var companyNameLabel: UILabel!
  @IBOutlet weak var companyDescriptionLabel: UILabel!
  @IBOutlet weak var benefitsLabel: UILabel!
  @IBOutlet weak var employementType: UILabel!
  @IBOutlet weak var payPeriodLabel: UILabel!
  @IBOutlet weak var ConditionJobLabel: UILabel!
  var cirlce: GMSCircle!
    var MarkPaidBuyer : Bool?
    @IBOutlet weak var UserViewByLabel: UILabel!
    @IBOutlet weak var watchListLabel: UILabel!
  @IBOutlet weak var watchListImageView: UIImageView!
  @IBOutlet weak var reportItemLabel: UILabel!
  @IBOutlet weak var reportImageView: UIImageView!
  //Last StackViewOutlets
  @IBOutlet weak var cosmosRatingView: CosmosView!
  @IBOutlet weak var ownerButtonsStack: UIStackView!
  @IBOutlet weak var acceptOffersBtn: UIButton!
  @IBOutlet weak var newOrderBtn: UIButton!
  @IBOutlet weak var stockBtn: UIButton!
  @IBOutlet weak var productVisibilityBTn: UIButton!
  @IBOutlet weak var relistBtn: DesignableButton!
  //Mark: - Slider View
  @IBOutlet weak var cosmosSetRating: CosmosView!
  @IBOutlet var sliderView: UIView!
  @IBOutlet weak var colViewProductImagesPopup: UICollectionView!
  @IBOutlet weak var smallSliderCollectionView: UICollectionView!
  @IBOutlet weak var turboChargeBtn: UIButton!
  //view counter offer
  @IBOutlet weak var viewCounterOfferContainer: UIView!
  @IBOutlet weak var btnViewCounterOffer: UIButton!
  ///counter offer for this product for this buyer
  lazy var counterOfferForThisProductForBuyer : CounterModel  = {
    let counterOffer = CounterModel()
    return counterOffer
  }()
  var flagShowBtnMarkPaid = false
  @IBOutlet weak var mapLocationMessage: UILabel!
  
  @IBOutlet weak var btnEditListing: ButtonNormal!
  
  
  //MARK: - variables
  let currentUserId = SessionManager.shared.userId
  var isOffer = false
  var isBid = false
  var productData: ProductModel!
  var imageUrlStringsForProduct = [String]()
  //var ischeck = false
  var isWatchList = false
  var isReport = false
  var isOrder = false
  var buyerHasRatedThisProduct = false
  var ischeckReport = false
  var flagGiveOptionToRate = false
  var flagWonItem = false
  var isTimer = false
  var isJob = false
  var isImageSlider = false
    var current_Time : Int64?
  //new
  var timer = Timer()
  lazy var geocoder = CLGeocoder()
  lazy var camera = GMSCameraPosition()
  var imageUrl = ""
  let dbRef = FirebaseDB.shared.dbRef
  lazy var UserArray = [UserModel]()
  
  var remainingBiddingTime:Double = 0
  var lat:Double = 0
  var long:Double = 0
  var location: CLLocation?
  var acceptOffer: String?
  var orderEnabled: String?
  var timeeeeee:Double = 0
  lazy var currentuserId = Auth.auth().currentUser?.uid
  
    @IBOutlet weak var WatchListBtn: UIButton!
    @IBOutlet weak var btnSetSeconds: UIButton!
  @IBOutlet var tableViewProdDetails: UITableView!
  var flagShowViewCounterOffer = false
  
  @IBOutlet weak var lblOfferWillBeAccepted: UILabel!
  @IBOutlet var viewCounterOfferInfoAndActions: UIView!
  
  //MARK:- View Life Cycle
  var viewBackGround : UIView!
  
  @IBOutlet weak var timeStackView: UIStackView!
  ///protocol to send
  weak var protocolForViewCounterOfferbtn : ProductDetailTableVcProtocol?
  var prodReference : DatabaseReference!
  @IBOutlet weak var cellViewCounterOffer: UITableViewCell!
  lazy var flagProductReferenceSet : Bool = { [unowned self] in
    let (success, reference) = setProductReference()
    if success {
      prodReference = reference
      return true
    }else {
      prodReference = reference
      return false
    }
    }()
  
  @IBOutlet weak var btnEndListing: UIButton!
  @IBOutlet weak var lblTimeEnded: UILabel!
    @IBOutlet weak var lblWonItem: UILabel!
    
    @IBOutlet weak var lblPurchaseItem: UILabel!
    
  @IBOutlet weak var lblDaysTimerStatic: UILabel!
  
  @IBOutlet weak var lblHoursTimerStatic: UILabel!
  
  @IBOutlet weak var lblMinsTimerStatic: UILabel!
  
  @IBOutlet weak var lblSecsTimerStatic: UILabel!
  
  @IBOutlet weak var btnMarkPaid: UIButton!
  
  @IBOutlet weak var btnYouMarkedPaid: UIButton!
  
  @IBOutlet weak var btnSellerMarkedPaid: UIButton!
  
  @IBOutlet weak var viewYouMarkedPaid: UIView!
  var flagShowBuyerButtons = false
  @IBOutlet weak var viewSellerMarkedPaid: UIView!
  var flagViewCounterOffedAdded = false
  var ViewbyUser = [String]()
  var dimView: UIView {
    //let window = UIApplication.shared.keyWindow!
    let dView = UIView(frame: CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height))
    view.addSubview(dView)
    dView.backgroundColor = UIColor.black
    return dView
  }
  ///buyer wants to rate the seller after purchasing a product
  @IBOutlet weak var btnRateNowSeller: UIButton!
  
    @IBAction func sharebtnitem(_ sender: UIButton) {
        
        
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
    
    @IBAction func AddInWatchList(_ sender: Any) {
        print("Add to watch list")
      let deviceUUID: String = (UIDevice.current.identifierForVendor?.uuidString)!
        
        if(!isWatchList){
            
            //writing data in main watching node
            let ref = self.dbRef.child("watching").child(self.productData.productKey!).child(self.currentUserId)
            ref.child("token").setValue(deviceUUID)
            
            
            //writing data in users node
            WatchListBtn.setImage(UIImage(named: "viewred"), for: .normal)
            //setting Auction value
            self.dbRef.child("users").child(self.currentUserId).child("products").child("watching").child(self.productData.productKey!).child("auction").setValue(self.productData.auctionType)
            
            //setting categoryName
            let watchlist = self.dbRef.child("users").child(self.currentUserId).child("products").child("watching").child(self.productData.productKey!).child("category")
                 watchlist.setValue(self.productData.categoryName)
            
            
            //setting state
            self.dbRef.child("users").child(self.currentUserId).child("products").child("watching").child(self.productData.productKey!).child("state").setValue(self.productData.state)
            
            // Code in this block will trigger when OK button tapped.
            WatchListBtn.setImage(UIImage(named: "viewred"), for: .normal)
            
            self.alert(message: "Item has been added to your Watch List" , title: "My Sell4Bids watch List")
            
            
        } else {
           
            let ref = self.dbRef.child("watching").child(self.productData.productKey!).child(self.currentUserId)
            ref.child("token").removeValue()
            
            self.dbRef.child("users").child(self.currentUserId).child("products").child("watching").child(self.productData.productKey!).removeValue()
             WatchListBtn.setImage(UIImage(named: "view"), for: .normal)
            
            self.alert(message: "This Item has been Removed from Your Watch List" , title: "My Sell4Bids watch List")
            
        }
        
    }
    

    @IBOutlet weak var ShareBtn: UIButton!
    
    func checkWatchListbtn() {
        dbRef.child("users").child(self.currentUserId).child("products").child("watching").observe(.value, with: { [weak self ] (snapshot) in
            guard let this = self else { return }
            
            if snapshot.hasChild(this.productData.productKey!){
                
                self?.WatchListBtn.setImage(UIImage(named: "viewred"), for: .normal)
                
                this.isWatchList = true
                
            }else {
                self?.WatchListBtn.setImage(UIImage(named: "view"), for: .normal)
                this.isWatchList = false
            }
            
        })
    }
  @IBOutlet weak var btnViewOfferHistory: UIButton!
  var flagOpenedFromScheme = Bool()
  
    
    var maxbidV = Int()
    var currentStartPrice : String?
    var dbRefB : DatabaseReference!
    lazy var mikeImgForSpeechRec = UIImageView(frame: CGRect(x: 0, y: 0, width: 0,height: 0))
    
     @IBOutlet weak var searchBarTop: UISearchBar!
    
    func loaddata() {
       
        let productId = productData?.productKey
        let category = productData?.categoryName
        let auctionType = productData?.auctionType
        let state = productData?.state
        if productData.auctionType != "buy-it-now" {
            dbRefB.child("products").child(category!).child(auctionType!).child(state!).child(productId!).observe( .value) { [weak self] (snapshot) in
                guard let this = self else { return }
                let dictObjt = snapshot.value as? NSDictionary
                if let orders = dictObjt?.value(forKey: "bids") as? NSDictionary
                {
                    if let startPrice = dictObjt?.value(forKey: "startPrice") as? String {
                        this.currentStartPrice = startPrice
                        print("StartingPrice\(this.currentStartPrice)")
                        
                        if let maxbid = orders.value(forKey: "maxBid") as? String {
                            this.maxbidV = Int(maxbid)!
                            print("Maxbid = \(this.maxbidV)")
                            
                            if Int(maxbid)! > 0 {
                                
                                this.btnEditListing.isHidden = true
                                this.EditingDisablebtn.isHidden = false
                            }else {
                                this.btnEditListing.isHidden = false
                                this.EditingDisablebtn.isHidden = true
                            }
                            
                        }
                    }
                }
            }
        }else {
            print("Buy Now")
            self.btnEditListing.isHidden = false
            self.EditingDisablebtn.isHidden = true
        }
    }

  override func viewDidLoad() {
    
    super.viewDidLoad()
   
       updateTimeRemOfProductInDB()
    updateIfSellerSharedLocation()
    if productData.currency_symbol == "$" {
        print("applied US" )
        PriceTagImage.image = UIImage(named: "US-Prize-image")
    }else if productData.currency_symbol == "₹" {
        print("applied IN")
        PriceTagImage.image = UIImage(named: "Indian-Prize-Image")
    }
    
    print("Product key \(productData.productKey)")
    
    
    self.definesPresentationContext = true
    
    checkWatchListbtn()
    self.UserViewByLabel.layer.cornerRadius = 15
    self.UserViewByLabel.layer.borderWidth = 1
    self.UserViewByLabel.layer.borderColor = UIColor.white.cgColor
    self.WatchListBtn.layer.cornerRadius = WatchListBtn.layer.bounds.height / 2
    self.ShareBtn.layer.cornerRadius = ShareBtn.layer.bounds.height / 2
    WatchListBtn.layer.borderWidth = 1
    WatchListBtn.layer.borderColor = UIColor.white.cgColor
    
    
    
    ShareBtn.layer.borderWidth = 1
    ShareBtn.layer.borderColor = UIColor.white.cgColor
    
    
    //    let ref = Database.database().reference().child("item_views").child(productData.productKey!).child(currentuserId!)
    //    let ref1 = Database.database().reference().child("item_views").child(productData.productKey!)
    //    ref.child("ios").setValue(true)
    //
    //    ref1.observeSingleEvent(of: .value, with: { (snapshot) in
    //
    //        let value = snapshot.children.allObjects.count
    //
    //        self.UserViewByLabel.text = String("  Views: \(value)  ")
    //        print("View = \(value)")
    //
    //
    //    })
    
    //navigationController?.navigationBar.sizeToFit()
   
    if flagOpenedFromScheme { handleSchemeOpening() }else { performViewDidLoad() }
    print("isBid\(remainingBiddingTime)")
    
    ///header is used to display images
    
    
    
   
  }
  
  func handleSchemeOpening() {
    
    updateTimer(currentTime: nil )
    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer(currentTime: )), userInfo: nil, repeats: true)

    performViewDidLoad()
    
  }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear.")
       setButtons()
        
    }
  
  
  override func viewDidAppear(_ animated: Bool) {
    //print("End Time : \(self.productData.endTime as Any)")
    print("end time = \(productData.endTime)")
    checkWatchListbtn()
    getUserData()
    checkAndEnableEndListingButton()
  
    guard let _ = productData else {
      return
    }
    updateTimer(currentTime: nil  )
    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer(currentTime: )), userInfo: nil, repeats: true)

    
  }
  
  
  
  override func viewDidLayoutSubviews() {
    let height = 300
    let width = tableViewProdDetails.frame.width
    self.tableViewProdDetails.tableHeaderView?.frame = CGRect.init(x: 0, y: 0, width: Int(width) , height: height)
    
    
  }
  var flagShowBtnEndListing = false
  var flagShowCellMarkPaid = true
  //MARK:- Private functions
  
  override func viewWillDisappear(_ animated: Bool) {
    self.timer.invalidate()
    //self.timer = nil
    
  }
  
  func getUserData() {
    print("Get user Data")
    if let userId = productData.userId {
      
      dbRef.child("users").child(userId).observe(.value, with: { [weak self ](userSnapshot) in
        guard let this = self else { return }
        guard let userDict = userSnapshot.value as? [String:AnyObject] else {
          print("ERRPR: while geting user Dict")
          return
        }
        let user = UserModel(userId: userId, userDict: userDict)
        this.UserArray.append(user)
        if let userName = this.UserArray[0].name {
          this.userNameLabel.text = userName
        }
        if let imageUrl = this.UserArray[0].image {
          this.userImageView.sd_setImage(with: URL(string:imageUrl), placeholderImage: #imageLiteral(resourceName: "avatar"))
        }else {
          this.userImageView.image = #imageLiteral(resourceName: "user_icon_512")
        }
        if this.UserArray[0].averageRating != 0 {
          if let totalRating = this.UserArray[0].averageRating {
            this.cosmosViewrating.rating = Double(totalRating)
          }
          if let maximumRating = this.UserArray[0].totalRating {
            let totalRatingsInt = Float(maximumRating)
            this.totalratingLabel.text = "( Total Ratings - \(totalRatingsInt)  )"
          }
        }
        else {
          this.cosmosViewrating.rating = 0
          this.totalratingLabel.text = "No ratings yet."
        }
        this.cosmosViewrating.settings.updateOnTouch = false
        
      })
      
    }
    
  }
  
  var flagShowCellLisingEnded = true
  
  //MARK:- Navigation.
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let dest = segue.destination as? RelistPopUpVC
    dest?.delegate = self
    dest?.selecteditem = productData
    if segue.identifier == "fromProductDetailTosetQuantity"{
      
      let destination = segue.destination as! UpdateProdQuantityPopUpVC
      destination.delegate = self
      destination.previousData = sender as! [String:Any]
    }
    else if segue.identifier == "fromDetailToRelistPopUp"{
      
      let destination = segue.destination as! RelistPopUpVC
      destination.previousData = sender as! [String:Any]
      
    } else if segue.identifier == "detailTableToEndListing" {
      guard let dest = segue.destination as? EndListingVC else {
        print("guard let dest = segue.destination as? EndListingVC failed in \(self)")
        return
      }
      dest.delegate = self
    }
    
  }
  
}



protocol ProductDetailTableVcProtocol: class{
  func viewCounterOfferTapped(counterOffer: CounterModel)
  func offerRejectedHidePopup()
}

