//
//  Product.swift
//  Sell4Bids
//
//  Created by H.M.Ali on 10/13/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UIKit

class Product {
    
    var images: [UIImage]?
    var title: String
    var category: String
    var condition: String
    var conditionValue: Int
    var description: String
    var price: Int?
    var quantity: Int?
    var duration: Int
    var acceptOffer: String?
    var productType: String?
    var city: String
    var state: String
    var startingPrice: Int?
    var endPrice: Int?
    var currency_string : String?
    var currency_symbol : String?
    init(images: [UIImage]?,title: String, category: String,condition: String,conditionValue: Int,description: String,price: Int?,quantity: Int?,duration: Int,acceptOffer: String?,productType: String?, city: String, state: String,startingPrice:Int?,endPrice:Int?,currency_string : String , currency_symbol : String) {
        self.images = images
        self.title = title
        self.category = category
        self.condition = condition
        self.conditionValue = conditionValue
        self.description = description
        self.price = price
        self.quantity = quantity
        self.duration = duration
        self.acceptOffer = acceptOffer
        self.productType = productType
        self.city = city
        self.state = state
        self.startingPrice = startingPrice
        self.endPrice = endPrice
        self.currency_string = currency_string
        self.currency_symbol = currency_symbol
    }
    
    
}
