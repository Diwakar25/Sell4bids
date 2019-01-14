//
//  CounterOfferModel.swift
//  Sell4Bids
//
//  Created by admin on 1/20/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
class CounterModel {
  var userId:String
  var counterCount:Int
  var pricePerItem:Int
  var quantity:Int
  
  init(userId:String,counterDict:[String:AnyObject]) {
    
    self.userId = userId
    self.counterCount = -1
    if let counterOfferCount = counterDict["counterOfferCount"] as? String{
      
      if let countInt = Int(counterOfferCount) { self.counterCount = countInt }
    }
    
    self.pricePerItem = -1
    if let pricePerItem = counterDict["pricePerItem"] as? String {
      
      if let price = Int(pricePerItem ) { self.pricePerItem = price }
    }
    
    self.quantity = -1
    if let quantity = counterDict["quantity"] as? String {
    
      if let quantityInt = Int(quantity) { self.quantity = quantityInt }
      
    }
    
  }
  
  init(userId: String, counterCount: Int, pricePerItem: Int, quantity: Int) {
    self.userId = userId
    self.counterCount = counterCount
    self.pricePerItem = pricePerItem
    self.quantity = quantity
  }
  
  init() {
    userId = ""
    counterCount = -1
    pricePerItem = -1
    quantity = -1
  }
}


