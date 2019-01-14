//
//
//  ViewController.swift
//  socialLogins
//
//  Created by Admin on 9/26/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import Firebase
import GoogleSignIn
import FirebaseDatabase
import IQKeyboardManagerSwift
class WelcomeVc: UIViewController , GIDSignInUIDelegate, UICollectionViewDelegateFlowLayout{
  //MARK:- Properties
  
  @IBOutlet weak var loginWithGoogleBtn: UIButton!
  @IBOutlet weak var loginWithFbBtn: UIButton!
  @IBOutlet weak var signUpBtn: UIButton!
  @IBOutlet weak var loginBtn: ButtonSignIn!
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var FbLoginBtn: UIButton!
  //@IBOutlet weak var loginFB: FBSDKLoginButton!
  
  @IBOutlet weak var fidgetImageView: UIImageView!
  //MARK:- Variables
  var scrollTimer : Timer?
  
  var array : [UIImage] = [#imageLiteral(resourceName: "onBoard1"), #imageLiteral(resourceName: "onBoard2"), #imageLiteral(resourceName: "onBoard3"), #imageLiteral(resourceName: "onBoard4"), #imageLiteral(resourceName: "onBoard5") ]
  //let arrayBackColors : [UIColor] = [#colorLiteral(red: 0.5529411765, green: 0.01176470588, blue: 0.01568627451, alpha: 1) , #colorLiteral(red: 0.6823529412, green: 0.3529411765, blue: 0.1411764706, alpha: 1) , #colorLiteral(red: 0.298582226, green: 0.4268352389, blue: 0.1869291067, alpha: 1), #colorLiteral(red: 0.4164571762, green: 0.01541041397, blue: 0.3004741669, alpha: 1), #colorLiteral(red: 0.3775613904, green: 0.351809144, blue: 0.04488798976, alpha: 1) ]
  var dummyCount = 9
  var nav = UINavigationController()
  
    
  override func viewDidLoad() {
    
    super.viewDidLoad()
    startTimer()
    
 
    
    GIDSignIn.sharedInstance().uiDelegate = self
    fidgetImageView.loadGif(name: gifNames[0])
    collectionView.delegate = self
    collectionView.dataSource = self
    loginWithFbBtn.addShadowAndRound()
    loginWithGoogleBtn.addShadowAndRound()
    signUpBtn.addShadowAndRound()
    loginBtn.addShadowAndRound()
    
    pageControl.numberOfPages = array.count
    setCustomBackImage()
    //if user is already logged In
    if let _ = AccessToken.current {
      // User is logged in,
      getFBData()
    }
    NotificationCenter.default.addObserver(self, selector: #selector(test), name: NSNotification.Name.init("test"), object: nil)
  }
  
  @objc func test() {
    signupBtnTapped(self)
   
  }
    
    @IBAction func TermsandConditionbtn(_ sender: Any) {
        
       
            let urlTerms = URL.init(string: "https://www.sell4bids.com/terms-and-conditions")!
            UIApplication.shared.open(urlTerms, options: [:])
        
    }
    
    
    @IBAction func PrivacyandPolicybtn(_ sender: Any) {
        
        let urlStrPolicy = URL.init(string: "https://www.sell4bids.com/privacy-policy")!
        UIApplication.shared.open(urlStrPolicy, options: [:])
    }
    
    

  
  //MARK:- Life View Cycle
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
       
        
    }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    //UIApplication.shared.isStatusBarHidden = true
    
    IQKeyboardManager.shared.enable = false
    IQKeyboardManager.shared.enableAutoToolbar = false
    
    //UIApplication.shared.isStatusBarHidden = true
    //setNeedsStatusBarAppearanceUpdate()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    //It will show the status bar again after dismiss'
   
    self.navigationController?.navigationBar.isHidden = false
    //UIApplication.shared.isStatusBarHidden = false
    //setNeedsStatusBarAppearanceUpdate()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.navigationBar.isHidden = true
  }
  
