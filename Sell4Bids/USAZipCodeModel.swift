//
//  USAZipCodeModel.swift
//  Sell4Bids
//
//  Created by admin on 27/11/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

class USAZipCodeModel {
    var country : String?
    var state : String?
    var city : String?
    
    init(country : String , state : String , city : String) {
        self.country = country
        self.state = state
        self.city = city
    }
}
