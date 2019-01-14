//
//  DateToString.swift
//  Sell4Bids
//
//  Created by admin on 8/16/18.
//  Copyright © 2018 admin. All rights reserved.
//


extension Date
{
  static let shared = DateFormatter()
  func toString( dateFormat format  : String ) -> String
  {
    Date.shared.dateFormat = format
    return Date.shared.string(from: self)
  }
  
  //.full, .none e.g. Wednesday 15, 2018
  func toString(dateStyle : DateFormatter.Style = .full, timeStyle: DateFormatter.Style = .none) -> String {
    Date.shared.dateStyle = dateStyle
    Date.shared.timeStyle =  timeStyle
    
    return Date.shared.string(from: self)
  }
  
}
