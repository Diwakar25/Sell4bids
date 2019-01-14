  
//
//  ViewController.swift
//  Sell4Bids
//
//  Created by admin on 8/25/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SDWebImage
//import FMMosaicLayout
import CoreLocation
import AVFoundation
  var isfilterclicked : Bool = false
  var stateName  = ""
  //used for nearby features on 11/22/2018
  var endkey : String?
  var endAt : String?
  var zipCode = ""
  var city = ""
  var gpscountry = ""
  var selectedProduct : ProductModel?
  var willAppear: Bool = false
  
  //variable is use for pagination on 11/22/2018
 
  var fetchingMethod = "zipcode"
  func getlocation () {
    let home = HomeVC_New()
    home.getCurrenState { (Complete,city, state, zip) in
        print("\(Complete), \(city!), \(state!), \(zip!)")
        
    }
  }
  
class HomeVC_New:  UIViewController, UITabBarControllerDelegate,CLLocationManagerDelegate,UIPopoverPresentationControllerDelegate  {
  //MARK: - Properties
    
    @IBOutlet weak var SellUStuff: UIButton!
    
    
    
   
 
    
    
    @IBAction func movetoSell(_ sender: Any) {
        tabBarController?.selectedIndex = 2
        tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.SellUStuff.isHidden = true
        
        
    }
    
    @IBAction func invitebtnshow(_ sender: Any) {
        let items =  [shareString, urlAppStore] as [ Any ]
        let activityVC = UIActivityViewController(activityItems: items , applicationActivities: [])
        //activityVC.popoverPresentationController?.sourceView = sender
        if let popoverController = activityVC.popoverPresentationController{
            popoverController.barButtonItem = sender as? UIBarButtonItem
            popoverController.permittedArrowDirections = .down
        }
    
        self.present(activityVC, animated:true , completion: nil)
    }
    
    
    
    

    //function for loading item from zipcode , city and state 11/23/2018
    @IBOutlet weak var itemLoadingView: UIView!
    @IBOutlet weak var itemFidgetSpinner: UIImageView!
    @IBOutlet weak var itemLoadingDescrib: UILabel!
     var downloadeditems = false
   
  @IBOutlet weak var btnMenuButton: UIBarButtonItem!
  @IBOutlet weak var emptyProductMessage: UILabel!
  @IBOutlet weak var fidgetImageView: UIImageView!
  @IBOutlet weak var dimView: UIView!
  @IBOutlet weak var colVProducts: UICollectionView!
  
  @IBOutlet weak var imgViewNetworkError: UIImageView!
  @IBOutlet weak var viewNoResults: UIView!
  
  @IBOutlet weak var btnTryAgainNoResults: UIButton!
  //MARK: - Variables
  var imagesUrlArray = [UIImage]()
  var databaseHandle:DatabaseHandle?
  var dbRef: DatabaseReference!
  var locationManager = CLLocationManager()
  var currentLocation: CLLocation!
  var mainNavigationController: UINavigationController?
  var productsArray = [ProductModel]()
  var FilteredDataFromFilterVcArray:[ProductModel]!
  var blockedUserIdArray = [String]()
  var flagIsFilterApplied = Bool()
    var productObj = ProductModel()
    let  downloader = SDWebImageDownloader(sessionConfiguration: URLSessionConfiguration.ephemeral)
  var CityName = ""
  var cityAndStateName:String?
  var setSearchResults : Set<ProductModel>!
  var isOpen = 0
  var endAtChargeTimes = [CategoryAndAuctionType:CLongLong]()
  var endAtChargeTime : CLongLong = -999
  private var jobsDataSource = [ProductModel]()
  private let downloadSession = URLSession(configuration: URLSessionConfiguration.ephemeral)
  //MARK:- View Life Cycle
  var categoryToFilter = "All"
  var buyingOptionToFilter = "Any"
  var stateToFilter = "New York, NY"
  var currency = String()
  var priceMinFilter : Int?
  var priceMaxFilter: Int?
 
  @IBOutlet weak var searchBarTop: UISearchBar!
  var prevHeight :CGFloat = 0

    
    
    @objc func searchbtnaction() {
    let searchVCStoryBoard = getStoryBoardByName(storyBoardNames.searchVC)
    let searchVC = searchVCStoryBoard.instantiateViewController(withIdentifier: "SearchVC")
    self.navigationController?.view.backgroundColor = UIColor.clear
    self.navigationController?.pushViewController(searchVC, animated: true)
    
    }
    
