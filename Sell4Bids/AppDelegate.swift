//
//  AppDelegate.swift
//  Sell4Bids
//
//  Created by admin on 8/25/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging
import FirebaseInstanceID
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import AppRater
import GooglePlaces
import Fabric
import Crashlytics
import IQKeyboardManagerSwift
import SwiftyStoreKit




//import IQKeyboardManagerSwift
var numberOfColumns = Int()
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate, GIDSignInDelegate {
 
    
  struct SensitiveStrings {
    
    /*Original AIzaSyDElOr_AjZsW7h_CAWtLl3BdXNXYMBDiZs*/
    static let GMS_SERVICES_API_KEY: [UInt8] = [26, 26, 31, 13, 63, 77, 6, 44, 8, 60, 92, 30, 49, 26, 30, 22, 59, 82, 15, 62, 55, 36, 123, 84, 2, 63, 124, 32, 14, 61, 45, 44, 117, 109, 12, 23, 58, 46, 1]
    /*Original AIzaSyDElOr_AjZsW7h_CAWtLl3BdXNXYMBDiZsC*/
    static let GMS_PLACES_API_KEY: [UInt8] = [26, 26, 31, 13, 63, 77, 6, 44, 8, 60, 92, 30, 49, 26, 30, 22, 59, 82, 15, 62, 55, 36, 123, 84, 2, 63, 124, 32, 14, 61, 45, 44, 117, 109, 12, 23, 58, 46, 1]
  }

    private var Printer = PinterestLayout()
    var Device = UIDevice()
    
    
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    var return_value: Int32 = 0
   
    
   
    
    var user_interactive_thread = pthread_t(bitPattern: 1)
    var user_interactive_qos_attr = pthread_attr_t()
    
    return_value = pthread_attr_init(&user_interactive_qos_attr)
    return_value = pthread_attr_set_qos_class_np(&user_interactive_qos_attr, QOS_CLASS_USER_INTERACTIVE, 0)
    let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "your-shared-secret")
    
    
    
   StoreReviewHelper.incrementAppOpenedCount()
    
    
    return_value = pthread_create(&user_interactive_thread, &user_interactive_qos_attr, { (x:UnsafeMutableRawPointer) in
        print("User interactive pthread")
        
        return nil
    }, nil)
    
    print("Device Name  : \(UIDevice.modelName)")
    print("Ipad = \(UIDevice.isPad)")
    print("Small = \(UIDevice.isSmall)")
    print("Medium = \(UIDevice.isMedium)")
    if Env.isIpad && Env.isIphoneMedium{
        
        Printer.get_numberOfColumns(numbersofColumns: 3)
        
        
       
    }
    else if UIDevice.isSmall {
        Printer.get_numberOfColumns(numbersofColumns: 3)
        print("Ipad = \(UIDevice.isSmall)")
    }else {
        Printer.get_numberOfColumns(numbersofColumns: 3)
    }
    

    ////////////////////////////////////////////////
    //Rating alert
