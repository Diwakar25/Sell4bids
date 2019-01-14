//
//  ChatLogVC_MessageKit.swift
//  Sell4Bids
//
//  Created by admin on 8/13/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import MessageKit
import SDWebImage

class ChatLogVC_MessageKit: MessagesViewController {
    fileprivate func addDoneLeftBarBtn() {
        
        
        addLogoWithLeftBarButton()
       
        
        let button = UIButton.init(type: .custom)
        button.setImage( #imageLiteral(resourceName: "hammer_white")  , for: UIControlState.normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItems = [barButton ]
    }
    
  //MARK:- Outlet
  //@IBOutlet weak var chatCollectionView: UICollectionView!
  @IBOutlet weak var textViewMessage: UITextView!
  @IBOutlet weak var btnSendMessage: UIButton!
  @IBOutlet weak var viewMessage: UIView!
  @IBOutlet weak var topColView: NSLayoutConstraint!
  weak var delegate : ChatLogVCDelegate?
    var count: Int = 0
    var images = [UIImage]()
  //MARK:- Properties
  var currentTimeStamp: Int64 = 0
  //var messages = [Message]()
  var lastValueOfMyMessage : Int64 = 0
  let cellId = "cell"
  var previousData = [String:Any]()
  let placeHolderText = "Type a message..."
  var timeStamp: Int64 = 0
  var imgitem = UIImageView()
  var myID = ""
  var ownerId = ""
  var ownerName = ""
  var myName : String = ""
  var concatenatedID = ""
  var userImage : UIImage?
    var itemImage : MediaItem?
  
  lazy var formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
  }()
  
  var currentServerTimeStamp : Int64?
  //Message Kit
  private var messages: [Message] = []
    private var messagesseller : [Messagewithseller] = []
  var label = UILabel()
  var senderInitialsBackColor : UIColor?
  var receiverInitialsBackColor : UIColor?
  //MARK:- View Life Cycle
    
    override func viewDidAppear(_ animated: Bool) {
         self.messagesCollectionView.scrollToBottom(animated: true)
        
    }
    
  override func viewDidLoad() {
    
    
    super.viewDidLoad()

    setupViews()
    addInviteBarButtonToTop()
    addDoneLeftBarBtn()
    messageInputBar.delegate = self
    messagesCollectionView.delegate = self
    messagesCollectionView.messagesDataSource = self
    messagesCollectionView.messagesLayoutDelegate = self
    messagesCollectionView.messagesDisplayDelegate = self
    messagesCollectionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300)
    let header = UINib(nibName: "HeaderView", bundle: nil)

    messagesCollectionView.register(header, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
    
    
    messageInputBar.sendButton.tintColor = colorRedPrimay
    scrollsToBottomOnKeybordBeginsEditing = true // default false
    maintainPositionOnKeyboardFrameChanged = true // default false
    
    getAndSaveCurrentServerTimeInProperty()
    getDataFromDictSent()
     //getAndShowMessages()
   // getAndShowMessages()
  
    getAndShowMessages()
    
    
    addObserversForKeyBoardShowHide()
  
    getCurrentServerTime { [weak self] (success, timeDouble) in
      guard let this = self else { return }
      if success {
        this.currentServerTimeStamp = Int64.init(timeDouble)
      }
    }
  }
  

  // MARK: - Helpers
  
  private func setupViews() {
    let arrayCount = colorsArrayForBackGroundInitials.count
    let random = arc4random_uniform(UInt32(arrayCount))
    let random2 = arc4random_uniform(UInt32(arrayCount))
    let intRandom1 = Int(random), intRandom2 = Int(random2)
    
    senderInitialsBackColor = colorsArrayForBackGroundInitials[intRandom1]
    receiverInitialsBackColor = colorsArrayForBackGroundInitials[intRandom2]
    
    messagesCollectionView.reloadData()
    
  }
    


    
    
