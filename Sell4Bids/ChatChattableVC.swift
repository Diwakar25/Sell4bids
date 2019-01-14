//
//  ChatChattableVC.swift
//  Sell4Bids
//
//  Created by admin on 1/9/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Firebase
//import JSQMessagesViewController
//class ChatChattableVC: JSQMessagesViewController {
////MARK:- Variables
//  var messageRef: DatabaseReference?
//  //private lazy var messageRef: DatabaseReference = self.channelRef!.child("TestingChat")
//  private var newMessageRefHandle: DatabaseHandle?
//          lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
//lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
//     var previousData = [String:Any]()
//     var messages = [JSQMessage]()
////MARK:- View Life Cyle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//      messageRef = Database.database().reference().child("TestingChat")
//      self.senderId = Auth.auth().currentUser?.uid
//      print(previousData["ownerName"] as! String )
//      self.senderDisplayName = previousData["ownerName"] as! String
//      
//        // Do any additional setup after loading the view.
//      collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
//      collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
//    }
//  
//  override func viewDidAppear(_ animated: Bool) {
//    super.viewDidAppear(animated)
//    addMessage(withId: "foo", name: "Mr.Bolt", text: "I am so fast!")
//    // messages sent from local sender
//    addMessage(withId: senderId, name: "Me", text: "I bet I can run faster than you!")
//    addMessage(withId: senderId, name: "Me", text: "I like to run!")
//    // animates the receiving of a new message on the view
//    finishReceivingMessage()
//  }
//  private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
//    let bubbleImageFactory = JSQMessagesBubbleImageFactory()
//    return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
//  }
//  private func setupIncomingBubble() -> JSQMessagesBubbleImage {
//    let bubbleImageFactory = JSQMessagesBubbleImageFactory()
//    return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
//  }
//  private func addMessage(withId id: String, name: String, text: String) {
//    if let message = JSQMessage(senderId: id, displayName: name, text: text) {
//      messages.append(message)
//    }
//  }
//  
//  // MARK:- Collection view data source (and related) methods
//  override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
//    return messages[indexPath.item]
//  }
//  
//  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    return messages.count
//  }
//  override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
//    let message = messages[indexPath.item] // 1
//    if message.senderId == senderId { // 2
//      return outgoingBubbleImageView
//    } else { // 3
//      return incomingBubbleImageView
//    }
//  }
//  override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
//    return nil
//  }
//  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
//    let message = messages[indexPath.item]
//    
//    if message.senderId == senderId {
//      cell.textView?.textColor = UIColor.white
//    } else {
//      cell.textView?.textColor = UIColor.black
//    }
//    return cell
//  }
//// MARK: Firebase related methods
//  override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
//    let itemRef = messageRef?.childByAutoId() // 1
//    let messageItem = [ // 2
//      "senderUid": senderId!,
//      "sender": senderDisplayName!,
//      "message": text!,
//      ]
//    
//    itemRef?.setValue(messageItem) // 3
//    
//    JSQSystemSoundPlayer.jsq_playMessageSentSound() // 4
//    
//    finishSendingMessage() // 5
//  }
//
//}
