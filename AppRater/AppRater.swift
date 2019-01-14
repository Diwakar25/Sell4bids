//
//  AppRater.swift
//  AppRater
//
//  Created by admin on 2/9/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import StoreKit

let AP_APP_LAUNCHES = "com.brainplow.applaunches"
let AP_APP_LAUNCHES_CHANGED = "com.brainplow.applaunches.changed"
let AP_FIRST_LAUNCH_DATE = "com.brainplow.launch_date"
let AP_APP_RATING_SHOWN = "com.brainplow.app_rating_shown"
let AP_APP_FirstLauchDateSet = "com.brainplow.firstLauchDataSet"

public class AppRater: NSObject , UIAlertViewDelegate{
  
  var application: UIApplication!
  var defaults = UserDefaults.standard
  let requiredLaunchesBeforeRating = 20
  public var appId: String!
  let requiredNumberOfDaysBeforeRating = 10
  
  public static var sharedInstance = AppRater()
  
  override public init() {
    super.init()
    setup()
  }
  func setup()  {
    
    NotificationCenter.default.addObserver(self, selector: #selector(appDidFinishLaunching(notification:)), name: NSNotification.Name.UIApplicationDidFinishLaunching, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(displayRatingsPromptIfRequired), name: NSNotification.Name(rawValue: NSNotification.Name.RawValue("displayRatingsPromptIfRequired")), object: nil)
    
    //only set first launch date one time when app is launched first time
    if !hasFirstLaunchDateSet() {
      setFirstLaunchDate()
    }
  }
  
  
  @objc func appDidFinishLaunching(notification: Notification) {
    
    if let _application = notification.object as? UIApplication {
      self.application = _application
      //displayRatingsPromptIfRequired()
    }
  }
  
  func getAppLauchCount() -> Int {
    let launches = defaults.integer(forKey: AP_APP_LAUNCHES)
    return launches
  }
  
  func incrementAppLaunches() {
    var launches = defaults.integer(forKey: AP_APP_LAUNCHES)
    launches = launches + 1
    defaults.set(launches, forKey: AP_APP_LAUNCHES)
  }
  func resetAppLaunches(){
    defaults.set(0, forKey: AP_APP_LAUNCHES)
  }
  
  //MARK: - First Launch Date
  func setFirstLaunchDate(){
    defaults.set(Date.init(), forKey: AP_FIRST_LAUNCH_DATE)
    defaults.set(true, forKey: AP_APP_FirstLauchDateSet)
  }
  
  func getFirstLaunchDate()->Date{
    if let date = defaults.value(forKey: AP_FIRST_LAUNCH_DATE) as? Date{
      return date
    }
    
    return Date()
  }
  
  func hasFirstLaunchDateSet() -> Bool {
    if let set = defaults.value(forKey: AP_APP_FirstLauchDateSet) as? Bool {
      return set
    }
    return false
  }
  
  //MARK: App Rating Shown
  func setAppRatingShown(){
    defaults.set(true, forKey: AP_APP_RATING_SHOWN)
    
  }
  
  func hasShownAppRating()->Bool{
    let shown = defaults.bool(forKey: AP_APP_RATING_SHOWN)
    return shown
  }
  
  //MARK: - Rating the App
  @objc private func displayRatingsPromptIfRequired(){
    let appLaunchCount = getAppLauchCount()
    if appLaunchCount >= self.requiredLaunchesBeforeRating && !hasShownAppRating() {
      //check if required number of days are passed
      if hasRequiredNumberOfDaysPassed() {
        if #available(iOS 10.3, *) {
          // show App Ratings
          //rateTheApp()
          SKStoreReviewController.requestReview()
        }
        else{
          //rateTheAppOldVersion()
        }
      }
    }
    
    incrementAppLaunches()
  }
  
