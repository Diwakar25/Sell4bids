//
//  ChatItem.swift
//  Sell4Bids
//
//  Created by admin on 07/11/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

class ChatItem {
    var auctionType : String
    var category : String
    var itemKey : String
    var itemState : String = ""
    var itemPrice : String
    var itemImage : String
    var itemTitle : String
    
    init(auctionType : String , category : String , itemKey : String , itemState : String , itemPrice : String , itemImage : String , itemTitle : String) {
        
        self.auctionType = auctionType
        self.category = category
        self.itemKey = itemKey
        self.itemState = itemState
        self.itemPrice = itemPrice
        self.itemImage = itemImage
        self.itemTitle = itemTitle
    }
}

