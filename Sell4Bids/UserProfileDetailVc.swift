//
//  UserProfileDetailVc.swift
//  Sell4Bids
//
//  Created by admin on 10/19/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import Cosmos


var defaults = UserDefaults.standard
import AVFoundation
class UserProfileDetailVc:UITableViewController, ImageUrlDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
  
  //MARK:- Properties
  
    @IBOutlet weak var switchchatmessagesemail: UISwitch!
    @IBOutlet weak var userImageview: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var zipCodeLabel: UILabel!
  @IBOutlet weak var stateLabel: UILabel!
  @IBOutlet weak var watchingLabel: UILabel!
  @IBOutlet weak var followerLabel: UILabel!
  @IBOutlet weak var followingLabel: UILabel!
  @IBOutlet weak var totalListingLabel: UILabel!
  @IBOutlet weak var boughtLabel: UILabel!
  @IBOutlet weak var buyingLabel: UILabel!
  @IBOutlet weak var unReadMessagedLabel: UILabel!
  @IBOutlet weak var unReadNotifyLabel: UILabel!
  @IBOutlet weak var userEditImageView: UIImageView!
  @IBOutlet weak var totalRatingLabel: UILabel!
  @IBOutlet weak var cosmosViewrating: CosmosView!
  
  
  //Mark: - variables
  var headerView:UIView!
  var newHeaderLayer: CAShapeLayer!
  var dbRef: DatabaseReference!
    var db = DatabaseReference()
  var imageUrl = ""
  var userData:UserModel?
  var imagePicker = UIImagePickerController()
  var picker2 = UIImagePickerController()
  var userImageData:UIImage!
  var fidgetImageView: UIImageView!
  @IBOutlet weak var switchBuyingActivities: UISwitch!
  @IBOutlet weak var switchSellingActivities: UISwitch!
    fileprivate func addDoneLeftBarBtn() {
        
        
        addLogoWithLeftBarButton()
        let doneBarBtn = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(backBtnTap))
     
        let button = UIButton.init(type: .custom)
        button.setImage( #imageLiteral(resourceName: "hammer_white")  , for: UIControlState.normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItems = [doneBarBtn , barButton ]
    }
    
  //MARK:- View Life Cycle
    func getLoginUserData(completion : @escaping (Bool) -> () ){
        guard let userId = Auth.auth().currentUser?.uid else {
            
            print("ERROR: While getting User ID")
            return
        }
        
        dbRef.child("users").child(userId).observe(.value, with:{ [weak self] (snapshot) in
            guard let this = self else { return }
            // Get user value
            if let dict = snapshot.value as? NSDictionary {
                var name = String()
                if let checkname = dict["name"]{
                    name = checkname as! String
                    defaults.set(name, forKey: "FullName")
                    
                }
                if let image = dict["image"] {
                    this.imageUrl = image as! String
                }
                let email = dict["email"]
                var city = "Edit Profile to update location "
                if let state = dict["city"]{
                    city = state as! String
                }
                var code = ""
                if let zipCode = dict["zipCode"]  {
                    code = zipCode as! String
                    defaults.set(code, forKey: "ZipCode")
                }
                var follow = "0"
                if let  followers = dict["followersCount"] as? String {
                    follow = String(describing: Int(followers))
                    
                }
                var following = "0"
                if let  followings = dict["followingsCount"] {
                    following = followings as! String
                    
                }
                
            
                
                
                var  checkSelling = 0
                var  checkbuying = 0
                var  checkBought = 0
                var  checkWatching = 0
                if let products = dict.value(forKey: "products") {
                    let productValues  = products as! NSDictionary
                    
                    let sellingKey = productValues.value(forKey: "selling") as? NSDictionary
                    
                    if   let sellingKeyCount = sellingKey?.count
                    {
                        checkSelling = sellingKeyCount
                    }
                    
                    let buyingKey = productValues.value(forKey: "buying") as? NSDictionary
                    
                    if   let buyingKeyCount = buyingKey?.count
                    {
                        checkbuying = buyingKeyCount
                    }
                    
                    let boughtKey = productValues.value(forKey: "bought") as? NSDictionary
                    
                    if let boughtKeyCount = boughtKey?.count
                    {
                        checkBought = boughtKeyCount
                    }
                    
                    let watchingKey = productValues.value(forKey: "watching") as? NSDictionary
                    
                    if   let watchingKeyCount = watchingKey?.count
                    {
                        checkWatching = watchingKeyCount
                    }
                    
                }
                var checkNotify = "0"
                if let notify = dict.value(forKey: "unreadNotifications") as? String {
                    checkNotify = notify
                }
                var checkMessages = "0"
                if let messages = dict.value(forKey: "unreadCount") {
                    
                    checkMessages = (messages as? String)!
                }
                var checkRating = "0"
                if let rating = dict.value(forKey: "averagerating") as? String{
                    checkRating = rating
                    
                }
                var checkTotalRating = "0"
                if let rating = dict.value(forKey: "totalratings") {
                    checkTotalRating = rating as! String
                    
                }
                let followInt = (follow as NSString).integerValue
                let followingInt = (following as NSString).integerValue
                let notifyInt = (checkNotify as NSString).integerValue
                let messageInt = (checkMessages as NSString).integerValue
                print("Messages = \(messageInt)")
                let ratingInt = (checkRating as NSString).floatValue
                let totalRatingInt = (checkTotalRating as NSString).floatValue
                
                let userData:UserModel = UserModel(name: name , image: this.imageUrl , userId:"", averageRating: ratingInt, totalRating: totalRatingInt, email: email as? String, zipCode: code, state: city, watching: checkWatching, follower: followInt, following: followingInt, totalListing: checkSelling, buying: checkbuying, bought: checkBought, unReadMessage: messageInt, unReadNotify: notifyInt )
                
                this.userData = userData
               
                
                completion(true)
                
                DispatchQueue.main.async {
                  
                    self!.tableView.reloadData()
                }
            }
        })
        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Ahmed")
        getLoginUserData { (completed) in
            if completed {
                print("Changed")
            }
        }
        getUserData()
        tableView.reloadData()
    }
  override func viewDidLoad() {
    
    super.viewDidLoad()
    cosmosViewrating.settings.filledColor = UIColor(red: 252.0/255.0 , green: 194.0/255.0, blue: 0, alpha: 1)
   addInviteBarButtonToTop()
    addDoneLeftBarBtn()
    imagePicker.delegate = self
    let id = SessionManager.shared.userId
     db = FirebaseDB.shared.dbRef
    let ref = db.child("users").child(id).child("configs")
    ref.observe(DataEventType.value, with: { (snapshot) in
        let dict = snapshot.value as? NSDictionary
        
        guard let buyingactivities = dict?["buyingActivities"] as? String else {
            print("data not found from firebase.")
            return
        }
        if  buyingactivities == "on" {
            self.switchBuyingActivities.isOn = true
        }else {
            self.switchBuyingActivities.isOn = false
        }
        
        
        guard let sellingactivites = dict!["sellingActivities"] as? String else {
            print("data not found from firebase")
            return
        }
        if sellingactivites == "on" {
            self.switchSellingActivities.isOn = true
        }else {
             self.switchSellingActivities.isOn = false
        }
        
        
        guard let chatactivities = dict!["chatActivities"] as? String else {
            print("data not found from firebase")
            return
        }
        if chatactivities == "on" {
            self.switchchatmessagesemail.isOn = true
        }else {
            self.switchchatmessagesemail.isOn = false
        }
        
        print("value == \(buyingactivities)")
        
        
        
    })
    dbRef = FirebaseDB.shared.dbRef
    // Do any additional setup after loading the view.
    setupViews()
    checkInternet()
    
  }
  
  func setupViews() {
    
    tableView.estimatedRowHeight = 60
    
    cosmosViewrating.settings.updateOnTouch =  false
    
//    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//    navigationItem.backBarButtonItem?.tintColor = UIColor.white
    
    let editIconTap = UITapGestureRecognizer(target: self, action: #selector(editProfileImageTapped))
    userEditImageView.addGestureRecognizer(editIconTap)
    userEditImageView.isUserInteractionEnabled = true
    
    let userImageTap = UITapGestureRecognizer(target: self, action: #selector(editPhotoTapped))
    userImageview.addGestureRecognizer(userImageTap)
    userImageview.isUserInteractionEnabled = true
    userImageview.layer.borderColor = UIColor.black.cgColor
    userImageview.layer.borderWidth = 2
    userImageview.layer.cornerRadius = userImageview.frame.width/2
    userImageview.layer.masksToBounds = false
    userImageview.makeRound()
    userImageview.clipsToBounds = true
    
//    let doneBarBtn = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(backBtnTap))
//    navigationItem.leftBarButtonItem = doneBarBtn
  }
  
  var downloadCompleted = false
  //MARK:- Private functions
  func addFidgetImageView() {
    let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    fidgetImageView = UIImageView(frame: frame)
    fidgetImageView.toggleRotateAndDisplayGif()
    self.view.addSubview(fidgetImageView)
    DispatchQueue.main.async {
      self.fidgetImageView.isHidden = true
    }
    
  }
  
  func toggleActivitiesOfUser(flag: Bool, flagBuyingOrSelling: Int) {
    var statusString = "off"
    if flag {
      statusString = "on"
    }
    let activitiesChildString = flagBuyingOrSelling == 0 ? "buyingActivities" : (flagBuyingOrSelling == 1 ? "sellingActivities" : "chatActivities" )
    let activitiesString = flagBuyingOrSelling == 0 ? "Buying Activities" : (flagBuyingOrSelling == 1 ? "Selling Activities" : "Chat Activities")
    
    let ref = dbRef.child("users").child(SessionManager.shared.userId).child("configs")
    toggleFidgetVisibility(flag: true)
    ref.child(activitiesChildString).setValue(statusString) { (error:Error?, dbRef) in
      self.toggleFidgetVisibility(flag: false)
      if let error = error {
        showSwiftMessageWithParams(theme: .error, title: activitiesString, body: "Oops. Some thing went wrong. \(error.localizedDescription)")
      }else {
        var mes = ""
        if flag{ mes = "You will receive all emails regarding \(activitiesString)" }
        else {  mes = "You Won't receive any emails regarding \(activitiesString)" }
        
        showSwiftMessageWithParams(theme: .success, title: activitiesString, body: mes)
      }
    }
  }
  
  func toggleFidgetVisibility(flag : Bool) {
   
  }
  
  @objc func backBtnTap() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc func editPhotoTapped(){
    self.performSegue(withIdentifier: "showimage", sender: self)
  }
  
  func checkInternet(){
    if  InternetAvailability.isConnectedToNetwork() == true {
      guard let userData = self.userData else {
        return
      }
      if let userName =  userData.name {
        defaults.set(userName, forKey: "UserName")
    self.navigationItem.title = userName
        getUserData()
      }
    }
    else {
      self.navigationItem.title = "Sell4Bids"
      self.alert(message: "Make sure your Device is connected to Internet", title: "No Internet Connection")
    }
  }
  
  @objc func editProfileImageTapped(){
    let controller = storyboard?.instantiateViewController(withIdentifier: "EditUserProfileVc") as? EditUserProfileVc
    navigationController?.pushViewController(controller!, animated: true)
  }

  func getUserData(){
    //self.navigationItem.title = self.userArray[0].name
    guard let userData = self.userData else { return }
    self.userNameLabel.text = userData.name
    self.emailLabel.text = userData.email
    defaults.set(userData.image, forKey: "UserImage")
    
   self.userImageview.sd_setImage(with: URL(string: userData.image ?? ""), placeholderImage: UIImage(named: "Profile-image-for-sell4bids-App" ))
    
    self.stateLabel.text = userData.state
    if let zipCode = userData.zipCode {
      self.zipCodeLabel.text = "\(zipCode)"
    }
    else {
      self.zipCodeLabel.text = "Edit Profile to update ZipCode"
    }
    
    if let followerNumber = userData.follower  {
        var followerNumbertxt = String()
        if followerNumber == 1 {
            followerNumbertxt = "Memebers"
        }else {
            followerNumbertxt = "Member"
        }
      self.followerLabel.text = "\(followerNumber) \(followerNumbertxt)"
    }
    if let followingNumber = userData.following  {
        var followingNumbertxt = String()
        if followingNumber == 1 {
            followingNumbertxt = "Members"
        } else {
            followingNumbertxt = "Member"
        }
      self.followingLabel.text =  "\(followingNumber) \(followingNumbertxt)"
    }
    if let totalSelling =  userData.totalListing  {
        var totalSellingtxt = String()
        if totalSelling > 1 {
            totalSellingtxt = "Items"
        }else {
            totalSellingtxt = "Item"
        }
      self.totalListingLabel.text = "\(totalSelling) \(totalSellingtxt)"
    }
    if let totalBuying =  userData.buying  {
        var totalBuyingtxt = String()
        if totalBuying > 1 {
            totalBuyingtxt = "Items"
        }else {
            totalBuyingtxt = "Item"
        }
      self.buyingLabel.text = "\(totalBuying) \(totalBuyingtxt)"
    }
    if let totalWatching =  userData.watching  {
        var itemtxt = String()
        if totalWatching > 1 {
            itemtxt = "Items"
        }else {
            itemtxt = "Item"
        }
      self.watchingLabel.text = "\(totalWatching) \(itemtxt)"
    }
    if let totalBought =  userData.bought  {
        var totalBoughttxt = String()
        if totalBought > 1 {
            totalBoughttxt = "Items"
        }else {
            totalBoughttxt = "Item"
        }
        
      self.boughtLabel.text = "\(totalBought) \(totalBoughttxt)"
    }
    if let totalNotify = userData.unReadNotify  {
        var totalNotifytxt = String()
        if totalNotify > 1 {
            totalNotifytxt = "Notifications"
        }else {
            totalNotifytxt = "Notification"
        }
        
      self.unReadNotifyLabel.text = "\(totalNotify) \(totalNotifytxt) "
    }
    if let totalmesage = userData.unReadMessage  {
        var totalmessagetxt = String()
        if totalmesage > 1 {
            totalmessagetxt = "Messages"
        }else {
            totalmessagetxt = "Message"
        }
      self.unReadMessagedLabel.text = "\(totalmesage) \(totalmessagetxt)"
    }
    if userData.averageRating != 0 {
      if let totalRating = userData.averageRating  {
       
        self.cosmosViewrating.rating = Double(totalRating)
        print("totalrating == \(totalRating)")
           let formatted = String(format: "%.2f", totalRating)
         self.totalRatingLabel.text = "( Total ratings : \(formatted) )"
        self.cosmosViewrating.reloadInputViews()
      }
      if let totalRatings = userData.totalRating  {
     
        let totalRatingsInt = Int(totalRatings)
       
      }
    }
    else {
      
      
      self.cosmosViewrating.rating = 5
      self.totalRatingLabel.text = "No ratings Yet"
    }
    self.cosmosViewrating.settings.updateOnTouch = false
    
  }
  //MARK:- IBActions and user interaction
  
  @IBAction func btnEditDetailsTapped(_ sender: UIButton) {
    editProfileImageTapped()
  }
  
  @IBAction func btnChangePhotoTapped(_ sender: UIButton) {
    editphotoButtonTapped(sender)
  }
  
  @IBAction func switchBuyingActivitiesTouched(_ sender: UISwitch) {
    print("buying activies touches")
    if sender.isOn {
      toggleActivitiesOfUser(flag: true, flagBuyingOrSelling: 0)
    }//end if sender.isOn
    else {
      toggleActivitiesOfUser(flag: false, flagBuyingOrSelling: 0)
    }
  }
    
    
    
    
  
  @IBAction func switchSellingActivitiesTapped(_ sender: UISwitch) {
    if sender.isOn {
      toggleActivitiesOfUser(flag: true, flagBuyingOrSelling: 1)
    }//end if sender.isOn
    else {
      toggleActivitiesOfUser(flag: false, flagBuyingOrSelling: 1)
    }
  }
    
    
    @IBAction func ChatActivitiesTouched(_ sender: UISwitch) {
        print("buying activies touches")
        if sender.isOn {
            toggleActivitiesOfUser(flag: true, flagBuyingOrSelling: 2)
        }//end if sender.isOn
        else {
            toggleActivitiesOfUser(flag: false, flagBuyingOrSelling: 2)
        }
    }
    
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let dest = segue.destination as? ChangeImagePopUpVc
    
    dest?.delegate = self
  }
  
  func dataChanged(UserImage: UIImage) {
    userImageview.image = UserImage
  }
  
  @IBAction func editphotoButtonTapped(_ sender: UIButton) {
    self.performSegue(withIdentifier: "changePhotoPopUp", sender: self)
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let cell = tableView.cellForRow(at: indexPath)
    cell?.contentView.addShadowView()
    cell?.selectionStyle = UITableViewCellSelectionStyle.none
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
   
    if indexPath.row == 1 {
      return Env.isIpad ? 80 : 70
    }
    else if indexPath.row == 6 {
      return Env.isIpad ? 250 : 200
      
    }
    return super.tableView(tableView, heightForRowAt: indexPath)
  }
}
