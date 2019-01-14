//
//  ResetPasswordVC.swift
//  socialLogins
//
//  Created by H.M.Ali on 9/27/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordVC: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var emailBelowView: UIView!
  @IBOutlet weak var sendCodeBtn: UIButton!
  // @IBOutlet weak var topBar: UIView!
  
  override func viewWillDisappear(_ animated: Bool) {
    
  }
  override var preferredStatusBarStyle: UIStatusBarStyle{
    return .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = "Forgot Password"
    self.emailBelowView.isHidden = false
    self.emailBelowView.backgroundColor = UIColor.gray
    // self.email.becomeFirstResponder()
    self.email.delegate = self
    self.emailLabel.isHidden = true
    // Do any additional setup after loading the view.
    sendCodeBtn.addDropShadow1()
    sendCodeBtn.makeCornersRound()
    //  self.topBar.backgroundColor = UIColor(hex: "e22127 ")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField == email{
      self.emailBelowView.backgroundColor = UIColor.red
      self.emailLabel.textColor = UIColor.red
      if textField.text == ""{
        
        self.emailLabel.fadeIn()
        self.email.placeholder = ""
        
      }
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField == email{
      
      self.emailBelowView.backgroundColor = UIColor.gray
      self.email.placeholder = "Email"
      self.email.resignFirstResponder()
      if textField.text == ""{
        self.emailLabel.isHidden = true
      }
      else{
        self.emailLabel.textColor = UIColor.gray
      }
      
    }
  }
  
  
  
  @IBAction func sendCodeBtnAction(_ sender: Any) {
    if InternetAvailability.isConnectedToNetwork() == true{
      if let email = email.text{
        if isEmailValid(text: email) {
          Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            
            if let err = error{
              if err.localizedDescription.contains("no user record corresponding to this identifier.") {
                let title = "Forgot Password"
                let mess = "Unable to send reset link to your email, please make sure it is a valid email. If you are not registered with Sell4Bids, Please Sign Up To Continue"
                let alert = UIAlertController(title: title, message: mess, preferredStyle: .alert)
                let actionSignUp = UIAlertAction(title: "Sign Up", style: .default, handler: { (signupAction) in
                  handleSignUpAction()
                })
                let actionLater = UIAlertAction(title: "Later", style: .cancel)
                alert.addAction(actionSignUp)
                alert.addAction(actionLater)
                self.present(alert, animated: true, completion: nil)
              }
              
              func handleSignUpAction() {
                self.navigationController?.popToRootViewController(animated: true)
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "test"), object: nil, userInfo: nil))
              }
              return
              
              
              
            }
            else{
              let title = "Password Assistance"
              let mess = "A reset password email has been sent to your registered email. Please click on the URL to reset your account Password"
              showSwiftMessageWithParams(theme: .success, title: title, body: mess, durationSecs: 7, layout: .cardView, position: .center, completion: { (completed) in
                self.navigationController?.popViewController(animated: true)
              })
              
              //self.performSegue(withIdentifier: "fromForgetToLogin", sender: nil)
            }
            
            
          }
        }else {
          let title = "Password Assistance"
          let message = "Please enter a valid email to continue"
          showSwiftMessageWithParams(theme: .error, title: title, body: message)
          self.email.shake()
        }
        
        
        
      }
    }else{
      self.alert(message: "Make sure your Device is connected to Internet", title: "No Internet Connection")
    }
  }
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first{
      if touch.view != email{
        self.emailBelowView.backgroundColor = UIColor.gray
        self.email.placeholder = "Email"
        self.email.resignFirstResponder()
      }
    }
  }
  
  
  
  
  
  
}
