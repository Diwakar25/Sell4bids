//
//  EditUserProfileVc.swift
//  Sell4Bids
//
//  Created by admin on 10/20/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
class EditUserProfileVc: UIViewController,UITextFieldDelegate {
  
  //Mark: - Properties
  @IBOutlet weak var NameTextField: UITextField!
  @IBOutlet weak var zipTextField: UITextField!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var ziplabel: UILabel!
  @IBOutlet weak var updateButton: UIButton!
  @IBOutlet weak var nameBelowView: UIView!
  @IBOutlet weak var zipCodeBelowView: UIView!
  @IBOutlet weak var imgVFidget: UIImageView!
  var userData:UserModel?
  var imageUrl = String()
  
  //Mark: - Variables
  var dbRef:DatabaseReference!
   
    @IBAction func Dissmiss_Keyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
  override func viewDidLoad() {
    
    super.viewDidLoad()
    navigationItem.title = "Edit Profile"
    if (defaults.value(forKey: "FullName")) != nil {
        let FullName = defaults.value(forKey: "FullName") as? String
        self.NameTextField.text = FullName
        
    }
    
    if (defaults.value(forKey: "ZipCode")) != nil {
        
        let ZipCode = defaults.value(forKey: "ZipCode") as? String
        self.zipTextField.text = ZipCode
        
        
    }
    dbRef = FirebaseDB.shared.dbRef
    // UpdateUservalues()
    zipTextField.keyboardType = UIKeyboardType.numberPad
    
    setupViews()
    
  }
  
  
  private func setupViews() {
  
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
//    if textField == NameTextField{
//
//      if ziplabel.isHidden == false{
//        ziplabel.isHidden = true
//        ziplabel.tintColor = UIColor.gray
//        ziplabel.backgroundColor = UIColor.gray
//      }
//
//      self.NameTextField.tintColor = UIColor.red
//      self.nameBelowView.backgroundColor = UIColor.red
//      self.nameBelowView.fadeIn()
//      self.nameLabel.fadeIn()
//
//
//
//    }
//
//    if textField == zipTextField {
//      if nameLabel.isHidden == false{
//        NameTextField.tintColor = UIColor.gray
//        nameLabel.isHidden = true
//        nameBelowView.backgroundColor = UIColor.gray
//      }
//
//      zipTextField.tintColor = UIColor.red
//      self.zipCodeBelowView.backgroundColor = UIColor.red
//      self.zipCodeBelowView.fadeIn()
//      self.ziplabel.fadeIn()
//      textField.placeholder = ""
//
//
//    }
//
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    
//    if textField == NameTextField{
//      self.nameBelowView.backgroundColor = UIColor.gray
//      self.nameLabel.isHidden = true
//      textField.placeholder = "Name"
//      // self.emailBelowLabel.fadeOut()
//
//    }
//    else if textField == zipTextField{
//
//
//      self.zipCodeBelowView.backgroundColor = UIColor.gray
//      self.ziplabel.isHidden = true
//      textField.placeholder = "Zip Code"
//      // self.passwordBelowLabel.fadeOut()
//    }
    
  }
//  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//    if let touch = touches.first{
//
//      if touch.view !=  NameTextField{
//        self.nameLabel.isHidden = true
//        NameTextField.tintColor = UIColor.black
//        self.nameBelowView.backgroundColor = UIColor.gray
//        if NameTextField.isFirstResponder{
//          NameTextField.resignFirstResponder()
//        }
//      }
//      if touch.view !=  zipTextField{
//        zipTextField.tintColor = UIColor.black
//        self.ziplabel.isHidden = true
//        self.ziplabel.backgroundColor = UIColor.gray
//        if zipTextField.isFirstResponder{
//          zipTextField.resignFirstResponder()
//        }
//      }
//    }
//  }
  func UpdateUservalues() {
    let currentUid = Auth.auth().currentUser?.uid
    let ref  = self.dbRef.child("users").child(currentUid!)
    
    
    if NameTextField.text != "" {
      if let name = NameTextField.text?.count, name >= 4{
        
        if zipTextField.text != ""{
          if zipTextField.text?.count == 5{
            
            let zipCode = zipTextField.text
            let str = "http://ziptasticapi.com/" + zipCode!
            let u = URL(string: str)
            
            
            imgVFidget.toggleRotateAndDisplayGif()
            Alamofire.request(u!).responseJSON { (response) in
              print(response)
              
              DispatchQueue.main.async {
                self.imgVFidget.isHidden = true
              }
              if response.error != nil{
                print("ERROR: \(String(describing: response.error))")
              }
              else{
                let data = response.result.value as! NSDictionary
                if let city = data.value(forKey: "city"){
                  let cityString = "\(city)".lowercased().capitalizingFirstLetter()
                  if let state = data.value(forKey: "state") {
                    print(state)
                    ref.child("name").setValue(self.NameTextField.text)
                    ref.child("city").setValue(cityString)
                    ref.child("state").setValue("\(state)")
                    ref.child("zipCode").setValue(self.zipTextField.text)
//                    showSwiftMessageWithParams(theme: .success, title: "Pofile Updated Successfully", body: "Your profile has been updated successfully")
                    showSwiftMessageWithParams(theme: .success, title: "Profile Updated Successfully", body: "Your profile has been updated successfully", durationSecs: 15, layout: .cardView, position: .center, completion: { (completed) in
                        if completed {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    })
                  }
                }
                else{
                  self.alert(message: "No such location exits", title: "ERROR")
                  
                  return
                }
                
                print(data)
              }
            }
            
            
            
          }else {
            self.alert(message: "Zip Code must have 5 numbers", title: "Edit Profie")
          }
        }
        else{
          self.alert(message: "Zip Codd is Required ", title: "Edit Profile")
        }
        
      }else {
        self.alert(message: "Name must atleast 4 characters Long", title: "Edit profile")
      }
    }
    else {
      
      self.alert(message: "Name is Required.", title: "Edit Profile")
    }
    
  }
  
  @IBAction func updateButtonTapped(_ sender: UIButton) {
    
    UpdateUservalues()
    
  }
  
  
}