  private func insertNewMessage(_ message: Message) {
    guard !messages.contains(message) else {
      return
    }
    
  
    messages.append(message)
    messages.sort()
    sortMessagesOnTimeStamp()
    
    let isLatestMessage = messages.index(of: message) == (messages.count - 1)
    let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
    
    messagesCollectionView.reloadData()
    
    if shouldScrollToBottom {
      self.messagesCollectionView.scrollToBottom(animated: true)
    
    }
  }

  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    toggleEnableIQKeyBoard(flag: false)
  }
  
  
  //MARK:- Private functions
  
  func addObserversForKeyBoardShowHide(){
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
  }
  
  func getAndSaveCurrentServerTimeInProperty() {
    getCurrentServerTime { [weak self] (success, currentTime) in
      guard let this = self else { return }
      this.currentTimeStamp = Int64(currentTime)
    }
  }
  
  @objc func keyBoardWillShow(notification: NSNotification) {
    
  }
  
  @objc func keyBoardWillHide(notification: NSNotification) {
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
  }
  
  //MARK:- Getting And Showing Data
  func getDataFromDictSent() {
    
    myID = previousData["myID"] as! String
    ownerId = previousData["ownerID"] as! String
    ownerName = previousData["ownerName"] as! String
    self.title = ownerName
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
            return
          }
//          print("number of messages : \(messages.count)")
          //messages.sort()
          this.messages = messages
          this.sortMessagesOnTimeStamp()
          
          DispatchQueue.main.async {
            this.messagesCollectionView.reloadData()
            this.messagesCollectionView.scrollToBottom()
          }
          
          
        }
      }else {
        debugPrint("No chat room exists")
      }
      
      
    }
    
  }
    


  func getMessagesOf(concatenatedId : String, completion: @escaping (Bool, [Message]? ) -> () ){
    
    let ref = FirebaseDB.shared.dbRef.child("chat_rooms").child(concatenatedId)
    print("chat room ref : \(ref)")
    ref.queryOrderedByKey().queryLimited(toLast: 50).observe(.value, with: { [weak self] (snapshot) in
      guard let strongSelf = self else {
        completion(false, nil)
        return
      }
      print("load messages getmessage\n")
      //var messages = [MessageOld]()
      //var messagesLocal = [Message]()
      if snapshot.hasChildren(){
        if let data = snapshot.value{
          
          //print(data)
          for m in data as! NSDictionary{
            
            //message.timeStamp = m.key as? String
            
            guard let val = m.value as? NSDictionary ,
            let id = m.key as? String,
            let messageContent = val["message"] as? String,
            //let receiverUid = val["receiverUid"] as? String,
            let senderUid = val["senderUid"] as? String,
            //let receiverName = val["receiver"] as? String,
            let timeStamp = val["timestamp"] as? Int64 else {
              print("Invalid values for a message. skipping this message")
              print(type(of: m.key))
              continue
            }
            
            let message = Message.init(id: id, senderID: senderUid, displayName: strongSelf.myName, msgContent: messageContent, timeStamp: timeStamp)
            
            if !strongSelf.messages.contains(where: { (aMessage: Message) -> Bool in
              guard let time1 = aMessage.timeStamp, let time2 = message.timeStamp else { return false }
              //print("time1 : \(time1), time2 : \(time2) ")
              
              return time1 == time2
            }){
              strongSelf.messages.append(message)
            }else {
              print("messages with same time stamp")
            }
            
            
            //print("appended message is \(debugPrint(message))")
          }
          
          completion(true, strongSelf.messages)
        }else{
          completion(false, nil)
        }
      }else {
        completion(false, nil)
      }
    })
  }
  
  //this function is used to sort the messages on the basis of timestamp
  func sortMessagesOnTimeStamp(){
    self.messages.sort { (m1, m2) -> Bool in
      guard let timeStamp1 = m1.timeStamp , let timeStamp2 = m2.timeStamp else { return false }
      return timeStamp1 < timeStamp2
    }
  }
  
  
  //MARK:- IBActions and user interaction
  
}

