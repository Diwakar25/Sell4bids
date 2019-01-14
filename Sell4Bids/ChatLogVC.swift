//
//  ChatLogVC.swift
//  Sell4Bids
//
//  Created by admin on 5/1/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift


struct ChatMessage {
    let text: String
    let isIncoming: Bool
    let date: Date

    var timeStamp : String?
    var receiver : String?
    var sender : String?
    var itemimg : String?
    var itemtitle : String?
    var receiverLastMessage = ""
    
}

extension Date {
    static func dateFromCustomString(customString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date =  dateFormatter.date(from: customString) ?? Date()
//        return date.addingTimeInterval(60*60*24)
                return date
    }
    
    func reduceToMonthDayYear() -> Date {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let year = calendar.component(.year, from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        var date =  dateFormatter.date(from: "\(month)/\(day)/\(year)") ?? Date()
        
        return date
        
        // .addingTimeInterval(-60 * -60 * -24)
    }
}


var suggestionDict = ["Hi":["Hi","Hello","Intrested"],"Last":["Hi","Ok","Then"],"Hello":["Hey","Hello","Intrested"],"Intrested":["Call me","Message me","Ok"]]

class ChatLogVC: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    
    @IBOutlet weak var textMessageHight: NSLayoutConstraint!
    
    @IBOutlet weak var ItemDetailView: UIView!
    var userName = String()
    var image = String()
    var heighttxt = CGFloat()
    var selectedchat : UserData?
    var last_item : ChatItem?
    var productUserId = String()
    var chatlistitemimages = [ChatItem]()
    var selectedproduct : ProductModel?
    var Suggestionmessage = String()
    
   
    @IBOutlet weak var suggestionBtn1: UIButton!
    @IBOutlet weak var suggestionBtn2: UIButton!
    @IBOutlet weak var suggestionBtn3: UIButton!
    var nav:UINavigationController?
    @IBOutlet weak var stackView: UIStackView!
    lazy var UserArray = [UserModel]()
    fileprivate let cellId1 = "id123"
  
    

    var messagesFromServer = [ChatMessage]()
    var chatMessages = [[ChatMessage]]()
    @objc func connected(_ sender:AnyObject){
        
        dbRef = FirebaseDB.shared.dbRef
        if chatwithseller {
            dbRef.child("products").child((selectedproduct?.categoryName)!).child((selectedproduct?.auctionType)!).child((selectedproduct?.state)!).child((selectedproduct?.productKey)!).observeSingleEvent(of: .value, with: { [weak self] (productSnapshot) in
                guard let this = self else { return }
                
                if productSnapshot.childrenCount > 0 {
                    guard let productDict = productSnapshot.value as? [String : Any] else {
                        print("ERROR: while fetchinh products Dicts")
                        return
                    }
                    print("product City == \(productDict)")
                    let product = ProductModel.init(categoryName: (this.selectedproduct?.categoryName)!, auctionType: (this.selectedproduct?.auctionType)!, prodKey: (this.selectedproduct?.productKey)!, productDict: productDict)
                    this.selectedproduct = product
                    
                    let prodDetailsSB = getStoryBoardByName(storyBoardNames.prodDetails)
                    let controller = prodDetailsSB.instantiateViewController(withIdentifier: "ProductDetailVc") as! ProductDetailVc
                    controller.productDetail = this.selectedproduct
                    
                    this.navigationController?.pushViewController(controller, animated: false)
                    
                }
                
            })
        }else{
            dbRef.child("products").child((selectedchat?.category)!).child((selectedchat?.auctionType)!).child((selectedchat?.itemState)!).child((selectedchat?.itemKey)!).observeSingleEvent(of: .value, with: { [weak self] (productSnapshot) in
            guard let this = self else { return }
            
            if productSnapshot.childrenCount > 0 {
                guard let productDict = productSnapshot.value as? [String : Any] else {
                    print("ERROR: while fetchinh products Dicts")
                    return
                }
                print("product City == \(productDict)")
                let product = ProductModel.init(categoryName: (this.selectedproduct?.categoryName)!, auctionType: (this.selectedproduct?.auctionType)!, prodKey: (this.selectedproduct?.productKey)!, productDict: productDict)
                this.selectedproduct = product
                
                let prodDetailsSB = getStoryBoardByName(storyBoardNames.prodDetails)
                let controller = prodDetailsSB.instantiateViewController(withIdentifier: "ProductDetailVc") as! ProductDetailVc
                controller.productDetail = this.selectedproduct
                
                this.navigationController?.pushViewController(controller, animated: false)
                
            }
            
        })
        
        }
        
        
    }
    
