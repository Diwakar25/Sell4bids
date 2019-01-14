//
//  OfferPopUpViewController.swift
//  Sell4Bids
//
//  Created by H.M.Ali on 10/26/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import Alamofire
import SwiftMessages

class OfferPopUpVc: UIViewController,UITextFieldDelegate {
  //MARK:- Properties
  @IBOutlet weak var offerAmountLabel: UILabel!
  @IBOutlet weak var quantityLabel: UILabel!
  @IBOutlet weak var offerAmountTextField: UITextField!
  @IBOutlet weak var quantityTextField: UITextField!
  @IBOutlet weak var popUpView: UIView!
  @IBOutlet weak var sendOfferBtn: UIButton!
  //MARK:- Variables
  var isOffer = false
  var constraint = NSLayoutConstraint()
  var userAndProductData = [String:Any]()
  var isBid = false
  var product: ProductModel!
  var myID = ""
  var startPrice = 0
  var temp = [String:Any]()
  var isFirstTime = true
  var apiKey = "qwerty"
  var mySellingActivities = ""
  var myBuyingActivities = ""
  var dbRef: DatabaseReference!
  var isOrder = false
  ///viewSendBuyNowOffer
  @IBOutlet weak var viewSendBuyNowOffer: UIView!
  @IBOutlet weak var tfQuantityBuyNow: UITextField!
  @IBOutlet weak var btnSendOrderBuyNow: UIButton!
  @IBOutlet weak var viewSendBuyNowOrder: UIView!
  @IBOutlet weak var btnClosePopup: UIButton!
  override func viewDidLoad() {
    
    super.viewDidLoad()
    setupViews()
    quantityTextField.delegate = self
    offerAmountTextField.delegate = self
    getBuyingSellingStatus()
    setupAppropriateViews()
    self.myID = (Auth.auth().currentUser?.uid)!
  }
  private func setupAppropriateViews () {
    if isOffer {
      DispatchQueue.main.async {
        self.viewSendBuyNowOffer.isHidden = false
        self.viewSendBuyNowOrder.isHidden = true
        DispatchQueue.main.async {
          self.offerAmountTextField.becomeFirstResponder()
        }
      }
    }
    else if isOrder {
      DispatchQueue.main.async {
        self.viewSendBuyNowOrder.isHidden = false
        self.viewSendBuyNowOffer.isHidden = true
        DispatchQueue.main.async {
          self.tfQuantityBuyNow.becomeFirstResponder()
        }
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    dbRef = Database.database().reference()
    if isFirstTime == false && isBid == true{
      let ref = Database.database().reference().child("products").child(self.temp["type"] as! String).child(self.temp["state"] as! String).child(self.temp["pId"] as! String).child("bids").child("startPrice")
      var tem = ""
      ref.observeSingleEvent(of: .value) { (snapshot) in
        tem = snapshot.value as! String
      }
      if tem != ""{
        myID = tem
      }
    }
  }
  
  //MARK:-  Helper functions
  private func setupViews() {
    
    offerAmountTextField.makeRedAndRound()
    quantityTextField.makeRedAndRound()
    sendOfferBtn.makeCornersRound()
    btnClosePopup.makeRound()
    tfQuantityBuyNow.makeRedAndRound()
    btnSendOrderBuyNow.addShadowAndRound()
    self.view.addShadowAndRound()
    
  }
  ///gets buying selling config setting of a user from database and sets self variables
  private func getBuyingSellingStatus() {
    self.getBuyingSellingStatus(myID: SessionManager.shared.userId) { (selling, buying, status) in
      if status == true{
        
        if selling != nil{
          self.mySellingActivities = selling!
        }
        else{
          self.mySellingActivities = "on"
        }
        if buying != nil{
          
          self.myBuyingActivities = buying!
          
        }
        else{
          self.myBuyingActivities = "on"
        }
      }
    }
  }
  
  //MARK:-  IBActions and user Interaction
  
  @IBAction func btnClosePopupTapped(_ sender: UIButton) {
    if let parent = self.parent as? ProductDetailVc {
      DispatchQueue.main.async {
        self.view.endEditing(true)
      }
      parent.contSendBuyItNowOfferOrOrder.isHidden = true
      parent.dimBackground(flag: false  )
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first
    if touch?.view == popUpView {
      DispatchQueue.main.async {
        self.view.endEditing(true)
        self.resignFirstResponder()
      }
    }
  }
  var userName = ""
  ///send offer button action
  @IBAction func sendOfferBtnAction(_ sender: UIButton) {
    isFirstTime = false
    var endTime:Int64 = 0
    
    if self.userAndProductData["endTime"] != nil {
      endTime = self.userAndProductData["endTime"] as! Int64
      
    }
        
   
    else{
      self.alert(message: "Time is nil", title: "ERROR")
      return
    }
    var time:Int64 = 0
    
    let dic = ["temporaryTimeStamp":ServerValue.timestamp()]
    dbRef.updateChildValues(dic)
    
    dbRef.child("temporaryTimeStamp").observeSingleEvent(of: .value, with: { (snapshot) in
      time = snapshot.value as! Int64
      //time remaining ?
      if endTime >= time || endTime == -1{
        if let userId = self.userAndProductData["myId"] as? String, let productId = self.userAndProductData["productId"] as? String{
          let UserRef = self.dbRef.child("users").child(userId).child("name")
          var myName = ""
          UserRef.observeSingleEvent(of: .value, with: { (snapshot) in
            myName = snapshot.value as! String
            self.userName = myName
            let categoryName = self.userAndProductData["category"] as! String
            let auctionType = self.userAndProductData["auctionType"] as! String
            let stateName = self.userAndProductData["state"] as! String
            let productKey = self.userAndProductData["productId"] as! String
            let productRef = self.dbRef.child("products").child(categoryName).child(auctionType).child(stateName).child(productKey).child("orders").child(userId)
            let userBuyingRef = self.dbRef.child("users").child(userId).child("products").child("buying").child(productId)
            
            //checking if isOffer else  buy-it-now
            
            if self.isOffer == true{
              guard !(self.offerAmountTextField.text?.isEmpty)! else{
                let title = "Buy Now"
                let message = "Please enter Price per item to Continue"
                self.offerAmountTextField.shake()
                showSwiftMessageWithParams(theme: .error, title: title, body: message)
                return
              }
              
              guard !(self.quantityTextField.text?.isEmpty)! else{
                let mess = "Please enter quantity to Continue"
                let title = "Buy Now"
                self.quantityTextField.shake()
                showSwiftMessageWithParams(theme: .error, title: title, body: mess)
                return
              }
              let quantity = self.quantityTextField.text!
              let intQuantity = (quantity as NSString).floatValue
              
              var price = self.offerAmountTextField.text!
              if price.contains("\((selectedProduct?.currency_symbol ?? "$"))"){
                price = price.replacingOccurrences(of: "\((selectedProduct?.currency_symbol ?? "$"))", with: "")
                
              }
              
              guard let intPrice = Float(price) else { return }
              
              
              
                let alert = UIAlertController(title: "Buy Now", message: "Are you sure you want to send your Buy Now offer for \((selectedProduct!.currency_symbol ?? "$"))\(intQuantity * intPrice ) ( \((selectedProduct!.currency_symbol ?? "$"))\(intPrice) X \(intQuantity) )?", preferredStyle: .alert)
              
              let actionYes = UIAlertAction(title: "Yes", style: .default, handler: { (yesAction) in
                handleYesAction()
              })
              let actionLater = UIAlertAction(title: "Later", style: UIAlertActionStyle.cancel)
              alert.addAction(actionYes)
              alert.addAction(actionLater)
              self.present(alert, animated: true, completion: nil)
              
              
              func handleYesAction() {
                
                if intQuantity <= 0 {
                  showSwiftMessageWithParams(theme: .error, title: "", body: "Please enter valid Quantity")
                  return
                }
                
                if let originalQuantity = self.userAndProductData["quantity"] as? Int {
                  
                    if originalQuantity < Int(intQuantity){
                    //self.showAlert(title: "Quantity ERROR", message: "You can't place order mare than "+"\(originalQuantity)"+" items")
                    let mess = "Not enough stock available. Only \(originalQuantity) items are in stock"
                    
                    showSwiftMessageWithParams(theme: .error, title: "Buy Now", body: mess)
                    return
                  }
                  
                }//end if let originalQuantity = self.previousData["quantity"] as? Int
                else{
                  self.alert(message: "No Quantity found", title: "ERROR")
                  return
                }
                
                if intPrice <= 0 {
                  showSwiftMessageWithParams(theme: .error, title: "", body: "Please enter valid Amount")
                  return
                }
                
                if self.userAndProductData["price"] != nil {
                  if let parent = self.parent as? ProductDetailVc {
                    DispatchQueue.main.async {
                      parent.dimBackground(flag: false)
                      parent.contSendBuyItNowOfferOrOrder.isHidden = true
                      self.view.endEditing(true)
                      parent.view.endEditing(true)
                    }
                    
                  }
                  let value = ["boughtPrice":price as String,"boughtQuantity":quantity as String,"uid":userId ,"name":myName] as [String : Any]
                  //update product  - orders. set a new order details for key userID
                  productRef.updateChildValues(value)
                  
                  //update buying node of user in users -> products -> buying
                  let val = ["auctionType":"buy-it-now","boughtPrice":price as String,"boughtQuantity":quantity ,"category":self.userAndProductData["category"] as! String,"state":self.userAndProductData["state"] as! String] as [String : Any]
                  
                  userBuyingRef.updateChildValues(val)
                  
                  
                  let message = "Your order/offer has been placed. Please wait for the seller to respond. You can also send him/her a personal message for more details about pickup/delivery"
                  showSwiftMessageWithParams(theme: .success, title: "Buy Now", body: message, durationSecs: -1, layout: MessageView.Layout.cardView, position: SwiftMessages.PresentationStyle.center)
                  
                }
              }
              
            }
          })
        }
        
      }
      else{
        
        self.showAlert(title: "Time Passed", message: "Sorry, You missed out on this item")
        return
        
      }
    })
  }
  ///place a buy now order
  @IBAction func btnSendOrderBuyNowTapped(_ sender: UIButton) {
    
    
    
    if let intPrice = self.userAndProductData["price"] as? Int {
      
        if Int(tfQuantityBuyNow.text!)! <= 0 {
            
            showSwiftMessageWithParams(theme: .error, title: "", body: "Enter valid quantity.")
            return
            
        }else {
            
       
      //guard let intPrice = Int(price)
      
      guard !(tfQuantityBuyNow.text?.isEmpty)! else {
        tfQuantityBuyNow.shake()
        let mess = "Please Enter quantity to continue"
        let title = "Buy Now"
        showSwiftMessageWithParams(theme: .error, title: title, body: mess)
        return
      }
      guard let intQuantity = Int(self.tfQuantityBuyNow.text!) else{
        self.alert(message: "No quantity found", title: "ERROR")
        return
      }
      let alert = UIAlertController(title: "Buy Now", message: "Are you sure you want to send your Buy Now order for \((selectedProduct!.currency_symbol ?? "$"))\(intQuantity * intPrice ) ( \((selectedProduct!.currency_symbol ?? "$"))\(intPrice) X \(intQuantity) )", preferredStyle: .alert)
      let actionYes = UIAlertAction(title: "Yes", style: .default, handler: { (yesAction) in
        handleYesAction()
      })
      let actionLater = UIAlertAction(title: "Later", style: .cancel)
      alert.addAction(actionYes)
      alert.addAction(actionLater)
      self.present(alert, animated: true, completion: nil)
      
      func handleYesAction() {
        
        if let originalQuantity = self.userAndProductData["quantity"] as? Int {
          
          if originalQuantity < intQuantity{
            
            let title = "Buy Now"
            let message = "Not enough stock available. Only \(originalQuantity) items are in stock."
            showSwiftMessageWithParams(theme: .error, title: title, body: message)
            return
          }
          
        }
        else{
          self.alert(message: "No Quantity found", title: "ERROR")
          return
          
        }
        
        
        let userId = SessionManager.shared.userId
        guard let price = self.userAndProductData["price"] else{return}
        
        DispatchQueue.main.async {
          self.tfQuantityBuyNow.resignFirstResponder()
          self.view.endEditing(true)
          self.resignFirstResponder()
          
          if let parent = self.parent as? ProductDetailVc {
            parent.contSendBuyItNowOfferOrOrder.isHidden = true
            parent.dimBackground(flag: false)
          }
        }
        
        
        let userName = SessionManager.shared.name
        let newOrder = ["boughtPrice":"\(price)","boughtQuantity":self.tfQuantityBuyNow.text!,"uid":userId ,"name":userName] as [String : Any]
        let productKey = self.userAndProductData["productId"] as! String
        let categoryName = self.userAndProductData["category"] as! String
        let auctionType = self.userAndProductData["auctionType"] as! String
        let stateName = self.userAndProductData["state"] as! String
        
        let productRef = self.dbRef.child("products").child(categoryName).child(auctionType).child(stateName).child(productKey).child("orders").child(userId)
        let userBuyingRef = self.dbRef.child("users").child(userId).child("products").child("buying").child(productKey)
        
        
        productRef.updateChildValues(newOrder, withCompletionBlock: { (error, dbRef) in
          guard error == nil else {
            showSwiftMessageWithParams(theme: .error, title: "Order Not Placed", body: "Sorry, Could not update Database. Try Again later")
            return
          }
        })
        let val = ["auctionType":"buy-it-now","boughtPrice":"\(price)","boughtQuantity":self.quantityTextField.text! ,"category":self.userAndProductData["category"] as! String,"state":self.userAndProductData["state"] as! String] as [String : Any]
        
        userBuyingRef.updateChildValues(val, withCompletionBlock: { (error, dbRef) in
          guard error == nil else {
            showSwiftMessageWithParams(theme: .warning, title: "Data not updated", body: "Sorry, Could not place this product in your Buying Section. Try Again later")
            return
          }
        })
        
        let message = "Your order/offer has been placed. Please wait for the seller to respond. You can also send him/her a personal message for more details about pickup/delivery"
        
        showSwiftMessageWithParams(theme: .success, title: "Buy Now", body: message, durationSecs: -1, layout: .cardView )
        
      }
        }
      
    }else {
      showSwiftMessageWithParams(theme: .error, title: "Internal Error", body: "Sorry, An internal Error Occured. Code : OPVC->BSOBNTapped")
    }
    
  }
   
  @IBAction func closeBtnAction(_ sender: UIButton) {
    isFirstTime = false
    if let prodDetailVC = self.parent as? ProductDetailVc {
      DispatchQueue.main.async {
        prodDetailVC.contSendBuyItNowOfferOrOrder.isHidden = true
        prodDetailVC.dimBackground(flag: false)
        prodDetailVC.resignFirstResponder()
        prodDetailVC.view.endEditing(true)
      }
      
    }
    
  }
  
  var startingPriceCheck = true
    
    
    @IBAction func tfOfferAmountEditingChanging(_ sender: Any) {
      self.offerAmountTextField.text = ""
    }
    
  @IBAction func tfOfferAmountEditingChanged(_ sender: Any) {
    
    if startingPriceCheck{
      let temp = self.offerAmountTextField.text
      if temp?.contains("\((selectedProduct?.currency_symbol ?? "$"))")==false{
        self.offerAmountTextField.text = "\((selectedProduct?.currency_symbol ?? "$"))" + temp!
        startingPriceCheck = true
      }
      else{
        startingPriceCheck = true
      }

    }
    if self.offerAmountTextField.text == ""{
      startingPriceCheck = true
    }
  }

  
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    
    if textField.tag == 4  {
        if (textField.text?.count)! > 8 {
            let maxLength = 8
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        
        
        
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        
        
        
        
        
        
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    if textField.tag == 5  {
        if (textField.text?.count)! > 8 {
            let maxLength = 8
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        
        
        
        let allowedCharacters = CharacterSet.alphanumerics
        let characterSet = CharacterSet(charactersIn: string)
        
        
        
        
        
        
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    if textField.tag == 6 {
        if (textField.text?.count)! > 17 {
            let maxLength = 17
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        
        
        
        let currentText = textField.text ?? ""
        let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        
        
        
        
        
        
        
        return replacementText.isValidDecimal(maximumFractionDigits: 2)
    }
    return true
    }

  
  func showAlert(title: String, message: String)
  {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .default) { (action) in
      self.dismiss(animated: true, completion: nil)
    }
    alert.addAction(ok)
    
    self.present(alert, animated: true, completion: nil)
    
  }
  
  func getBuyingSellingStatus(myID: String, completion: @escaping (_ sellingActivities: String?, _ buyingActivities: String?,_ status: Bool)->()){
    
    let ref = Database.database().reference().child("users").child(SessionManager.shared.userId).child("configs")
    ref.observeSingleEvent(of: .value) { (snapshot) in
      if snapshot.hasChildren(){
        var sellingActivities = "off"
        var buyingActivities = "off"
        
        if let configsValue = snapshot.value as? [String:Any]{
          
          if let selling = configsValue["sellingActivities"] as? String{
            sellingActivities = selling
          }
          if let buying = configsValue["buyingActivities"] as? String{
            buyingActivities = buying
          }
          completion(sellingActivities, buyingActivities, true)
        } // end if let configsValue = snapshot.value as? [String:Any]
        else{
          completion(nil, nil, true)
        }
      }// end if snapshot.hasChildren()
      else{
        
        completion(nil, nil, true)
      }
      
    }
  }
  
}

extension String{
    
    private static let decimalFormatter:NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        return formatter
    }()
    
    private var decimalSeparator:String{
        return String.decimalFormatter.decimalSeparator ?? "."
    }
    
    func isValidDecimal(maximumFractionDigits:Int)->Bool{
        
        // Depends on you if you consider empty string as valid number
        guard self.isEmpty == false else {
            return true
        }
        
        // Check if valid decimal
        if let _ = String.decimalFormatter.number(from: self){
            
            // Get fraction digits part using separator
            let numberComponents = self.components(separatedBy: decimalSeparator)
            let fractionDigits = numberComponents.count == 2 ? numberComponents.last ?? "" : ""
            return fractionDigits.characters.count <= maximumFractionDigits
        }
        
        return false
    }
    
}
