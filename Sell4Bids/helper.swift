//
//  helper.swift
//  Sell4Bids
//
//  Created by Irfan on 11/1/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import Firebase
var myUniversalID = ""

typealias getDataCompletion = (Bool, ProductModel?) -> ()
func getProductData(for product: ProductModel, completion : @escaping getDataCompletion) {
  let cat = product.categoryName!, auction = product.auctionType!, state = product.state!, id = product.productKey!
  var ref = FirebaseDB.shared.dbRef.child(DB_Names.products).child(cat).child(auction)
  ref = ref.child(state).child(id)
  
  ref.observeSingleEvent(of: .value) { (productSnapShot) in
    guard let snapValue = productSnapShot.value as? [String:Any] else {
      completion(false, nil )
      return
    }
    let productObj = ProductModel.init(categoryName: cat, auctionType: auction, prodKey: id, productDict: snapValue)
    debugPrint(productObj)
    completion(true, productObj)
  }
}

func getLoggedInUserID(completion: @escaping(_ result: String,_ staus:Bool)->()){
    
    if let id = Auth.auth().currentUser?.uid{
        myUniversalID = id
        completion(id, true)
    }
    else{
        completion("", false)
    }
}

func getStoryBoardByName ( _ name : String) -> UIStoryboard {
  let storyBoard = UIStoryboard.init(name: name, bundle: nil)
  return storyBoard
}
func writeTime(id : String){
    
    let ref = FirebaseDB.shared.dbRef.child("users").child(id)
    let dic = ["startTime":ServerValue.timestamp()]
    ref.updateChildValues(dic)
    
}

func isEmailValid (text: String ) -> Bool {
  let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
  
  let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
  return emailTest.evaluate(with: text)

}

func getImageFromURLAsync(_ urlStr:String, completion: @escaping (UIImage) -> () ) {
    if let url: URL = URL(string: urlStr){
        let session = URLSession.shared
        session.dataTask(with: url) {
            (data, response, error) in
            if(data != nil){
                let image = UIImage(data: data!)
                if(image != nil){
                    completion(image!)
                    
                }else {
                    //image == nil
                    let image = UIImage(named: "emptyImage")
                    completion(image!)
                }
            }else{
                print("Data == nil in getImageFromURLAsync.swift")
                //error
                let image = UIImage(named: "emptyImage")
                completion(image!)
            }
            }.resume()
    }
    else{
        //print("url could not be unwrapped in getImage FromURLAsync.swift")
        
        
    }
}

func getProductReference(productModel : ProductModel) -> (Bool, DatabaseReference ) {
  
  let productData = productModel
  var prodRef  = Database.database().reference().child("TempNode")
  guard let state = productData.state else{
    return (false, prodRef)
  }
  
  guard let auctionType = productData.auctionType else{
    return (false, prodRef)
  }
  
  guard let productID = productData.productKey else{
    return (false, prodRef)
  }
  
  guard let category = productData.categoryName else{
    return (false, prodRef)
  }
  
  prodRef = Database.database().reference().child("products").child(category).child(auctionType).child(state).child(productID)
  
  return (true, prodRef)
}

///converts the time stamp value to "Just Now", OR "3 secs ago", etc
func convertTimeStampToString(time: Int64) -> String{
  var str: String = ""
  var t = time/1000
  
  if t <= 0{
    str = "Just Now"
    return str
  }
  else if  t > 0 && t <= 59{
    // t = Int(Double(t).rounded(toPlaces: 1))
    str = "\(t)" + " secs ago."
    return str
  }
  else if t>59 && t < 3600{
    
    t = t/60
    //t = Double(t).rounded(toPlaces: 1)
    str = "\(t)"+" mints ago."
    return str
  }
  else if t > 3600{
    var d = Int(t)
    d = d/3600
    //  d = Double(d).rounded(toPlaces: 1)
    let hourString :String = d > 1 ? "hours" : "hour"
    str = "\(d)"+" \(hourString) ago."
    if d > 24{
      
      d = d/24
      
      if d >= 30{
        d = d/30
        // d = Double(d).rounded(toPlaces: 1)
        str = "\(d)"+" months ago"
        
        if d >= 12
        {
          d = d/12
          // d = Double(d).rounded(toPlaces: 1)
          str = "\(d)"+" years ago"
          return str
        }
        return str
        
      }
      // d = Double(d).rounded(toPlaces: 1)
      str = "\(d)"+" days ago"
      return str
    }
    return str
  }
  else
  {
    return ""
  }
}

extension ProductModel  {
  /// if cat, auction, state and key are not null, return true, else false
  func isDataValid() -> Bool {
    guard let _ = self.categoryName, let _  = self.auctionType, let _ = state, let _ = productKey else {
      return false
    }
    return true
  }
}

import IQKeyboardManagerSwift
func enableIQKeyBoardManager(flag : Bool = true) {
  IQKeyboardManager.shared.enable = flag
  IQKeyboardManager.shared.enableAutoToolbar = flag
}
