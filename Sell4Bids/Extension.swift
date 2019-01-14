
//

//  Extensions.swift

//  chatPractice

//

//  Created by Admin on 9/16/17.

//  Copyright © 2017 Admin. All rights reserved.

//



import Foundation

import UIKit
import SystemConfiguration
import Firebase
protocol Utilities {
  
}

extension NSObject:Utilities{
  
  enum ReachabilityStatus {
    
    case notReachable
    
    case reachableViaWWAN
    
    case reachableViaWiFi
    
  }
  
  var currentReachabilityStatus: ReachabilityStatus {
    
    var zeroAddress = sockaddr_in()
    
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
      
      $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
        
        SCNetworkReachabilityCreateWithAddress(nil, $0)
        
      }
      
    }) else {
      
      return .notReachable
      
    }
    
    
    
    var flags: SCNetworkReachabilityFlags = []
    
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
      
      return .notReachable
      
    }
    
    
    
    if flags.contains(.reachable) == false {
      
      // The target host is not reachable.
      
      return .notReachable
      
    }
      
    else if flags.contains(.isWWAN) == true {
      
      // WWAN connections are OK if the calling application is using the CFNetwork APIs.
      
      return .reachableViaWWAN
      
    }
      
    else if flags.contains(.connectionRequired) == false {
      
      // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
      
      return .reachableViaWiFi
      
    }
      
    else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
      
      // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
      
      return .reachableViaWiFi
      
    }
      
    else {
      
      return .notReachable
      
    }
    
  }
  
  
  
}

let imageCache = NSCache<AnyObject, AnyObject>()

let userCache = NSCache<AnyObject, AnyObject>()



extension UIImageView{
  func loadImageUsingCacheWithUrlString(urlString: String){
    self.image = nil
    if urlString != ""{
      if let cachedImage = imageCache.object(forKey: urlString as AnyObject){
        self.image = cachedImage as! UIImage
        return
      }
        
      else {
        
        var url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
          
          if error != nil{
            
            print(error)
            
            return}
          
          
          
          DispatchQueue.main.async {
            if let downloadedImage = UIImage(data: data!){
              imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
              
              self.image = downloadedImage
              
            }
            
            
            
          }
          
        }).resume()
        
      }
      
    }
    
  }
  
}
extension Date {
  
  var ticks: UInt64 {
    
    return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    
  }
  
}

extension Date {
  
  init(ticks: UInt64) {
    
    self.init(timeIntervalSince1970: Double(ticks)/10_000_000 - 62_135_596_800)
    
  }
  
}



//let date = Date(ticks: 636110903202288256
extension Double {
  
  /// Rounds the double to decimal places value
  
  func rounded(toPlaces places:Int) -> Double {
    
    let divisor = pow(10.0, Double(places))
    
    return (self * divisor).rounded() / divisor
    
  }
  
}

extension Date {
    
    func currentTimeInMiliseconds() -> Int64! {
        let currentDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let date = dateFormatter.date(from: dateFormatter.string(from: currentDate as Date))
        let nowDouble = date!.timeIntervalSince1970
        return Int64(nowDouble*1000)
    }
    
  var millisecondsSince1970:Int64 {
    
    return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    
  }
  //Milisec to Data
  init(milliseconds:Int) {
    
    self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    
  }
  
}

extension UIButton {
  public func addBotomShadow() {
    //self.backgroundColor
  }
}

///text field with no copy paste and select
class textFieldWithNoCopyPasteSelect : DesignableUITextField {
  override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    if action == #selector(select(_:)) {
      return false
    }
    if action == #selector(selectAll(_:)) {
      return false
    }
    if action == #selector(paste(_:)) {
      return false
    }
    return super.canPerformAction(action, withSender: sender)
  }
}
//for shaking
extension UIView {
  
  func show(){
    //DispatchQueue.main.async {
      self.isHidden = false
    //}
  }
  func hide () {
    //DispatchQueue.main.sync {
      self.isHidden = true
    //}
  }
  public func makeRound() {
    DispatchQueue.main.async {
      let width = self.frame.width
      self.layer.cornerRadius = width / 2
      self.clipsToBounds = true
    }
    
  }
  
  func shake() {
    let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    animation.duration = 0.6
    animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
    layer.add(animation, forKey: "shake")
  }
  public func makeRedAndRound() {
    
    self.addBorderWithColorAndWidth()
    self.makeCornersRound()
    
  }
  
