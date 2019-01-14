//
//  ChatTableVC.swift
//  chatPractice
//
//  Created by Admin on 9/17/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import IQKeyboardManagerSwift
//import Refresher

class ChatTableVC: UIViewController, UITextFieldDelegate,UITextViewDelegate {
  
  
  //MARK:- Properties
  
  @IBOutlet weak var bottomSpaceOfTableView: NSLayoutConstraint!
  @IBOutlet weak var bottomSpace: NSLayoutConstraint!
  @IBOutlet var myView: UIView!
  @IBOutlet weak var table: UITableView!
  @IBOutlet weak var textViewMessage: UITextView!
  @IBOutlet weak var heightConstraintOfLastView: NSLayoutConstraint!
  @IBOutlet weak var btnSendMessage: UIButton!
  
  //MARK:- Variables
  
  var activeTextFiled = UITextField()
  var apiKey = "qwerty"
  var messages = [MessageOld]()
  var lastValueOfMyMessage : Int64 = 0
  var lastValueOfSecondPersonMessage : Int64 = 0
  var previousData = [String:Any]()
  var myID = ""
  var ownerId = ""
  var ownerName = ""
  var myName : String = ""
  var currentTimeStamp: Int64 = 0
  var timeStamp: Int64 = 0
  var concatenatedID = ""
  
  //MARK:- View Life cycle
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    writeTime(id: SessionManager.shared.userId)
    
    table.delegate = self
    table.dataSource = self
    textViewMessage.delegate = self
    
    myID = previousData["myID"] as! String
    ownerId = previousData["ownerID"] as! String
    ownerName = previousData["ownerName"] as! String
    myName = previousData["myName"] as! String
    
    self.navigationItem.title = ownerName
    textViewMessage.autocorrectionType = .no
    textViewMessage.delegate = self
    
    self.checkString { (ID, status) in
      
      if status == true{
        self.concatenatedID = ID
         self.loadMessages(concatenatedId: self.concatenatedID)
      }
      
    }
    table.estimatedRowHeight = 44
    table.rowHeight = UITableViewAutomaticDimension
  
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: Notification.Name.UIKeyboardWillShow, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    
    
    updatedUnReadCountNodes()
    //design messageBox
    
