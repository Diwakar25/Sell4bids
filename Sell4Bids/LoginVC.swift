//
//  loginVC.swift
//  socialLogins
//
//  Created by H.M.Ali on 9/27/17.
//  Copyright © 2017 Admin. All rights reserved.
//


import Firebase
import FirebaseAuth
import FacebookCore
import FacebookLogin
import GoogleSignIn

class LoginVC: UIViewController {
  //MARK:- Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewDim: UIView!
  @IBOutlet weak var fidgetImageView: UIImageView!
  @IBOutlet weak var topConstraint: NSLayoutConstraint!
  @IBOutlet weak var emailBelowLabel: UIView!
  @IBOutlet weak var passwordBelowLabel: UIView!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var tfPass: UITextField!
  @IBOutlet weak var tfEmail: UITextField!
  @IBOutlet weak var passwordLabel: UILabel!
  @IBOutlet weak var loginWithFbBtn: UIButton!
  @IBOutlet weak var loginWithGoogleBtn: DesignableButton!
  @IBOutlet weak var loginFB: UIButton!
  @IBOutlet weak var btnLoginManual: UIButton!
  weak var delegate : delegateOfLoginVC?
  // @IBOutlet weak var topBar: UIView!
  
    
    private func loginUserAndTakeToHomeScreen(user: User?, fbUserId: String) {
        
        guard let user = user else {
            showSwiftMessageWithParams(theme: .error, title: "Error", body: "No User Data Found From Facebook")
            return
        }
        
        
        let ref = Database.database().reference().child("users").child(user.uid)
        let deviceUUID: String = (UIDevice.current.identifierForVendor?.uuidString)!
        
        let urlStrProfPicFB = "http://graph.facebook.com/\(fbUserId)/picture?type=large"
        let value = ["email":user.email ?? "NA" ,
                     "name":user.displayName ?? "Name Not Available",
                     "uid":user.uid,
                     "token": deviceUUID,
                     "image" : urlStrProfPicFB ]
            
            as [String: Any]
        ref.updateChildValues(value)
        
        
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
        
        print("successfully logged in ", user)
        
    }
    func getFBData(){
        
        fidgetImageView.show()
        guard let accessToken = AccessToken.current else {
            print("guard let accessToken = AccessToken.current failed. Going to return")
            showSwiftMessageWithParams(theme: .error, title: "Login With Facebook Failed", body: "Internal Error occured")
            return
        }
        
        let params = ["fields" : "id, name , email"]
        let graphRequest = GraphRequest(graphPath: "me", parameters: params)
        
        graphRequest.start { (response: HTTPURLResponse?, requestResult) in
            DispatchQueue.main.async {
                self.fidgetImageView.isHidden = true
                self.fidgetImageView.image = nil
            }
            switch requestResult {
            case .failed(let error):
                print("error in graph request:", error)
                break
            case .success(response: let graphResponse):
                if let responseDictionary = graphResponse.dictionaryValue {
                    //print(responseDictionary)
                    print("printing response dictionary :\(responseDictionary)")
                    print("Succsfully Got User info from Facebook")
                    
                    var fbUserId = "NA"
                    if let userId = responseDictionary["id"] as? String {
                        fbUserId = userId
                        print("user id from graph request :\(userId)")
                    }
                    
                    if let name = responseDictionary["name"] as? String {
                        SessionManager.shared.name = name
                        
                    }
                    
                    if let email = responseDictionary["email"] as? String { SessionManager.shared.email = email }
                    
                    
                    let credentials = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                    //print(credentials)
                    var message = ""
                    self.fidgetImageView.show()
                    
                    Auth.auth().signInAndRetrieveData(with: credentials, completion: { (authResult, error: Error?) in
                        
                        DispatchQueue.main.async {
                            
                            self.fidgetImageView.isHidden = true
                            self.fidgetImageView.image = nil
                        }
                        
                        guard let authResult = authResult, error == nil else {
                            
                            if (error?.localizedDescription.contains("An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address"))! {
                                message = "You are already registered manually. Please use the Login Button to Log Into your account with email and password."
                                SessionManager.logOut()
                                
                            }else { message = (error?.localizedDescription)!}
                            
                            self.alert(message: message, title: "Attention")
                            
                            return
                        }
                        
                        SessionManager.shared.isUserLoggedIn = true
                        SessionManager.shared.loggedInThrough = loggedInThrough.facebook.hashValue
                        let id = authResult.user.uid
                        SessionManager.shared.userId = id
                        self.loginUserAndTakeToHomeScreen(user: authResult.user, fbUserId: fbUserId)
                        
                        
                    })
                    
                }
            }
        }
        
        
    }
    
    
    
    
    
