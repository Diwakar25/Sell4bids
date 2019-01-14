//
//  IndiaPinCodeModel.swift
//  Sell4Bids
//
//  Created by admin on 27/11/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

class IndiaPinCodeModel {
    var name : String?
    var description : String?
    var branchType : String?
    var deliveryStatus : String?
    var taluk : String?
    var circle : String?
    var district : String?
    var division : String?
    var region : String?
    var state : String?
    var country : String?
    
    init(name : String , description : String , branchType : String , deliveryStatus : String , taluk : String , circle : String , district : String , division : String , region : String , state : String , country : String) {
        self.name = name
        self.description = description
        self.branchType = branchType
        self.deliveryStatus = deliveryStatus
        self.taluk = taluk
        self.circle =  circle
        self.district = district
        self.division = division
        self.region = region
        self.state = state
        self.country = country
        
    }
}