  public func addBorderWithColorAndWidth(color:CGColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), width: Int = 2) {
    
    DispatchQueue.main.async {
      self.layer.borderWidth = CGFloat(width)
      self.layer.borderColor = color
    }
    
  }
  public func makeCornersRound () {
    self.layer.cornerRadius = 8
    self.clipsToBounds = true
  }
  public func fadeIn(alpha: CGFloat = 1 ) {
    DispatchQueue.main.async {
      self.alpha = alpha
    }
  }
  public func fadeOut(alpha: CGFloat = 0) {
    DispatchQueue.main.async {
      self.alpha = alpha
    }
  }
  
  // OUTPUT 1
  func addDropShadow1(scale: Bool = true) {
    self.layer.masksToBounds = false
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOpacity = 0.5
    self.layer.shadowOffset = CGSize(width: -1, height: 1)
    self.layer.shadowRadius = 3
    
    self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    self.layer.shouldRasterize = true
    self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
  
  // OUTPUT 2
  func addDropShadow2(color: UIColor = UIColor.black, opacity: Float = 0.5, offSet: CGSize =  CGSize(width: -1, height: 1), radius: CGFloat = 3, scale: Bool = true) {
    self.layer.masksToBounds = false
    //black shadow color
    self.layer.shadowColor = #colorLiteral(red: 0.8078431373, green: 0.1098039216, blue: 0.137254902, alpha: 1)
    //0.5
    self.layer.shadowOpacity = opacity
    self.layer.shadowOffset = offSet
    self.layer.shadowRadius = radius
    
    self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    self.layer.shouldRasterize = true
    self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
  
  
  
}

extension Date {
  
  public func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
    
    let currentCalendar = Calendar.current
    
    guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
    guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
    
    return end - start
  }
  
}

extension UIViewController {
  
  func showToast(message : String) {
    let width :CGFloat = 250
    let font = UIFont.boldSystemFont(ofSize: 18)
    let height = message.height(withConstrainedWidth: width, font: font)
    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 125, y: self.view.frame.size.height-150, width: 250, height: height))
    //toastLabel.center = self.view.center
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.textAlignment = .center;
    toastLabel.font = font
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
      toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
      toastLabel.removeFromSuperview()
    })
  }
  
}
let gifNames :[String] =  ["red" , "rediphone5"]

extension UIImageView {
  
    
    func hideview() {
         DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.superview?.isHidden = true
            
        }
    }
  func toggleRotateAndDisplayGif ()
  {
    if self.isHidden == true {
        self.image = nil
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        let randNumber = arc4random_uniform(5) + 1
        let nextGifName : String
        
            nextGifName = gifNames[0]
       
        
        self.loadGif(name: nextGifName)
        
    }
    }
    
}

func getCurrentServerTime( completion: @escaping (Bool, Double) ->()  ) {
  let dbRef = FirebaseDB.shared.dbRef
  let timeStamp = ServerValue.timestamp()
  dbRef.child("timeStamp").setValue(timeStamp)
  //print(timeStamp.values.count)
  dbRef.child("timeStamp").observeSingleEvent(of: .value, with: { (timeStampSnap) in
    if let time = timeStampSnap.value as? TimeInterval {
      //print(Date(timeInterval: time/1000, since: ))
      //print(Date(milliseconds: Int(time)))
      completion(true, time)
    }
    
  }) { (error) in
    completion(false, -1)
  }
  
}

extension String {
  func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
    
    return ceil(boundingBox.height)
  }
  
  func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
    
    return ceil(boundingBox.width)
  }
}

extension UITableView {
  func reloadUsingDispatch() {
    DispatchQueue.main.async {
      self.reloadData()
    }
  }
}


extension UICollectionView {
  func reloadUsingDispatch() {
    DispatchQueue.main.async {
      self.reloadData()
    }
  }
}

extension UIViewController {
  func addInviteBarButtonToTop() {
    let barButton = UIBarButtonItem(title: "Invite", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.inviteBarBtnTapped))
    barButton.tintColor = UIColor.white
    self.navigationItem.rightBarButtonItem = barButton
  }
    
    func addLeftHomeBarButtonToTop() {
        
        let button = UIButton.init(type: .custom)
        button.setImage( #imageLiteral(resourceName: "Home32")  , for: UIControlState.normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20) //CGRectMake(0, 0, 30, 30)
        button.addTarget(self, action: #selector(homeTap), for: .touchUpInside)
        let barButton = UIBarButtonItem.init(customView: button)
        
        barButton.image = UIImage(named: "Home32")
        self.navigationItem.rightBarButtonItem = barButton
    }
    
  @objc func inviteBarBtnTapped(_ sender: UIButton) {
    let items =  [shareString, urlAppStore] as [ Any ]
    let activityVC = UIActivityViewController(activityItems: items , applicationActivities: [])
    activityVC.popoverPresentationController?.sourceView = sender
    self.present(activityVC, animated:true , completion: nil)
  }
    
    @objc func homeTap() {
        print("alialialiali")
        self.tabBarController?.selectedIndex = 0 
    }
}




func imageWithImage (sourceImage:UIImage, scaledToWidth: CGFloat) -> UIImage {
  let oldWidth = sourceImage.size.width
  
  let scaleFactor = ( scaledToWidth / oldWidth ) + (UIDevice.isPad ? 0 : 0.1)
  
  let newHeight = sourceImage.size.height * scaleFactor
  let newWidth = oldWidth * scaleFactor
  
  UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
  sourceImage.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
  let newImage = UIGraphicsGetImageFromCurrentImageContext()
  UIGraphicsEndImageContext()
  return newImage!
}
