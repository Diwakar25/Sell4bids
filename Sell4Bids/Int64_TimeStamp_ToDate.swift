//
//  Int64_TimeStamp_ToDate.swift
//  Sell4Bids
//
//  Created by admin on 8/16/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
extension Int64 {
  
  func millisTotoDate() -> Date {
    let endTimeInterval:TimeInterval = TimeInterval(self)
    //Convert to Date
    let date = Date(timeIntervalSince1970: endTimeInterval/1000)
    return date
  }
  
  
}
