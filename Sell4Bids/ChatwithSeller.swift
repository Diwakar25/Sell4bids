//
//  ChatwithSeller.swift
//  Sell4Bids
//
//  Created by admin on 19/10/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

class ChatwithSeller {
    var itemAuctionType : String
    var itemCategoty : String
    var itemID : String
    var itemImages : String = ""
    var itemState : String
    var itemTitle : String
    var itemprice : String
    
    init(itemAuctionType : String , itemCategory : String , itemID : String , itemImages : String , itemState : String  ,itemTitle : String , itemprice : String) {
        
        self.itemAuctionType = itemAuctionType
        self.itemCategoty = itemCategory
        self.itemID = itemID
        self.itemImages = itemImages
        self.itemState = itemState
        self.itemTitle = itemTitle
        self.itemprice = itemprice
    }
}

