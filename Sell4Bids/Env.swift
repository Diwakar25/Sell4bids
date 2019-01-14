//
//  Env.swift
//  Sell4Bids
//
//  Created by admin on 3/19/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

class Env {
  static var isIpad : Bool { return UIDevice.current.userInterfaceIdiom == .pad }
  static var isIphoneSmall : Bool { return UIDevice.isSmall }
  static var isIphoneMedium : Bool { return UIDevice.isMedium  }
}



