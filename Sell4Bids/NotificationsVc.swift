//
//  NotificationsViewController.swift
//  Sell4Bids
//
//  Created by admin on 10/11/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import TableFlip
class NotificationsVc: UIViewController,SWRevealViewControllerDelegate {
  
  //MARK: - Properties
  @IBOutlet weak var searchBarTop: UISearchBar!
  @IBOutlet weak var table: UITableView!
  @IBOutlet weak var fidgetImageView: UIImageView!
  @IBOutlet weak var emptyMessage: UILabel!
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    
    @IBOutlet weak var errorimg: UIImageView!
    @objc func mikeTapped() {
        print("ahmed---090")
        let searchSB = getStoryBoardByName(storyBoardNames.searchVC)
        let searchVC = searchSB.instantiateViewController(withIdentifier: "SearchVC") as! SearchVc
        searchVC.flagShowSpeechRecBox = true
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    fileprivate func addDoneLeftBarBtn() {
        
        
        addLogoWithLeftBarButton()
        let button = UIButton.init(type: .custom)
        button.setImage( #imageLiteral(resourceName: "hammer_white")  , for: UIControlState.normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItems = [btnMenuButton, barButton ]
    }
    
    
    @IBAction func FilterBtn(_ sender: Any) {
        isfilterclicked = true
        
        tabBarController?.selectedIndex = 0
    }
    lazy var mikeImgForSpeechRec = UIImageView(frame: CGRect(x: 0, y: 0, width: 0,height: 0))
  //MARK: - Variables
  var messageArray = [UserModel]()
  var notificationArray = [NotificationModel]()
    var notificationArraySorted = [NotificationModel]()
    var RefreshNotifcatoinArray = [NotificationModel]()
  var notificatonProductArray = [ProductModel]()
    var notificationsort = [NotificationModel]()
  var dbRef: DatabaseReference!
  let fadeout = TableViewAnimation.Table.top(duration: 1.0)
  let currentUserID = Auth.auth().currentUser?.uid
  var unReadNotCount : Int = 0
  //let refreshControl = UIRefreshControl()
  
    
    var titleview = Bundle.main.loadNibNamed("NavigationBarMainView", owner: self, options: nil)?.first as! NavigationBarMainView
    
    override func viewLayoutMarginsDidChange() {
        navigationItem.titleView?.frame = CGRect(x: 2, y: 0, width: UIScreen.main.bounds.width, height: 40)
    }
    
    
    
    @objc func searchbtnaction() {
        let searchVCStoryBoard = getStoryBoardByName(storyBoardNames.searchVC)
        let searchVC = searchVCStoryBoard.instantiateViewController(withIdentifier: "SearchVC")
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.pushViewController(searchVC, animated: true)
        
    }
    
    
    @objc func filterbtnaction() {
        
        isfilterclicked = true
        
        tabBarController?.selectedIndex = 0
    }

    
    
    override func viewDidLoad() {
    super.viewDidLoad()
        
        self.notificatonProductArray.removeAll()
        self.notificationsort.removeAll()
        self.notificationArray.removeAll()
        self.messageArray.removeAll()
        self.RefreshNotifcatoinArray.removeAll()
        
//        fetchAndDisplayNotifications()
        self.navigationItem.titleView = titleview
        titleview.citystateZIpcode.text = "\(city), \(stateName) \(zipCode)"
        titleview.searchBarButton.addTarget(self, action: #selector(searchbtnaction), for: .touchUpInside)
        titleview.filterbtn.addTarget(self, action: #selector(filterbtnaction), for: .touchUpInside)
        titleview.inviteBtn.addTarget(self, action:  #selector(self.inviteBarBtnTapped), for: .touchUpInside)
        titleview.micBtn.addTarget(self, action: #selector(mikeTapped), for: .touchUpInside)
    
    //addDoneLeftBarBtn()
//    addInviteBarButtonToTop()
//     searchBarTop.delegate = self
  mikeImgForSpeechRec.image = UIImage(named: "mike")
    
//    searchBarTop.setImage(mikeImgForSpeechRec.image, for: .bookmark, state: .normal)
//
    
//    searchBarTop.showsBookmarkButton = true
    
    
//    navigationItem.titleView = searchBarTop
    
    if (self.revealViewController()?.delegate = self) != nil {
        self.revealViewController().delegate = self
    }
    
//    btnMenuButton.target = revealViewController()
//    btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        titleview.menuBtn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        
    self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    
//    addInviteBarButtonToTop()
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = UIColor.white
    dbRef = FirebaseDB.shared.dbRef
  
    table.tableFooterView = UIView.init(frame: .zero)
    
    //table.estimatedRowHeight = 130
    if #available(iOS 10.0, *) {
      table.refreshControl = refreshControl
    } else {
      table.addSubview(refreshControl)
    }
   
    //addDoneLeftBarBtn()
    //addDoneTabBarButtonToNav()
    
  }
  override func viewWillAppear(_ animated: Bool) {
  //fetchAndDisplayNotifications()
    tabBarController?.tabBar.isHidden = false
   fetchAndDisplayNotifications()
    
    
  }
  
  
  func addDoneTabBarButtonToNav() {
    let barbuttonHome = UIBarButtonItem(title: "Home", style: .done, target: self, action: #selector(self.barBtnInNavTapped))
    barbuttonHome.tintColor = UIColor.white
    
    let button = UIButton.init(type: .custom)
    button.setImage( #imageLiteral(resourceName: "hammer_white")  , for: UIControlState.normal)
    button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20) //CGRectMake(0, 0, 30, 30)
    let barButton = UIBarButtonItem.init(customView: button)
    
    self.navigationItem.leftBarButtonItems = [barbuttonHome, barButton]
  }
  
  
  @objc func barBtnInNavTapped() {
    tabBarController?.selectedIndex = 0
  }
  
  
  private func fetchAndDisplayNotifications() {

    self.messageArray.removeAll()
    self.notificationArray.removeAll()
    self.notificatonProductArray.removeAll()
   self.notificationsort.removeAll()
    self.RefreshNotifcatoinArray.removeAll()
    
    
    dbRef = FirebaseDB.shared.dbRef
    guard let userId = Auth.auth().currentUser?.uid else {
      print("Fatal Error. No user id found to download notifications ")
      return
    }
    let query : DatabaseQuery = dbRef.child("users").child(userId).child("notifications")
    var flagDownloadComplete = false
    Timer.scheduledTimer(withTimeInterval: TimeInterval(Constants.fidgetSpinAfterSeconds), repeats: false) {[weak self] (timer) in
      guard let this = self else { return }
      if !flagDownloadComplete {
        this.fidgetImageView.show()
      }
    }
    fidgetImageView.toggleRotateAndDisplayGif()
    query.observeSingleEvent(of: .value) { [weak self] (notificationsSnapShot: DataSnapshot) in
      guard let this = self else { return }
      flagDownloadComplete = true
      this.fidgetImageView.hide()
      if notificationsSnapShot.childrenCount > 0 {
        print("Total Notifications for this \(userId) \(notificationsSnapShot.childrenCount)" )
        for child in notificationsSnapShot.children {
          
          guard let notSnapShot = child as? DataSnapshot else {
            print("guard let snapCasted = notSnapShot as? DataSnapshot failed in \(this)")
            return
          }
            
           
          let key = notSnapShot.key
          
          if key == "-LDosERS2GbllyNYgM0V" {
            print("gotcha")
          }
          guard let notDict = notSnapShot.value as? [String:AnyObject] else {
            print("Error: guard let notDict = notSnapShot as? [String:AnyObject] failed in \(this) ")
            return
          }
          
             print("Notification data = \(notDict)")
          let notifObj = NotificationModel(notifyKey:key, notificationDict: notDict)
          
            //self!.notificationArray.insert(notifObj, at: 0)
          if notifObj.read == "0" {
            this.unReadNotCount += 1
          }
           if notifObj.type != "c"{
             if notifObj.auctionType != "" && notifObj.category != "" && notifObj.stateName != "" && notifObj.productKey != ""{
              //this notification is about Product, so save product data corresponding to this notification
              if notifObj.notifyKey == "-LDosERS2GbllyNYgM0V" {
                print("here")
              }
              this.saveProductFor(notification: notifObj, completion: { [weak self] (success) in
                guard let this = self else { return }
                if success {
                  this.fidgetImageView.isHidden = true
                  //  self!.notificationArray.insert(notifObj, at: 0)
                    
                  this.notificationArray.sort(by: { (not1, not2) -> Bool in
                    return not1.read < not2.read
                  })
                   
                    
                    DispatchQueue.main.async {
                        this.table.reloadData()
                       this.table.animate(animation: self!.fadeout)
                    }
                    
                
                   
                 
                  //print("Successfully fetched and saved product")
                }else {
                  print("Warning. could not fetch and saved product for notification ")
                }
              })
            }else {
              //this notification is about chat
            
            }
            
           }else {
           this.notificationArray.insert(notifObj, at: 0)

          }
        
        }
        
        
        
      }else {
        this.hideCollectionView(hideYesNo: true)
        this.fidgetImageView.isHidden = true
          this.refreshControl.endRefreshing()
      }
    }
   
  }
  
  private func saveProductFor(notification:NotificationModel, completion: @escaping (Bool) -> () ) {
    
   
    var ref = self.dbRef.child("products").child(notification.category)
    ref = ref.child(notification.auctionType).child(notification.stateName)
    ref = ref.child(notification.productKey)
    //print("final ref = \(ref)")
    ref.observeSingleEvent(of: .value, with: { [weak self] (productSnapshot) in
      guard let this = self else { return }
      if productSnapshot.childrenCount > 0 {
        
        guard let productDict = productSnapshot.value as? [String:AnyObject] else {
          completion(false)
          return
          
        }
        if notification.productKey == "-LACmWpwXRDklu42kbFR" {
          print("here")
        }
        let product = ProductModel(categoryName: notification.category, auctionType: notification.auctionType, prodKey: notification.productKey, productDict: productDict)
        if product.title != nil {
          
          notification.product = product
          //self.notificatonProductArray.insert(product, at: 0)
          this.notificationArray.insert(notification, at: 0)
          completion(true )
          
        }
        
      }else {
        //no data found at this node
        this.unReadNotCount -= 1
        //made this notification as read because this notification's product data is not found. maybe deleted.
        
        func markNotificationAsRead(notification: NotificationModel) {
          let userId = SessionManager.shared.userId
          var ref = FirebaseDB.shared.dbRef.child("users").child(userId)
          ref = ref.child("notifications").child(notification.notifyKey)
          ref.child("read").setValue("1")
          
        }
        
        markNotificationAsRead(notification: notification)
      }
      
    })
    
  }
  
  lazy var refreshControl: UIRefreshControl = {
    
    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = colorRedPrimay
    refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
    refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
    
    return refreshControl
    
  }()
  
  @objc func handleRefresh(_ refreshControl: UIRefreshControl){
    
    fetchAndDisplayNotifications()
    refreshControl.endRefreshing()
  
    
    
  }
  func hideCollectionView(hideYesNo : Bool) {
    
    emptyMessage.text = "No notifications yet"
    if hideYesNo == false {
      table.isHidden = false
      
      fidgetImageView.isHidden = false
      emptyMessage.isHidden = true
      errorimg.isHidden = true
    }
    else  {
      fidgetImageView.isHidden = true
      table.isHidden = true
      
      emptyMessage.isHidden = false
        errorimg.isHidden = false
    }
  }
  var count = 0
  
  
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension NotificationsVc : UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return notificationArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    let lblTitle = cell.viewWithTag(1) as! UILabel
    let lblProductName =  cell.viewWithTag(2) as! UILabel
    let senderLabel =  cell.viewWithTag(3) as! UILabel
    let postedTimeLabel =  cell.viewWithTag(4) as! UILabel
    let imageView = cell.viewWithTag(10) as! UIImageView
    if notificationArray.isEmpty { return UITableViewCell() }
    if indexPath.row < notificationArray.count {
    let notification = notificationArray[indexPath.row]
    print(indexPath.row)
    if let type = notification.type , type == "c" {
      //chat notificaiont
      imageView.image = notification.senderImage ?? #imageLiteral(resourceName: "ic_profile")
      lblTitle.text = notification.message
      lblProductName.text = "Chat Message"
      senderLabel.text = notification.senderName
        
    }
    
    else {
      
      let notification = notificationArray[indexPath.row]
      if notification.notifyKey == "-LDosERS2GbllyNYgM0V" {
        print("here you go")
      }
      let product = notification.product
      
      lblProductName.text = product?.title
      if let imageUrlStr = product?.imageUrl0 , let url = URL.init(string: imageUrlStr){
        imageView.sd_setImage(with: url,  placeholderImage: UIImage(named: "emptyImage"))
      }else { imageView.image = #imageLiteral(resourceName: "emptyImage") }
      
    }
   
    //print("notificationARray count : \(notificationArray.count)")
    //print("Product Array count : \(notificatonProductArray.count)")
    //  let product  = notificatonProductArray[indexPath.row]
    
    
    imageView.layer.cornerRadius = 5
        
    imageView.layer.masksToBounds = false
    imageView.clipsToBounds = true
    lblTitle.text = notification.message
    
    print(notification.startTime as Any)
    if notification.startTime != nil {
      //print("time  is not nil")
      let startTime:TimeInterval = Double(notification.startTime)
      let miliToDate = Date(timeIntervalSince1970:startTime/1000)
      let calender  = NSCalendar.current as NSCalendar
      let unitflags = NSCalendar.Unit([.day,.hour,.minute,.second])
      var diffDate = calender.components(unitflags, from:miliToDate, to: Date())
      if let days = diffDate.day, let hours = diffDate.hour, let minutes = diffDate.minute, let seconds = diffDate.second {
        if days > 1 {
          postedTimeLabel.text = "\(days) days ago."
        }
        else if  hours < 24 && hours > 1{
          
          postedTimeLabel.text = "\(hours) hours ago."
        }
        else if minutes < 60 && minutes > 1 {
          postedTimeLabel.text = "\(minutes) minutes ago."
        }
        else if seconds < 60 && seconds > 1{
          
          postedTimeLabel.text = "\(seconds) seconds ago."
        }
        
      }
    }else {
      postedTimeLabel.text = "NA"
      print("time is nil")
    }
    //senderLabel.text = notification.senderName
    senderLabel.text = "\(notification.senderName)"
    if notification.read == "1" {
      cell.contentView.backgroundColor = UIColor.white
    }
    else {
     // cell.contentView.backgroundColor =  UIColor(red: 242/255, green: 201/255, blue: 207/255, alpha: 1)
        
         cell.contentView.backgroundColor =  UIColor(red: 255/255, green: 229/255, blue: 229/255, alpha: 1)
    }
    }
    cell.selectionStyle = UITableViewCellSelectionStyle.none

    return cell
    
  }
    
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    return self.table.rowHeight
    
    
  }
    
  
    
    
   
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let currentNot = notificationArray[indexPath.row]
    notificationArray[indexPath.row].read = "1"
   // tableView.reloadRows(at: [indexPath], with: .automatic)
    tableView.animate(animation: self.fadeout)
    if notificationArray[indexPath.row].read == "1" {
    
    
    }
    let myID  = SessionManager.shared.userId
    let userRef = dbRef.child("users").child(myID).child("notifications")
    print("My ID === \(myID)")
    userRef.child(currentNot.notifyKey).child("read").setValue("1")
    print("Notify Key == \(currentNot.notifyKey)")
    if let type = currentNot.type , type == "c" {
      //open user chat with this sender
      guard let senderUid = currentNot.senderUId else {
        print("Error: guard let senderUid = currentNot.senderUId failed in \(self)")
        return
      }
        

      let chatSB = getStoryBoardByName(storyBoardNames.chat)
      let chatLogVC = chatSB.instantiateViewController(withIdentifier: "ChatLogVC") as! ChatLogVC
      var destPreviousData : [String:Any] = [ "myID": myID, "ownerID": senderUid, "ownerName": currentNot.senderName , "myName" : SessionManager.shared.name]
      if let image = currentNot.senderImage {
        destPreviousData["image"] = image
      }
      tabBarController?.tabBar.isHidden = true
      chatLogVC.previousData = destPreviousData
      self.navigationController?.pushViewController(chatLogVC, animated: true)
    }
    else {
      let prodDetailsSB = getStoryBoardByName(storyBoardNames.prodDetails)
      let controller = prodDetailsSB.instantiateViewController(withIdentifier: "ProductDetailVc") as! ProductDetailVc
      let currentProduct = currentNot.product
      controller.productDetail = currentProduct
      if currentNot.read == "0" {
        updateNotCount(updatedCount: unReadNotCount - 1) {[weak self] (success) in
    
          guard let this = self else { return }
          if !success {
            this.showToast(message: "Notification Not marked as Read")
          }
        }
      }

      self.tabBarController?.tabBar.isHidden = true

      self.navigationController?.pushViewController(controller, animated: true)
      //  self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 30, width: 50, height: 40)
    }
   
    
  }
  
}
///upates the user node with count give as param
func updateNotCount(updatedCount: Int, completion: @escaping (Bool) -> () ) {
  let userRef = FirebaseDB.shared.dbRef.child("users").child(SessionManager.shared.userId)

  let unReadStr = "\(updatedCount)"
  userRef.updateChildValues((["unreadNotifications" : unReadStr])) { (error, dbRef) in
    guard error == nil else {
      completion(false)
      print(error?.localizedDescription as Any)
      return
    }
    completion(true)
  }

  
}

extension NotificationsVc: UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let searchVCStoryBoard = getStoryBoardByName(storyBoardNames.searchVC)
        let searchVC = searchVCStoryBoard.instantiateViewController(withIdentifier: "SearchVC")
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.pushViewController(searchVC, animated: true)
        
        return false
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        mikeTapped()
    }
}

