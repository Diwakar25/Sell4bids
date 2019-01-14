//
//  producDetailPopUpVC.swift
//  Sell4Bids
//
//  Created by H.M.Ali on 11/2/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase

class UpdateProdQuantityPopUpVC: UIViewController,UITextFieldDelegate {
  //MARK:- Properties
  @IBOutlet weak var btnSetQuantity: UIButton!
  weak var delegate: UpdateProdQuantityPopUpVCDelegate!
  @IBOutlet weak var popUpView: UIView!
  @IBOutlet weak var quantityTFO: UITextField!
  //MARK:- Variables
  var previousData = [String:Any]()
  override func viewDidLoad() {
    super.viewDidLoad()
    quantityTFO.delegate = self
    DispatchQueue.main.async {
      self.quantityTFO.becomeFirstResponder()
    }
    // Do any additional setup after loading the view.
    popUpView.layer.cornerRadius = 8
    popUpView.clipsToBounds = true
    quantityTFO.makeRedAndRound()
    btnSetQuantity.addShadowAndRound()
    
  }
  @IBAction func setQuantityBtnAction(_ sender: UIButton) {
    
    guard let category = previousData["category"] as? String else{
      self.alert(message: "No category found", title: "ERROR")
      return
    }
    guard let state = previousData["state"] as? String else{
      self.alert(message: "No state found", title: "ERROR")
      return
    }
    guard let type = previousData["auctionType"] as? String else{
      self.alert(message: "No Auction Type found", title: "ERROR")
      return
    }
    guard let id = previousData["id"] as? String else{
      self.alert(message: "No ID found", title: "ERROR")
      return
    }
    
    guard !(quantityTFO.text?.isEmpty)! else{
      self.alert(message: "Please Enter the quantity", title: "No Quantity")
      return
    }
    let quantity = quantityTFO.text!
    let ref = Database.database().reference().child("products").child(category).child(type).child(state).child(id)
    let dic = ["quantity":quantity]
    ref.updateChildValues(dic)
    
    
    let alert = UIAlertController(title: "Quantity changed", message: "Quantity Updated Successfully", preferredStyle: .alert)
    delegate.quantityUpdated(quantity: quantity)
    let ok = UIAlertAction(title: "OK", style: .default) { (action) in
      self.dismiss(animated: true, completion: nil)
    }
    alert.addAction(ok)
    self.present(alert, animated: true, completion: nil)
    
  }
  
  @IBAction func dismisViewBtnAction(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField == quantityTFO {
      let temp = string
      let allowedCharacters = CharacterSet.decimalDigits
      let characterSet = CharacterSet(charactersIn: temp)
      let result = allowedCharacters.isSuperset(of: characterSet)
      if result == false{
        let alert = UIAlertController(title: "ERROR", message: "Please enter Numbers only", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) in
          //textField.text = "$"
        })
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
      }
      return true
    }
    return true
  }
  
}

protocol  UpdateProdQuantityPopUpVCDelegate : class{
  func quantityUpdated(quantity: String)
}
