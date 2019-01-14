//
//  FireBaseDB.swift
//  Sell4Bids
//
//  Created by admin on 3/31/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Firebase
class FirebaseDB {
  private init() {
    
  }
  static let shared = FirebaseDB()
  let dbRef = Database.database().reference()
  
}
