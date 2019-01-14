//
//  SendCounterOfferPopUp.swift
//  Sell4Bids
//
//  Created by admin on 1/20/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
class SendCounterOfferPopUp: UIViewController {
  //MARK:- Properties
  
  @IBOutlet weak var offerAmountTextField: UITextField!
  @IBOutlet weak var quantityTextField: UITextField!
  @IBOutlet weak var popUpView: UIView!
  @IBOutlet weak var sendOfferBtn: UIButton!
  @IBOutlet weak var crossButton: UIButton!
  
  //MARK:- Variables
  var productRef: DatabaseReference!
  var productData: ProductModel!
  var orderData:OrderModel!
  var CounterOfferArray = [CounterModel]()
  override func viewDidLoad() {
    super.viewDidLoad()
    CounterOfferArray.removeAll()
    setupViews()
    
    
  }
  
  private func setupViews() {
    
    popUpView.addShadowAndRound()
    offerAmountTextField.makeRedAndRound()
    quantityTextField.makeRedAndRound()
    sendOfferBtn.addShadowAndRound()
    crossButton.makeRound()
    
  }
  private func sendCounterOffer() {
    
    //validiation
    performValidation { (success, offerAmount, quantity) in
       CounterOfferArray.removeAll()
        print("")
        if success {
        
        let dbRef = Database.database().reference()
        guard let categoryName = productData.categoryName ,
          let auctionType = productData.auctionType,
          let stateName = productData.state,
          let productKey = productData.productKey else {
            
            print("Error. Could not get product data in \(self). Going to return")
            return
            
        }
        dbRef.child("products").child(categoryName).child(auctionType).child(stateName).child(productKey).observeSingleEvent(of: .value) { (snapshot) in
          
          if snapshot.childrenCount > 0 {
            //let userId = snapshot.key
            guard let productDict = snapshot.value as? [String:AnyObject] else {
              print("guard let productDict = snapshot.value as? [String:AnyObject] failed in self")
              return
            }
            //already a counter offer is placed
            if let counterOffers = productDict["counterOffers"] as? [String:AnyObject]  {
              guard  let buyerID = self.orderData.uid else {
                print("guard  let buyerID = orderData.uid failed in \(self)")
                return
              }
              if counterOffers.keys.contains(buyerID) {
                
                guard let counterOfferForBuyer = counterOffers[buyerID] as? [String:AnyObject] else {
                  print("guard let counterOfferForBuyer = counterOffers[buyerID] as? [String:AnyObject] failed in \(self). Going to return")
                  return
                }
                let counterOffer = CounterModel.init(userId: buyerID , counterDict: counterOfferForBuyer)
                //change for testing.
                if counterOffer.counterCount < 20 {
                  self.CounterOfferArray.append(counterOffer)
                  
                  var messageStr = "Are you sure you want to send Counter Offer at "
                    messageStr.append("\((self.productData.currency_symbol ?? "$"))\(offerAmount) ( \((self.productData.currency_symbol ?? "$"))\(offerAmount) x \(quantity) ) ?")
                  let alert = UIAlertController(title: "Counter Offer", message: messageStr, preferredStyle: .alert)
                  alert.addAction(UIAlertAction(title: "Later", style: .default, handler: nil))
                  alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    print("Going to Write the counter offer in Database")
                    //update the count of counter offer
                    let dictCounterOffer = ["counterOfferCount": "\(counterOffer.counterCount + 1)",
                      "pricePerItem": "\(offerAmount)",
                      "quantity": "\(quantity)" ]
                    
                    dbRef.child("products").child(categoryName).child(auctionType).child(stateName).child(productKey).child("counterOffers").child(buyerID).setValue(dictCounterOffer)
                    let currentCount = counterOffer.counterCount + 1
                    //self.alert(message: "Counter offer ( \(currentCount)/5 ) sent to buyer.")
                    let alertInner = UIAlertController(title: "Counter Offer Sent", message: "Counter offer ( \(currentCount)/5 ) sent to buyer.", preferredStyle: .alert)
                    alertInner.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                      self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alertInner, animated: true, completion: nil)
                  }))
                  self.present(alert, animated: true, completion: nil)
                  
                }else {
                  //alert already 5 offers sent
                  self.alert(message: "You have already sent 5 counter offers.")
                }
              }//end if counterOffers.keys.contains(buyerID) {
              else {
                //A counter offer has not been sent to this buyer before
                let counterOfferForBuyer = ["counterOfferCount": "\(1)",
                  "pricePerItem": "\(offerAmount)",
                  "quantity": "\(quantity)" ]
                dbRef.child("products").child(categoryName).child(auctionType).child(stateName).child(productKey).child("counterOffers").child(buyerID).setValue(counterOfferForBuyer)
                
              }
              
              
              
            }//end if let counterOffers = productDict["counterOffers"] as? [String:AnyObject]
            else {
              //no previousl applied counter offers found
              var messageStr = "Are you sure you want to send Counter Offer at "
                messageStr.append("\((self.productData.currency_symbol ?? "$"))\(offerAmount) ( \((self.productData.currency_symbol ?? "$"))\(offerAmount) x \(quantity) ) ?")
              let alert = UIAlertController(title: "Counter Offer", message: messageStr, preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "Later", style: .default, handler: nil))
              alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                print("Going to Write the counter offer in Database")
                //update the count of counter offer
                let dictCounterOffer = ["counterOfferCount": "1",
                                        "pricePerItem": "\(offerAmount)",
                                        "quantity": "\(quantity)" ]
                
                if let buyerId = self.orderData.uid {
                  dbRef.child("products").child(categoryName).child(auctionType).child(stateName).child(productKey).child("counterOffers").setValue([buyerId : dictCounterOffer])
                  let currentCount =  1
                  //self.alert(message: "Counter offer ( \(currentCount)/5 ) sent to buyer.")
                  let alertInner = UIAlertController(title: "Counter Offer Sent", message: "Counter offer ( \(currentCount)/5 ) sent to buyer.", preferredStyle: .alert)
                  alertInner.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                  }))
                  self.present(alertInner, animated: true, completion: nil)
                  
                }//if let buyerId = self.orderData.uid
                else {
                  self.alert(message: .strInternalErrorOccured + " Hint: Could not get Order Data")
                }
                
               
              }))
              self.present(alert, animated: true, completion: nil)
              
              
            }
            
            
            
            
          }
        }
        
      }
    }
    
    
    
  }
  
  private func performValidation( completion: (Bool, Int, Int) ->() ) {
    
    let quantity:Int? = Int(quantityTextField.text!)
    let boughtquantity :Int? = Int(orderData.boughtQuantity!)
    if (offerAmountTextField.text?.isEmpty)! {
      self.alert(message: "Please enter price per item to continue.")
      completion(false, -1, -1 )
    }
    else if (quantityTextField.text?.isEmpty)! {
      self.alert(message: "Please enter quantity to continue")
      completion(false, -1, -1 )
    }else if (quantity!  > boughtquantity! ) {
        
        self.alert(message: "Please enter right quantity")
        completion(false, -1, -1 )
        
    }
    else {
        let offerAmountPerItem = offerAmountTextField.text!.replacingOccurrences(of: "\((self.productData.currency_symbol ?? "$"))", with: "")
      //offer Amount includes $ sign.
      let quantity = quantityTextField.text!
      if let offerAmountInt = Int(offerAmountPerItem), let quantityInt = Int(quantity) {
        completion(true, offerAmountInt, quantityInt)
      }else {
        completion(false, -1, -1)
      }
      
    }
  }
  
  //MARK:- Actions
  @IBAction func closeBtnTapped(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func SendOfferBtnTapped(_ sender: Any) {
    sendCounterOffer()
  }
  
  @IBAction func sendOfferTFeditingChanged(_ sender: UITextField) {
    
    if !(sender.text?.isEmpty)! {
      let text = sender.text!
        if !text.contains("\((self.productData.currency_symbol ?? "$"))") {
        DispatchQueue.main.async {
          sender.text = "\((self.productData.currency_symbol ?? "$"))" + text
        }
      }
      
    }
  }
  
  
}