    func getproductUserDetials() {
        dbRef = FirebaseDB.shared.dbRef
        if selectedchat?.category != nil {
        dbRef.child("products").child((selectedchat?.category!)!).child((selectedchat?.auctionType)!).child((selectedchat?.itemState)!).child((selectedchat?.itemKey)!).observeSingleEvent(of: .value, with: { [weak self] (productSnapshot) in
            guard let this = self else { return }
            
            if productSnapshot.childrenCount > 0 {
                guard let productDict = productSnapshot.value as? [String : Any] else {
                    print("ERROR: while fetchinh products Dicts")
                    return
                }
                print("product City == \(productDict)")
                let product = ProductModel.init(categoryName: (this.selectedchat?.category)!, auctionType: (this.selectedchat?.auctionType)!, prodKey: (this.selectedchat?.itemKey)!, productDict: productDict)
               
                    this.selectedproduct = product
                print("product ID  2: \(product.userId)")
                if product.userId != nil {
                dbRef.child("users").child(product.userId!).observeSingleEvent(of: .value, with: { [weak self ](userSnapshot) in
                    guard let this = self else { return }
                    guard let userDict = userSnapshot.value as? [String:AnyObject] else {
                        print("ERRPR: while geting user Dict")
                        return
                    }
                    let user = UserModel(userId: product.userId!, userDict: userDict)
//                    this.titleview.userImg.sd_setImage(with: URL(string: user.image ?? " " ), placeholderImage: UIImage(named: "Profile-image-for-sell4bids-App" ))
//                    this.titleview.userName.text = user.name
                    
                    
                   
                })
                
                }else {
                    print("product ID nil")
                }
               
              
                
            }
            
        })
        }
    }
    