    @objc func filterbtnaction() {
       
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "FiltersVc") as? FiltersVc else {return}
            controller.selfWasPushed = true
        controller.cityAndStateName = city + " " + stateName ?? "New York, NY"
        stateToFilter = controller.stateToFilter
            controller.delegate = self
            
            if flagIsFilterApplied {
                controller.categoryToFilter = self.categoryToFilter
                controller.buyingOptionToFilter = self.buyingOptionToFilter
                
            }
        controller.stateToFilter = stateName
            
            self.navigationController?.pushViewController(controller, animated: true)
   
    }
    
    @objc func invitebtnaction(_ sender : AnyObject) {
        let items =  [shareString, urlAppStore] as [ Any ]
        let activityVC = UIActivityViewController(activityItems: items , applicationActivities: [])
        activityVC.popoverPresentationController?.sourceView = sender as! UIView
        if let popoverController = activityVC.popoverPresentationController{
            popoverController.barButtonItem = sender as? UIBarButtonItem
            popoverController.permittedArrowDirections = .up
        }
        self.present(activityVC, animated:true , completion: nil)
    }
    
    
    
  lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    self.colVProducts.alwaysBounceVertical = true
    refreshControl.tintColor = #colorLiteral(red: 0.8566855788, green: 0.1049235985, blue: 0.136507839, alpha: 1)
    refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
    refreshControl.attributedTitle = NSAttributedString.init(string: "Pull to refresh")
    return refreshControl
  }()
    
    lazy var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
    
    lazy var mikeImgForSpeechRec = UIImageView(frame: CGRect(x: 0, y: 0, width: 0,height: 0))
    
     var titleview = Bundle.main.loadNibNamed("NavigationBarMainView", owner: self, options: nil)?.first as! NavigationBarMainView
    
    
    override func viewLayoutMarginsDidChange() {
        navigationItem.titleView?.frame = CGRect(x: 2, y: 0, width: UIScreen.main.bounds.width, height: 40)
    }
    fileprivate func getAndDisplayNotificationCount() {
        
        NetworkService.getNotificationCount{ [weak self ] (complete, unReadCount) in
            guard let this = self, let unRead = unReadCount else { return }
            
            let dict = ["unRead" : unRead]
            
            UIApplication.shared.applicationIconBadgeNumber = unReadCount!
           
            
            //update notifications count in main user node
            updateNotCount(updatedCount: unRead, completion: { (success) in
                
            })
            //update notifications tab badge number
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"updateTabBadgeNumber"), object: nil, userInfo: dict)
            
            
        }
    }
    
    func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    

    //self.navigationController?.navigationBar.barTintColor = UIColor(red:0.85, green:0.11, blue:0.13, alpha:1.0)
    
    if !InternetAvailability.isConnectedToNetwork() {
        itemFidgetSpinner.isHidden = true
    }else {
        
        fidget.toggleRotateAndDisplayView(fidgetView: fidgetImageView, downloadcompleted: downloadCompleted)
        
        fidget.toggleRotateAndDisplayItems(fidgetView: itemFidgetSpinner, downloadcompleted: downloadeditems)
        getCurrenState{ (complete,state,ci,zip)  in
            print("Zipcode = \(zip!) city = \(ci!) state = \(state!) country = \(gpscountry)")
            stateName = state!
            city = ci!
            zipCode = zip!
            print("Data Fetching.........")
            self.fetchAndDisplayData()
            print("statenamehome did load = \(stateName)")
            
            self.titleview.citystateZIpcode.text = "\(city), \(stateName) \(zipCode)"
            
            self.cityAndStateName = city + ",\(stateName)"
            
        }
    }
    
    StoreReviewHelper.checkAndAskForReview()
    getAndDisplayNotificationCount()
   
    
   fidget.toggleRotateAndDisplayView(fidgetView: fidgetImageView , downloadcompleted: downloadCompleted)
   tabBarController?.delegate = self
    
   
   
    
    
    print("titleview width = \(titleview.frame.width)")
    
    
   self.navigationItem.titleView = titleview
    titleview.searchBarButton.addTarget(self, action: #selector(searchbtnaction), for: .touchUpInside)
    titleview.filterbtn.addTarget(self, action: #selector(filterbtnaction), for: .touchUpInside)
    titleview.inviteBtn.addTarget(self, action:  #selector(self.inviteBarBtnTapped), for: .touchUpInside)
    
   
  
    
//    addInviteBarButtonToTop()
    
    toggleDimBack(true)
   addDoneLeftBarBtn()
   //addInviteBarButtonToTop()
  
    
     SellUStuff.layer.borderWidth = 1
    SellUStuff.layer.borderColor = UIColor.black.cgColor
    
//    searchBarTop.translatesAutoresizingMaskIntoConstraints = false
//
//
//    searchBarTop.frame = CGRect(x: 50, y: 0, width: 100, height: 50)
//    let leftNavBarButton = UIBarButtonItem(customView:searchBarTop)
//    self.navigationItem.leftBarButtonItem = leftNavBarButton
    
    setupViews()
    
    
    

   
    
    if productsArray.count > 1 {
        print("Applied......")
      
        print("productArray .....\(productsArray.count)")
    }
  
    getUserIDAndStoreFCMInUsersNode()
    
    dbRef = FirebaseDB.shared.dbRef
    
    downloadAndShowData()
    self.colVProducts.delegate = self
    self.colVProducts.dataSource = self
    
   NotificationCenter.default.addObserver(self, selector: #selector(self.displayUnReadNotifInTabBadge(_:)), name: NSNotification.Name("updateTabBadgeNumber"), object: nil)
    
    getAndShowNotificationsNumberInTabBadge()
    
  }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        
        
        
//      self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 33, width: 50, height: 40)
       isfilterclicked = false
        
        
    }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
   
    print("WillAppear ")
    getAndDisplayNotificationCount()
    willAppear = animated
    print("viewwillDisappear\(flagIsFilterApplied)")
      //  self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 33, width: 20, height: 33)
    
    if isOpen == 1 {
      self.revealViewController().revealToggle(animated: true)

    }
    if self.downloadCompleted {
        self.fidgetImageView.isHidden = true
    }
    toggleDimBack(true)
   //
    



    DispatchQueue.main.async {
     
      self.view.endEditing(true)
        if self.downloadCompleted {
           self.reloadColView()
            self.fidgetImageView.isHidden = true
        }
    }

  }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       print("statenamehome will appear = \(stateToFilter)")
      self.titleview.citystateZIpcode.text = "\(city), \(stateName) \(zipCode)"
        
       
        
        if isfilterclicked {
            
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "FiltersVc") as? FiltersVc else {return}
            controller.selfWasPushed = true
            controller.cityAndStateName = cityAndStateName ?? "New York, NY"
            controller.delegate = self
            
            
            controller.stateToFilter = stateName
           
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
     
     fidget.toggleRotateAndDisplayView(fidgetView: fidgetImageView , downloadcompleted: downloadCompleted)
        self.SellUStuff.isHidden = true
        toggleDimBack(true)
        DispatchQueue.main.async {
           
            self.view.endEditing(true)
            if self.downloadCompleted {
                self.fidgetImageView.isHidden = true
            }
        }
    }
   
    
    
  
  var downloadCompleted = false
  //MARK:- Private functions
  
  func getAndShowNotificationsNumberInTabBadge() {
    NetworkService.getNotificationCount{ (complete, unReadCount) in
        print("unRead222 == \(unReadCount)")
        print("complete == \(complete)")
        
        if complete {
            guard let unRead = unReadCount else { return }
      print("unRead == \(unRead)")
      UIApplication.shared.applicationIconBadgeNumber = unRead
      
      ///update notifications count in main user node
      updateNotCount(updatedCount: unRead, completion: { (success) in
        
      })
      //update notifications tab badge number
      if unRead == 0 {
        self.tabBarController?.tabBar.items![4].badgeValue = nil
      }else { self.tabBarController?.tabBar.items![4].badgeValue = "\(unReadCount!)" }
      
      
    }
    }
  }
  
  func getUserIDAndStoreFCMInUsersNode() {
    
    getLoggedInUserID { (id, status) in
      if status{
        writeTime(id: id)
        //get fcm token from firebase and store in users node in fcmToken Attribute
        
        //going to store fcm token from firebase in users node to receive push notifications
        InstanceID.instanceID().instanceID(handler: { (result, error) in
          if let result = result {
            self.storeFCMTokenInUsersNode(fcmToken: result.token)
          }
        })
        
        
      }
    }
  }
    
   
  
    
    
  func reloadColView() {
    print("reloadColView Called")
   let layout = self.colVProducts.collectionViewLayout as! PinterestLayout
    
    layout.cache.removeAll()
    colVProducts.reloadData()
    setupViews()
  layout.prepare()
    
  }
    fileprivate func addDoneLeftBarBtn() {
        
        
        //addLogoWithLeftBarButton()
        
//        self.navigationItem.leftBarButtonItems = [btnMenuButton]
    }
    
  private func setupViews() {
    
    if #available(iOS 10.0, *) {
      self.colVProducts.refreshControl = refreshControl
    }
    
    btnTryAgainNoResults.addShadowAndRound()
    setCustomBackImage()
    addGestureToMike()
    self.emptyProductMessage.text = "Sorry, No items found. Try searching with different filters"
    imgViewNetworkError.loadGif(name: "networkError")
    
    self.dimView.alpha = 0.3
    self.automaticallyAdjustsScrollViewInsets = true
    //FireBase connection
    //CollectionView
    if let layout = colVProducts.collectionViewLayout as? PinterestLayout {
      layout.delegate = self
    }
    colVProducts.backgroundColor = .clear
    colVProducts.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    //Registering the header view identifier
    let headerNib = UINib(nibName: "HeaderView", bundle: nil)
    

    
    colVProducts.register(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
    
    //Side Menu Properties
    if (self.revealViewController()?.delegate = self) != nil {
        self.revealViewController().delegate = self
    
 
        titleview.menuBtn.addTarget( revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
//  titleview.menuBtn.target = revealViewController()
//    titleview.menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
    self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
    }
    self.tabBarController?.delegate = self
    mikeImgForSpeechRec.image = UIImage(named: "mike")
    
    let button = UIButton.init(type: .custom)
    button.setImage( #imageLiteral(resourceName: "emptyImage")  , for: UIControlState.normal)
    button.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40) //CGRectMake(0, 0, 30, 30)
    
    


    
    
    //navigationItem.titleView = searchBarTop
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
   
   // navigationItem.titleView = imageView
    
    
  }
  
  func downloadAndShowData() {
    
    if checkInternetAndShowNoResults() {
      toggleShowViewNoResults(flag: false)
      
      
      if !self.flagIsFilterApplied {
        
//        getCurrenState{ (complete,country,a,b)  in
//            print("country = \(country!)")
//          self.cityAndStateName = city + ",\(stateName)"
//          self.getUserBlockedList{(complete) in
//            self.fetchAndDisplayData(flagFirstTime: true)
//           print("Zipcode = \(zipCode)")
//
//          }
//        }
      }else {
        
//        let cityAndStateArr = self.cityAndStateName?.components(separatedBy: ",")
//
//        guard let cityAndStateArr_ = cityAndStateArr else {
//          return
//        }
//        guard cityAndStateArr_.count > 1 else {
//          return
//        }
//        let state =  cityAndStateArr_[1]
//        stateName = state.trimmingCharacters(in: .whitespaces)
//
//        self.CityName = cityAndStateArr_[0]
//        self.cityAndStateName = city + ",\(stateName)"
        
        
//        DB_Names.state = stateName
      
        
      }
        
    }
    
    
    
  }
  
  private func addGestureToMike() {
   // let tap = UITapGestureRecognizer(target: self, action: #selector(mikeTapped))
    titleview.micBtn.addTarget(self, action:  #selector(mikeTapped), for: .touchUpInside)
    //mikeImgForSpeechRec.addGestureRecognizer(tap)
  }
  
  private func storeFCMTokenInUsersNode(fcmToken: String) {
    //print("going to store fcm token from firebase in users node to receive push notifications")
    dbRef.child("users").child(SessionManager.shared.userId).child("token").setValue(fcmToken)
  }
  
  @objc private func displayUnReadNotifInTabBadge(_ notification: Notification) {
    if let userInfo = notification.userInfo as? [String:Int] {
      if let unRead = userInfo["unRead"]  {
        if unRead > 0 {
          DispatchQueue.main.async {
            self.tabBarController?.tabBar.items![4].badgeValue = "\(unRead)"
          }

        }else {
          DispatchQueue.main.async {
            self.tabBarController?.tabBar.items![4].badgeValue = nil
          }


        }
      }
    }
  }
  
  func getCurrenState(completion : @escaping (Bool,String?,String?,String?) -> ()) {
    //1. Try to get users physical location
    self.locationManager.requestWhenInUseAuthorization()
    locationManager.delegate = self
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self as CLLocationManagerDelegate
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.startUpdatingLocation()
      if locationManager.location != nil{
        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        let loc = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        let geo = CLGeocoder()
        geo.reverseGeocodeLocation(loc, completionHandler: { [weak self] (placemarks, error) -> Void in
            print("placmarks == \(placemarks?.first?.country!)")
          guard let this = self else {
            completion(false,nil,nil,nil)
            return
            
          }
            
          if let placeMark = placemarks?.first {
            if let country = placeMark.addressDictionary!["Country"] as? String {
            
              
                
              if  country == "United States" || country == "India" {
            let state = placeMark.addressDictionary!["State"] as? String
            let citygps = placeMark.addressDictionary!["City"] as? String
            let zipcode = placeMark.postalCode!
                city = citygps!
                stateName = state!
                zipCode = zipcode
                
                if country == "United States" {
                    gpscountry = "USA"
                }else if country == "India" {
                    gpscountry = "IN"
                }
                
                if zipcode != zipCode {
                    zipCode = zipcode
                    fetchingMethod = "zipcode"
                    
                }
                
                print("get gps citygps = \(citygps) , state = \(state) , zipcode = \(zipcode)")
               
                
            
                self!.titleview.citystateZIpcode.text = "\(citygps!), \(state!) \(zipcode)"
                completion(true,state,citygps,zipcode)
              }
              else {
                print("Country ==\(country)")
                 realGpsCountry = country
                gpscountry = "USA"
                this.getCityAndStateFromUsersNode(completion: { (c, state , zipcode, country)  in
                    guard let ci = c, let state = state , let zip = zipcode  else {
                    //could not get city and state from users node, so falling back to new york
                    stateName = "NY"
                    this.CityName = "NewYork"
                    city =  "NewYork"
                    zipCode = "10001"
                    
                       
                   
                        this.cityAndStateName = city + ", " + stateName
                    
                    completion(false,"NewYork","NY","10001")
                    return
                  }
                  //got city and state name from users node
                    
//                  stateName = state
//                  this.CityName = ci
//                 // city = ci
//                    zipCode = zip
//                  //  if zip.isEmpty {
//                    //    zipCode = "10001"
//                 //   }
//                  print("Zipcode == \(zip)")
//                  this.cityAndStateName = city + stateName
                     print("get from user node citygps = \(ci) , state = \(state) , zipcode = \(zip), country = \(gpscountry)")
                  completion(true,state,ci,zip)
                  
                })
                
                
                
                
              }
            }
          }
        })
      } else{
        //print("location is disabled")
        //get location from user's node
        
        stateName = "NY"
        self.CityName = "NewYork"
        zipCode = "10001"
        gpscountry = "USA"
        completion(true,"NewYork","NY", "10001")
      }
    } else{
      //location is disable, revert to new York
      //print("location is disabled")
      stateName = "NY"
      self.CityName = "NewYork"
         zipCode = "10001"
        gpscountry = "USA"
      completion(true,"NewYork","NY","10001")
    }
  }
  ///gets users' city and state stored in users node
  func getCityAndStateFromUsersNode(completion: @escaping (String?, String?,String?,String?) -> () ) {
    
    let userRef = FirebaseDB.shared.dbRef.child("users").child(SessionManager.shared.userId)
    userRef.observeSingleEvent(of: .value) {  (userSnapshot) in
       
        self.dbRef.child("users").child(SessionManager.shared.userId).child("countryCode").setValue(gpscountry)
      guard let snapDict = userSnapshot.value as? [String:Any] else {
        completion(nil, nil,nil,nil)
        return
      }
      guard let city = snapDict["city"] as? String, let state = snapDict["state"] as? String,let zipcode = snapDict["zipCode"] as? String,let country = snapDict["countryCode"] as? String else {
        
        completion(nil, nil,nil,nil)
        return
      }
       
        
       
        
    
      completion(city, state,zipcode,country)
      
    }
    
    
  }
  

  
}

//var imageCache = [String:UIImage]()

  // MARK: - Image Scaling.
  extension UIImage {
    
    
    /// Scales an image to fit within a bounds with a size governed by the passed size. Also keeps the aspect ratio.
    /// Switch MIN to MAX for aspect fill instead of fit.
    ///
    /// - parameter newSize: newSize the size of the bounds the image must fit within.
    ///
    /// - returns: a new scaled image.
    func scaleImageToSize(newSize: CGSize) -> UIImage {
        var scaledImageRect = CGRect.zero
        
        let aspectWidth = newSize.width/size.width
        let aspectheight = newSize.height/size.height
        let aspectheight3 = aspectheight
        let aspectRatio = max(aspectWidth, aspectheight3)
        
        scaledImageRect.size.width = size.width * aspectRatio;
        scaledImageRect.size.height = size.height * aspectRatio;
        scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0;
        scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0;
        
        UIGraphicsBeginImageContext(newSize)
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
  }

  extension UIView {
    func fade_In() {
        // Move our fade out code from earlier
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0 // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
        }, completion: nil)
    }
    
    func fade_Out() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
  }
