//
//  AuctionTypeAndState.swift
//  Sell4Bids
//
//  Created by admin on 1/11/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
struct AuctionTypeAndState : Hashable{
  var hashValue: Int
  static func ==(lhs: AuctionTypeAndState, rhs: AuctionTypeAndState) -> Bool {
    return lhs.auctionType == rhs.auctionType &&
      rhs.State == lhs.State
  }
  let auctionType:String
  let State : String
}

public struct CategoryAndAuctionType : Hashable{
  public var hashValue: Int
  let catName: String
  let auctionType: String
  public static func ==(lhs: CategoryAndAuctionType, rhs: CategoryAndAuctionType) -> Bool {
      return  lhs.auctionType == rhs.auctionType &&
              lhs.catName == rhs.catName
  }
}