   @objc func connectuser(_ sender:AnyObject) {
        print("Get user Data")
    if chatwithseller{
        if let userId = selectedproduct!.userId {
            
            dbRef.child("users").child(userId).observe(.value, with: { [weak self ](userSnapshot) in
                guard let this = self else { return }
                guard let userDict = userSnapshot.value as? [String:AnyObject] else {
                    print("ERRPR: while geting user Dict")
                    return
                }
                let user = UserModel(userId: userId, userDict: userDict)
                this.UserArray.append(user)
               
                let selectUser = self!.UserArray[0]
                let userDetailSB = getStoryBoardByName(storyBoardNames.prodDetails)
                let controller = userDetailSB.instantiateViewController(withIdentifier: "UserProfileVc") as! SellerProfileVC
                controller.userData = selectUser
                
                this.navigationController?.pushViewController(controller, animated: false)
                
               
            })
        }
    }else{
        
        if chatwithseller {
            
            
            if let userId = selectedproduct!.userId {
                
                dbRef.child("users").child(userId).observe(.value, with: { [weak self ](userSnapshot) in
                    guard let this = self else { return }
                    guard let userDict = userSnapshot.value as? [String:AnyObject] else {
                        print("ERRPR: while geting user Dict")
                        return
                    }
                    let user = UserModel(userId: userId, userDict: userDict)
                    this.UserArray.append(user)
                    
                    let selectUser = self!.UserArray[0]
                    let userDetailSB = getStoryBoardByName(storyBoardNames.prodDetails)
                    let controller = userDetailSB.instantiateViewController(withIdentifier: "UserProfileVc") as! SellerProfileVC
                    controller.userData = selectUser
                    
                    this.navigationController?.pushViewController(controller, animated: false)
                    
                    
                })
            }
            
            
        }else {
        
            if let userId = selectedchat!.id {
                
                dbRef.child("users").child(userId).observe(.value, with: { [weak self ](userSnapshot) in
                    guard let this = self else { return }
                    guard let userDict = userSnapshot.value as? [String:AnyObject] else {
                        print("ERRPR: while geting user Dict")
                        return
                    }
                    let user = UserModel(userId: userId, userDict: userDict)
                    this.UserArray.append(user)
                    
                    let selectUser = self!.UserArray[0]
                    let userDetailSB = getStoryBoardByName(storyBoardNames.prodDetails)
                    let controller = userDetailSB.instantiateViewController(withIdentifier: "UserProfileVc") as! SellerProfileVC
                    controller.userData = selectUser
                    
                    this.navigationController?.pushViewController(controller, animated: false)
                    
                    
                })
            }
        }
    }
        
    }
    
    
    @IBAction func ItemDetails(_ sender: Any) {
        let storyBoard_ = UIStoryboard.init(name: storyBoardNames.prodDetails , bundle: nil)
        let controller = storyBoard_.instantiateViewController(withIdentifier: "ProductDetailVc") as! ProductDetailVc
        controller.productDetail = selectedProduct
        
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    //MARK:- Outlet
    
    
  //  @IBOutlet weak var chatCollectionView: UICollectionView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var textViewMessage: UITextView!
    @IBOutlet weak var btnSendMessage: UIButton!
    
    @IBOutlet weak var tabview: UITableView!
    @IBOutlet weak var ItemImg: UIImageView!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var topColView: NSLayoutConstraint!
    weak var delegate : ChatLogVCDelegate?
    //MARK:- Properties
    var currentTimeStamp: Int64 = 0
    var messages = [MessageOld]()
    var lastValueOfMyMessage : Int64 = 0
    let cellId = "cell"
    var previousData = [String:Any]()
    let placeHolderText = "Type a message..."
    var timeStamp: Int64 = 0
    var widthtext = CGFloat()
    var myID = ""
    var ownerId = ""
    var ownerName = ""
    var myName : String = ""
    var concatenatedID = ""
    var userImage : UIImage?
    var userCurrentImg : String?
    
    @IBOutlet weak var bottomChatToSafeArea: NSLayoutConstraint!
    //MARK:- View Life Cycle
    
    
    @IBOutlet weak var bottomTextViewToSafe: NSLayoutConstraint!
    
    

    var titleview = Bundle.main.loadNibNamed("ChatNavigation", owner: self, options: nil)?.first as! ChatNavi
    
    override func viewLayoutMarginsDidChange() {
        titleview.frame =  CGRect(x: 0, y: 0, width: (navigationController?.navigationBar.frame.width)!, height: (navigationController?.navigationBar.frame.height)!)
        
        
        print("titleview width = \(titleview.frame.width)")
    }
    override func viewWillLayoutSubviews() {
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        tabview.delegate = self
        tabview.dataSource = self
        
        tabview.register(ChatMessageCell.self, forCellReuseIdentifier: cellId1)
        tabview.separatorStyle = .none
        suggestionBtn1.layer.cornerRadius = 12
        suggestionBtn2.layer.cornerRadius = 12
        suggestionBtn3.layer.cornerRadius = 12
        attemptToAssembleGroupedMessages()
        
        
        getproductUserDetials()
        print("product ID : \(selectedchat?.id)")
        getDataFromDictSent()
        
      
        print("Product ID = \(selectedproduct?.userId)")
   
        textViewMessage.delegate = self
        dbRef = FirebaseDB.shared.dbRef
        var userdetails = FirebaseDB.shared.dbRef
        if chatwithseller{
        userdetails = dbRef.child("users").child((selectedproduct?.userId)!)
        }else if selectedchatvalue ?? false {
            if selectedchat?.id != nil {
                userdetails = dbRef.child("users").child((selectedchat?.id)!)
            }else {
                print("SelectedChat ID not Found")
            }
            
        }
        
        userdetails.observeSingleEvent(of: .value) { (snapshot) in
            
            print("snapshot count = \(snapshot.children.allObjects.count)")
            let datadic = snapshot.value as! NSDictionary
            
            let namenodenew = datadic["name"] as? String
            if namenodenew != nil {
                self.myName = namenodenew ?? "Sell4Bid User"
            }
            
            let imagenodenew = datadic["image"] as? String
            if imagenodenew != nil {
                self.userCurrentImg = imagenodenew ?? " "
            }
            
           
           
            self.titleview.itemImage.addShadowAndRound()
            self.titleview.itemImage.makeRound()
            
            if self.selectedproduct?.title !=  nil  && self.selectedproduct?.imageUrl0 != nil {
                self.titleview.itemImage.sd_setImage(with: URL(string: self.selectedproduct?.imageUrl0 ?? "" ),placeholderImage: UIImage(named: "emptyImage" ))
                self.titleview.itemTitle.text = self.selectedproduct?.title
                let tapGestureRecongizer = UITapGestureRecognizer(target: self, action: #selector(self.connected(_:)))
                self.titleview.itemImage.addGestureRecognizer(tapGestureRecongizer)
            }else {
                self.titleview.itemTitle.isHidden = true
                self.titleview.itemImage.isHidden = true
                
            }
          
            self.titleview.itemImage.isUserInteractionEnabled = true
            
            
            
            self.titleview.userImg.addShadowAndRound()
            self.titleview.userImg.makeRound()
            
//            let tapGestureRecongizer1 = UITapGestureRecognizer(target: self, action: #selector(self.connectuser(_:)))
//            self.titleview.userImg.isUserInteractionEnabled = true
//            self.titleview.userImg.addGestureRecognizer(tapGestureRecongizer1)
            //
            
            
            self.titleview.userImg.sd_setImage(with: URL(string: self.userCurrentImg ?? "" ),placeholderImage: UIImage(named: "Profile-image-for-sell4bids-App" ))
            
      
            self.titleview.userName.text = self.myName
            
             self.navigationItem.titleView = self.titleview
            self.navigationItem.title = ""
            
            
        }
        
       
     
        
        
        
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        
        setupViews()
        
       

        
      
        
        getCurrentServerTime { [weak self] (success, currentTime) in
            guard let this = self else { return }
            this.currentTimeStamp = Int64(currentTime)
        }
        getDataFromDictSent()
        getAndShowMessages()
        
        updatedUnReadCountNodes()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
     //   --
         print("numberOfSections = \(messagesFromServer.count)")
    
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabview.dequeueReusableCell(withIdentifier: cellId1, for: indexPath) as! ChatMessageCell
        //        let chatMessage = chatMessages[indexPath.row]
        print("message22 = \(messages[indexPath.row].message)")
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let message = messages[indexPath.item]
        let cellSpacing : CGFloat = 5
       
        if let messageText = message.message {
            
            if message.receiver == SessionManager.shared.userId  {
                
                
                cell.messageLabel.text = messages[indexPath.row].message
                cell.isIncoming = true
                
            
                func handleTimeSender() {
                    
                    let time = Int64(messages[indexPath.row].timeStamp!)!
                    let f = Date(milliseconds: Int(time))
                    let currentTime = self.currentTimeStamp
                    let difference = Int64(currentTime) - time
                    
                    let a = "\(f)"
                    var m  = a.components(separatedBy: " ")
                    var n = m[1].components(separatedBy: ":")
                    let thisIsRecivedMessage = message.receiver == SessionManager.shared.userId
                    
                    let timeText = "\(n[0])"+":"+"\(n[1])"
                    
                 //   cell.timeLabel.text = timeText
                 cell.timeLabel.text = TimeStempDateConversion(value: messages[indexPath.row].timeStamp!)
                    print("timetext = \(timeText)")
                    
                }
                
                handleTimeSender()
              
               

                
                
            }else {
                func handleTimeSender() {
                    
                    let time = Int64(messages[indexPath.row].timeStamp!)!
                    let f = Date(milliseconds: Int(time))
                    let currentTime = self.currentTimeStamp
                    let difference = Int64(currentTime) - time
                    
                    let a = "\(f)"
                    var m  = a.components(separatedBy: " ")
                    var n = m[1].components(separatedBy: ":")
                    let thisIsRecivedMessage = message.receiver == SessionManager.shared.userId
                    
                    let timeText = "\(n[0])"+":"+"\(n[1])"
                    
                  //   cell.timeLabel.text = timeText
                  cell.timeLabel.text = TimeStempDateConversion(value: messages[indexPath.row].timeStamp!)
                    print("timetext = \(timeText)")
                    
                }
                handleTimeSender()
                print("timecheck = \(handleTimeSender)")
                cell.messageLabel.text = messages[indexPath.row].message
                cell.isIncoming = false
                
                
            }
            
          
        }
        Suggestionmessage = messages[messages.count-1].message!
        print("suggestionmeg  = \(String(describing: Suggestionmessage))")
         self.suggestionOptions(lastMessage: messages[messages.count-1].message!)
        cell.Autoset()
        return cell
    }
    
    private func tableView(tableView: UITableView, willDisplay cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        print("willDisplay")
    }

    
    func suggestionOptions(lastMessage:String){
    
        print("last Message = \(lastMessage)")
        for value in suggestionDict {
            print("Value = Message = \(value.key)")
            if value.key == lastMessage {
                suggestionBtn1.isHidden = false
                suggestionBtn2.isHidden = false
                suggestionBtn3.isHidden = false

                print("value suggestion = \(value.key)")
//                suggestionBtn1.titleLabel?.text = value.value[0]
                suggestionBtn1.setTitle(value.value[0], for: .normal)
//                suggestionBtn2.titleLabel?.text = value.value[1]
                suggestionBtn2.setTitle(value.value[1], for: .normal)
//                suggestionBtn3.titleLabel?.text = value.value[2]
                suggestionBtn3.setTitle(value.value[2], for: .normal)
                break
            }else{
                suggestionBtn1.isHidden = true
                suggestionBtn2.isHidden = true
                suggestionBtn3.isHidden = true
            }
        }



    }
    
    @objc func buttonTapped( _ button : UIButton)
    {
        print("actionss")
        print(button.tag)
    }
    
    

    class DateHeaderLabel: UILabel {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundColor = .black
            textColor = .white
            textAlignment = .center
            translatesAutoresizingMaskIntoConstraints = false // enables auto layout
            font = UIFont.boldSystemFont(ofSize: 14)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override var intrinsicContentSize: CGSize {
            let originalContentSize = super.intrinsicContentSize
            let height = originalContentSize.height + 12
            layer.cornerRadius = height / 2
            layer.masksToBounds = true
            return CGSize(width: originalContentSize.width + 20, height: height)
        }
        
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tabview.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    @IBAction func SuggestionButtonSelectAction(_ sender: UIButton) {
        
        var btnmessage = ""
        if sender.tag == 1 {
            btnmessage = (suggestionBtn1.titleLabel?.text)!
            print("its 1 \(btnmessage)")
            textViewMessage.text = btnmessage
        }
        if sender.tag == 2 {
            btnmessage = (suggestionBtn2.titleLabel?.text)!
            print("its 2 \(btnmessage)")
            textViewMessage.text = btnmessage
        }
        if sender.tag == 3 {
            btnmessage = (suggestionBtn3.titleLabel?.text)!
            textViewMessage.text = btnmessage
            print("its 3 \(btnmessage)")
        }
        
        sendMessage()
        
        //sendMessage1(message: btnmessage)
    }
    
    fileprivate func attemptToAssembleGroupedMessages() {
        print("Attempt to group our messages together based on Date property")
        
        let groupedMessages = Dictionary(grouping: messagesFromServer) { (element) -> Date in
            return element.date.reduceToMonthDayYear()
        }
        
        // provide a sorting for your keys somehow
        let sortedKeys = groupedMessages.keys.sorted()
        sortedKeys.forEach { (key) in
            let values = groupedMessages[key]
            
            print("groupedmsh\(values)")
            chatMessages.append(values ?? [])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        toggleEnableIQKeyBoard(flag: false)
    }
    
    @objc func keyBoardWillShow(notification: NSNotification) {
        
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let adjustedConstant = keyboardFrame.size.height + 50
        debugPrint(adjustedConstant)
        
        
        bottomTextViewToSafe.constant = keyboardFrame.size.height + 5
        self.viewMessage.frame.origin.y = keyboardFrame.size.height - 5
        self.view.layoutIfNeeded()
        //    UIView.animate(withDuration: 0.3, animations: { () -> Void in
        //self.view.layoutIfNeeded()
        //      self.chatCollectionView.layoutIfNeeded()
        //      self.viewMessage.layoutIfNeeded()
        
        //    })
        //    if messages.count > 0 {
        //      let indexPath = IndexPath.init(row: self.messages.count - 1, section: 0)
        //      self.chatCollectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        //    }
        
        
        
    }
    
    @objc func keyBoardWillHide(notification: NSNotification) {
        
        // bottomChatToSafeArea.constant =  0
        bottomTextViewToSafe.constant =  5
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
        //-    self.chatCollectionView.layoutIfNeeded()
            self.viewMessage.layoutIfNeeded()
            self.view.layoutIfNeeded()
        })
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
//--        if touch?.view == self.view || touch?.view == self.chatCollectionView {
//            DispatchQueue.main.async {
//                self.textViewMessage.resignFirstResponder()
//                self.view.endEditing(true)
//            }
//        }
    }
    
    func setupViews() {
//        self.title = ownerName
        
        
        btnSendMessage.makeRound()
        textViewMessage.addShadowAndRound()
        textViewMessage.tintColor = colorRedPrimay
        
        
    }
    private func estimateFrameForText(text: String) -> CGRect {
        //we make the height arbitrarily large so we don't undershoot height in calculation
        
        let height: CGFloat = 1000
        
        
        
        let size = CGSize(width: self.view.frame.width , height: height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)]
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
    
    //
    override func viewDidLayoutSubviews() {
        
        
    //-    let height = self.chatCollectionView.collectionViewLayout.collectionViewContentSize.height
        
    //-    self.heighttxt = height
        
        // adjust()
        
    }
    //
    ///if it is a first message, the collection view goes up and sender can't see the message in log.
    private func adjust() {
        if messages.count < 5 {
            //calculate total height of all messages
            
            let viewHeight = view.frame.height
            let bottomSpace : CGFloat = 55
            
            var messagesHeight : CGFloat = 0
            
            let size = CGSize(width: 250, height: 100)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            for message in messages {
                let estimatedFrame = NSString(string: message.message ?? "").boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)], context: nil)
                messagesHeight += estimatedFrame.height + 50
            }
            
            
            
            let topFinal = viewHeight - bottomSpace - messagesHeight
            if topFinal > 0 {
                topColView.constant = topFinal
            }
        }
    }
    
    func getDataFromDictSent() {
        
        guard let getmyID = previousData["myID"] as? String else {
         return print("myID is null")
        }
        myID = getmyID
        
      //  myID = previousData["myID"] as! String
        ownerId = previousData["ownerID"] as! String
        ownerName = previousData["ownerName"] as! String
//        self.title = ownerName
        myName = previousData["myName"] as! String
        if let image = previousData["image"] as? UIImage {
            self.userImage = image
            
        }
    }
    
    func getAndShowMessages() {
        NetworkService.chatRoomExistsWithUser(otherUsersId: ownerId) { (concatId:String, exists: Bool) in
            self.concatenatedID = concatId
            if exists {
                self.getMessagesOf(concatenatedId: concatId) { [weak self] (success, messages) in
                    guard let this = self , let messages = messages else {
                        //IQKeyboardManager.sharedManager().enable = false
                        //IQKeyboardManager.sharedManager().enableAutoToolbar = false
                        return
                        
                    }
                    
                    IQKeyboardManager.shared.enable = messages.count > 5
                    //IQKeyboardManager.sharedManager().enableAutoToolbar = messages.count > 5
                    
                    if messages.count > 5 {
                        
                        NotificationCenter.default.removeObserver(this, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
                        
                        NotificationCenter.default.removeObserver(this, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
                        
                        //            DispatchQueue.main.async {
                        //              this.textViewMessage.resignFirstResponder()
                        //              this.view.endEditing(true)
                        //            }
                        //            this.bottomChatToSafeArea.constant =  50
                        //            this.bottomTextViewToSafe.constant =  5
                        //
                        //
                        //            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        //              this.chatCollectionView.layoutIfNeeded()
                        //              this.viewMessage.layoutIfNeeded()
                        //              //self.view.layoutIfNeeded()
                        //            })
                        
                        
                    }
                    
                    this.messages = messages
                    
                    if messages.count != 0{
                        
                        let m = messages.min(by: { (message1, message2) -> Bool in
                            message1.timeStamp! < message2.timeStamp!
                        })
                        this.lastValueOfMyMessage = Int64((m?.timeStamp)!)!
                        
                        
                    }
                    this.sortMessagesOnTimeStamp()
                    
                    DispatchQueue.main.async {
                        this.tabview.reloadData()
                        self!.scrollToBottom()
                    //    let indexPath = IndexPath.init(row: messages.count - 1, section: 0)
                        
                  //-      this.chatCollectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
                        //this.adjust()
                    }
                    
                }
            }else {
                debugPrint("No chat room exists")
            }
            
            
        }
        
    }
    
  
    
    //MARK:- Private functions
    func getMessagesOf(concatenatedId : String, completion: @escaping (Bool, [MessageOld]? ) -> () ){
        
        let ref = FirebaseDB.shared.dbRef.child("chat_rooms").child(concatenatedId)
        ref.queryOrderedByKey().queryLimited(toLast: 50).observe(.value, with: { [weak self] (snapshot) in
            guard let _ = self else {
                completion(false, nil)
                return
            }
            print("load messages getmessage\n")
            var messages = [MessageOld]()
            
           var count11 = 0
         //   self!.messagesFromServer.removeAll()
            self!.messages.removeAll()
            self!.chatMessages.removeAll()
            if snapshot.hasChildren(){
                if let data = snapshot.value{
                    var itemimage = [String]()
                    var receiverLastMessage = String()
                    
                    for m in data as! NSDictionary{
                        print("concatenateId == \(concatenatedId)")
                       
                        let message = MessageOld()
                        print("m.key =\(m.key)")
                        message.timeStamp = m.key as? String
                        
                        let val = m.value as! NSDictionary
                        
                        message.message = val["message"] as? String
                        message.receiver = val["receiverUid"] as? String
                        message.sender = val["senderUid"] as? String
                        
                        var chatmessageItemImg = String()
                        var chatmessageItemTitle = String()
                        if (val["itemImages"] as? String) != nil {
                            
                            message.itemimg = val["itemImages"] as? String
                            message.itemtitle = val["itemTitle"] as? String
                            
                            chatmessageItemImg = val["itemImages"] as? String ?? ""
                            chatmessageItemTitle = val["itemTitle"] as? String ?? ""
                        }
                       
                        let senderId = val["senderUid"] as? String
                       
                        print("val = \(val)")
                        count11 += 1
                        
                        if (itemimage.count == 0 ) {
                            
                            
                        }else {
                            
                            
                            self?.ItemDetailView.isHidden = false
                        }
                        if (val["itemTitle"] as? String) != nil {
                            let itemtitle = val["itemTitle"] as? String
                            
                            print("itemtitle == \(itemtitle!)")
                        }
                        
                        if (val["itemState"] as? String) != nil {
                            let itemState = val["itemState"] as? String
                            
                            print("itemState == \(itemState!)")
                        }
                        
                        // self?.itemTitle.text = itemtitle!
                        
                        messages.append(message)
                        //
                        
                        let isIncomeCheck = senderId == SessionManager.shared.userId ? false : true
                        if (isIncomeCheck){
                            receiverLastMessage = val["message"] as? String ?? ""
                        }
                        
                        

//                        self!.messagesFromServer.append(ChatMessage(text: val["message"] as? String ?? "", isIncoming: isIncomeCheck , date:Date.dateFromCustomString(customString: self?.TimeStempDateConversion(value: m.key as? String ?? "") ?? "08/03/2018"), timeStamp: self?.TimeStempTimeConverter(value: m.key as? String ?? ""), receiver: val["receiverUid"] as? String, sender: val["senderUid"] as? String , itemimg: chatmessageItemImg, itemtitle: chatmessageItemTitle, receiverLastMessage: receiverLastMessage))
//
//
                    }
                  
                  
//                     self!.chatMessages.append(self!.messagesFromServer)
            
                    completion(true, messages)
                }else{
                    completion(false, nil)
                }
            }else {
                completion(false, nil)
            }
        })
    }
    
    func TimeStempTimeConverter(value:String)->String {
        
        let time = Int64(value)!
        let f = Date(milliseconds: Int(time))
        let currentTime = self.currentTimeStamp
        let difference = Int64(currentTime) - time
        
        let a = "\(f)"
        var m  = a.components(separatedBy: " ")
        var n = m[1].components(separatedBy: ":")
       // let thisIsRecivedMessage = message.receiver == SessionManager.shared.userId
        
        let timeText = "\(n[0])"+":"+"\(n[1])"
        
       // cellsender.dateLabel.text =  timeText
        print("timetext = \(timeText)")
        return timeText
    }
    
    func TimeStempDateConversion(value:String)->String{
        
        let dd = Double(value)
        let datedd = dd!/1000
        let date = Date(timeIntervalSince1970: datedd )
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM/dd/YYYY hh:mm" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        print("timetext1 = \(strDate)")
        return strDate
    }
    
    
    //this function is used to sort the messages on the basis of timestamp
    func sortMessagesOnTimeStamp(){
        self.messages.sort { (m1, m2) -> Bool in
            return m1.timeStamp?.compare(m2.timeStamp!) == ComparisonResult.orderedAscending
        }
    }
    
    ///updates unReadCount node in user node and user -> chat -> \(chatting with user id) in a transaction. because when multiple users are chatting with this user (sending messages), some updates may lost.
    func updatedUnReadCountNodes (){
        
        //    //clear unread count in user -> chat -> userIamChattingWith -> unread count
        
        //    let existingNumber = UIApplication.shared.applicationIconBadgeNumber
        //    if let unReadStr = user.unreadCount, let unReadInt = Int(unReadStr) {
        //      let updatedCount = existingNumber - unReadInt
        //      UIApplication.shared.applicationIconBadgeNumber = updatedCount
        //      //self.tabBarController?.tabBar.items![4].badgeValue = "\(updatedCount)"
        //      let dict = ["unRead" : updatedCount]
        //      NotificationCenter.default.post(name:
        //    }
        
        let ref = FirebaseDB.shared.dbRef.child("users").child(self.myID)
        
        ref.runTransactionBlock { (mutableData) -> TransactionResult in
            
            if var data = mutableData.value as? [String:Any]{
                
                var mainUnreadCount = "0"
                
                if let unreadCount = data["unreadCount"] as? String, let unReadMainInt = Int(unreadCount){
                    
                    mainUnreadCount = unreadCount
                    
                    if var chatDict = data["chat"] as? [String:Any]{
                        guard var ownerChatDict = chatDict[self.ownerId] as? [String:Any] else {
                            print("Error: guard let ownerChatDict = chat[ownerId] as? [String:Any] failed in self")
                            return TransactionResult()
                        }
                        
                        guard let unReadCountForUser = ownerChatDict["unreadCount"] as? String else {
                            print("Error: guard let unReadCountForUser = ownerChatDict[unreadCount] as? String")
                            return TransactionResult()
                        }
                        ownerChatDict["unreadCount"] = "0"
                        
                        chatDict.updateValue(ownerChatDict, forKey: self.ownerId)
                        
                        data["chat"] = chatDict
                        
                        mainUnreadCount = "\(Int(mainUnreadCount)!-Int(unReadCountForUser)!)"
                        
                        data["unreadCount"] = "\(mainUnreadCount)"
                        
                        mutableData.value = data
                        
                        DispatchQueue.main.async {
                            UIApplication.shared.applicationIconBadgeNumber = unReadMainInt
                        }
                        
                        
                        let dict = ["unRead" : unReadMainInt]
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"updateTabBadgeNumber"), object:nil, userInfo: dict)
                        
                        return TransactionResult.success(withValue: mutableData)
                        
                    }else {
                        return TransactionResult.abort()
                    }
                }else {
                    return TransactionResult.abort()
                }
                
                
            }else {
                return TransactionResult.abort()
            }
        }
    }
    //MARK:- IBActions and user interaction
    
    @IBAction func btnSendMessageTapped(_ sender: UIButton) {
        sendMessage()
    }
}

