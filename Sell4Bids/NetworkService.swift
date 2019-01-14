//
//  NetworkService.swift
//  Sell4Bids
//
//  Created by admin on 5/1/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import Firebase
var imageUrl : String = ""
var userData : UserModel?
var dbRef = DatabaseReference()

class NetworkService {
  
  static var timeStamp: Int64 = 0
  static var myId = SessionManager.shared.userId
  static var unreadCount = 0
  static var readCount = 0
    static var products = ProductModel()
    static func chatRoomExistsWithUser(otherUsersId: String, completion: @escaping (_ concatenatedID: String, _ status: Bool)->()){
    let myID = SessionManager.shared.userId
    let str1 = myID + "_" + otherUsersId
    let str2 =  otherUsersId + "_" + myID
    var final = str1
   
        
        var unreadCount = Int()

        
        func getLoginUserData(completion : @escaping (Bool) -> () ){
            guard let userId = Auth.auth().currentUser?.uid else {
                
                print("ERROR: While getting User ID")
                return
            }
            dbRef = FirebaseDB.shared.dbRef
            
            dbRef.child("users").child(userId).observe(DataEventType.value) { (snapshot) in
               
               
                // Get user value
                if let dict = snapshot.value as? NSDictionary {
                    var name = "Sell4Bids"
                    if let checkname = dict["name"]{
                        name = checkname as! String
                    }
                    var imageurl = "NO"
                    if let image = dict["image"] {
                        imageurl = image as! String
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
                    
                    print(self.unreadCount)
                    
                    
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
                    
                    let userdata:UserModel = UserModel(name: name , image: imageurl , userId:userId, averageRating: ratingInt, totalRating: totalRatingInt, email: email as? String, zipCode: code, state: city, watching: checkWatching, follower: followInt, following: followingInt, totalListing: checkSelling, buying: checkbuying, bought: checkBought, unReadMessage: messageInt, unReadNotify: notifyInt )
                    
                    userData = userdata
                    
                    completion(true)
                    
                    
                }
            }
    
        }
        

    
    let ref = FirebaseDB.shared.dbRef.child("chat_rooms")
    
    ref.child(str2).observeSingleEvent(of: .value) { (snapshot) in
      
      print("i am check string")
      if snapshot.hasChildren(){
        final = str2
        completion(final, true)
      }
      else{
        final = str1
        completion(final, true)
      }
    }
  }//end of checkString
  
  ///updates unread count of both the owner and the user and writes values in concated id inside chat rooms
    static func sendMessage(message: String, ownerId: String, timeStamp: Int64, concatId: String, ownerName: String, completion: @escaping (Bool) -> () ){
    
    let dbRef = FirebaseDB.shared.dbRef
    let ownerRef = dbRef.child("users").child("\(ownerId)")
    
    ownerRef.observeSingleEvent(of: .value, with: { (snapshot) in
      
      //print(snapshot)
      var data : [String:Any] = [:]
      if let d = snapshot.value as? [String:Any]{
        data = d
      }
      else{
        print("No data found")
        
      }
      
      let startTime = data["startTime"] as? Int64
      let diff = timeStamp - startTime!
    
        var chat = data["chat"] as? [String:Any]
        
        if var myNode = chat![myId] as? [String:Any]{
          
          if let count = myNode["unreadCount"] as? String, let intCount = Int(count) {
            
            myNode.updateValue(intCount + 1, forKey: "unreadCount")
            let value = ["unreadCount":"\(intCount)"]
            ownerRef.child("chat").child(myId).updateChildValues(value)
            
            if let count = data["unreadCount"] as? String, let intCount = Int(count) {
                print("uncount READ MSG ==\(count)")
                let value = ["unreadCount":"\(intCount + 1)"]
                ownerRef.updateChildValues(value)
            }
            
          }
          
        }
        
        
        
      
      
    })
    
    let refForLastMessage = dbRef.child("Messages").child("Last Message").child(ownerId)
    
    let val = ["message": message, "timeStamp": timeStamp ] as [String : Any]
    refForLastMessage.setValue(val)
    
    let ref = FirebaseDB.shared.dbRef.child("chat_rooms").child(concatId).child("\(timeStamp)")
        let value = ["message" : message,"receiver": ownerName, "senderUid": SessionManager.shared.userId, "receiverUid": ownerId,"sender":SessionManager.shared.name,"timestamp": timeStamp]  as [String : Any]
    
    ref.updateChildValues(value) { (error: Error?, _) in
      guard error == nil else {
        completion(false)
        return
      }
      completion(true)
    }
  
  }
  
    //ChatwithSeller send with Image
    static func sendMessagewithitem(message: String, ownerId: String, timeStamp: Int64, concatId: String, ownerName: String,itemAuctionType: String , itemCategory:String , itemImages : String,itemState : String , itemTitle : String ,itemID : String, itemPrice : String , completion: @escaping (Bool) -> () ){
        
        let dbRef = FirebaseDB.shared.dbRef
        let ownerRef = dbRef.child("users").child("\(ownerId)")
        
        ownerRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //print(snapshot)
            var data : [String:Any] = [:]
            if let d = snapshot.value as? [String:Any]{
                data = d
            }
            else{
                print("No data found")
                
            }
            
            let startTime = data["startTime"] as? Int64
            let diff = timeStamp - startTime!
            
            var chat = data["chat"] as? [String:Any]
            
            if var myNode = chat![myId] as? [String:Any]{
                
                if let count = myNode["unreadCount"] as? String, let intCount = Int(count) {
                    
                    myNode.updateValue(intCount + 1, forKey: "unreadCount")
                    let value = ["unreadCount":"\(intCount)"]
                    ownerRef.child("chat").child(myId).updateChildValues(value)
                    
                    if let count = data["unreadCount"] as? String, let intCount = Int(count) {
                        print("uncount READ MSG ==\(count)")
                        let value = ["unreadCount":"\(intCount + 1)"]
                        ownerRef.updateChildValues(value)
                    }
                    
                }
                
            }
            
            
            
            
            
        })
        
