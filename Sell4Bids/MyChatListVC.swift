//
//  MyChatList.swift
//  Sell4Bids
//
//  Created by H.M.Ali on 11/2/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import Crashlytics
import SDWebImage
import XLPagerTabStrip



class MyChatListVC: UIViewController, IndicatorInfoProvider  {

    var itemprice = String()
    @objc func connected(_ sender:AnyObject){
        print("you tap image number : \(sender.view.tag)")
        let index: Int = sender.view.tag
        
      
        if usersIamChattingWith[index].category != nil && usersIamChattingWith[index].auctionType != nil && usersIamChattingWith[index].itemKey != nil && usersIamChattingWith[index].itemState != nil {
            print("Category = \(usersIamChattingWith[index].category!)")
            print("Auctiontype = \(usersIamChattingWith[index].auctionType!)")
            print("ItemKey = \(usersIamChattingWith[index].itemKey!)")
            print("ItemState = \(usersIamChattingWith[index].itemState!)")
        dbRef = FirebaseDB.shared.dbRef
        dbRef.child("products").child(usersIamChattingWith[index].category!).child(usersIamChattingWith[index].auctionType!).child(usersIamChattingWith[index].itemState!).child(usersIamChattingWith[index].itemKey!).observeSingleEvent(of: .value, with: { [weak self] (productSnapshot) in
            guard let this = self else { return }
            
            if productSnapshot.childrenCount > 0 {
                guard let productDict = productSnapshot.value as? [String : Any] else {
                    print("ERROR: while fetchinh products Dicts")
                    return
                }
                print("product City == \(productDict)")
                let product = ProductModel.init(categoryName: this.usersIamChattingWith[index].category!, auctionType: this.usersIamChattingWith[index].auctionType!, prodKey: this.usersIamChattingWith[index].itemKey!, productDict: productDict)
                    this.selectedproduct = product
                let selectedProduct = this.selectedproduct
               
                
                let prodDetailsSB = getStoryBoardByName(storyBoardNames.prodDetails)
                let controller = prodDetailsSB.instantiateViewController(withIdentifier: "ProductDetailVc") as! ProductDetailVc
                controller.productDetail = selectedProduct
                
                this.nav?.pushViewController(controller, animated: false)
              //  this.navigationController?.navigationBar.frame = CGRect(x: 0, y: 33, width: 50, height: 40)

            }
        })
        
        }
    }
    
    
    @IBOutlet weak var ChatError: UIView!
    var chatItem : ChatItem?
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo.init(title: "My Chat")
  }
    
    
    @objc func backBtnTap() {
        dismiss(animated: true, completion: nil)
    }
    
    
    var dbRef = DatabaseReference()
    var selectedproduct : ProductModel?
    
    @objc func selectitemImg() {
         dbRef = FirebaseDB.shared.dbRef
        dbRef.child("products").child((chatItem?.category)! ).child((chatItem?.auctionType)!).child((chatItem?.itemState)! ).child((self.chatItem?.itemKey)!).observeSingleEvent(of: .value, with: { [weak self] (productSnapshot) in
            guard let this = self else { return }
            if productSnapshot.childrenCount > 0 {
                guard let productDict = productSnapshot.value as? [String:AnyObject] else {
                    print("ERROR: while fetchinh products Dicts")
                    return
                }
                let product = ProductModel(categoryName: (this.chatItem?.category)!, auctionType: (this.chatItem?.auctionType)!, prodKey: (this.chatItem?.auctionType)!, productDict: productDict)
                if product.categoryName != nil && product.auctionType != nil && product.state != nil{
                   
                }
                this.selectedproduct = product
            }
        })
        
        let selectedProduct = self.selectedproduct
        
        let prodDetailsSB = getStoryBoardByName(storyBoardNames.prodDetails)
        let controller = prodDetailsSB.instantiateViewController(withIdentifier: "ProductDetailVc") as! ProductDetailVc
        controller.productDetail = selectedProduct
        
        nav?.pushViewController(controller, animated: false)
      //  self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 33, width: 50, height: 40)

    }
    fileprivate func addDoneLeftBarBtn() {
        
        
        addLogoWithLeftBarButton()
        let doneBarBtn = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(backBtnTap))
        navigationItem.title = "My Chat"
        let button = UIButton.init(type: .custom)
        button.setImage( #imageLiteral(resourceName: "hammer_white")  , for: UIControlState.normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItems = [doneBarBtn , barButton ]
    }
  //MARK:-Properties
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var fidgetImageView: UIImageView!
  var nav:UINavigationController?
  //MARK:- variables
  var usersIamChattingWith = [UserData]()
  var flagUsedInMySell4Bids = true
  var myID = ""
  var myName = ""
  var ownerId = ""
  var ownerName = ""
  var itemimg = ""
  
  var flagViewDidLoadCalled = false
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  @IBOutlet weak var bottomTableView: NSLayoutConstraint!
  @IBOutlet weak var dimView: UIView!
  
  var refreshControl = UIRefreshControl()
  var fidgetbool = Bool()
  override func viewDidLoad() {
    
    super.viewDidLoad()
 
    print("Ahmed123")
    downloadAndShowChatList()
    addDoneLeftBarBtn()
    //setupNavigation()
    //setupBarButton()
    addInviteBarButtonToTop()
    self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
    setupViews()
   

    flagViewDidLoadCalled = true

    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    writeTime(id: SessionManager.shared.userId)
    
    
//    if !flagViewDidLoadCalled {
//      loadUserChatList { [weak self] (success, usersIamChattingWithOpt) in
//        guard let strongSelf = self , success, let users = usersIamChattingWithOpt else {
//          return
//        }
//        var indexPathsToReload : [IndexPath] = []
//        if users != strongSelf.usersIamChattingWith {
//          for (index, userSelf)  in strongSelf.usersIamChattingWith.enumerated() {
//            let userNew = users[index]
//            if userNew != userSelf {
//              let indexPathToReload = IndexPath.init(row: index, section: 0)
//              indexPathsToReload.append(indexPathToReload )
//
//            }
//          }
//          DispatchQueue.main.async {
//            strongSelf.tableView.reloadRows(at: indexPathsToReload, with: .automatic)
//          }
//        }
//      }
//    }
    
    tabBarController?.tabBar.isHidden = false
  }
    override func viewLayoutMarginsDidChange() {
        
    }