  func setCustomBackImage() {
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }
  
  //MARK:- IBActions and user interaction
  
//  @IBAction func btnByLogginInOrSignUpTapped(_ sender: UIButton) {
//    let alert = UIAlertController(title: nil, message: nil , preferredStyle: .actionSheet)
//
//    let actionTerms = UIAlertAction.init(title: "Terms of Service", style: .default) { (action) in
//      let urlTerms = URL.init(string: "https://www.sell4bids.com/terms-and-conditions")!
//      UIApplication.shared.open(urlTerms, options: [:])
//    }
//    let actionPrivacy = UIAlertAction.init(title: "Privacy Policy", style: .default) { (action) in
//      let urlStrPolicy = URL.init(string: "https://www.sell4bids.com/privacy-policy")!
//      UIApplication.shared.open(urlStrPolicy, options: [:])
//    }
//    let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//    alert.addAction(actionTerms)
//    alert.addAction(actionPrivacy)
//    alert.addAction(actionCancel)
//
//    if let popoverPresentationController = alert.popoverPresentationController {
//      popoverPresentationController.sourceView = sender
//      popoverPresentationController.sourceRect = sender.bounds
//    }
//
//    self.present(alert, animated: true, completion: nil)
//  }
  
  @IBAction func loginBtnTapped(_ sender: Any) {
    btn_click_Effect(btn: loginBtn)
    performSegue(withIdentifier: "Login", sender: nil)
   
  }
  
  @IBAction func signupBtnTapped(_ sender: Any) {
    
   performSegue(withIdentifier: "Signup", sender: nil)
    
  }
  
  @IBAction func loginWithFbbtnAction(_ sender: Any) {
    
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
  
  @IBAction func loginWithgoogleBtnAction(_ sender: Any) {
    
    
    if InternetAvailability.isConnectedToNetwork() == true{
      GIDSignIn.sharedInstance().signIn()
    }
    else{
      fidgetImageView.isHidden = true
        fidgetImageView.image = nil
      self.alert(message: "Make sure your Device is connected to Internet", title: "No Internet Connection")
    }
  }
  
  
  //used in scroll view delegate
  var temp:CGPoint!
  var selectedPage = 0
  
  
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension WelcomeVc : UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return array.count * dummyCount
    
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cellSlider = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
    //makeCellRound(cell: cellSlider)
    
    let imageIndex = indexPath.item % array.count
    let image = array[imageIndex]
    
    cellSlider.myImage.tag = indexPath.row
    //    let gradientLayer = CAGradientLayer()
    //    gradientLayer.frame = cellSlider.bounds
    //    gradientLayer.colors = [UIColor.init(hex: "FF0000").cgColor, UIColor.init(hex: "AD0000").cgColor]
    //    if imageIndex == 0 {
    //      cellSlider.layer.addSublayer(gradientLayer)
    //    }
    cellSlider.myImage.image = image
    
    //        cellSlider.contentMode = UIViewContentMode.scaleAspectFill
    //        cellSlider.clipsToBounds = true
    //        cellSlider.myImage.contentMode = UIViewContentMode.scaleAspectFill
    //        cellSlider.myImage.clipsToBounds = true
    //        cellSlider.myImage.layer.masksToBounds = true
    return cellSlider
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return collectionView.bounds.size
  }
  
  func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    
    if(collectionView == self.collectionView){
      
      var page:Int =  Int(collectionView.contentOffset.x / collectionView.frame.size.width)
      
      page = page % array.count
      
      print("page = \(page)")
      
      pageControl.currentPage = Int (page)
      
    }
    
  }
}

//MARK:- delegateSignUpVC
extension WelcomeVc : delegateSignUpVC {
  func btnLoginWithGoogleTapped() {
    loginWithgoogleBtnAction(self)
  }
  