        let refForLastMessage = dbRef.child("Messages").child("Last Message").child(ownerId)
        
        let val = ["message": message, "timeStamp": timeStamp ] as [String : Any]
        refForLastMessage.setValue(val)
        
        
        
        let ref = FirebaseDB.shared.dbRef.child("chat_rooms").child(concatId).child("\(timeStamp)")
        let value = ["itemAuctionType": itemAuctionType,"itemCategory": itemCategory , "itemID" :  itemID ,"itemImages" : itemImages ,"itemState" : itemState ,"itemTitle" :itemTitle , "message" : message,"receiver": ownerName, "senderUid": SessionManager.shared.userId, "receiverUid": ownerId,"sender":SessionManager.shared.name,"timestamp": timeStamp]  as [String : Any]
        
        let itemvalue = ["auctionType" : itemAuctionType , "category" : itemCategory,"itemImage" : itemImages , "itemKey" : itemID , "itemState" : itemState , "itemTitle" : itemTitle, "itemPrice" : itemPrice ]
        
        let userref = FirebaseDB.shared.dbRef.child("users").child(myId).child("chat").child(ownerId)
        let ownerref = FirebaseDB.shared.dbRef.child("users").child(ownerId).child("chat").child(myId)
        
        userref.child("last_item").updateChildValues(itemvalue)
        ownerref.child("last_item").updateChildValues(itemvalue)
        
        ref.updateChildValues(value) { (error: Error?, _) in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
        
    }
    
  static func getNotificationCount(completion : @escaping (Bool, Int?) -> ()) {
    
    
    
    let dbRef = FirebaseDB.shared.dbRef
    guard let userId = Auth.auth().currentUser?.uid else {
      print("Fatal Error. No user id found to download notifications ")
      //exit(0)
      return
    }
   
   
    let query : DatabaseQuery = dbRef.child("users").child(userId).child("notifications").queryLimited(toLast: 25)
   
    query.observe(.value) {  (notificationsSnapShot: DataSnapshot) in
      //guard let this = self else { return }
        unreadCount = 0
      if notificationsSnapShot.childrenCount > 0 {
      
        print("notification Count == SideMenu \(notificationsSnapShot.childrenCount)")
        for child in notificationsSnapShot.children {
  
          guard let notSnapShot = child as? DataSnapshot, let notDict = notSnapShot.value as? [String:AnyObject] else {
            print("guard let snapCasted = notSnapShot as? DataSnapshot failed in network service")
            continue
          }
            
            
            guard let read = notDict["read"]  else {
                print("Not Found! ")
                return
            }
           print("read text = \(read)")
            if !read.contains("1") {
                 print("read = \(read)")
                unreadCount += 1
print("unreadcount = \(unreadCount)")
            }
         completion(false , unreadCount)
        }
        
      }else {
        completion(false, nil )
      }
    }
    
  }
}