//MARK:- Collection View
//extension ChatLogVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return messages.count
//    }
////
////    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////
////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! ReciverCell
////        let cellsender = collectionView.dequeueReusableCell(withReuseIdentifier: "SenderCell", for: indexPath) as! SenderCell
////
////        let SenderImgItem = collectionView.dequeueReusableCell(withReuseIdentifier: "SenderCellImage", for: indexPath) as! SenderImageItemCell
////
////
////        let message = messages[indexPath.item]
////        let cellSpacing : CGFloat = 5
////        if let messageText = message.message {
////
////
////
////
////
////            if message.receiver == SessionManager.shared.userId  {
////
////
////
////
////
////
////
////
////
////
////
////            }else {
////                func handleTimeSender() {
////
////                    let time = Int64(messages[indexPath.row].timeStamp!)!
////                    let f = Date(milliseconds: Int(time))
////                    let currentTime = self.currentTimeStamp
////                    let difference = Int64(currentTime) - time
////
////                    let a = "\(f)"
////                    var m  = a.components(separatedBy: " ")
////                    var n = m[1].components(separatedBy: ":")
////                    let thisIsRecivedMessage = message.receiver == SessionManager.shared.userId
////
////                    let timeText = "\(n[0])"+":"+"\(n[1])"
////
////
////                    cellsender.dateLabel.text =  timeText
////                    print("timetext = \(timeText)")
////
////                }
////
////
////                }
////
////
////
////
////
////
////            }
////        }
////
////
////
//
//
//
//    }
//
//

    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    //-    let flowLayout = chatCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