  func hasRequiredNumberOfDaysPassed() -> Bool {
    //get first lauch date, find its difference from today
    let firstLauchDate = getFirstLaunchDate()
    let todaysDate = Date.init()
    let currentCalender = Calendar.current
    
    guard let start = currentCalender.ordinality(of: .day, in: .era, for: firstLauchDate) else {
      return false
    }
    guard let end = currentCalender.ordinality(of: .day, in: .era, for: todaysDate) else {
      return false
    }
    print("Number of days passed. \(end - start)")
    if end - start >= requiredNumberOfDaysBeforeRating { return true }
    return false
    
  }
  @available(iOS 8.0, *)
  private func rateTheApp(){
    let app_name = Bundle(for: type(of: application.delegate!)).infoDictionary!["CFBundleName"] as? String
    let message = "Enjoying \(app_name!) app?"
    
    let enjoyingQuestionAlert = UIAlertController(title: "Hi There!", message: message, preferredStyle: .alert)
    
    let notEnjoyingAction = UIAlertAction(title: "No", style: .default) { (noAction) in
      //Get feedback from user and show respective alert
      self.askForFeedback()
      //let feedbackVC = UIStoryboard.init(name: "Main", bundle: )
    }
    let yesEnjoyingAction = UIAlertAction(title: "Yes!", style: .default) { (yesAction) in
      //show an alert asking user to rate the app in the app store
      self.askForRating()
    }
    enjoyingQuestionAlert.addAction(yesEnjoyingAction)
    enjoyingQuestionAlert.addAction(notEnjoyingAction)
    
    
    //enjoyingQuestionAlert.addAction(cancelAction)
    //enjoyingQuestionAlert.addAction(goToItunesAction)
    DispatchQueue.main.async {
      let window = self.application.windows[0]
      window.rootViewController?.present(enjoyingQuestionAlert, animated: true, completion: nil)
    }
//    DispatchQueue.async(group: DispatchQueue.main, execute: { () -> Void in
//      let window = self.application.windows[0]
//      window.rootViewController?.presentViewController(rateAlert, animated: true, completion: nil)
//    })
    
  }
  private func askForFeedback() {
    let giveFeedBackAlert = UIAlertController(title: "Give Your Feedback", message: "Would you mind giving us some feedback?", preferredStyle: .alert)
    let giveFeedBackAction = UIAlertAction(title: "Ok, sure", style: .default) { (giveFeedback) in
      //redirect the user to feedback view controller
      //let storyboard = UIStoryboard(name: "AppRater", bundle: Bundle.)
      
//      let feedbackVC = UIStoryboard().instantiateViewController(withIdentifier: "feedbackVC")
//      DispatchQueue.main.async {
//        let window = self.application.windows[0]
//        window.rootViewController?.present(feedbackVC, animated: true, completion: nil)
//      }
      NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: Notification.Name.RawValue("ShowFeedBackForm")), object: nil, userInfo: nil))
      
      
    }
    let cancelAction = UIAlertAction(title: "No, thanks", style: .default, handler: nil)
    giveFeedBackAlert.addAction(giveFeedBackAction)
    giveFeedBackAlert.addAction(cancelAction)
    DispatchQueue.main.async {
      let window = self.application.windows[0]
      window.rootViewController?.present(giveFeedBackAlert, animated: true, completion: nil)
    }
    
    
  }
  
  private func askForRating() {
    let askForRatingAlert = UIAlertController(title: "Rate Us", message: "How about a rating on the app store, then?", preferredStyle: .alert)
    
    let goToItunesAction = UIAlertAction(title: "Ok, sure", style: .default, handler: { (action) -> Void in
      let url = NSURL(string: "itms-apps://itunes.apple.com/app/id\(self.appId)")
      UIApplication.shared.openURL(url! as URL)
      
      self.setAppRatingShown()
    })
    
    let cancelAction = UIAlertAction(title: "No Thanks", style: .cancel, handler: { (action) -> Void in
      self.resetAppLaunches()
    })
    askForRatingAlert.addAction(goToItunesAction)
    askForRatingAlert.addAction(cancelAction)
  }
  
  private func rateTheAppOldVersion(){
    let app_name = Bundle.main.infoDictionary!["CFBundleName"] as? String
    let message = "Do you love the \(app_name!) app?  Please rate us!"
    let alert = UIAlertView(title: "Rate Us", message: message, delegate: self as UIAlertViewDelegate, cancelButtonTitle: "Not Now", otherButtonTitles: "Rate Us")
    alert.show()
  }
  
  
  //MARK: - Alert Views
  @objc public func alertViewCancel(_ alertView: UIAlertView) {
    // reset app launch count
    self.resetAppLaunches()
  }
  
  @objc public func alertView(_ alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
    setAppRatingShown()
    
    let url = NSURL(string: "itms-apps://itunes.apple.com/app/id\(self.appId)")
    UIApplication.shared.openURL(url! as URL)
  }
  
}