    @IBAction func SignUpbtn(_ sender: Any) {
        
         navigationController?.popViewController(animated: true)
        self.performSegue(withIdentifier: "backtoLogin", sender: nil)
        
    }
    
    
    let button = UIButton(type: .custom)
    
    @objc func showpass () {
        if tfPass.isSecureTextEntry == true {
            tfPass.isSecureTextEntry = false
            button.setImage(UIImage(named: "eye (1)"), for: .normal)
        } else {
            tfPass.isSecureTextEntry = true
            button.setImage(UIImage(named: "hide (1)"), for: .normal)
        }
        
    }
    func addLogoWithLeft() {
        
        navigationItem.leftItemsSupplementBackButton = true
        let button = UIButton.init(type: .custom)
        button.setImage( #imageLiteral(resourceName: "hammer_white")  , for: UIControlState.normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItems = [barButton]
    }
  
    
    
  //MARK: - View did load
  override func viewDidLoad() {
    super.viewDidLoad()
    logoff = false
    
    button.setImage(UIImage(named: "hide (1)"), for: .normal)
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0)
    button.frame = CGRect(x: CGFloat( 25), y: CGFloat(5), width: CGFloat(15), height: CGFloat(25))
    button.addTarget(self, action: #selector(self.showpass), for: .touchUpInside)
    tfPass.rightView = button
    tfPass.rightViewMode = .unlessEditing
    addLogoWithLeft()
    tfEmail.delegate = self
    tfPass.delegate = self
    setupViews()
  }
  
    
    
    
    
    
  //MARK: - Private Functions
  private func setupViews() {
    
    
    self.emailBelowLabel.backgroundColor = UIColor.gray
    self.passwordBelowLabel.backgroundColor = UIColor.gray
    
    self.navigationItem.title = "Login"
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    
    passwordBelowLabel.isHidden = true
    emailBelowLabel.isHidden = true
    emailLabel.isHidden = true
    passwordLabel.isHidden = true
    passwordBelowLabel.isHidden = false
    emailBelowLabel.isHidden = false
    
    loginWithFbBtn.addShadowAndRound()
    loginWithGoogleBtn.addShadowAndRound()
    btnLoginManual.addShadowAndRound()
  }
  //for Firebase manual login
  
  func signInWithEmail(){
    
    viewDim.alpha = 0.3
    DispatchQueue.main.async {
      self.view.resignFirstResponder()
      self.view.endEditing(true)
    }
    if let mail = tfEmail.text{
      if mail != ""{
        if isEmailValid(text: mail) {
          if let pass = tfPass.text{
            
            if pass != ""
            {
              var taskCompleted = false
              Timer.scheduledTimer(withTimeInterval: 3, repeats: false) {[weak self] (timer) in
                guard let this = self else { return }
                if !taskCompleted {
                    if this.fidgetImageView.isHidden == true {
                        this.fidgetImageView.image = nil
                    }
                  this.fidgetImageView.toggleRotateAndDisplayGif()
                  this.fidgetImageView.show()
                }
              }
              Auth.auth().signIn(withEmail: mail, password: pass, completion: { [weak self](user, error) in
               
                taskCompleted = true
                guard let this = self else { return }
                this.fidgetImageView.hide()
                this.fidgetImageView.image = nil
                
                if  let _ =  error{
                  
                  
                  DispatchQueue.main.async {
                    this.fidgetImageView.isHidden = true
                    this.fidgetImageView.image = nil
                    this.viewDim.alpha = 0
                    
                  }
                   showSwiftMessageWithParams(theme: .error, title: "Login Failed", body: "Sorry, invalid password.", durationSecs: 4, layout: .cardView, position: .center)
                 
                  
                  return
                  //print("Error occured: ",error!)
                }
                guard let user = user else {
                  showSwiftMessageWithParams(theme: .error, title: "Login Failed", body: "No user Data Found")
                  return
                }
                print("user details = \(user.user.uid)")
                if user.user.isEmailVerified == true {
                  //user.displayName can be nil so if it is nil, download from firebase and store in sessionManager
                  this.handleName(userDisplayName: user.user.displayName, uid: user.user.uid)
                  //SessionManager.shared.name = user.displayName ?? "Sell4bids User"
                  SessionManager.shared.userId = user.user.uid
                  SessionManager.shared.fcmToken = Messaging.messaging().fcmToken ?? ""
                  SessionManager.shared.email = user.user.email ?? ""
                  SessionManager.shared.isUserLoggedIn = true
                  
                  let token:String = Messaging.messaging().fcmToken!
                  this.postToken(token: token, id: (user.user.uid))
                  DispatchQueue.main.async {
                    this.fidgetImageView.isHidden = true
                    this.fidgetImageView.image = nil
                    this.viewDim.alpha = 0
                  }
                  
                
                  let appDelegate = UIApplication.shared.delegate! as! AppDelegate
                  let mainSB = getStoryBoardByName(storyBoardNames.main)
                  let initialViewController = mainSB.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                  appDelegate.window?.rootViewController = initialViewController
                  appDelegate.window?.makeKeyAndVisible()
                   
                    
                    showSwiftMessageWithParams(theme: .success, title: "Logged in", body: "You’ve successfully logged in.")
                }
                else{
                  DispatchQueue.main.async {
                    
                    this.viewDim.alpha = 0
                  }
                  
                  let title = "User Authentication "
                  let message = "A verification email has been sent to your email address. Please check your Inbox for Account Activation Instructions."
                  showSwiftMessageWithParams(theme: .info, title: title, body: message)
                  user.user.sendEmailVerification(completion: nil)
                  
                }
              })
              
            }else{
              DispatchQueue.main.async {
                self.fidgetImageView.isHidden = true
                self.fidgetImageView.image = nil
                self.viewDim.alpha = 0
              }
              let title = "User Authentication "
              let message = "Please enter password to continue"
              showSwiftMessageWithParams(theme: .warning, title: title, body: message)
              self.tfPass.shake()
            }
            
          }else{
            DispatchQueue.main.async {
              self.fidgetImageView.isHidden = true
                self.fidgetImageView.image = nil
              self.viewDim.alpha = 0
            }
            let title = "User Authentication "
            let message = "Please enter password to continue"
            showSwiftMessageWithParams(theme: .warning, title: title, body: message)
            self.tfPass.shake()
          }
        }
        else {
          let title = "User Authentication "
          let message = "Please enter a valid email to continue"
          showSwiftMessageWithParams(theme: .warning, title: title, body: message)
          self.tfEmail.shake()
          
        }
        
        
      }
        
        
      else{
        fidgetImageView.isHidden = true
        fidgetImageView.image = nil
        self.viewDim.alpha = 0
        
        let title = "User Authentication "
        let message = "Please enter a valid email to continue"
        showSwiftMessageWithParams(theme: .warning, title: title, body: message)
        self.tfEmail.shake()
      }
      
    }
    else{
      DispatchQueue.main.async {
        self.fidgetImageView.isHidden = true
        self.fidgetImageView.image = nil
        self.viewDim.alpha = 0
      }
      
      let title = "User Authentication "
      let message = "Please enter a valid email to continue"
      showSwiftMessageWithParams(theme: .warning, title: title, body: message)
      self.tfEmail.shake()
    }
    
  }
  ///if userDisplayName is nil (not got from firebase, then, get from users NOde)
  func handleName(userDisplayName: String?, uid: String) {
   
    if let name = userDisplayName {
      SessionManager.shared.name = name
    } else {
     //get from database
      Database.database().reference().child("users").child(uid).child("name").observeSingleEvent(of: .value) { (snap) in
        if let name = snap.value as? String {
          SessionManager.shared.name = name
        }
      }
    }
      
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first{
      if touch.view != tfEmail{
        self.emailLabel.isHidden = true
        self.emailBelowLabel.backgroundColor = UIColor.gray
        if tfEmail.isFirstResponder{
          tfEmail.resignFirstResponder()
        }
      }
      if touch.view != tfPass{
        self.passwordLabel.isHidden = true
        self.passwordBelowLabel.backgroundColor = UIColor.gray
        if tfPass.isFirstResponder{
          tfPass.resignFirstResponder()
        }
      }
    }
  }
  
  //MARK:- IBAction and user interaction
  
  
 
  
  @IBAction func loginWithFbBtnAction(_ sender: Any) {
    if InternetAvailability.isConnectedToNetwork() {
        
        let loginManager = LoginManager()
        loginManager.loginBehavior = .web
        
        loginManager.logIn(readPermissions: [.userAboutMe, .email], viewController: self, completion: { (loginResult) in
            
            switch loginResult {
            case .failed(let error):
                print(error)
                showSwiftMessageWithParams(theme: .error, title: "Login With Facebook Failed", body: error.localizedDescription)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print(grantedPermissions)
                print(declinedPermissions)
                print(accessToken)
                print("Logged in!")
                self.getFBData()
            }
        })
        
    }
    else{
        self.alert(message: "Make sure your Device is connected to Internet", title: "No Internet Connection")
        
    }

  }
  
  @IBAction func loginWithGoogleBtnAction(_ sender: Any) {
    if InternetAvailability.isConnectedToNetwork() == true{
        GIDSignIn.sharedInstance().signIn()
    }
    else{
        fidgetImageView.isHidden = true
        fidgetImageView.image = nil
        self.alert(message: "Make sure your Device is connected to Internet", title: "No Internet Connection")
    }
  }
  
  @IBAction func loginBtnAction(_ sender: Any) {
    if InternetAvailability.isConnectedToNetwork()==true{
      
      self.signInWithEmail()
    }
    else{
      self.alert(message: "Make sure your Device is connected to Internet", title: "No Internet Connection")
      return
    }
    
  }
  @IBAction func forgetPasswordBtnAction(_ sender: Any) {
    
    let vc = storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
    navigationController?.pushViewController(vc, animated: true)
    
  }
  
  func postToken(token: String, id: String){
    print("FCM Token \(token)")
    let ref = Database.database().reference().child("users").child(id)
    ref.child("fcmToken").setValue(token)
  }

}

extension LoginVC: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField == tfEmail{
      if passwordLabel.isHidden == false{
        // password.tintColor = UIColor.gray
        if (tfPass.text?.isEmpty)! {
          passwordLabel.isHidden = true
        }else {
          passwordLabel.isHidden = false
          passwordLabel.textColor = UIColor.gray
        }
        // passwordBelowView.backgroundColor = UIColor.gray
      }
      
