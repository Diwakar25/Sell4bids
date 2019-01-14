//
//  userInfo.swift
//  ShopNRoar
//
//  Created by admin on 12/14/17.
//  Copyright © 2017 BrainPlow. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import GoogleSignIn
import FirebaseAuth
import FacebookCore
import FacebookLogin

enum loggedInThrough {
  case manually
  case facebook
  case google
}
final class SessionManager {
  
  static let shared = SessionManager()
  let defaults = UserDefaults.standard
  //var userName = ""
  
  var email = ""
  
  var isUserLoggedIn : Bool {
    get { return defaults.bool(forKey: .strKeyUserDefaultsisUserLogged)  }
    set { defaults.set(newValue, forKey: .strKeyUserDefaultsisUserLogged) }
  }
  var userId : String {
    get { if let userId = defaults.string(forKey: .strKeyUserDefaultsuserID)  { return userId }
    else { return "" } }
    set { defaults.set(newValue, forKey: .strKeyUserDefaultsuserID) }
  }

  var loggedInThrough : Int {
    get { return defaults.integer(forKey: .strKeyUserLoggindInThrough) }
    set { defaults.set(newValue, forKey: .strKeyUserLoggindInThrough)}
  }
  
  var name : String {
    get { return defaults.string(forKey: .strKeyUserDefaultsName) ?? ""}
    set { defaults.set(newValue, forKey: .strKeyUserDefaultsName)}
  }
  
  var fcmToken : String {
    get { return defaults.string(forKey: .strKeyUserDefaultsFCMToken) ?? ""}
    set { defaults.set(newValue, forKey: .strKeyUserDefaultsFCMToken)}
  }
  ///used if user logs in through facebook or google and has set his/her pic
  var urlStrProfPic : String {
    get { return defaults.string(forKey: "urlStrProfPic" ) ?? ""}
    set { defaults.set(newValue, forKey: "urlStrProfPic" ) }
  }
  
  
  
  private init() {
    
  }
  
  public static func logOut() {
    
    //self.shared.authToken = ""
    self.shared.isUserLoggedIn = false
    self.shared.userId = ""
    self.shared.name = ""
    self.shared.loggedInThrough = -1
    
    FBSDKLoginManager().logOut()
    
    GIDSignIn.sharedInstance().signOut()
    
     try! Auth.auth().signOut()
    
  }
  public static func storeUserInfoArrayInInstance(array: [Any]) {
    
    if let isLoggedIn = array[0] as? Bool {
      shared.isUserLoggedIn = isLoggedIn
    }
    
    if let userID = array[1] as? String {
      shared.userId = userID
      
    }
    
    if let name = array[2] as? String {
      shared.name = name
    }
    
    if let email = array[3] as? String {
      shared.email = email
    }
    
    if let loggedInThrough = array[4] as? Int {
      shared.loggedInThrough = loggedInThrough
    }
    
  }
}

