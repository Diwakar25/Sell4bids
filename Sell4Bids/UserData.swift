//
//  UserData.swift
//  Sell4Bids
//
//  Created by H.M.Ali on 11/2/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation


class UserData : Equatable {
  public static func == (lhs: UserData, rhs: UserData) -> Bool {
    return
      lhs.id == rhs.id &&
      lhs.name == rhs.name &&
      lhs.status == rhs.status &&
      lhs.unreadCount == rhs.unreadCount &&
      lhs.imageUrlStr == rhs.imageUrlStr &&
      lhs.itemImg == rhs.itemImg &&
      lhs.lastMessage == rhs.lastMessage &&
      lhs.auctionType == rhs.auctionType &&
      lhs.category == rhs.category &&
      lhs.itemKey == rhs.itemKey &&
      lhs.itemState == rhs.itemState &&
      lhs.itemTitle == rhs.itemTitle &&
      lhs.itemPrice == rhs.itemPrice &&
      
      lhs.lastActivityTime == rhs.lastActivityTime
    
    
  }
  
  
  var id: String?
  var name: String?
  var status: String?
  var unreadCount: String?
  var imageUrlStr : String?
    var itemImg : String?
    var lastMessage : String?
    var auctionType : String?
    var category : String?
    var itemKey : String?
    var itemState : String?
    var itemTitle : String?
    var itemPrice : String?
  var lastActivityTime : Int64?
}
