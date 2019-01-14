//
//  Constants.swift
//  Sell4Bids
//
//  Created by admin on 2/17/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
class Obfuscator {
  
  static var GMSServicesByteArray = [UInt8]()
  static var GMSPlacesByteArray = [UInt8]()
    static var obfuscator = ObfuscatorClass.init()
    
  public static func obfuscate() {
    
    //AIzaSyDElOr_AjZsW7h_CAWtLl3BdXNXYMBDiZs
  GMSServicesByteArray = obfuscator.bytesByObfuscatingString(string: "AIzaSyBiYnlmacOmOu7Ku4Qum3PeM9TiTTbI6F0")
    
    GMSPlacesByteArray = obfuscator.bytesByObfuscatingString(string: "AIzaSyBiYnlmacOmOu7Ku4Qum3PeM9TiTTbI6F0")
//    
//    
    //print(GMSPlacesByteArray)
    //print(GMSServicesByteArray)
  }
  
  public static func reveal(key: [UInt8]) -> String{
    return obfuscator.reveal(key:key)
  }
}

