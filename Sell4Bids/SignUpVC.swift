//
//  SignUpVC.swift
//  socialLogins
//
//  Created by H.M.Ali on 9/27/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import FirebaseDatabase
import Alamofire

class SignUpVC: UIViewController {
  
  //MARK:- Properties
  weak var delegate : delegateSignUpVC?
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fidgetImageView: UIImageView!
  @IBOutlet weak var topConstraint: NSLayoutConstraint!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var tfName: UITextField!
  @IBOutlet weak var nameBelowView: UIView!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var emailBelowView: UIView!
  @IBOutlet weak var passwordLabel: UILabel!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var passwordBelowView: UIView!
  @IBOutlet weak var signUpBtn: UIButton!
  @IBOutlet weak var loginWitiFbBtn: UIButton!
  @IBOutlet weak var loginWithGoogleBtn: DesignableButton!
  @IBOutlet weak var topBar: UIView!
  @IBOutlet weak var viewHeight: NSLayoutConstraint!
  @IBOutlet var topSpace: UIView!
  @IBOutlet weak var fbIcon: UIImageView!
  @IBOutlet weak var dimView: UIView!
    
    let button = UIButton(type: .custom)
    
    
     let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
  var apiKey = "qwerty"
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @objc func showpass () {
        if password.isSecureTextEntry == true {
            password.isSecureTextEntry = false
            button.setImage(UIImage(named: "eye (1)"), for: .normal)
        } else {
            password.isSecureTextEntry = true
            button.setImage(UIImage(named: "hide (1)"), for: .normal)
        }
        
    }

    
    func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else { return false }
        
        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: testStr)
    }
    
    
    func addLogoWithLeft() {
        
        navigationItem.leftItemsSupplementBackButton = true
        let button = UIButton.init(type: .custom)
        button.setImage( #imageLiteral(resourceName: "hammer_white")  , for: UIControlState.normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItems = [barButton]
    }
 
  //MARK:- View did load
  override func viewDidLoad() {
    super.viewDidLoad()
    button.setImage(UIImage(named: "hide (1)"), for: .normal)
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0)
    button.frame = CGRect(x: CGFloat( 25), y: CGFloat(5), width: CGFloat(15), height: CGFloat(25))
    button.addTarget(self, action: #selector(self.showpass), for: .touchUpInside)
    password.rightView = button
    password.rightViewMode = .unlessEditing
    addLogoWithLeft()
    //addNotObservers()
    setupViews()
  }
  
  //MARK:- Private functions
  private func addNotObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: Notification.Name.UIKeyboardWillShow, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
  }
  
  private func setupViews() {
    
    loginWitiFbBtn.addShadowAndRound()
    loginWithGoogleBtn.addShadowAndRound()
    signUpBtn.addShadowAndRound()
    
    self.navigationItem.title = "Sign Up"
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    nameBelowView.isHidden = false
    passwordBelowView.isHidden = false
    emailBelowView.isHidden = false
    
    nameLabel.isHidden = true
    emailLabel.isHidden = true
    passwordLabel.isHidden = true
    
    tfName.delegate = self
    email.delegate = self
    password.delegate = self
    
    self.emailBelowView.backgroundColor = UIColor.gray
    self.passwordBelowView.backgroundColor = UIColor.gray
    self.nameBelowView.backgroundColor = UIColor.gray
    
    
  }
  
  @objc func handleKeyboardHide(notification: Notification)
  {
    self.topConstraint.constant = 10
    self.fbIcon.isHidden = false
    
  }
  
  @objc func handleKeyboardNotification(notification: Notification){
    
    if let userInfo = notification.userInfo{
      
      let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
      //self.bottomSpace.constant = keyboardFrame.height
      print(password.frame.origin.y)
      print(keyboardFrame.origin.y)
      if (password.frame.origin.y + password.frame.height) > keyboardFrame.origin.y{
        self.fbIcon.isHidden = true
        self.topConstraint.constant = topConstraint.constant - (password.frame.height + 30)
      }
      //  bottomSpaceOfTableView.constant = keyboardFrame.height
      print(keyboardFrame)
      
    }
  }
  
  //MARk:- IBActions and user interaction
  

  
  @IBAction func loginWithFbBtnAction(_ sender: Any) {
    delegate?.btnLoginWithFacebbokTapped()
    self.navigationController?.popViewController(animated: false)
  }
  
  @IBAction func loginWithGoogleBtnAction(_ sender: Any) {
    delegate?.btnLoginWithGoogleTapped()
    self.navigationController?.popViewController(animated: false)
  }
  
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first{
      
      
      if touch.view != tfName {
        self.nameLabel.isHidden = true
        tfName.tintColor = UIColor.gray
        self.nameBelowView.backgroundColor = UIColor.gray
        if tfName.isFirstResponder{
          tfName.resignFirstResponder()
        }
      }
      if touch.view != email{
        email.tintColor = UIColor.gray
        self.emailLabel.isHidden = true
        self.emailBelowView.backgroundColor = UIColor.gray
        if email.isFirstResponder{
          email.resignFirstResponder()
        }
      }
      if touch.view != password{
        password.tintColor = UIColor.gray
        self.passwordLabel.isHidden = true
        self.passwordBelowView.backgroundColor = UIColor.gray
        if password.isFirstResponder{
          password.resignFirstResponder()
        }
      }
    }
  }
  
  
  
  
  @IBAction func signUpWithEmail(_ sender: Any) {
    
    
    if InternetAvailability.isConnectedToNetwork() == true{
      self.signUpWithEmail()
    }
    else{
      self.alert(message: "Make sure your Device is connected to Internet", title: "No Internet Connection")
    }
  }
  
  func signUpWithEmail(){
    guard !(tfName.text?.isEmpty)! else{
      
      let title = "User Registration"
      let message = "Please enter your name to continue"
      showSwiftMessageWithParams(theme: .warning, title: title, body: message, durationSecs: 5, layout: .cardView, position: .top)
      tfName.shake()
      return
    }
    if let mail = email.text{
      if mail != ""{
        if isEmailValid(text: mail) {
          if let pass = password.text{
            if pass != ""
            {
                if isValidPassword(testStr: pass)
                {
              fidgetImageView.toggleRotateAndDisplayGif()
              self.fidgetImageView.isHidden = true
              self.dimView.alpha = 0.3
              
              Auth.auth().createUser(withEmail: mail, password: pass) { (user, error) in
                
                DispatchQueue.main.async {
                  self.fidgetImageView.isHidden = true
                  self.dimView.alpha = 0
                }
                
                if let err =  error?.localizedDescription{
                  
                  showSwiftMessageWithParams(theme: .error, title: "User Registration", body: err)
                  return
                  //print("Error occured: ",error!)
                }else {
                  
                  if user != nil{
                    
                    let currentID = user?.user.uid
                    let ref = FirebaseDB.shared.dbRef.child("users").child(currentID!)
                    let deviceUUID: String = (UIDevice.current.identifierForVendor?.uuidString)!
                    // print(user?.displayName)
                    //print(user?.email)
                    let value = ["email":user?.user.email as Any, "name":self.tfName.text!,"token": deviceUUID, "uid":currentID as Any] as [String:Any]
                    ref.updateChildValues(value)
                    //  self.dismiss(animated: true, completion: nil)
                    
                    DispatchQueue.main.async {
                      self.fidgetImageView.isHidden = true
                      self.dimView.alpha = 0
                    }
                    //let urlStrSendEmail = "https://us-central1-sell4bids-4affe.cloudfunctions.net/sendWelcomeMail"
                    
                    Auth.auth().currentUser?.sendEmailVerification(completion: { (error : Error?) in
                      
                      
                      let title = String.str_AccountActivation
                      if error == nil {
                        
                        let message = String.str_VerEmailSent
                        showSwiftMessageWithParams(theme: .success, title: title, body: message, durationSecs: 5, layout: .cardView, completion: { (complete) in
                          
                          self.performSegue(withIdentifier: "fromSignUpToLogin", sender: self)
                        })
                        
                      }else{
                        let message = String.str_VerEmailNotSent
                        showSwiftMessageWithParams(theme: .error, title: title, body: message)
                      }
                      
                    })
                    //let recepientEmail = (user?.user.email)!
//                    self.sendEmail(url: urlStrSendEmail , recipientEmail: recepientEmail, recipientName: self.tfName.text!, completion: { (success) in
//
//
//                    })
                    
                    
                  }
                  else{
                    
                    self.alert(message: "Please Enter a Valid Email", title: "Invalid Email")
                    return
                    
                  }
                  
                }
                
                
              }
              
                }else {
                    showSwiftMessageWithParams(theme: .warning, title: "User Registration", body: "Password must contain 1 upper case letter , 1 lower case letter and minimum 8 charaters")
                    password.shake()
                }
            }else{
              DispatchQueue.main.async {
                self.fidgetImageView.isHidden = true
                self.dimView.alpha = 0
              }
              showSwiftMessageWithParams(theme: .warning, title: "User Registration", body: "Please enter password to continue")
              password.shake()
            }
            
          }else{
            DispatchQueue.main.async {
              self.fidgetImageView.isHidden = true
              self.dimView.alpha = 0
            }
            
            showSwiftMessageWithParams(theme: .warning, title: "User Registration", body: "Please enter password to continue")
            password.shake()
          }
        }else {
          let title = "Invalid email format "
          let message = "Please enter a valid email to continue"
          showSwiftMessageWithParams(theme: .warning, title: title, body: message)
          self.email.shake()
        }
        
        
        
      }
      else{
        DispatchQueue.main.async {
          self.fidgetImageView.isHidden = true
          self.dimView.alpha = 0
        }
        
        let title = "User Registration"
        let message = "Please enter email Address to Continue"
        showSwiftMessageWithParams(theme: .warning, title: title, body: message)
      }
      
    }
    else{
      DispatchQueue.main.async {
        self.fidgetImageView.isHidden = true
        self.dimView.alpha = 0
      }
      self.alert(message: "Please Enter Email Address", title: "Empty Email")
      
    }
    
    
  }
  
  @IBAction func fromSignUpToLoginBtnAction(_ sender: Any) {
    
    navigationController?.popViewController(animated: true)
    self.performSegue(withIdentifier: "fromSignUpToLogin", sender: nil)
  }
  
  
  func sendEmail(url: String, recipientEmail: String,recipientName: String, completion: @escaping (Bool) -> () ){
    
    let urlComponents = NSURLComponents(string: url)
    urlComponents?.queryItems = [
      URLQueryItem(name: "key", value: self.apiKey),
      
      URLQueryItem(name: "to", value: recipientEmail),
      
      URLQueryItem(name: "receiverName", value: recipientName)
    ]
    
    
    
    Alamofire.request((urlComponents?.url)!).responseJSON(completionHandler: { (response) in
      switch response.result {
      case .success(let value):
        print("Success in Send Email Alamofire request ")
        print("value of send email request \(value)")
        completion(true)
      case .failure(let error):
        print("failure in Send Email Alamofire request")
        debugPrint("error description \(error)")
        completion(false)
      }
      print("response of sending verification email.")
      print(response.result)
    })
    
  }
}
protocol delegateSignUpVC : class {
  func btnLoginWithGoogleTapped()
  func btnLoginWithFacebbokTapped()
}