//    let appRater = AppRater.sharedInstance
//    appRater.appId = "1304176306"
    
    weak var KB = IQKeyboardManager.shared
    weak var Firebase = FirebaseConfiguration.shared
    
    
    
    
    Fabric.with([Crashlytics.self])
    KB?.enable = true
    ////////////////////////////////////////////////
    // Override point for customization after application launch.
    Firebase?.setLoggerLevel(.min)
    FirebaseApp.configure()
    GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    GIDSignIn.sharedInstance().delegate = self
    //googleMaps API
    Obfuscator.obfuscate()
    GMSServices.provideAPIKey("AIzaSyBiYnlmacOmOu7Ku4Qum3PeM9TiTTbI6F0")
    GMSPlacesClient.provideAPIKey("AIzaSyBiYnlmacOmOu7Ku4Qum3PeM9TiTTbI6F0")
    
    //UITabBar.appearance().tintColor = UIColor.red
    
     //UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.black], for: .normal)
    //UINavigationBar.appearance().barTintColor = UIColor(red:206/255, green:31/255, blue:43/255, alpha:1.0)
    
    
     UINavigationBar.appearance().barTintColor = UIColor(red:206/255, green:31/255, blue:43/255, alpha:1.0)
    UINavigationController().navigationBar.backItem?.backBarButtonItem?.tintColor = UIColor.white
  
   
    UIApplication.shared.statusBarStyle = .lightContent
    UIApplication.shared.isStatusBarHidden = false
    
   // UINavigationBar.appearance().barStyle = .blackOpaque
    
    //Background color of status bar
    
    let statWindow = UIApplication.shared.value(forKey:"statusBarWindow") as! UIView
    let statusBar = statWindow.subviews[0] as UIView
    statusBar.backgroundColor = UIColor(red:206/255, green:31/255, blue:43/255, alpha:1.0)
    
    
    UINavigationBar.appearance().isTranslucent = false
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
   UINavigationBar.appearance().tintColor = UIColor.white
     //UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(10, -60), for:UIBarMetrics.default)
    //check if user is login then goto  xHome Screen else goto login scree
    //let token = UserDefaults.standard.object(forKey: "uid")
    
    if SessionManager.shared.isUserLoggedIn  {
      
      //Create your HomeViewController and make it the rootViewController
      
      let appDelegate = UIApplication.shared.delegate! as! AppDelegate
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let initialViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
      appDelegate.window?.rootViewController = initialViewController
      appDelegate.window?.makeKeyAndVisible()
      
    }
    else {
      
      
      let loginSignupSB = getStoryBoardByName(storyBoardNames.loginSignupSB)
      let appdelegate = UIApplication.shared.delegate as! AppDelegate
      
      let homeViewController = loginSignupSB.instantiateViewController(withIdentifier: "WelcomeVc") as! WelcomeVc
      let nav = UINavigationController(rootViewController: homeViewController)
      appdelegate.window!.rootViewController = nav
      appdelegate.window?.makeKeyAndVisible()
     homeViewController.reloadInputViews()
    }
    
    //Notification
    //requesting authorization to send push notifications
    if #available(iOS 11.0, *) {
      // For iOS 11 display notification (sent via APNS)
      UNUserNotificationCenter.current().delegate = self
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: {_, _ in })
      // For iOS 11 data message (sent via FCM
      Messaging.messaging().delegate = self as MessagingDelegate
    } else {
      let settings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    application.registerForRemoteNotifications()
    
    UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont.boldSystemFont(ofSize: 20)
    //UIApplication.shared.isStatusBarHidden = true
    UITextField.appearance().tintColor = UIColor.black
    
    
    //checking wether app opened using universal link
    
    var isUniversalLinkClick: Bool = false
    guard let launchOptions = launchOptions else {
      return true
    }
    if (launchOptions[UIApplicationLaunchOptionsKey.userActivityDictionary] != nil) {
    
      let activityDictionary = launchOptions[UIApplicationLaunchOptionsKey.userActivityDictionary] as? [AnyHashable: Any] ?? [AnyHashable: Any]()
      let activity = activityDictionary[UIApplicationLaunchOptionsKey.userActivityDictionary] as? NSUserActivity ?? NSUserActivity()
      if activity != nil {
        isUniversalLinkClick = true
      }
    }
    if isUniversalLinkClick {
      // app opened via clicking a universal link.
    } else {
      // set the initial viewcontroller
    }
    
    return true
  }
  ///MARK:- handling universal links
  func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
    
    print("Continue User Activity called: ")
    if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
      let url = userActivity.webpageURL!
      print(url.absoluteString)
        userActivity.invalidate()
      //handle url and open whatever page you want to open.
    }
    return true
  }
  
  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    
    if let err = error{
      print("Failed to log into Google: ", err)
      return
    }
    print("Successfully logged into Google ",user)
    
    guard let idToken = user.authentication.idToken else {return}
    guard let accessToken = user.authentication.accessToken else {return}
    let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
    //create firebase user with google accont
    Auth.auth().signIn(with: credentials) { (user, error) in
      if error != nil{
        print("Failed to create Firebase User with Google account: ", error as Any)
        return
      }
      else{
        guard let userID = user?.uid else {
          print("Error. guard let userID = user?.uid failed in \(self)" )
          return
          
        }
        guard let user = user else {
          print("Error. guard let user = user failed in \(self)" )
          return
        }
        var imageUrlStr = ""
        if let url = user.photoURL {
          print("Image url of google user. " + url.absoluteString )
          //SessionManager.shared.urlStrProfPic = url
          imageUrlStr = url.absoluteString
        }
        
        let ref = Database.database().reference().child("users").child(userID)
        
        let deviceUUID: String = (UIDevice.current.identifierForVendor?.uuidString)!
        let value =        ["name"  :user.displayName ?? "NA",
                           "email"  :user.email ?? "NA" ,
                           "token"  :deviceUUID,
                           "uid"    :userID,
                           "image"  :imageUrlStr ]
                        as [String  : Any]
          
        SessionManager.shared.email = user.email ?? "NA"
        SessionManager.shared.name = user.displayName ?? "NA"
        SessionManager.shared.userId = userID
        
        SessionManager.shared.isUserLoggedIn = true
        SessionManager.shared.loggedInThrough = loggedInThrough.google.hashValue
        
        ref.updateChildValues(value)
        print("Successfully logged into the firebase with Google: ", userID)
        
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        appDelegate.window?.rootViewController = initialViewController
        
      }
      
      
    }
  }
  
  func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
    Messaging.messaging().delegate = self
    let loginObj: LoginVC = LoginVC()
    let token: String = Messaging.messaging().fcmToken!
    if Auth.auth().currentUser?.uid != nil{
      loginObj.postToken(token: token, id: (Auth.auth().currentUser?.uid)!)
    }
    //  let newToken = InstanceID.instanceID().token()
    connectToFCM()
  }
  var window: UIWindow?

  func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
    -> Bool {
      
      let canHandleURL = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options[.sourceApplication] as? String, annotation: options[.annotation])
      let canHandleGoogleUrl = GIDSignIn.sharedInstance().handle(url,sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
      
      handleCustomUrlScheme(url: url)
      
      return canHandleURL || canHandleGoogleUrl
      

      
  }
  func application(received remoteMessage: MessagingRemoteMessage) {
    print(remoteMessage.appData)
    
  }
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    print("i am in the backgroud")
    
    Messaging.messaging().shouldEstablishDirectChannel = false
    //UIApplication.shared.applicationIconBadgeNumber = 0
    
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    connectToFCM()
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    print("i am terminating")
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
    //print("userInfo \(userInfo["gcm_message_id"]!)")
    //UIApplication.shared.applicationIconBadgeNumber += 1
    print(userInfo)
  }
  func connectToFCM(){
    Messaging.messaging().shouldEstablishDirectChannel = true
    let newToken = InstanceID.instanceID().token()
      print("DCM: " + (newToken ?? "Default value of new Token") )
    
  }
  @available(iOS 10.0, *)
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler(.alert)
    //UIApplication.shared.applicationIconBadgeNumber += 1
  }
  
  func postToken(token: String, id: String){
    print("FCM Token \(token)")
    let ref = Database.database().reference().child("users").child(id)
    ref.child("fcmToken").setValue(token)
  }
  
  
  
  var flagOpenedFromScheme = true
  func handleCustomUrlScheme(url : URL) {
    
    guard SessionManager.shared.isUserLoggedIn else {
      showSwiftMessageWithParams(theme: .error, title: "Authentication Required", body: "Please Sign In to see the shared product")
      return
    }
    guard let query = url.query , url.absoluteString.contains("itemDetails") else {
      return
    }
    flagOpenedFromScheme = true

    //open details page
    let components = query.components(separatedBy: "itemDetails")
    print(components)
//    guard components.count > 1 else {
//      print("guard components.count > 1 failed")
//      return
//    }
    let paramString = components[0]
    
    print(paramString) // "cat=Antiques&auction=buy-it-now&state=MN&pid=-LDGkEleiWBvBeBaAfoT&uid=undefined"
    
    
    let pairs = paramString.components(separatedBy: "&")
    //pairs = ["cat=Antiques", "auction=buy-it-now", "state=MN", "pid=-LDGkEleiWBvBeBaAfoT", "uid=undefined"]
    let catPair = pairs[0], auctionPair = pairs[1], statePair = pairs[2], productIDPair = pairs[3]
    guard let catRange = catPair.range(of: "="), let aucRange  = auctionPair.range(of: "="),
      let stateRange = statePair.range(of: "="), let idRange = productIDPair.range(of: "=") else {
        return
    }
  
    let cat = catPair[catRange.upperBound...].trimmingCharacters(in: .whitespaces)
    let auction = auctionPair[aucRange.upperBound...].trimmingCharacters(in: .whitespaces)
    let state = statePair[stateRange.upperBound...].trimmingCharacters(in: .whitespaces)
    let productID = productIDPair[idRange.upperBound...].trimmingCharacters(in: .whitespaces)
    
    
    if let revealVC =  window?.rootViewController as? SWRevealViewController {

      if let homeTabBar = revealVC.frontViewController as? HomeTabBarController, let
        homeNav = homeTabBar.viewControllers?[0] as? UINavigationController {
        
        if let homeVC = homeNav.childViewControllers[0] as? HomeVC_New {
          print("in home")
          let productDetailSB = getStoryBoardByName(storyBoardNames.prodDetails)
          guard let detailsProd = productDetailSB.instantiateViewController(withIdentifier: "ProductDetailVc") as? ProductDetailVc else { return  }
          
          let productDetail = ProductModel()
          productDetail.categoryName = cat
          productDetail.auctionType = auction
          productDetail.state = state
          productDetail.productKey = productID
          
          getProductData(for: productDetail) { (success, productModel) in
          
            guard success , let productData = productModel else {
              return
            }
            
            detailsProd.productDetail = productData
            homeVC.navigationController?.pushViewController(detailsProd, animated: true)
            
          }
          
        }
      }

    }


  }
    
    deinit {
        print("Deintiailize App Delegate")
        
    }
  
}

