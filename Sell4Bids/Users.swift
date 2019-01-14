//
//  Users.swift
//  Sell4Bids
//
//  Created by admin on 10/9/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
class UserModel {
    
    var name:String?
    var image:String?
    var userId:String?
    var averageRating:Float?
    var totalRating:Float?
    var email:String?
    var zipCode:String?
    var state:String?
    var watching:Int?
    var follower:Int?
    var following:Int?
    var totalListing:Int?
    var buying:Int?
    var bought:Int?
    var unReadMessage:Int?
    var unReadNotify:Int?
   
    
    
    init(name:String?,image:String?,userId:String?,  averageRating:Float?,totalRating:Float?,email:String?, zipCode:String?, state:String?,watching:Int?,follower:Int?,following:Int?, totalListing:Int?, buying:Int?, bought:Int?,unReadMessage:Int?,unReadNotify:Int?) {
        self.name = name
        self.userId = userId
        self.image =  image
        self.averageRating = averageRating
        self.totalRating =  totalRating
        self.email = email
        self.zipCode = zipCode
        self.state = state
        self.watching = watching
        self.follower = follower
        self.following = following
        self.totalListing = totalListing
        self.buying = buying
        self.bought = bought
        self.unReadMessage = unReadMessage
        self.unReadNotify = unReadNotify
    
    }
  init(userId:String,userDict:[String:AnyObject]) {
    if let userName = userDict["name"] as? String {
      self.name = userName
    }
    if let userImage = userDict["image"] as? String{
      self.image = userImage
    }
    if let averageRating = userDict["averagerating"] as? String{
      self.averageRating = Float(averageRating)
    }
    if let totalRating = userDict["totalratings"] as? String{
      self.totalRating = Float(totalRating)
    }
    if let email = userDict["email"] as? String{
      self.email = email
    }
    if let zipCode = userDict["zipCode"] as? String{
      self.zipCode = zipCode
    }
    if let follower = userDict["followersCount"] as? String{
      self.follower = Int(follower)
    }else {
      self.follower = 0
    }
    if let following = userDict["followingsCount"] as? String{
      self.following = Int(following)
    }else {
      self.following = 0
    }
    if let stateName = userDict["state"] as? String {
      self.state = stateName
    }
    if  let productDict = userDict["products"] as? NSDictionary{
      if let selling = productDict["selling"] as? NSDictionary{
        self.totalListing = selling.count
      }
    if let buying = productDict["buying"] as? NSDictionary{
      self.buying  = buying.count
      }
    }
    
    
    self.userId = userId
    
  }
  
    
}