//    override func viewWillLayoutSubviews() {
//        tableView.layer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
//    }
  override func viewWillDisappear(_ animated: Bool) {
    flagViewDidLoadCalled = false
  }
  
  func setupNavigation() {
    self.navigationItem.title = "My Chat"
    
    self.navigationController?.navigationBar.backgroundColor = UIColor.red
    
    
  }
  func setupBarButton() {
    let barItem = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(backBtnTap))
    navigationItem.leftBarButtonItem = barItem
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = UIColor.white
  }
  
  fileprivate func setupViews() {
    if fidgetbool {
        ChatError.isHidden = true
     fidgetImageView.toggleRotateAndDisplayGif()
    }
   
    refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
    refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
    tableView.addSubview(refreshControl)
    
    func setupTableBottom() {
      
      if flagUsedInMySell4Bids {
        bottomTableView.constant = 8
      }else {
        bottomTableView.constant = 8
      }
      UIView.animate(withDuration: 0.3) {
        self.view.layoutIfNeeded()
      }
    }
    //setupTableBottom()
    
    
  }
  
  @objc func refresh(sender:AnyObject) {
    downloadAndShowChatList()
  }
  

  private func downloadAndShowChatList() {
    tableView.hide()
    dimView.fadeIn(alpha: 0.3)
    print("Working")
    loadUserChatList { [weak self] (success, usersIamChattingWith) in
          print("Working 2 ")
      guard let strongSelf = self , success, let users = usersIamChattingWith else {
          self!.ChatError.isHidden = false
        self!.fidgetbool = false
        print("Not Working 3 ")
        return
      }
        
        self!.fidgetbool = true
        print("Working 3 ")
        print("Sucess == \(success)")
       
      print("inside handler")
      strongSelf.refreshControl.endRefreshing()
      strongSelf.usersIamChattingWith = users
      strongSelf.dimView.fadeOut()
      DispatchQueue.main.async {
        strongSelf.tableView.reloadData()
        strongSelf.tableView.fadeIn()
        
      }
        
    }
  }
  func getUserImageUrl(userId: String, completion: @escaping (Bool, String?) ->() ) {
    let userRef = FirebaseDB.shared.dbRef.child("users").child(userId)
    
    userRef.observeSingleEvent(of: .value) { (snap) in
      guard let snap = snap.value as? [String:Any], let imageUrlStr = snap["image"] as? String else {
        completion(false, nil)
        return
      }
      completion(true, imageUrlStr)
    }
  }
  
  func loadUserChatList(completion: @escaping (Bool, [UserData]?) -> () ){
    
    self.myID = SessionManager.shared.userId
    
    let refDB = FirebaseDB.shared.dbRef
    let refUsers = refDB.child("users")
    let refuserChat = refUsers.child(self.myID).child("chat")
      var userkey = String()
   
    
    //update timeStamp
    
    let dic = ["temporaryTimeStamp":ServerValue.timestamp()]
    refDB.updateChildValues(dic)
    //print("SessionManager.shared.userId \(SessionManager.shared.userId)" )
    
    var taskCompleted = false
    Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] (_) in
      guard let this = self, !taskCompleted else { return }
      DispatchQueue.main.async {
        this.fidgetImageView.isHidden = false
      }
    }
    //getting my last activity time
    refDB.child("users").child(myID).observeSingleEvent(of: .value) { [weak self] (snapshotUser) in
      guard let this = self else { return }
      
      var lastActivityTime: Int64 = 0
      if snapshotUser.value != nil{
        
        var v = snapshotUser.value as! [String: Any]
        if v["startTime"] != nil{
          //start time = last activity time
          lastActivityTime = v["startTime"] as! Int64
          
        }
        
        if v["name"] != nil{
          this.myName = v["name"] as! String
        }
      }
      
      refuserChat.observeSingleEvent(of: .value) { [weak self] (snapshotUserChat) in
        guard let this = self else {
          completion(false, nil)
          return
          
        }
        
        if snapshotUserChat.hasChildren(){
          //user -> chat has a list of all keys as userIDs to which this user is chatting
          //each user id has a dictionary value having
          //name, token, uid, and unread count
          guard let chatValueDict = snapshotUserChat.value as? [String:Any] else {
            print("Error: guard let chatValueDict = snapshotUserChat.value as? [String:Any] failed")
            completion(false, nil)
            return
          }
          //print(chatValueDict)
          //for each user, this user is chatting with
          var index = 0
          print("total items in chatValueDict : \(chatValueDict.keys.count)")
          var usersIamChattingWith : [UserData] = []
          let myGroup = DispatchGroup()
            
           

          for userDict in chatValueDict{
            
            let keyUserID = userDict.key
            if keyUserID != SessionManager.shared.userId {
              
              let temp = UserData()
              myGroup.enter()
              refUsers.child(keyUserID).child("startTime").observeSingleEvent(of: .value, with: { [weak self ](snap) in
                
                index += 1
                //print("incremented index to :\(index)")
                guard let thisInner_ = self else { return }
                //print(snap)
                var currentUserLastActivityTime : Int64 = -1
                if let lastActivity = snap.value as? Int64{
                  currentUserLastActivityTime = lastActivity
                } else {
                  print("could not get last activity time of user with id\n\(keyUserID) in \(thisInner_)")
                  
                }
                
              
                
                
                  
                let dif = lastActivityTime - currentUserLastActivityTime
                
                if dif < 60000 && currentUserLastActivityTime != -1{
                  temp.status = "Online"
                }
                else if currentUserLastActivityTime != -1{
                  temp.status =   thisInner_.convertToString(timeInMilliSeconds: dif)
                }else {
                  temp.status = "Unknown"
                }
                temp.lastActivityTime = dif
              
              
                temp.id = keyUserID
                
                var userDictValue = [String:Any]()
                
                if let value = userDict.value as? [String:Any]  {
                  
                  userDictValue = value
                    print("User Dict Value =\(userDictValue)")
                }
                
                if let name = userDictValue["name"] as? String{
                  temp.name = name
                    print("Name == \(name)")
                }
                
                if let unreadCount = userDictValue["unreadCount"] as? String{
                  temp.unreadCount = unreadCount
                }
                
                if let imageUrl = userDictValue["image"] as? String {
                  temp.imageUrlStr = imageUrl
                }
                
                if let last_item = userDictValue["last_item"] as? NSDictionary {
                    temp.itemImg = last_item["itemImage"] as! String
                    let  auctionType = last_item["auctionType"] as! String
                    let  category = last_item["category"] as! String
                    if  last_item["itemPrice"] != nil {
                         let itemPrice = last_item["itemPrice"] as! String
                        self?.itemprice = itemPrice
                    }
                   
                    let itemTitle = last_item["itemTitle"] as! String
                    let  itemKey = last_item["itemKey"] as! String
                    let itemState = last_item["itemState"] as! String
                    temp.auctionType = auctionType
                    temp.category = category
                    temp.itemKey = itemKey
                    temp.itemState = itemState
                    temp.itemTitle = itemTitle
                    temp.itemPrice = self?.itemprice
                    
                    
                    self!.chatItem?.auctionType = auctionType
                    self!.chatItem?.category = category
                    self!.chatItem?.itemKey = itemKey
                    self!.chatItem?.itemState = itemState
                    
                    
                    
                    
                    
                    print("last time == \(last_item["itemImage"]!)")
                }
                
                if let lastMessage = userDictValue["lastMessage"] as? String {
                    temp.lastMessage = lastMessage
                }
                
               
                
                
                
                if !thisInner_.usersIamChattingWith.contains(temp) {
                  usersIamChattingWith.append(temp)
                  
                }
                
                
                usersIamChattingWith.sort(by: { (userData1, userData2) -> Bool in
                  guard let lastActivityTimeData1 = userData1.lastActivityTime , let
                    lastActivityTimeData2 = userData2.lastActivityTime else {
                      return false
                  }
                  return lastActivityTimeData1 < lastActivityTimeData2
                })
                
                myGroup.leave()
                
//                thisInner_.getUserImageUrl(userId: keyUserID, completion: { (success, imageUrlStr) in
//                  
//                  if success {
//                    temp.imageUrlStr = imageUrlStr
//                  }else {
//                    temp.imageUrlStr = nil
//                  }
//                  
//                  
//                  
//                  print("now index : \(index)")
//                  
//                })
              })
            }//end if keyUserID != SessionManager.shared.userId
            else {
              index += 1
              print("keyUserID != SessionManager.shared.userId failed")
            }
          }
          
          
          myGroup.notify(queue: DispatchQueue.main, execute: {
            taskCompleted = true
            DispatchQueue.main.async {
              this.fidgetImageView.isHidden = true
            }
            print("Finished all requests.")
            completion(true, usersIamChattingWith)
            
          })
              
//          if index == chatValueDict.keys.count  {
//            print("Going to reload table")
//            completion(true, usersIamChattingWith)
//
//          }
          
        }else {
          
          completion(false, nil)
        }
        
      }
    }
    
    
  }
  
  func convertToString(timeInMilliSeconds: Int64) -> String{
    var str: String = ""
    
    let seconds = timeInMilliSeconds/1000
    // 0 -> 59 seconds
    if seconds > 0 && seconds <= 59{
      // t = Int(Double(t).rounded(toPlaces: 1))
      let secString = seconds > 1 ? "seconds" : "second"
      str = "\(seconds)" + " \(secString) ago."
      return str
    }
    //>= one minute and <  hour, show minutes
    else if seconds > 59 && seconds < 3600{
      
      let minutes = seconds/60
      //t = Double(t).rounded(toPlaces: 1)
      let mintString = minutes > 1 ? "minutes" : "minute"
      str = "\(minutes) "+" \(mintString) ago."
      return str
    }
    //>= 1 hour
    else if seconds >= 3600{
      var hours = Int(seconds)
      hours = hours/3600
      
      let hourString = hours > 1 ? "hours" : "hour"
      str = "\(hours) "+" \(hourString) ago."
      //more than 24 hours passed
      if hours > 24{
        
        let days = hours/24
        //going into months
        if days < 30 {
          let dayStr = days > 1 ? "days" : "day"
          str = "\(days)" + " \(dayStr) ago."
          return str
        }
        else if days >= 30{
          let months = days/30
          //d = Double(d).rounded(toPlaces: 1)
          let monthStr = months > 1 ? "months" : "month"
          str = "\(months)" + " \(monthStr) ago."
          
          if months >= 12
          {
            let years = months/12
            //d = Double(d).rounded(toPlaces: 1)
            let yearStr = years > 1 ? "years" : "year"
            str = "\(years)" + " \(yearStr) ago."
            return str
          }
          return str
          
        }
        
      }
      return str
    }
    else
    {
      return ""
    }
  }
  
}

