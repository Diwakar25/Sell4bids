//
//  Notifications.swift
//  Sell4Bids
//
//  Created by admin on 10/18/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
class NotificationModel {
  
  var auctionType = String()
  var category = String()
  var productKey = String()
  var message = String()
  var read = String()
  var senderName = String()
  var stateName = String()
  var startTime = Int64()
  var notifyKey = String()
  
  var senderUId : String?
  var senderImage: UIImage?
  var type: String?
  //variables for chat dictionary
  
  var product : ProductModel!
  
  
  init(notifyKey:String,notificationDict:[String:AnyObject]){
    
    if let auctionType = notificationDict["auctionType"] as? String {
      self.auctionType = auctionType
    }
    if  let categoryName = notificationDict["category"] as? String {
      self.category = categoryName
    }
    if let productkey = notificationDict["key"] as? String{
      self.productKey = productkey
    }
    if let message = notificationDict["message"] as? String{
      self.message = message
    }
    
    //  var readNoti:Int = 0
    if let read =  notificationDict["read"] as? String{
      self.read = read
    }else {
      self.read = "0"
    }
    if let senderName =  notificationDict["sender"] as? String {
      self.senderName = senderName
    }else {
      self.senderName = "Sell4Bids"
    }
    if let state = notificationDict["state"] as? String{
      self.stateName = state
    }
    if let startTime = notificationDict["time"]  as? Int64 {
      //checkTime = startTime as? Int64
      self.startTime = startTime
    }else {
      self.startTime = 0
    }
    self.notifyKey = notifyKey
    
    //parsing for chat notification variables
    if let senderUId = notificationDict["senderUid"]  as? String {
      self.senderUId = senderUId
    }
    
    if let senderImage = notificationDict["senderImage"]  as? UIImage {
      self.senderImage = senderImage
    }
    
    if let type = notificationDict["type"]  as? String {
      self.type = type
    }
    
  }
}