extension SignUpVC: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField == tfName{
      if passwordLabel.isHidden == false{
        if (password.text?.isEmpty)! {
          passwordLabel.isHidden = true
        }else {
          passwordLabel.isHidden = false
          passwordLabel.textColor = UIColor.gray
        }
        password.tintColor = UIColor.gray
        passwordBelowView.backgroundColor = UIColor.gray
      }
      if emailLabel.isHidden == false{
        if (email.text?.isEmpty)! {
          emailLabel.isHidden = true
        }else {
          emailLabel.isHidden = false
          emailLabel.textColor = UIColor.gray
        }
        email.tintColor = UIColor.gray
        emailBelowView.backgroundColor = UIColor.gray
      }
      self.tfName.tintColor = UIColor.red
      self.nameBelowView.backgroundColor = UIColor.red
      self.nameBelowView.fadeIn()
      self.nameLabel.fadeIn()
      textField.placeholder = ""
    }
    if textField == email{
      if passwordLabel.isHidden == false{
        password.tintColor = UIColor.gray
        if (password.text?.isEmpty)! {
          passwordLabel.isHidden = true
        }else {
          passwordLabel.isHidden = false
          passwordLabel.textColor = UIColor.gray
        }
        passwordBelowView.backgroundColor = UIColor.gray
      }
      if nameLabel.isHidden == false{
        tfName.tintColor = UIColor.gray
        if (tfName.text?.isEmpty)! {
          nameLabel.isHidden = true
        }else {
          nameLabel.isHidden = false
          nameLabel.textColor = UIColor.gray
        }
        
        nameBelowView.backgroundColor = UIColor.gray
      }
      email.tintColor = UIColor.red
      self.emailBelowView.backgroundColor = UIColor.red
      self.emailBelowView.fadeIn()
      self.emailLabel.fadeIn()
      textField.placeholder = ""
      
    }
    if textField == password{
      if nameLabel.isHidden == false{
        if (tfName.text?.isEmpty)! {
          nameLabel.isHidden = true
        }else {
          nameLabel.isHidden = false
          nameLabel.textColor = UIColor.gray
        }
        tfName.tintColor = UIColor.gray
        nameBelowView.backgroundColor = UIColor.gray
      }
      if emailLabel.isHidden == false{
        email.tintColor = UIColor.gray
        if (email.text?.isEmpty)! {
          emailLabel.isHidden = true
        }else {
          emailLabel.isHidden = false
          emailLabel.textColor = UIColor.gray
        }
        
        emailBelowView.backgroundColor = UIColor.gray
      }
      
      password.tintColor = UIColor.red
      self.passwordBelowView.backgroundColor = UIColor.red
      self.passwordLabel.fadeIn()
      self.passwordBelowView.fadeIn()
      textField.placeholder = ""
      
    }
  }
    
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
       
        print("Notification Keyboard == \(textField.isEditing )")
        
       
        if textField.tag == 1 {
           
            if tfName.text!.count < 150 {
                
                if !(tfName.text?.isEmpty)! {
                    
              
            if ((textField.text?.rangeOfCharacter(from: characterset.inverted )) != nil){
                nameLabel.text = "Name only contain alphabets"
                
                
            }
                }else {
                    nameLabel.text = "Name"
                    
                    
                }
           
            } else {
                nameLabel.text = "maximum charaters allowed 150."
                
                
            }
        }
        if textField.tag == 2 {
          //scrollView.setContentOffset(CGPoint(x: 0, y: 20 ), animated: true)
            
            if (email.text?.count)! < 254 {
                
           
            if !(email.text?.isEmpty)! {
                if !isValidEmail(testStr: email.text!) {
                    emailLabel.text = "Invalid Emaild Address"
                   
                   
                }
            }else {
                    emailLabel.text = "Email"
                    
                }
            }else {
                emailLabel.text = "maximum charaters allowed 254"
                
            }
                
            }
        if textField.tag == 3 {
            
            if ((password.text?.count)! < 254) {
                
            if !(password.text?.isEmpty)! {
                
           
            if !isValidPassword(testStr: password.text) {
                passwordLabel.text = "Password must contain 1 upper case letter , 1 lower case letter and minimum 8 charaters"
                
            
            }else {
                passwordLabel.text = "Password"
                }
            }else {
                passwordLabel.text = "Password"
                }
            }else {
                passwordLabel.text = "maximum charaters allowed 254"
                
            }
        
      
    }
        
      return true
    }
   
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    
    
    
    
    
    
    if textField == tfName{
       scrollView.setContentOffset(CGPoint(x: 0, y: 0 ), animated: true)
      self.nameBelowView.backgroundColor = UIColor.gray
      if (tfName.text?.isEmpty)! {
        self.nameLabel.isHidden = true
      }else {
        self.nameLabel.isHidden = false
      }
      
      textField.placeholder = "Name"
      // self.emailBelowLabel.fadeOut()
    }
    if textField == email{
        scrollView.setContentOffset(CGPoint(x: 0, y: 30 ), animated: true)
      
      
      self.emailBelowView.backgroundColor = UIColor.gray
      if (email.text?.isEmpty)! {
        self.emailLabel.isHidden = true
      }else {
        self.emailLabel.isHidden = false
      }
      textField.placeholder = "Email"
      // self.emailBelowLabel.fadeOut()
      
    }
    else if textField == password{
        scrollView.setContentOffset(CGPoint(x: 0, y: 0 ), animated: true)
     
      self.passwordBelowView.backgroundColor = UIColor.gray
      if (password.text?.isEmpty)! {
        self.passwordLabel.isHidden = true
      }else {
        self.passwordLabel.isHidden = false
      }
      textField.placeholder = "Password"
      // self.passwordBelowLabel.fadeOut()
    }
    
  }
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == tfName{
      
      self.nameLabel.isHidden = true
      self.nameBelowView.backgroundColor = UIColor.gray
      if tfName.isFirstResponder{
        tfName.resignFirstResponder()
      }
      self.email.becomeFirstResponder()
      return true
    }
    if textField == email{
      self.emailLabel.isHidden = true
      self.emailBelowView.backgroundColor = UIColor.gray
      if email.isFirstResponder{
        email.resignFirstResponder()
      }
      self.password.becomeFirstResponder()
      //email.resignFirstResponder()
      return true
    }
    if textField == password{
         scrollView.setContentOffset(CGPoint(x: 0, y: 30 ), animated: true)
      if InternetAvailability.isConnectedToNetwork() == true{
        self.passwordLabel.isHidden = true
        self.passwordBelowView.backgroundColor = UIColor.gray
        if password.isFirstResponder{
          password.resignFirstResponder()
        }
        self.signUpWithEmail()
        
        return true
      }
      else{
        self.alert(message: "Make sure your Device is connected to Internet", title: "No Internet Connection")
        self.passwordLabel.isHidden = true
        self.passwordBelowView.backgroundColor = UIColor.gray
        if password.isFirstResponder{
        tfName.resignFirstResponder()
        }
        //password.resignFirstResponder()
        return true
      }
    }
    scrollView.setContentOffset(CGPoint(x: 0, y: 0 ), animated: true)
    return true
    
  }
  
}