//MARK:- Private functions
extension MyChatListVC  {
  
  ///updates unReadCount node in user node and user -> chat -> \(chatting with user id) in a transaction. because when multiple users are chatting with this user (sending messages), some updates may lost.
  func updatedUnReadCountNodes ( completion: @escaping (Bool, TransactionResult) -> () )  {
    
    //clear unread count in user -> chat -> userIamChattingWith -> unread count
    
    let ref = FirebaseDB.shared.dbRef.child("users").child(self.myID)
    print("ref = \(ref)")
//    ref.runTransactionBlock({ (mutableData) -> TransactionResult in
//      if var data = mutableData.value as? [String:Any]{
//        print("data = \(data)")
//      }
//      return TransactionResult.success(withValue: mutableData)
//
//    }) { (error, Success, Snap) in
//      print("snap = \(Snap)")
//    }
    ref.runTransactionBlock { (mutableData) -> TransactionResult in
      //print(type(of: mutableData.value))
      if var data = mutableData.value as? [String:Any]{

        var mainUnreadCount = "0"

        if let unreadCount = data["unreadCount"] as? String, let unReadMainInt = Int(unreadCount){

          mainUnreadCount = unreadCount

            print("unreadCount Messages == \(unreadCount)")
          if var chatDict = data["chat"] as? [String:Any]{
            guard var ownerChatDict = chatDict[self.ownerId] as? [String:Any] else {
              print("Error: guard let ownerChatDict = chat[ownerId] as? [String:Any] failed in self")
              completion(false, TransactionResult.abort())
              return TransactionResult.abort()
            }

            guard let unReadCountForUser = ownerChatDict["unreadCount"] as? String else {
              print("Error: guard let unReadCountForUser = ownerChatDict[unreadCount] as? String")
              completion(false, TransactionResult.abort())
              return TransactionResult.abort()
            }
            ownerChatDict["unreadCount"] = "0"

            chatDict.updateValue(ownerChatDict, forKey: self.ownerId)

            data["chat"] = chatDict

            //deduct the number of unread chats from main unread node. (because all chats are read
            mainUnreadCount = "\(unReadMainInt-Int(unReadCountForUser)!)"

            data["unreadCount"] = "\(mainUnreadCount)"

            mutableData.value = data

            //            DispatchQueue.main.async {
            //              UIApplication.shared.applicationIconBadgeNumber = unReadMainInt
            //            }


            //            let dict = ["unRead" : unReadMainInt]
            //            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"updateTabBadgeNumber"), object:nil, userInfo: dict)
            completion(true, TransactionResult.success(withValue: mutableData) )
            return TransactionResult.success(withValue: mutableData)

          }else {
            completion(false, TransactionResult.abort())
            return TransactionResult.abort()
          }
        }else {
          completion(false, TransactionResult.abort())
          return TransactionResult.abort()
        }


      }else {
        completion(false, TransactionResult.abort())
        return TransactionResult.abort()
      }
    }
  }
 