      self.emailBelowLabel.backgroundColor = UIColor.red
      self.emailBelowLabel.fadeIn()
      self.emailLabel.fadeIn()
      textField.placeholder = ""
      
    }
    else if textField == tfPass{
      if emailLabel.isHidden == false{
        // password.tintColor = UIColor.gray
        if (tfEmail.text?.isEmpty)! {
          emailLabel.isHidden = true
        }else {
          emailLabel.isHidden = false
          emailLabel.textColor = UIColor.gray
        }
        // passwordBelowView.backgroundColor = UIColor.gray
      }
      
      self.passwordBelowLabel.backgroundColor = UIColor.red
      self.passwordLabel.fadeIn()
      self.passwordBelowLabel.fadeIn()
      textField.placeholder = ""
      
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    
    if textField == tfEmail{
       scrollView.setContentOffset(CGPoint(x: 0, y: 50 ), animated: true)
      self.emailBelowLabel.backgroundColor = UIColor.gray
      if (tfEmail.text?.isEmpty)! {
        self.emailLabel.isHidden = true
      }else {
        self.emailLabel.isHidden = false
      }
      textField.placeholder = "Email"
      
    }
    else if textField == tfPass{
       scrollView.setContentOffset(CGPoint(x: 0, y: 0 ), animated: true)
      self.passwordBelowLabel.backgroundColor = UIColor.gray
      
      if (tfPass.text?.isEmpty)! {
        self.passwordLabel.isHidden = true
      }else {
        self.passwordLabel.isHidden = false
      }
      textField.placeholder = "Password"
      
    }
    
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == tfEmail{
      self.emailLabel.isHidden = true
      self.emailBelowLabel.backgroundColor = UIColor.gray
      if tfEmail.isFirstResponder{
        tfEmail.resignFirstResponder()
      }
      self.tfPass.becomeFirstResponder()
      return true
    }
    if textField == tfPass{
      if InternetAvailability.isConnectedToNetwork() == true{
        self.passwordLabel.isHidden = true
        self.passwordBelowLabel.backgroundColor = UIColor.gray
        if tfPass.isFirstResponder{
          tfPass.resignFirstResponder()
        }
        self.signInWithEmail()
        
        
        return true
      }
      else{
        self.alert(message: "Make sure your Device is connected to Internet", title: "No Internet Connection")
        self.passwordLabel.isHidden = true
        self.passwordBelowLabel.backgroundColor = UIColor.gray
        if tfPass.isFirstResponder{
          tfPass.resignFirstResponder()
        }
        //password.resignFirstResponder()
        return true
      }
    }
    return true
    
    
  }
}

protocol delegateOfLoginVC: class {
  
  func btnLoginWithFBTapped_LoginVC()
  
  func btnLoginWithGoogleTapped_LoginVC()
  
}