//        //we are just measuring height so we add a padding constant to give the label some room to breathe!
//        let padding: CGFloat = 50
//        var height = CGFloat()
//        //estimate each cell's height
//
//        //        var mx = messages
//        //        mx.sort(){$0.message!.count > ($1.message?.count)!}
//
//        let width = CGFloat((messages[indexPath.row].message?.widthOfString(usingFont: UIFont.systemFont(ofSize: 13)))!)
//
//
//        let heighth = messages[indexPath.row].message?.height(constraintedWidth: width, font: UIFont.boldSystemFont(ofSize: 13))
//
//
//
//
//        if let text = messages[indexPath.row].message {
//
//            height = estimateFrameForText(text: text).height + padding
//
//        }
//        print("heibjkfjght == \(height)")
//        print("Textheight == \(height)")
//
//        return CGSize(width: self.view.frame.width , height: height  )
//
//    }
    ////
    ////  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    ////    return UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0 )
    ////  }
    //
    //
    //
    //
    

extension ChatLogVC : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textViewMessage.numberOfLines() == 1 {
            textMessageHight.constant = 40
        }else if textViewMessage.numberOfLines() == 2 {
            textMessageHight.constant = 55
        }else if textViewMessage.numberOfLines() == 3 {
            textMessageHight.constant = 65
        }
        
        if text == "\n" {
            
            if (textView.text == "")  {
                self.alert(message: "message can't be empty")
            }else {
                sendMessage()
            }
            
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        
        
        
        if textView.text == placeHolderText {
            //currently was placeholder
            textView.text = ""
            textView.textColor = UIColor.black
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        
        
        if textView.text.isEmpty {
            textView.text = placeHolderText
            textView.textColor = UIColor.lightGray
        }
        
    }
}
//MARK:- Sending message
extension ChatLogVC {
    func sendMessage() {
        writeTime(id: SessionManager.shared.userId)
        let str = textViewMessage.text
        if !(str?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!{
            
            getCurrentServerTime { (succees, time) in
                self.timeStamp = Int64(time)
                self.lastValueOfMyMessage = self.timeStamp
                if chatwithseller {
                    NetworkService.sendMessagewithitem(message: str!, ownerId: self.ownerId, timeStamp: self.timeStamp, concatId: self.concatenatedID, ownerName: self.ownerName, itemAuctionType: (chatwithsellermodel?.itemAuctionType)!, itemCategory: (chatwithsellermodel?.itemCategoty)!, itemImages: (chatwithsellermodel?.itemImages)!, itemState: (chatwithsellermodel?.itemState)! , itemTitle: (chatwithsellermodel?.itemTitle)!, itemID: (chatwithsellermodel?.itemID)!, itemPrice: (chatwithsellermodel?.itemprice)!, completion: { (success) in
                        if succees {
                            
                            self.getAndShowMessages()
                        }
                    })
                }else {
                    NetworkService.sendMessage(message: str!, ownerId: self.ownerId, timeStamp: self.timeStamp, concatId: self.concatenatedID, ownerName: self.ownerName, completion: { (success) in
                        if succees {
                            
                            self.getAndShowMessages()
                        }
                    })
                    
                }
                
                
                DispatchQueue.main.async {
                    self.textViewMessage.textColor = UIColor.black
                    self.textViewMessage.text = ""
                    
                }
            }
            
            
        }
    }
    func sendMessage1(message:String) {
        writeTime(id: SessionManager.shared.userId)
        let str = message
        if !(str.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
            
            getCurrentServerTime { (succees, time) in
                self.timeStamp = Int64(time)
                self.lastValueOfMyMessage = self.timeStamp
        
                
                    NetworkService.sendMessage(message: str, ownerId: self.ownerId, timeStamp: self.timeStamp, concatId: self.concatenatedID, ownerName: self.ownerName, completion: { (success) in
                        if succees {
                            
                            self.getAndShowMessages()
                        }
                    })
                    
                
                
                
                DispatchQueue.main.async {
                    self.textViewMessage.textColor = UIColor.black
                    self.textViewMessage.text = ""
                    
                }
            }
            
            
        }
    }
    
}

extension ChatLogVC {
    override func willMove(toParentViewController parent: UIViewController?) {
        //print("Got it ")
        if parent == nil, let delegate = delegate {
            delegate.willMove()
        }
        
    }
}

protocol ChatLogVCDelegate: class {
    func willMove()
}

extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
        
        return label.frame.height
    }
    
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedStringKey.font: font], context: nil)
        return boundingBox.height
    }
}

extension UITextView{
    
    func numberOfLines() -> Int{
        if let fontUnwrapped = self.font{
            return Int(self.contentSize.height / fontUnwrapped.lineHeight)
        }
        return 0
    }
    
}