  func btnLoginWithFacebbokTapped() {
    loginWithFbbtnAction(self)
  }
}
//MARK:- delegateOfLoginVC
extension WelcomeVc: delegateOfLoginVC {
  func btnLoginWithFBTapped_LoginVC() {
    loginWithFbbtnAction(self)
  }
  
  func btnLoginWithGoogleTapped_LoginVC() {
    loginWithgoogleBtnAction(self)
  }
}

extension WelcomeVc: UIScrollViewDelegate {
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    
    stopTimer()
    
  }
  
  func startTimer() {
    
    //self.colVSliderImages.setContentOffset(CGPoint.zero, animated: false)
    
    if array.count > 1 && scrollTimer == nil {
      
      let timeInterval = 6.0;
      
      scrollTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.rotate), userInfo: nil, repeats: true)
      
      scrollTimer!.fireDate = Date().addingTimeInterval(timeInterval)
      
    }
    
  }
  
  func stopTimer() {
    
    scrollTimer?.invalidate()
    
    scrollTimer = nil
    
  }
  
  @objc func rotate() {
    
    
    
    //print("passed offset to rotate: \(collectionView.contentOffset.x)")
    
    
    
    let offset = CGPoint(x:self.collectionView.contentOffset.x + cellWidth, y: self.collectionView.contentOffset.y)
    
    
    
    // print("setting the Calculated offset in rotate: \(offset)")
    
    var animated = true
    
    if (offset.equalTo(CGPoint.zero) || offset.equalTo(CGPoint(x: totalContentWidth, y: offset.y))){
      
      animated = false
      
    }
    
    self.collectionView.setContentOffset(offset, animated: animated)
    
    
    
    
    
  }
  
  
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    
    self.centerIfNeeded(animationTypeAuto: true, offSetBegin: CGPoint.zero)
    
  }
  
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    if(scrollView == collectionView){
      
      if(scrollView.panGestureRecognizer.state == .began){
        
        stopTimer()
        
      }else if( scrollView.panGestureRecognizer.state == .possible){
        
        //startTimer()
        
      }
      
    }
    
  }
  
  
  func updatePageControl(){
    
    var updatedPage = selectedPage + 1
    
    let totalItems = array.count
    
    updatedPage = updatedPage % totalItems
    
    // print("updatedPage: \(updatedPage)")
    
    selectedPage  = updatedPage
    
    self.pageControl.currentPage = updatedPage
    
    
    
  }
  
  
  func centerIfNeeded(animationTypeAuto:Bool, offSetBegin:CGPoint) {
    
    let currentOffset = self.collectionView.contentOffset
    
    let contentWidth = self.totalContentWidth
    
    let width = contentWidth / CGFloat(dummyCount)
    
    
    if currentOffset.x < 0{
      //left scrolling
      
      self.collectionView.contentOffset = CGPoint(x: width - currentOffset.x, y: currentOffset.y)
      
    } else if (currentOffset.x + cellWidth) >= contentWidth {
      
      //right scrolling
      
      let  point = CGPoint.zero
      
      //point.x = point.x - cellWidth
      
      var tempCGPoint = point
      
      tempCGPoint.x = tempCGPoint.x + cellWidth
      
      print("center if need set offset to \( tempCGPoint)")
      
      self.collectionView.contentOffset = point
      
    }
    
  }
  
  
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    
    print("\(scrollView.contentOffset)")
    
    self.temp = scrollView.contentOffset
    
    self.stopTimer()
    
  }
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    self.centerIfNeeded(animationTypeAuto: false, offSetBegin: temp)
    self.startTimer()
  }
  
  override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
    DispatchQueue.main.async() {
      
      self.stopTimer()
      
      self.collectionView.reloadData()
      
      self.collectionView.setContentOffset( CGPoint.zero, animated: true)
      
      self.startTimer()
      
    }
    
    print("changed orientation")
    
  }
  
  var totalContentWidth: CGFloat {
    return CGFloat(array.count * dummyCount) * cellWidth
  }
  
  var cellWidth: CGFloat {
    return self.collectionView.frame.width
  }
  
}