//MARK:- Sending message
extension ChatLogVC_MessageKit {
  func sendMessage(text : String, completion: @escaping (Bool, Message?) -> () ) {
    writeTime(id: SessionManager.shared.userId)
   
    let str = text
    if !(str.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
      
      getCurrentServerTime { (succees, time) in
        self.timeStamp = Int64(time)
        self.lastValueOfMyMessage = self.timeStamp
       
        
            
           
        
            NetworkService.sendMessage(message: str, ownerId: self.ownerId, timeStamp: self.timeStamp, concatId: self.concatenatedID, ownerName: self.ownerName, completion: { [weak self] (success) in
                guard let this = self else { return }
                if succees {
                    
                    let message = Message.init(id: "\(this.timeStamp)" , senderID: this.myID, displayName: this.myName, msgContent: str, timeStamp: this.timeStamp)
                    completion(true, message)
                    
                }else {
                    completion(false, nil)
                }
            })
        }

      }
      
      
    
  }
  
    
}

//Mark:- Message kit data source
extension ChatLogVC_MessageKit : MessagesDataSource {
  
    
    
   
  func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
   
   
  
        return messages.count
    
    
  }
  
   
  func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
    return 1
  }

  
  func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
    print("messageForItem : \(messages.count)")
   
        return messages[indexPath.section]
 
   
  }
  
  func currentSender() -> Sender {
    let id = Auth.auth().currentUser?.uid ?? "nil user Id in currentSender()"
    //print("current sender id is \(id)")
    return Sender.init(id: id, displayName: SessionManager.shared.name)
  }

  func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
   
        guard indexPath.section < messages.count, let timeStamp = messages[indexPath.section].timeStamp else {
            return nil
        }
        let dateStr = timeStamp.millisTotoDate().toString()
        
        return NSAttributedString(
            string: dateStr,
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .caption1),
                .foregroundColor: UIColor(white: 0.3, alpha: 1)
            ]
        )
    }
    }
  


// MARK: - MessagesLayoutDelegate

extension ChatLogVC_MessageKit: MessagesLayoutDelegate {
  
    
    
  static var firstTimeStamp : Int64 = 0
  func avatarSize(for message: MessageType, at indexPath: IndexPath,
                  in messagesCollectionView: MessagesCollectionView) -> CGSize {
    
    // 1
    
    return CGSize.init(width: 35, height: 35)

  }
  
  func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
   
        return 16
  
  }
  
  func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
   
        return 8
 
  
  }
  
  func footerViewSize(for message: MessageType, at indexPath: IndexPath,
                      in messagesCollectionView: MessagesCollectionView) -> CGSize {
  
        return CGSize(width: 0, height: 50)

    
  }
  
  func heightForLocation(message: MessageType, at indexPath: IndexPath,
                         with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    
    // 3
    return 0
  }
  
  func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    

        if indexPath.section == 0 {
            guard let firstTimeStamp = messages[indexPath.section].timeStamp else {
                return 0
            }
            ChatLogVC_MessageKit.firstTimeStamp = firstTimeStamp
            
            return 16
        }else if indexPath.section < messages.count {
            
            let firstMessageDate = ChatLogVC_MessageKit.firstTimeStamp.millisTotoDate()
            let firstMessageDateString = firstMessageDate.toString()
            
            guard let currentDateTimeStamp = messages[indexPath.section].timeStamp else { return 0 }
            
            let currentDate = currentDateTimeStamp.millisTotoDate()
            let dateString = currentDate.toString(dateStyle: .full, timeStyle: .none)
            
            
            
            //we don't want to show date with every cell. only when date changes
            if firstMessageDateString == dateString {
                return 0
            }
            ChatLogVC_MessageKit.firstTimeStamp = currentDateTimeStamp
            
            return 16
        }else {
            return 0
        }
        
    }
    

  
}

//MARK:- MessageKit MessagesDisplayDelegate
extension ChatLogVC_MessageKit: MessagesDisplayDelegate {
  

    
    
