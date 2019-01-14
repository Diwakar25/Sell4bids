  //
  //  MenuViewController.swift
  //  Sell4Bids
  //
  //  Created by admin on 8/29/17.
  //  Copyright © 2017 admin. All rights reserved.
  //
  
  import UIKit
  import Firebase
  import FirebaseStorage
  import FirebaseDatabase
  import SDWebImage
  import SwiftMessages
  var logoff = false
  
  
  class SideMenuVc: UIViewController{
    
    //MARK: - Properties
    @IBOutlet weak var imgViewUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    static var numOfUnReadNotifications = 0
    //MARK: - Variables
    var userData : UserModel?
    var productArray = [ProductModel]()
    var databaseHandle:DatabaseHandle?
    var dbRef: DatabaseReference!
    var imageUrl = ""
    var unreadCount:Int! = 0
    var unreadmsg = 0
    var unreadmsg1 = 0
    var nav:UINavigationController?
    var userHasUnReadNotifications = false
    var userHasUnReadMessages = false
    var arrayTableSections = [tableSection]()
    var width = CGFloat()
    var useridmsg = String()
    var textlabelmsg = UILabel()
    struct tableSection {
      let name : String
      var items : [tableItem]
    }
    struct tableItem {
      var name : String
      let image : UIImage
    }
    //MARK:- View Life Cycle
    
    
    
    override func viewDidLoad() {
      super.viewDidLoad()
        if unreadCount < 100 {
            width = UIDevice.isPad ? 370 : 300
        }else {
            width = UIDevice.isPad ? 380 : 315
        }
       
       
      self.revealViewController().rearViewRevealWidth = width
      
      dbRef = FirebaseDB.shared.dbRef
      
      getLoginUserData{ [weak self ] (complete) in
        guard let this = self else { return }
        let tap = UITapGestureRecognizer(target: self, action: #selector(SideMenuVc.imageTapped))
        this.imgViewUser.addGestureRecognizer(tap)
        this.imgViewUser.isUserInteractionEnabled = true
        guard let userData = this.userData else {
          return
        }
        if userData.unReadNotify! > 0 {
           
            this.arrayTableSections[0].items[8].name = "Notifications - \(userData.unReadNotify!) unread"
            
        
           
           
        }else {
             this.arrayTableSections[0].items[8].name = "Notifications"
        }
        if userData.unReadMessage! > 0 {
          self?.unreadmsg = userData.unReadMessage!
          this.arrayTableSections[0].items[5].name = "My Chat - \(userData.unReadMessage!) unread"
           
            
            self?.unreadmsg1 = userData.unReadMessage!
            print("Count msg =\(String(describing: userData.unReadMessage))")
        
          
        }else {
             this.arrayTableSections[0].items[5].name = "My Chat"
        }
        
        
      }
      //custome User Image
      imgViewUser.layer.borderWidth = 2
      imgViewUser.layer.borderColor = UIColor.white.cgColor
      imgViewUser.layer.cornerRadius = 50
      imgViewUser.layer.masksToBounds = false
      imgViewUser.clipsToBounds = true
      handleNilUserId()
      
      loadArrayTableSectionsWithData()
      getAndDisplayNotificationCount()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
      print("unRead count in viewDidAppear: \( self.unreadCount)")
        
        
        
    }
    
   
    
    
    fileprivate func getAndDisplayNotificationCount() {

      NetworkService.getNotificationCount{ [weak self ] (complete, unReadCount) in
        guard let this = self, let unRead = unReadCount else { return }

      let dict = ["unRead" : unRead]

        UIApplication.shared.applicationIconBadgeNumber = unReadCount!
        this.arrayTableSections[0].items[8].name = unReadCount! == 0 ? "Notifications" :  "Notifications - \(unReadCount!)  UnRead"
        SideMenuVc.numOfUnReadNotifications = unRead
        self?.unreadmsg = unRead
        this.userHasUnReadNotifications = unRead == 0 ? false : true
        DispatchQueue.main.async {
          this.tableView.reloadData()
        }
        //update notifications count in main user node
        updateNotCount(updatedCount: unRead, completion: { (success) in

        })
        //update notifications tab badge number
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"updateTabBadgeNumber"), object: nil, userInfo: dict)


      }
    }
    
    func loadArrayTableSectionsWithData() {
      let itemHome : tableItem = tableItem.init(name: "Home", image: #imageLiteral(resourceName: "Home"))
      let itemSell : tableItem = tableItem.init(name: "Sell Now", image: #imageLiteral(resourceName: "Sell now"))
      let itemCat : tableItem = tableItem.init(name: "Browse Categories", image: #imageLiteral(resourceName: "categories_top"))
//      let itemFilters : tableItem = tableItem.init(name: "Search Products", image: #imageLiteral(resourceName: "filterColor"))
      let itemMy : tableItem = tableItem.init(name: "My Sell4Bids", image: #imageLiteral(resourceName: "My Sell4Bids"))
      let itemJobs : tableItem = tableItem.init(name: "Jobs", image: #imageLiteral(resourceName: "Jobs"))
      let itemChat : tableItem = tableItem.init(name: "My Chat", image: #imageLiteral(resourceName: "chat"))
      let itemWatchList : tableItem = tableItem.init(name: "My Watch List", image: #imageLiteral(resourceName: "My view list"))
      let itemProfile : tableItem = tableItem.init(name: "My Profile", image: #imageLiteral(resourceName: "My Profile"))
      let itemNotification : tableItem = tableItem.init(name: "Notifications", image: #imageLiteral(resourceName: "Notification"))
      
      let itemsOfFirstSection :[tableItem] = [itemHome, itemSell, itemCat, itemMy, itemJobs, itemChat, itemWatchList, itemProfile, itemNotification]
      let sectionHome = tableSection.init(name: "Sell4Bids", items: itemsOfFirstSection)
      arrayTableSections.append(sectionHome)
      
      let itemWhatIs : tableItem = tableItem(name: "What is Sell4Bids?", image: #imageLiteral(resourceName: "My Sell4Bids"))
      let itemHowWorks : tableItem = tableItem(name: "How it Works?", image: #imageLiteral(resourceName: "How it works"))
      let itemEstablishContact : tableItem = tableItem(name: "Establish Contact", image: #imageLiteral(resourceName: "Establish contact"))
      
      let itemsOfAboutSell4Bids : [tableItem] = [itemWhatIs, itemHowWorks, itemEstablishContact]
      let sectionAbout = tableSection.init(name: "About Sell4Bids", items: itemsOfAboutSell4Bids)
      arrayTableSections.append(sectionAbout)
      
      let itemTerms = tableItem(name: "Terms and conditions", image: #imageLiteral(resourceName: "terms and condition")  )
      let itemPolicy = tableItem(name: "Privacy Policy", image: #imageLiteral(resourceName: "privacy policy"))
      let itemsOfLegal = [itemTerms, itemPolicy ]
      
      let sectionLegal = tableSection.init(name: "Legal", items: itemsOfLegal)
      arrayTableSections.append(sectionLegal)
      
      let itemRateUs = tableItem(name: "Rate Us", image: #imageLiteral(resourceName: "Rate us"))
      //let itemFeedback = tableItem(name: "Give Feedback", image: #imageLiteral(resourceName: "drawer_feedback"))
      let itemShare = tableItem(name: "Share this App", image: #imageLiteral(resourceName: "Share"))
      let itemLogOut = tableItem(name: "Logout", image: #imageLiteral(resourceName: "log out"))
      let itemsOfSettingsAndFeedBack = [itemRateUs, itemShare, itemLogOut ]
      
      let sectionSettings = tableSection.init(name: "FeedBack", items: itemsOfSettingsAndFeedBack)
      
      arrayTableSections.append(sectionSettings)
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
       
      navigationController?.setNavigationBarHidden(true, animated: false)
       
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
      
      super.viewDidDisappear(animated)
      
      navigationController?.setNavigationBarHidden(false, animated: false)
      
    }
    
    
    func handleNilUserId() {
      if Auth.auth().currentUser?.uid == nil {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let loginSignUpSB = getStoryBoardByName(storyBoardNames.loginSignupSB)
        let controller = loginSignUpSB.instantiateViewController(withIdentifier: "WelcomeVc")
        let nav = UINavigationController(rootViewController: controller)
        appdelegate.window!.rootViewController = nav
      }else {
        //print(" User ID : \( Auth.auth().currentUser?.uid)")
      }
      
    }
    
    @objc func imageTapped(){
      let myProfileSB = getStoryBoardByName(storyBoardNames.myProfileSB)
      if let controller = myProfileSB.instantiateViewController(withIdentifier: "UserProfileDetailVc") as? UserProfileDetailVc {
        controller.userData = self.userData
        let tbc = self.revealViewController().frontViewController as? UITabBarController
        let nav = UINavigationController.init(rootViewController: controller)
        tbc?.present(nav, animated: true, completion: nil)
        self.revealViewController().setFrontViewPosition(.left, animated: true)
      }
    }
    //var unread = 0
    
    
    func getLoginUserData(completion : @escaping (Bool) -> () ){
      guard let userId = Auth.auth().currentUser?.uid else {
        
        print("ERROR: While getting User ID")
        return
      }
        useridmsg = userId
      dbRef.child("users").child(userId).observe(.value, with:{ [weak self] (snapshot) in
        guard let this = self else { return }
        // Get user value
        if let dict = snapshot.value as? NSDictionary {
          var name = "Sell4Bids"
          if let checkname = dict["name"]{
            name = checkname as! String
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
          }
          var follow = "0"
          if let  followers = dict["followersCount"] as? String {
            follow = String(describing: Int(followers))
            
          }
          var following = "0"
          if let  followings = dict["followingsCount"] {
            following = followings as! String
            
          }
          
          print(this.unreadCount)
          
          
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
          this.imgViewUser.sd_setImage(with: URL(string: userData.image ?? "" ), placeholderImage: #imageLiteral(resourceName: "Profile-image-for-sell4bids-App-1"))
          
          completion(true)
          
          DispatchQueue.main.async {
            this.lblUserName.text = userData.name
            this.tableView.reloadData()
          }
        }
      })
      
    }
    
    deinit {
        print("Memeory Realse")
    }
    
  }
  
  //MARK: - UITableViewDelegate, UITableViewDataSource
  extension SideMenuVc : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      if section == 0 {
        return 0
      }
      return UIDevice.isPad ? 50 : 40
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
      guard section != 0 else { return }
      guard let header = view as? UITableViewHeaderFooterView else { return }
      header.textLabel?.textColor = UIColor.darkGray
      
      
      header.textLabel?.font = AdaptiveLayout.HeadingBold
      header.textLabel?.frame = header.frame
      header.textLabel?.textAlignment = .left
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      return arrayTableSections[section].name
    }
    func numberOfSections(in tableView: UITableView) -> Int {
      return arrayTableSections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return arrayTableSections[section].items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
    
      let image = arrayTableSections[indexPath.section].items[indexPath.row].image
      
        let text = arrayTableSections[indexPath.section].items[indexPath.row].name
        
        cell.menuLabel.tag = indexPath.row
      
//      if indexPath.section == 0 && indexPath.row == 8 {
//        text = "Notifications"
//        let count = SideMenuVc.numOfUnReadNotifications
//
//        if count > 0 {
//          text = "Notifications - \(SideMenuVc.numOfUnReadNotifications)"
//        }
//
//        print("text = \(text)")
//        if SideMenuVc.numOfUnReadNotifications != 0  {
//          cell.menuLabel.textColor = #colorLiteral(red: 0.8566855788, green: 0.1049235985, blue: 0.136507839, alpha: 1)
//        }
//        else { cell.menuLabel.textColor = UIColor.black }
//
//      }
        
       
        
       print("Section = \(indexPath.section)   Row = \(indexPath.row)")

      //cell.menuLabel.font = AdaptiveLayout.normalBold
      cell.imgIcon.image = image
      cell.menuLabel.text = text
        textlabelmsg = cell.menuLabel
        
        if (cell.menuLabel.text?.contains("My Chat - \(unreadmsg) unread"))! {
            cell.menuLabel.textColor = UIColor.red
        }else if (cell.menuLabel.text?.contains("Notifications -"))!{
            cell.menuLabel.textColor = UIColor.red
        }else{
            cell.menuLabel.textColor = UIColor.black
        }
//
      //cell.menuLabel.font = UIFont.boldSystemFont(ofSize: 20)
      cell.selectionStyle = UITableViewCellSelectionStyle.none
      
      return cell
    }
 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      if indexPath.section == 0 {
        
        if indexPath.row == 0
        {
          //Home
          let tbc = revealViewController().frontViewController as? UITabBarController
          // var nc = tbc?.selectedViewController as? UINavigationController
          tbc?.selectedIndex = 0
          self.revealViewController().setFrontViewPosition(.left, animated: true)
          
        }
        else if indexPath.row == 1 {
          //Sell Now
          let tbc = revealViewController().frontViewController as? UITabBarController
          //var nc = tbc?.selectedViewController as? UINavigationController
          tbc?.selectedIndex = 2
          self.revealViewController().setFrontViewPosition(.left, animated: true)
          
        }
        else if indexPath.row == 2 {
          //Browse Categories
          let tbc = revealViewController().frontViewController as? UITabBarController
          // var nc = tbc?.selectedViewController as? UINavigationController
          tbc?.selectedIndex = 3
          self.revealViewController().setFrontViewPosition(.left, animated: true)
        }
//        else if indexPath.row == 3 {
//          //Search Products
//          let storyBoard = getStoryBoardByName(storyBoardNames.tabs.homeTab)
//
//          if let controller = storyBoard.instantiateViewController(withIdentifier: "FiltersVc") as? FiltersVc {
//            controller.selfWasPushed = true
//            let tbc = revealViewController().frontViewController as? UITabBarController
//            let nav = UINavigationController.init(rootViewController: controller)
//            tbc?.present(nav, animated: true, completion: nil)
//            self.revealViewController().setFrontViewPosition(.left, animated: true)
//
//          }
//
//        }
        else if indexPath.row == 3 {
          //MySel4Bids
          let tbc = revealViewController().frontViewController as? UITabBarController
          //var nc = tbc?.selectedViewController as? UINavigationController
          tbc?.selectedIndex = 1
          self.revealViewController().setFrontViewPosition(.left, animated: true)
        
        }
        else if indexPath.row == 4 {
          //Jobs
          let SBName = storyBoardNames.tabs.categoriesTab
          let catDetailsSB = getStoryBoardByName(SBName)
          
          if let controller = catDetailsSB.instantiateViewController(withIdentifier: "jobsVc") as? jobsVc {
            
            controller.categoryName = "Jobs"
            let tbc = revealViewController().frontViewController as? UITabBarController
            let nav = UINavigationController.init(rootViewController: controller)
            tbc?.present(nav, animated: true, completion: nil)
            self.revealViewController().setFrontViewPosition(.left, animated: true)
            
          }
        }
          
        else if indexPath.row == 5{
            self.unreadmsg1 = 0
          //My Chat
          //          if let controller = self.storyboard?.instantiateViewController(withIdentifier: "MyChatList") as? MyChatListVC {
          //
//          let tbc = revealViewController().frontViewController as? UITabBarController
//          let nav = UINavigationController.init(rootViewController: controller)
//          self.revealViewController().setFrontViewPosition(.left, animated: true)
//          tbc?.present(nav, animated: true, completion: nil)
//
            
           let ref =  dbRef.child("users").child(useridmsg).child("unreadCount")
            ref.setValue("0")
            
            
          let chatSB = getStoryBoardByName(storyBoardNames.chat)
          let chatListVC = chatSB.instantiateViewController(withIdentifier: "MyChatList") as! MyChatListVC
          chatListVC.flagUsedInMySell4Bids = false
          
          let tbc = revealViewController().frontViewController as? UITabBarController
          let nav = UINavigationController.init(rootViewController: chatListVC)
          self.revealViewController().setFrontViewPosition(.left, animated: true)
          tbc?.present(nav, animated: true, completion: nil)
          
        }
          
        else if indexPath.row == 6 {
          //My Watch list
            let tbc = revealViewController().frontViewController as? UITabBarController
            //var nc = tbc?.selectedViewController as? UINavigationController
            tbc?.selectedIndex = 1
        
            
            
           
            
            
            
           
            self.revealViewController().setFrontViewPosition(.left, animated: true)
          
        }
        else if indexPath.row == 7 {
          //My Profile
          let myProfileSB = getStoryBoardByName(storyBoardNames.myProfileSB)
          
          if let controller = myProfileSB.instantiateViewController(withIdentifier: "UserProfileDetailVc") as? UserProfileDetailVc {
            controller.userData = self.userData
            let tbc = revealViewController().frontViewController as? UITabBarController
            let nav = UINavigationController.init(rootViewController: controller)
            tbc?.present(nav, animated: true, completion: nil)
            self.revealViewController().setFrontViewPosition(.left, animated: true)
            
          }
        }
        else if indexPath.row == 8{
            
         
         
          //notifications
          let tbc = revealViewController().frontViewController as? UITabBarController
          //var nc = tbc?.selectedViewController as? UINavigationController
          tbc?.selectedIndex = 4
           
          self.revealViewController().setFrontViewPosition(.left, animated: true)
        }
      }
      else if indexPath.section == 1 {
        //About sell4Bids
        if indexPath.row == 0 {
          //What is Sell4Bids
          
          let whatIsSell4bids_HowWorks_ContactSB = getStoryBoardByName(storyBoardNames.whatIsSell4bids_HowWorks_Contact)
          
          let controller = whatIsSell4bids_HowWorks_ContactSB.instantiateViewController(withIdentifier: "whatIsSell4Bids")
          let tbc = revealViewController().frontViewController as? UITabBarController
          let nav = UINavigationController.init(rootViewController: controller)
          tbc?.present(nav, animated: true, completion: nil)
          self.revealViewController().setFrontViewPosition(.left, animated: true)
          
          
        }
          
        else if indexPath.row == 1 {
          
          
          let whatIsSell4bids_HowWorks_ContactSB = getStoryBoardByName(storyBoardNames.whatIsSell4bids_HowWorks_Contact)
          let controller = whatIsSell4bids_HowWorks_ContactSB.instantiateViewController(withIdentifier: "howItWorksTableVC")
          let tbc = revealViewController().frontViewController as? UITabBarController
          let nav = UINavigationController.init(rootViewController: controller)
          tbc?.present(nav, animated: true, completion: nil)
          self.revealViewController().setFrontViewPosition(.left, animated: true)
          
        }
        else if indexPath.row == 2 {
          
          //Establish Contact
          let whatIsSell4bids_HowWorks_ContactSB = getStoryBoardByName(storyBoardNames.whatIsSell4bids_HowWorks_Contact)
          let controller = whatIsSell4bids_HowWorks_ContactSB.instantiateViewController(withIdentifier: "establishContact")
          let tbc = revealViewController().frontViewController as? UITabBarController
          let nav = UINavigationController.init(rootViewController: controller)
          tbc?.present(nav, animated: true, completion: nil)
          self.revealViewController().setFrontViewPosition(.left, animated: true)
          
        }
        
      }//end if indexPath.section == 1
      else if indexPath.section == 2 {
        //Legal
        if indexPath.row == 0 {
          //Terms and conditions
          if let controller = self.storyboard?.instantiateViewController(withIdentifier: "termsServiceVC") as? termsServiceVC {
            let tbc = revealViewController().frontViewController as? UITabBarController
            let nav = UINavigationController.init(rootViewController: controller)
            tbc?.present(nav, animated: true, completion: nil)
            self.revealViewController().setFrontViewPosition(.left, animated: true)
          }
        }
        if indexPath.row == 1 {
          //Privacy Policy
          
          if let controller = self.storyboard?.instantiateViewController(withIdentifier: "termsServiceVC") as? termsServiceVC {
            let tbc = revealViewController().frontViewController as? UITabBarController
            controller.flagShowTerms_or_PrivacyPolicy = 1
            let nav = UINavigationController.init(rootViewController: controller)
            tbc?.present(nav, animated: true, completion: nil)
            self.revealViewController().setFrontViewPosition(.left, animated: true)
            
          }
          
          
        }
      }//end if indexPath.section == 2
      else if indexPath.section == 3 {
        //Settings & Feedback
        if indexPath.row == 0 {
          //Rate Us
          
          guard let url = URL(string : "itms-apps://itunes.apple.com/app/id1304176306") else {
            return
          }
          guard #available(iOS 10, *) else {
            return
          }
          UIApplication.shared.open(url, options: [:])
        }
        else if indexPath.row == 1 {
          //Share this App
          let messageStr = "Did you install the Official Sell4Bids App? You wil find Stuff, Services, Jobs, Offers, Counter-Offers, Auctions & Bidding and a whole lot more.\n\n"
          
          let itunesLink = URL.init(string: "https://itunes.apple.com/us/app/sell4bids/id1304176306?mt=8")!
          
          let activityItems = [ messageStr, itunesLink] as [Any]
          let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
          activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
          
          self.present(activityViewController, animated: true, completion: nil)
        }
        else if indexPath.row == 2 {
          //Log Out
          //log out function
          func logOut() {
            SessionManager.logOut()
            if Auth.auth().currentUser == nil
            {
              let loginSignUpSB = getStoryBoardByName(storyBoardNames.loginSignupSB)
              let controller = loginSignUpSB.instantiateViewController(withIdentifier: "WelcomeVc")
                self.navigationController?.popToRootViewController(animated: true)
               // self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)

                UIApplication.shared.keyWindow?.rootViewController?.dismiss(
                    animated: false, completion: nil)
                let thread_count: mach_msg_type_number_t = 0
                 let size = MemoryLayout<thread_t>.size * Int(thread_count)
                
                
                
              
               
                
              let nav = UINavigationController(rootViewController: controller)
            
             // self.navigationController?.popToRootViewController(animated: true)
             
              self.present(nav, animated: true, completion: {
                showSwiftMessageWithParams(theme: .success, title: "Signed Out", body: "You have been Successfully signed out from Sell4bids.", durationSecs: 10, layout: .cardView, position: .center)
               
              })
              
              
            }else {
              self.alert(message: "Sorry, Could not sign you out")
              
            }
          }
          
          let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to Sign Out? ", preferredStyle: .alert)
          let actionYes = UIAlertAction.init(title: "Yes", style: .destructive) { (action ) in
            logOut()
          }
          alert.addAction(actionYes)
          alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel))
          
          

          
          self.present(alert, animated: true)
          
          
        }
        else if indexPath.row == 3 {
          //Log Out
          
        }
      }
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
      var height : CGFloat = 0
      if UIDevice.isSmall { height = 40 }
      if UIDevice.isMedium { height = 45 }
      if UIDevice.isPad { height = 50  }
      else if UIDevice.isX {height = 48 }
      
      
      return height
    }
    
    
    
   
    
  }