    self.textViewMessage.layer.borderWidth = 1
    self.textViewMessage.layer.borderColor = UIColor.gray.cgColor
    //request a review
    //table.backgroundColor = UIColor.clear
    setupViews()
  }
 
  
  override func viewWillAppear(_ animated: Bool) {
    IQKeyboardManager.shared.enable = false
    IQKeyboardManager.shared.enableAutoToolbar = false
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    IQKeyboardManager.shared.enable = true
    IQKeyboardManager.shared.enableAutoToolbar = true
  }
  //MARK:- Private functions
  private func setupViews() {
    btnSendMessage.makeRound()
    textViewMessage.addShadowAndRound()
    textViewMessage.tintColor = colorRedPrimay
    
  }
  func checkString(completion: @escaping (_ concatenatedID: String, _ status: Bool)->()){
    
    let str1 = self.myID+"_"+self.ownerId
    let str2 =  self.ownerId+"_"+self.myID
    var final = str1
    
    
    let ref = FirebaseDB.shared.dbRef.child("chat_rooms")
    ref.child(str2).observe(.value) { (snapshot) in
      
      print("i am check string")
      if snapshot.hasChildren(){
        print(snapshot)
        print(snapshot.value )
        
        
        final = str2
        completion(final, true)
        
        self.loadMessages(concatenatedId: final)
      }
      else{
        final = str1
        completion(final, true)
        self.loadMessages(concatenatedId: final)
      }
      
    }
  }
  
  lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
    
    return refreshControl
  }()
  
  
  func convertTime(time: Int64) -> String{
    var str: String = ""
    var t = time/1000
    
    if t <= 0{
      str = "Just Now"
      return str
    }
    else if  t > 0 && t <= 59{
      // t = Int(Double(t).rounded(toPlaces: 1))
      str = "\(t)" + " secs ago."
      return str
    }
    else if t>59 && t < 3600{
      
      t = t/60
      //t = Double(t).rounded(toPlaces: 1)
      str = "\(t)"+" mints ago."
      return str
    }
    else if t > 3600{
      var d = Int(t)
      d = d/3600
      //  d = Double(d).rounded(toPlaces: 1)
      str = "\(d)"+" hours ago."
      if d > 24{
        
        d = d/24
        
        if d >= 30{
          d = d/30
          // d = Double(d).rounded(toPlaces: 1)
          str = "\(d)"+" months ago"
          
          if d >= 12
          {
            d = d/12
            // d = Double(d).rounded(toPlaces: 1)
            str = "\(d)"+" yesrs ago"
            return str
          }
          return str
          
        }
        // d = Double(d).rounded(toPlaces: 1)
        str = "\(d)"+" days ago"
        return str
      }
      return str
    }
    else
    {
      return ""
    }
  }

  func sendMessage() {
    writeTime(id: SessionManager.shared.userId)
    let str = textViewMessage.text
    if !(str?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!{
      send()
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if textViewMessage.isFirstResponder{
      //message.resignFirstResponder()
    }
  }
 
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    writeTime(id: SessionManager.shared.userId)
    
    let str = textField.text
    if (str?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!{
      //textField.resignFirstResponder()
      bottomSpace.constant = 8
      //  bottomSpaceOfTableView.constant = 0
      return true
    }
    else{
      
      send()
      //message.text = ""
      //textField.resignFirstResponder()
      //bottomSpace.constant = 8
      //  bottomSpaceOfTableView.constant = 0
      return true
    }
  }
 
  func loadMessages(concatenatedId : String ){
    
    //  writeTime(id: myUniversalID)
    
    // let myId = Auth.auth().currentUser?.uid
    // let concatenatedId = self.myID+"_"+self.ownerId
    let ref = FirebaseDB.shared.dbRef.child("chat_rooms").child(concatenatedId)
    
    let dic = ["temporaryTimeStamp":ServerValue.timestamp()]
    let reference = Database.database().reference()
    reference.updateChildValues(dic)
    
    reference.child("temporaryTimeStamp").observeSingleEvent(of: .value) { [weak self] (snapshot) in
      guard let this = self else { return }
      print("load messages ttimestamp\n")
      this.currentTimeStamp = snapshot.value as! Int64
      
      ref.queryOrderedByKey().queryLimited(toLast: 50).observe(.value, with: { [weak self] (snapshot) in
        guard let thisInner = self else { return }
        print("load messages getmessage\n")
        var temp = [MessageOld]()
        
        thisInner.messages.removeAll()
        if snapshot.hasChildren(){
          if let data = snapshot.value{
            
            print(data)
            for m in data as! NSDictionary{
              
              let message = MessageOld()
              //print("aaaaaaaaa")
              print(m)
              
              message.timeStamp = m.key as? String
              
              let val = m.value as! NSDictionary
              
              message.message = val["message"] as? String
              message.receiver = val["receiverUid"] as? String
              message.sender = val["senderUid"] as? String
              
              temp.append(message)
            }
            
          }
          if temp.count != 0{
            thisInner.messages.append(contentsOf: temp)
            //get minimum timestamp
            let m = temp.min(by: { (message1, message2) -> Bool in
              message1.timeStamp! < message2.timeStamp!
            })
            thisInner.lastValueOfMyMessage = Int64((m?.timeStamp)!)!
            
            //self.lastValueOfMyMessage = Int64((m?.timeStamp)!)!
            temp.removeAll()
          }
          thisInner.sortMessagesOnTimeStamp()
          thisInner.table.reloadData()
          thisInner.table.scrollToRow(at: IndexPath.init(row: thisInner.messages.count - 1, section: 0) ,at: .top, animated: false)
          //self.loadOtherUserMessages()
        }
        
        
      })
      
    }
    
  }
  
  func loadLastMessage(concatenatedId: String){
    var scrollToRowDone = false
    writeTime(id: SessionManager.shared.userId)
    
    let ref = FirebaseDB.shared.dbRef.child("chat_rooms").child(concatenatedId)
    
    let dic = ["temporaryTimeStamp":ServerValue.timestamp()]
    let reference = Database.database().reference()
    reference.updateChildValues(dic)
    
    reference.child("temporaryTimeStamp").observeSingleEvent(of: .value, with: { (tempSnapShot) in
      
      print("load messages ttimestamp\n")
      self.currentTimeStamp = tempSnapShot.value as! Int64
      ref.queryOrderedByKey().queryLimited(toLast: 1).observeSingleEvent(of: .value, with: { (snapshot) in
        
      
        print("load messages of lastMessage\n")
        var temp = [MessageOld]()
        
        //  self.messages.removeAll()
        if snapshot.hasChildren(){
          if let data = snapshot.value{
            
            print(data)
            for m in data as! NSDictionary{
              
              let message = MessageOld()
              print("aaaaaaaaa")
              print(m)
              
              message.timeStamp = m.key as? String
              
              let val = m.value as! NSDictionary
              
              message.message = val["message"] as? String
              message.receiver = val["receiverUid"] as? String
              message.sender = val["senderUid"] as? String
              
              temp.append(message)
            }
            
          }
          if temp.count != 0{
            //self.messages.removeAll()
            self.messages.append(contentsOf: temp)
            self.messages = Array(Set(self.messages))
            //get minimum timestamp
            
            
            let m = self.messages.min(by: { (message1, message2) -> Bool in
              message1.timeStamp! < message2.timeStamp!
            })
            self.lastValueOfMyMessage = Int64((m?.timeStamp)!)!
            
            //self.lastValueOfMyMessage = Int64((m?.timeStamp)!)!
            temp.removeAll()
          }
          
          self.sortMessagesOnTimeStamp()
          let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
          
          
          self.table.reloadData()
          if !scrollToRowDone {
            self.table.scrollToRow(at: indexPath, at: .bottom, animated: true)
            scrollToRowDone = true
          }
          
        
          
          //self.loadOtherUserMessages()
        }
        
        
      })
      
      
      
      
      
    })
  }
  
  //this function is used to sort the messages on the basis of timestamp
  func sortMessagesOnTimeStamp(){
    
    self.messages.sort { (m1, m2) -> Bool in
      return m1.timeStamp?.compare(m2.timeStamp!) == ComparisonResult.orderedAscending
    }
  }
 
  func reload(){
    
    writeTime(id: SessionManager.shared.userId)
    
    let ref = Database.database().reference().child("chat_rooms").child(self.concatenatedID)
    
    ref.queryOrderedByKey().queryEnding(atValue: "\(self.lastValueOfMyMessage)").queryLimited(toLast: 10).observeSingleEvent(of: .value, with: { (snapshot) in
      
      var temp = [MessageOld]()
      
      if snapshot.hasChildren(){
        if let data = snapshot.value{
          print(data)
          for m in data as! NSDictionary{
            
            let message = MessageOld()
            //print("aaaaaaaaa")
            //print(m)
            //values
            message.timeStamp = m.key as? String
            
            let val = m.value as! NSDictionary
            
            message.message = val["message"] as? String
            message.receiver = val["receiverUid"] as? String
            message.sender = val["senderUid"] as? String
            
            temp.append(message)
            
            
            
          }
          if temp.count != 0{
            let m = temp.min(by: { (message1, message2) -> Bool in
              message1.timeStamp! < message2.timeStamp!
            })
            
            self.lastValueOfMyMessage = Int64((m?.timeStamp)!)!
            
            self.messages.append(contentsOf: temp)
            temp.removeAll()
          }
          
        }
        self.messages = Array(Set(self.messages))
        self.sortMessagesOnTimeStamp()
        self.table.reloadData()
      }
      //self.reloadOtherUserMessages()
      
      
    }, withCancel: nil)
    
  }
  //function to send Messages
  func send(){
    
    
    let message = self.textViewMessage.text!
    let dic = ["temporaryTimeStamp":ServerValue.timestamp()]
    let reference = Database.database().reference()
    reference.updateChildValues(dic)
    
    let r = Database.database().reference().child("users").child("\(self.ownerId)")
    reference.child("temporaryTimeStamp").observeSingleEvent(of: .value) { (snapshot) in
      
      print("send message timestamp\n")
      self.timeStamp = snapshot.value as! Int64
      
      r.observeSingleEvent(of: .value, with: { (snapshot) in
        
        print(snapshot)
        var data = ["something":"something"] as [String:Any]
        if let d = snapshot.value as? [String:Any]{
          data = d
        }
        else{
          print("No data found")
        }
        
        //var data = d as! [String:Any]
        
        let startTime = data["startTime"] as? Int64
        let diff = self.timeStamp - startTime!
        if diff > 60000{
          
          //var ref3 = Database.database().reference()
          var chat = data["chat"] as? [String:Any]
          var count = "0"
          var intCount = 0
          
          if var myNode = chat![self.myID] as? [String:Any]{
            
            
            if let c: String? = myNode["unreadCount"] as? String{
              
              if c != nil{
                count = c!
              }
            }
            
            intCount = Int(count)!
            intCount += 1
            
            myNode.updateValue(intCount, forKey: "unreadCount")
            let value = ["unreadCount":"\(intCount)"]
            r.child("chat").child(self.myID).updateChildValues(value)
            
          }
          
          if let c: String = data["unreadCount"] as? String{
            
            if c != nil{
              count = c
            }
          }
          intCount = 0
          intCount = Int(count)!
          intCount += 1
          
          //myNode.updateValue(intCount, forKey: "unreadCount")
          var value = ["unreadCount":"\(intCount)"]
          r.updateChildValues(value)
          
          
        }
        
        print(snapshot.value as Any)
        
      })
      let refForLastMessage = Database.database().reference().child("Messages").child("Last Message").child(self.ownerId)
      
      self.lastValueOfMyMessage = self.timeStamp
      
      let val = ["message": message, "timeStamp": self.timeStamp] as [String : Any]
      refForLastMessage.setValue(val)
      
      let ref = Database.database().reference().child("chat_rooms").child(self.concatenatedID).child("\(self.timeStamp)")
      let value = ["message" : message,"receiver":self.ownerName, "senderUid": self.myID, "receiverUid": self.ownerId,"sender":self.myName,"timestamp":self.timeStamp] as [String : Any]
      ref.updateChildValues(value)
      
      
      self.sendNotification(id: self.ownerId, title: "New Message", message: message)
      self.loadLastMessage(concatenatedId: self.concatenatedID)
      //self.loadMessages(concatenatedId: self.concatenatedID)
      
      DispatchQueue.main.async {
        self.textViewMessage.textColor = UIColor.black
        self.textViewMessage.text = ""
        
      }
    }
    
    
    
  }
  
  @objc func handleRefresh(_ refreshControl: UIRefreshControl){
    self.reload()
    self.refreshControl.endRefreshing()
  }
  

  //MARK:- Key board handling
  @objc func handleKeyboardHide(notification: Notification)
  {
    self.bottomSpace.constant = 8
    // bottomSpaceOfTableView.constant = 0
    
  }
  
  @objc func handleKeyboardNotification(notification: Notification){
    
    if let userInfo = notification.userInfo{
      
      let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
      print(self.bottomSpace.constant)
      
      self.bottomSpace.constant += (keyboardFrame.height)
      if self.messages.count > 0{
        
        DispatchQueue.main.async {
          self.table.scrollToRow(at: IndexPath.init(row: self.messages.count - 1, section: 0), at: .bottom, animated: false)
          
        }
        
      }
      
      print(keyboardFrame)
      
    }
  }
  
  ///updates unReadCount node in user node and user -> chat -> chatting with user in a transaction. because when multiple users are chatting with this user (sending messages), some updates may lost.
  func updatedUnReadCountNodes (){
    
    let ref = FirebaseDB.shared.dbRef.child("users").child(self.myID)
    
    ref.runTransactionBlock { (mutableData) -> TransactionResult in
      
      if var data = mutableData.value as? [String:Any]{
        
        var mainUnreadCount = "0"
        var userUnreadCount = "0"
        
        if let unreadCount:String? = data["unreadCount"] as? String{
          if unreadCount != nil{
            mainUnreadCount = unreadCount!
          }
          
        }
        
        if var chat = data["chat"] as? [String:Any]{
          
          //print(chat)
          
          for var person in chat{
            
            //print(person)
            
            if person.key == self.ownerId{
              
              var ownerChatDict = person.value as? [String:Any]
              
              var count:String? = ownerChatDict!["unreadCount"] as? String
              if count != nil{
                userUnreadCount = count!
                
                if count! != "0"{
                  
                  count = "0"
                  
                  ownerChatDict!["unreadCount"] = "\(count!)"
                  
                }
              }
              
              
              person.value = ownerChatDict
              
              chat.updateValue(person.value, forKey: person.key)
              
              
            }
            
          }
          
          data["chat"] = chat
          
        }
        
        
        
        mainUnreadCount = "\(Int(mainUnreadCount)!-Int(userUnreadCount)!)"
        
        data["unreadCount"] = "\(mainUnreadCount)"
        
        mutableData.value = data
        
      }
      return TransactionResult.success(withValue: mutableData)
      
    }
  }
  
  func getCurrentLocalDate()-> Date {
    var now = Date()
    var nowComponents = DateComponents()
    let calendar = Calendar.current
    nowComponents.year = Calendar.current.component(.year, from: now)
    nowComponents.month = Calendar.current.component(.month, from: now)
    nowComponents.day = Calendar.current.component(.day, from: now)
    nowComponents.hour = Calendar.current.component(.hour, from: now)
    nowComponents.minute = Calendar.current.component(.minute, from: now)
    nowComponents.second = Calendar.current.component(.second, from: now)
    nowComponents.timeZone = TimeZone(abbreviation: "GMT")!
    now = calendar.date(from: nowComponents)!
    return now as Date
  }
  
  //MARK:- IBActions and user interaction
  
  @IBAction func btnSendMessageTapped(_ sender: UIButton) {
    send()
  }
  
  //MARK:- Touches
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first{
      
      if touch.view != textViewMessage{
        if textViewMessage.isFirstResponder{
          textViewMessage.resignFirstResponder()
        }
      }
      
    }
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    
    
    if text == "\n" {
      
      if (textView.text == "")  {
        self.alert(message: "message can't be empty")
      }else {
        
        sendMessage()
        
      }
      
    }
    return true
  }
  let placeHolderText = "Type a message..."
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
  var prevHeight:CGFloat = 0
  func adjustFrame(textView: UITextView){
    
//    var frame:CGRect = textView.frame
//    prevHeight = frame.size.height
//    print(prevHeight)
//    frame.size.height = textView.contentSize.height
//    if frame.size.height + 30 > self.heightConstraintOfLastView.constant{
//      UIView.animate(withDuration: 1, animations: {
//        self.heightConstraintOfLastView.constant = frame.size.height+20
//      })
//      self.heightConstraintOfLastView.constant = frame.size.height+20
//    }
//    if prevHeight > frame.size.height{
//      let temp = frame.size.height
//      frame.size.height = temp
//      UIView.animate(withDuration: 1, animations: {
//        self.heightConstraintOfLastView.constant = frame.size.height + 20
//      })
//
//      prevHeight = temp
//    }
//    //self.heightConstraintOfLastView.constant = self.heightConstraintOfLastView.constant+textView.contentSize.height
//    textView.frame = frame
  }
  
  
  func sendNotification(id: String, title: String, message: String){
    print("Going to send message notification")
    let url = "https://us-central1-sell4bids-4affe.cloudfunctions.net/sendNotification/"
    let urlComponents = NSURLComponents(string: url)
    urlComponents?.queryItems = [
      URLQueryItem(name: "key", value: self.apiKey),
      URLQueryItem(name: "id", value: id),
      URLQueryItem(name: "title", value: title),
      URLQueryItem(name: "message", value: message)
    ]
    
    Alamofire.request((urlComponents?.url)!).responseJSON { (response) in
      
      print(response.response as Any)
      //print(response.response)
      print(response.result)
    }
    
  }
  
}
//MARK: - UITableViewDelegate, UITableViewDataSource
extension ChatTableVC: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell") as! RecevingMessagesTableViewCell
    
    //cell1.viewMessageText.makeCornersRound()
    if self.messages.count >= indexPath.row{
      if self.messages[indexPath.row].sender != self.myID{
        //cell1.backView.makeRedAndRound()
        cell1.sizeToFit()
        
        cell1.messageLabel.numberOfLines = 0
        
        if let m = messages[indexPath.row].message{
          cell1.messageLabel.text = m
        }
        else{
          cell1.messageLabel.text = ""
        }
        
        let time = Int64(messages[indexPath.row].timeStamp!)!
        let f = Date(milliseconds: Int(time))
        let currentTime = self.currentTimeStamp
        let difference = Int64(currentTime) - time
        
        let a = "\(f)"
        var m  = a.components(separatedBy: " ")
        var n = m[1].components(separatedBy: ":")
        
        let timeText = "\(n[0])"+":"+"\(n[1])" + " " +   self.convertTime(time: difference)
        let ownerName = previousData["ownerName"] as! String
        cell1.nameLabel.text = ownerName + " , \(timeText)"
        
        //let color = UIColor.init(patternImage: #imageLiteral(resourceName: "chat_background_1080"))
        //cell1.backgroundColor = UIColor.clear
        //cell1.contentView.backgroundColor = color
        return cell1
      }
        
      else{
        // i am sender cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! MessageSenderTableViewCell
        
        cell.sizeToFit()
        
        cell.messageLabel.numberOfLines = 0
        //cell.viewMessageText.makeCornersRound()
        let time = Int64(messages[indexPath.row].timeStamp!)!
        let f = Date(milliseconds: Int(time))
        let currentTime = self.currentTimeStamp
        let difference = Int64(currentTime) - time
        
        let a = "\(f)"
        var m  = a.components(separatedBy: " ")
        var n = m[1].components(separatedBy: ":")
        
        let message = self.messages[indexPath.row].message!
        let timeText = "\(n[0])"+":"+"\(n[1])" + " " + self.convertTime(time: difference)
        cell.nameLabel.text = "You, \(timeText)"
        cell.messageLabel.text = message
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        //let color = UIColor.init(patternImage: #imageLiteral(resourceName: "chat_background_1080"))
        //cell.backgroundColor = UIColor.clear
        //let color = UIColor.init(patternImage: #imageLiteral(resourceName: "chat_background_1080"))
        //cell1.backgroundColor = UIColor.clear
        //cell.contentView.backgroundColor = color
        return cell
      }
      
    }
    return cell1
  }
  
  
}