    func headerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        
            return CGSize(width: self.view.frame.width, height: 20)
        
    }
    

  func backgroundColor(for message: MessageType, at indexPath: IndexPath,
                       in messagesCollectionView: MessagesCollectionView) -> UIColor {
    
    // 1
    let flagIsFromCurrentSender = isFromCurrentSender(message: message)
    //print("isFromCurrentSender : \(flagIsFromCurrentSender)")
    return flagIsFromCurrentSender ? .primary : .incomingMessage
  }
 
  func messageStyle(for message: MessageType, at indexPath: IndexPath,
                    in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
    
    let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
    
    // 3
    return .bubbleTail(corner, .curved)
  }
  
  func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
    
    
    let flagIsFromCurrentSender = isFromCurrentSender(message: message)
    let nameToUse = flagIsFromCurrentSender ? SessionManager.shared.name : ownerName
    var initials = "U"

    if !nameToUse.isEmpty { initials = String.init(nameToUse[nameToUse.startIndex]) }
    
    avatarView.initials = initials

    avatarView.placeholderFont = UIFont.boldSystemFont(ofSize: 18)
    //set backgroud color
    if flagIsFromCurrentSender {
      avatarView.backgroundColor = senderInitialsBackColor ?? colorAqua
    }
    else {
      //message received
      
      avatarView.backgroundColor = receiverInitialsBackColor ??  colorDarkPink
      
    }
    
    
    
    
  }
    
  
  func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {

        var stringToUse = ""
        if message.sender !=  currentSender() {
            stringToUse = ownerName.components(separatedBy: " ")[0]
            stringToUse.append(", ")
        }
        //add date and time
        
        func returnDateString() -> String {
            
            
                guard let timeStamp = messages[indexPath.section].timeStamp, let currentTimeStamp = self.currentServerTimeStamp else {
                    return ""
                }
                
                
                let difference = currentTimeStamp - timeStamp
                //let endTimeInterval:TimeInterval = TimeInterval(timeStamp)
                //Convert to Date
                //let date = Date(timeIntervalSince1970: endTimeInterval/1000)
                
                //let date = Date(timeIntervalSince1970: TimeInterval(timeStamp / 1000 ))
                //let f = Date(milliseconds: Int(timeStamp))
                //let a = "\(f)"
                //var m  = a.components(separatedBy: " ")
                //var n = m[1].components(separatedBy: ":")
                
                //let dateStr = MessageKitDateFormatter.shared.string(from: date)
                let timeAgoString = convertTimeStampToString(time: difference  )
                //let timeText = "\(n[0])"+":"+"\(n[1])" + ", " +   convertTimeStampToString(time: difference)
                //let timeText = "\(n[0])"+":"+"\(n[1])"  + dateStr
                //stringToUse.append(timeAgoString)
                
                return timeAgoString
                //return date.toString(dateFormat: "dd-MM")
    }
            
        
        let dateString = returnDateString()
        stringToUse.append(dateString)
        
        let attributes = [
            NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1),
            NSAttributedStringKey.foregroundColor : UIColor.darkGray
        ]
        return NSAttributedString(string: stringToUse, attributes: attributes )
    
    
    }
//  func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//
//
//
////    let attributes = [
////      NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1),
////      NSAttributedStringKey.foregroundColor : UIColor.darkGray
////    ]
////    return NSAttributedString(string: dateString, attributes: attributes)
//  }
}

// MARK: - MessageInputBarDelegate

extension ChatLogVC_MessageKit: MessageInputBarDelegate {
  
  func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
    //let message = Message(user: user, content: text)
   
        sendMessage(text: text) { [weak self] (success, messageOpt : Message?) in
            
            guard let this = self,  success, let message = messageOpt else { return }
            this.insertNewMessage(message)
            print("inserted this message : \(debugPrint(message))")
        }
        inputBar.inputTextView.text = ""
    }
   
    
//    save(message)

  }
  