  ///User selected a person (receiver) for chat. Set the number of UnRead in user -> chat -> (receiverID) -> UnReadCount to 0
  func setUnReadChatToZero(indexPath : IndexPath) {
    var ref = FirebaseDB.shared.dbRef.child("users").child(SessionManager.shared.userId).child("chat")
    guard let selectedUserID = usersIamChattingWith[indexPath.row].id else {
      print("Error : no user id found in setUnReadChatToZero ")
      return
      
    }
    
    ref = ref.child(selectedUserID).child("unreadCount")
    print("ref = \(ref)")
    ref.setValue("0")
    //print("selectedUserID \(selectedUserID)" )
    
    
    
  }
}

extension MyChatListVC : UITableViewDelegate, UITableViewDataSource {
  
  
  // MARK: - UITableViewDelegate, UITableViewDataSource
  static var colorIndexForInitialsBackground = 0
  func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return self.usersIamChattingWith.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "myChatCell", for: indexPath) as! MyChatCell
    
    guard indexPath.row < usersIamChattingWith.count  else {
      return cell
    }
    cell.unreadCountLabel.isHidden = true
  
    let user = self.usersIamChattingWith[indexPath.row]
    //cell.roundNameLabel.text = "\(ch!)".capitalized
    cell.nameLabel.text = user.name
    if let name = user.name, name.lowercased().contains("noah") {
      print("haha")
    }
    if let status = user.status {
      let lastActiveStr = status.lowercased().contains("online") ? "" : ""
      cell.onlineTextLabel.text = "\(lastActiveStr) \(status) "
    }
    
    
    if let count = usersIamChattingWith[indexPath.row].unreadCount ,  count != "0" {
      
      cell.unreadCountLabel.isHidden = false
      cell.unreadCountLabel.text = self.usersIamChattingWith[indexPath.row].unreadCount
    
      
    }
    // cell.statusLabel.text = self.data[indexPath.row].status
    if self.usersIamChattingWith[indexPath.row].status == "Online"{
      cell.statusLabel.backgroundColor = UIColor.green
    }
    else{
      cell.statusLabel.backgroundColor = UIColor.gray
    }
   
    cell.selectionStyle  = UITableViewCellSelectionStyle.none
    cell.userImageView.makeRound()
    cell.lblUserInitials.makeRound()
    cell.lblUserInitials.alpha = 1
    if let urlStr = user.imageUrlStr , let url = URL.init(string: urlStr) {
        cell.userImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "avatar"))
        cell.userImageView.show()
        cell.lblUserInitials.alpha = 0
    }else{
      if var name = usersIamChattingWith[indexPath.row].name {
        //set initials
        cell.userImageView.makeRound()
        cell.userImageView.hide()
        cell.lblUserInitials.alpha = 1
        
        let index = MyChatListVC.colorIndexForInitialsBackground % colorsArrayForBackGroundInitials.count
        cell.lblUserInitials.backgroundColor = colorsArrayForBackGroundInitials[index]
        MyChatListVC.colorIndexForInitialsBackground += 1
        //print("name = \(name)")
        //let components = name.components(separatedBy: " ")
        
//        if components.count > 1 {
//          if  !components[1].isEmpty , components[1] != "" {
//            let initials = name.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
//            cell.lblUserInitials.text = initials
//          }
//
//        }
        
        if name.isEmpty || name == "" {
          name = "User"
        }
      
        let initials = name[name.startIndex]
        cell.lblUserInitials.text = "\(initials)"
      
       
      }
      else {
        //placeholder image
        cell.userImageView.image = #imageLiteral(resourceName: "avatar")
        cell.userImageView.show()
      }
      
    }
 
        cell.itemImage.sd_setImage(with: URL(string: self.usersIamChattingWith[indexPath.row].itemImg ?? "" ), placeholderImage: UIImage(named: "emptyImage" ))
    cell.itemImage.addShadow()
    
       cell.lastMessage.text = self.usersIamChattingWith[indexPath.row].lastMessage ?? ""
     let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyChatListVC.connected(_:)))
    
    cell.itemImage.isUserInteractionEnabled = true
    cell.itemImage.tag = indexPath.row
    cell.itemImage.addGestureRecognizer(tapGestureRecognizer)
   
    
    return cell
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    chatwithseller = false
    selectedchatvalue = true
    updatedUnReadCountNodes {[weak self] (success, TransactionResult) in
      
      if !success  {
        print("self = \(self as Any)")
        DispatchQueue.main.async {
          //self?.showToast(message: "Could not update UnRead Count")
        }
      }
      
      
      DispatchQueue.main.async {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? MyChatCell else {
          return
        }
        
        guard let strongSelf = self else { return }
        strongSelf.setUnReadChatToZero(indexPath: indexPath)
        let user = strongSelf.usersIamChattingWith[indexPath.row]
        user.unreadCount = "0"
        strongSelf.tableView.reloadData()
        
        guard let name = user.name, let id = user.id else {
          return
        }
        let image =  cell.userImageView.image
        let dic = ["myID"       :strongSelf.myID,
                   "myName"     :strongSelf.myName,
                   "ownerName"  :name,
                   "ownerID"    :id,
                   "image"      :image ?? #imageLiteral(resourceName: "ic_profile")]
          as [String : Any]
        
        let chatSB = getStoryBoardByName(storyBoardNames.chat)
        //    let chatLogVC = chatSB.instantiateViewController(withIdentifier: "ChatLogVC") as! ChatLogVC
        //    chatLogVC.previousData = dic
        let chatLogVC = chatSB.instantiateViewController(withIdentifier: "ChatLogVC") as! ChatLogVC
      
        chatLogVC.previousData = dic
        
        if strongSelf.flagUsedInMySell4Bids {
          chatLogVC.delegate = self
            chatLogVC.selectedchat = strongSelf.usersIamChattingWith[indexPath.row]
          if let _ = strongSelf.tabBarController {
            strongSelf.tabBarController?.tabBar.isHidden = true
          }
          strongSelf.nav?.pushViewController(chatLogVC, animated: true)
        }else {
            strongSelf.navigationController?.pushViewController(chatLogVC, animated: false)
          //   strongSelf.navigationController?.navigationBar.frame = CGRect(x: 0, y: 50, width: 50, height: 40)
        }
        user.unreadCount = "0"
        
        
      }
      
      
    }
   
    
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    return 100
    }
}

extension MyChatListVC : ChatLogVCDelegate {
  func willMove() {
    usersIamChattingWith.removeAll()
    tableView.reloadUsingDispatch()
    downloadAndShowChatList()
  }
}



