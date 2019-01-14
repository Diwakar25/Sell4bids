//
//  Step4VC.swift
//  socialLogins
//
//  Created by H.M.Ali on 10/7/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseStorage
import SVProgressHUD_0_8_1
import SwiftyJSON
import SwiftMessages

class Step4VC: UIViewController,CLLocationManagerDelegate, UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryList.count
    }
    
  
  //MARK:- Properties
  @IBOutlet weak var zipPopUpView: UIView!
  @IBOutlet weak var saveBtn: DesignableButton!
  @IBOutlet weak var backgroundView: UIView!
  @IBOutlet weak var zipCodeTextField: DesignableUITextField!
  @IBOutlet weak var shareWithFbLabel: UILabel!
  @IBOutlet weak var locationFromZipLabel: UILabel!
  @IBOutlet weak var locateMeLabel: UILabel!
  
  @IBOutlet weak var nextBtn: DesignableButton!
  
  @IBOutlet weak var nameOfCompanyTextField: DesignableUITextField!
  
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var detailOfCompanyTextField: DesignableUITextField!
  // @IBOutlet weak var secondViewLabel: UILabel!
  
  @IBOutlet weak var thirdViewLabel: UILabel!
  
  //viewOutlets
  @IBOutlet weak var firstView: UIView!
  // @IBOutlet weak var secondView: UIView!
  @IBOutlet weak var thirdView: UIView!
  @IBOutlet weak var mainView: UIView!
  //third view
  //for adding border and making it round
  @IBOutlet weak var viewLocation: UIView!
  @IBOutlet weak var viewLocateMe: UIView!
    fileprivate func addDoneLeftBarBtn() {
        
        let barbuttonHome = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(self.barBtnInNav))
        barbuttonHome.image = UIImage(named: "BackArrow24")
        
        let button = UIButton.init(type: .custom)
        button.setImage( #imageLiteral(resourceName: "hammer_white")  , for: UIControlState.normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        
        self.navigationItem.leftBarButtonItems = [barbuttonHome, barButton]
    }
    @objc func barBtnInNav() {
         self.navigationController?.popViewController(animated: true)
    }
    
  //MARK:- Varibales
  var locationManager = CLLocationManager()
  var previousData = [String:Any]()
  var myState = ""
  var myCity = ""
  var count = 0
    var indiaZipCode : IndiaPinCodeModel?
    var UsaZipCode : USAZipCodeModel?
    var countrypicker = UIPickerView()
  var isJob = false
    var defaults = UserDefaults.standard
  //var acceptOffers = "No"
    @IBOutlet weak var btnLocateMeCheck: UISwitch!
    
  @IBOutlet weak var imgFidget: UIImageView!
  
  @IBOutlet weak var viewDim: UIView!
  @IBOutlet weak var imgSuccessTick: UIImageView!
  
    
    
    
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    
    self.view.endEditing(true)
    

        if self.defaults.value(forKey: "SelectedCountry") as? String != nil {
            let value = self.defaults.value(forKey: "SelectedCountry") as? String
            print("Value 1 \(value)")
            self.countryTextField.text = value!
            
        }
    
    
        
        if self.defaults.value(forKey: "City_State_ZipCode") as? String != nil {
            let value = self.defaults.value(forKey: "City_State_ZipCode") as? String
            print("Value 2 \(value)")
            self.locateMeLabel.text = value!
        }
    
    
        
        if self.defaults.value(forKey: "LocationFromZip") as? String != nil {
            let value = self.defaults.value(forKey: "LocationFromZip") as? String
             print("Value 3 \(value)")
            self.locationFromZipLabel.text = value!
        }
        
        if self.defaults.value(forKey: "LocateMeCheckStatus") as? Bool != nil {
            let value = self.defaults.value(forKey: "LocateMeCheckStatus") as? Bool
             print("Value 4 \(value)")
            self.btnLocateMeCheck.isOn = value!
        }
  
    
    if defaults.value(forKey: "CompanyName") as? String != nil {
        let value = defaults.value(forKey: "CompanyName") as? String
        self.nameOfCompanyTextField.text = value!
    }
    
  
    if defaults.value(forKey: "CompanyDetails") as? String != nil {
        let value = defaults.value(forKey: "CompanyDetails") as? String
        self.detailOfCompanyTextField.text = value!
    }
    
    
    
    addLeftHomeBarButtonToTop()
    addDoneLeftBarBtn()
    countryTextField.makeRedAndRound()
   
    countrypicker.delegate = self
    
    countryTextField.inputView = countrypicker
    
    countryTextField.delegate = self
    if isJob {
      nameOfCompanyTextField.becomeFirstResponder()
    }
    indiaZipCode = IndiaPinCodeModel.init(name: "", description: "", branchType: "", deliveryStatus: "", taluk: "", circle: "", district: "", division: "", region: "", state: "", country: "")
    
    UsaZipCode = USAZipCodeModel.init(country: "", state: "", city: "")
    navigationItem.title = "List item"
    
    self.locationManager.requestAlwaysAuthorization()
    
    // For use in foreground
    self.locationManager.requestWhenInUseAuthorization()
    locationManager.delegate = self
    backgroundView.isHidden = true
    zipCodeTextField.delegate = self
    //secondView.addShadowView()
    thirdView.addShadowView()
    
    if isJob == true{
      firstView.isHidden = false
      firstView.addShadowView()
      thirdViewLabel.text = "Available at"
      
    }
    else{
      firstView.isHidden = true
      thirdViewLabel.text = "Available At"
    }
    
    // Do any additional setup after loading the view.
    setupViews()
  }
  
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
            return countryList[row]
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      
            countryTextField.text = countryList[row]
    
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 3 {
            
        }
    }
  
  override func viewDidAppear(_ animated: Bool) {
    enableIQKeyBoardManager(flag: false)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    enableIQKeyBoardManager()
  }
  @IBOutlet weak var btnCrossViewEnterZipCode: UIButton!
  
  private func setupViews() {
    btnCrossViewEnterZipCode.makeRound()
    saveBtn.addShadowView()
    nameOfCompanyTextField.makeRedAndRound()
    detailOfCompanyTextField.makeRedAndRound()
    viewLocateMe.makeRedAndRound()
    viewLocation.makeRedAndRound()
    
    nextBtn.addShadowAndRound()
    zipCodeTextField.makeRedAndRound()
    saveBtn.addShadowAndRound()
    zipPopUpView.makeCornersRound()
    
  }
  
  //MARK:- IBActions and user interaction
  
  @IBAction func btnCrossEnterZipCTapped(_ sender: Any) {
    zipCodeTextField.resignFirstResponder()
    
    DispatchQueue.main.async {
      self.backgroundView.isHidden = true
    }
    
  }
  @IBAction func shareWithFbBtnAction(_ sender: UIButton) {
    
    sender.isSelected = !sender.isSelected
    
  }
  
    
    @IBAction func locateMeBtnAction(_ sender: Any) {
  
        if btnLocateMeCheck.isOn {
        
            
            print("GpsCountry = \(realGpsCountry)")
            if gpscountry == "USA" || gpscountry == "IN" {
                if btnLocateMeCheck.isOn == true{
                    nextBtn.isEnabled = false
                    SVProgressHUD.show()
                    if CLLocationManager.locationServicesEnabled() {
                        locationManager.delegate = self as CLLocationManagerDelegate
                        locationManager.desiredAccuracy = kCLLocationAccuracyBest
                        locationManager.startUpdatingLocation()
                    }
                    
                    
                    if locationManager.location?.coordinate != nil {
                        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
                        
                        
                        let loc = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
                        
                        
                        let geo = CLGeocoder()
                        geo.reverseGeocodeLocation(loc, completionHandler: { [weak self] (placemarks, error) -> Void in
                            guard let strongSelf = self else { return }
                            // Place details
                            var placeMark: CLPlacemark!
                            placeMark = placemarks?[0]
                            
                            // Address dictionary
                            print(placeMark.addressDictionary as Any)
                            
                            
                            
                            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                                print(locationName)
                            }
                            // Street address
                            if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
                                print(street)
                            }
                            // City
                            
                            // Zip code
                            if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
                                print(zip)
                            }
                            
                            if let State = placeMark.addressDictionary!["State"] as? NSString{
                                // Country
                                if let country = placeMark.addressDictionary!["Country"] as? NSString {
                                    print(country)
                                    
                                    if country == "United States" || country == "India"{
                                        if let city = placeMark.addressDictionary!["City"] as? NSString {
                                            print(city)
                                            DispatchQueue.main.async {
                                                SVProgressHUD.dismiss()
                                                strongSelf.nextBtn.isEnabled = true
                                                                  strongSelf.locateMeLabel.text = city as String+","+"\(State)"
                                                                  strongSelf.locationFromZipLabel.text = "   " + (city as String) as String+","+"\(State)"
                                                strongSelf.imgSuccessTick.fadeIn()
                                            }
                                            
                                            strongSelf.myCity = city as String
                                            strongSelf.myState = State as String
                                            
                                            
                                            self!.locateMeLabel.text = city as String
                                        }
                                    }
                                    else{
                                        strongSelf.alert(message: "Sorry, Could not find your location", title: "Location Error")
                                        strongSelf.btnLocateMeCheck.isOn = false
                                        
                                        DispatchQueue.main.async {
                                            SVProgressHUD.dismiss()
                                            strongSelf.nextBtn.isEnabled = true
                                        }
                                        
                                    }
                                }
                            }
                        })
                        
                        print("locations = \(locValue.latitude) \(locValue.longitude)")

                    }else {
                        SVProgressHUD.dismiss()
                        btnLocateMeCheck.isOn = false
                        self.nextBtn.isEnabled = false
                        alert(message: "Something went wrong.")
                    }
                }
            }
            else{
                SVProgressHUD.dismiss()
                alert(message: "This functionality isn't avialable in your Country", title: "Locate Me")
                self.locateMeLabel.text = "  Locate Me"
                self.btnLocateMeCheck.isOn = false
                 self.nextBtn.isEnabled = false
            }
        }else {
            SVProgressHUD.dismiss()
        }
        
   
            self.defaults.set(self.countryTextField.text, forKey: "SelectedCountry")
            self.defaults.set(self.locateMeLabel.text, forKey: "City_State_ZipCode")
            self.defaults.set(self.locationFromZipLabel.text, forKey: "LocationFromZip")
            self.defaults.set(self.btnLocateMeCheck.isOn, forKey: "LocateMeCheckStatus")
            self.defaults.set(self.nameOfCompanyTextField.text, forKey: "CompanyName")
            self.defaults.set(self.detailOfCompanyTextField.text, forKey: "CompanyDetails")
        
      
                alert(message: "This functionality isn't avialable in your Country", title: "Locate Me")
                self.locateMeLabel.text = "  Locate Me"
                self.btnLocateMeCheck.isOn = false
            }
    

    
    
 
  
  @IBAction func fbShareButtonTapped(_ sender: Any) {
    print("share with fb")
  }
  @IBAction func getLocationFromZipCode(_ sender: Any) {
    
    backgroundView.isHidden = false
    DispatchQueue.main.async {
      self.zipCodeTextField.becomeFirstResponder()
    }
    
  }
  //save zipcode ..to get the state from zipcode
  @IBAction func findMeUsingZipCode(_ sender: Any) {
    
   
    
    
    guard !(zipCodeTextField.text?.isEmpty)! else {
      showSwiftMessageWithParams(theme: .error, title: "Error", body: "Enter valid Zip Code to Continue")
      zipCodeTextField.shake()
      return
    }
    //self.nextBtn.isEnabled = false
    zipPopUpView.layer.cornerRadius = 8
    zipPopUpView.clipsToBounds = true
    backgroundView.isHidden = true
    if zipCodeTextField.isFirstResponder{
      zipCodeTextField.resignFirstResponder()
    }
    //var zipCode = zipCodeTextField.text
    // var x = Int(zipCode!)
    // var geo = CLGeocoder()
    //let str = "http://ziptasticapi.com/" + zipCode!
    //let u = URL(string: str)
    
    
    //var url = URL(strng: "http://ziptasticapi.com/ + \(zipCode!)")
    SVProgressHUD.show()
    self.nextBtn.isEnabled = false
    dimBack()
    
    if countryTextField.text == "IN" {
        
        Alamofire.request("http://postalpincode.in/api/pincode/\(self.zipCodeTextField.text!)", method: .get, encoding: JSONEncoding.default).responseJSON{(response) in
            
            switch response.result {
                
            case .success(_):
                SVProgressHUD.dismiss()
                 self.dimBack(flag: false)
                self.nextBtn.isEnabled = true
                print("datazip = \(response.value)")
                let swiftyJson = JSON(response.result.value)
                 if swiftyJson["error"].string != "Zip Code not found!"  {
                let postOffice = swiftyJson["PostOffice"]
                for result in postOffice {
                    print("Country = \(result.1["Country"].string!)")
                    self.indiaZipCode = IndiaPinCodeModel.init(name: result.1["Name"].string!, description: result.1["Description"].string!, branchType: result.1["BranchType"].string!, deliveryStatus: result.1["DeliveryStatus"].string!, taluk: result.1["Taluk"].string!, circle: result.1["Circle"].string!, district: result.1["District"].string!, division:  result.1["Division"].string!, region: result.1["Region"].string!, state: result.1["State"].string!, country: result.1["Country"].string!)
                    
//                    zipCode = self.zipCodeTextField.text!
//                    city = (self.indiaZipCode?.district)!
//                    
//                    stateName = (self.indiaZipCode?.state)!
                    self.myState = (self.indiaZipCode?.state)!
                    self.myCity = (self.indiaZipCode?.district)!
                    self.locationFromZipLabel.text = "\(self.myCity), \(self.myState), \(self.zipCodeTextField.text!)"
                }
                 }else {
                     showSwiftMessageWithParams(theme: .error, title: "Zip Code not found!", body: "")
                }
                
            case .failure(let error):
                SVProgressHUD.dismiss()
                 self.dimBack(flag: false)
                 self.nextBtn.isEnabled = false
            print("error = \(error)")
            
            }
            
            
        }
        
    }else if countryTextField.text == "USA" {
        
        
        
        Alamofire.request("http://ziptasticapi.com/\(self.zipCodeTextField.text!)", method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
            
            switch response.result {
                
            case .success(_):
               SVProgressHUD.dismiss()
               self.dimBack(flag: false)
                self.nextBtn.isEnabled = true
                  print("USA response = \(response)")
                let swiftyJson = JSON(response.result.value)
                if swiftyJson["error"].string != "Zip Code not found!"  {
                self.UsaZipCode = USAZipCodeModel.init(country: swiftyJson["country"].string!, state: swiftyJson["state"].string!, city: swiftyJson["city"].string!)
                
//                zipCode = self.zipCodeTextField.text!
//                city = (self.UsaZipCode?.city)!
//                stateName = (self.UsaZipCode?.state)!
               self.myCity = (self.UsaZipCode?.city)!
               self.myState = (self.UsaZipCode?.state)!
                self.locationFromZipLabel.text = "\(self.myCity), \(self.myState), \(self.zipCodeTextField.text!)"
                    
                }else {
                    showSwiftMessageWithParams(theme: .error, title: "Zip Code not found!", body: "")

                }
                
            case .failure(let error):
               SVProgressHUD.dismiss()
               self.dimBack(flag: false)
                self.nextBtn.isEnabled = false
                print("error = \(error)")
            }
          
           
        }
        
        
        
    }
    
    self.defaults.set(self.countryTextField.text, forKey: "SelectedCountry")
    self.defaults.set(self.locateMeLabel.text, forKey: "City_State_ZipCode")
    self.defaults.set(self.locationFromZipLabel.text, forKey: "LocationFromZip")
    self.defaults.set(self.btnLocateMeCheck.isOn, forKey: "LocateMeCheckStatus")
    self.defaults.set(self.nameOfCompanyTextField.text, forKey: "CompanyName")
    self.defaults.set(self.detailOfCompanyTextField.text, forKey: "CompanyDetails")
    
    
    
  }
  
  
  //utility function
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first{
      
      if touch.view == backgroundView{
        backgroundView.isHidden = true
        if zipCodeTextField.isFirstResponder{
          zipCodeTextField.resignFirstResponder()
        }
      }
    }
  }
  
  
  //this gunctio is used to uplad urls of images
  func uploadUrl(referenceOfProduct: DatabaseReference, url: String, count: Int, uid: String){
    
    let imageName = "image" + "\(count)"
    let dic = [imageName: url]
    referenceOfProduct.updateChildValues(dic)
    self.count = self.count + 1
    
    //var ref = Database.database().reference().child(uid).child("products")
  }
  
  //this function is used to upload images on firebase
  func uploadProductImages(referenceOfProduct: DatabaseReference,uid: String, product: Product,imageName: Int, completion: @escaping (Bool) -> () )
  {
    var Count = 0
    
      //.child("_cat_auction_state_count")
    
    
    let images = product.images!
    
    var imagesToUpload = images.count
    
    for image in images{
      
   
      let uploadData = resizeImage(image: image)
      
      let newMetadata = StorageMetadata()
        // let name = "\(imageName)"+"_"+"\(Count).jpg"
         let name = "image.jpg"
      //newMetadata.cacheControl = "public,max-age=300";
      newMetadata.contentType = "image/jpeg";
      let storageRef = Storage.storage().reference().child("users").child(uid).child("listings").child(referenceOfProduct.key!).child("_\(product.category)_\(product.productType!)_\(product.state)_\(Count)")
      storageRef.child(name).putData(uploadData, metadata:  newMetadata) { [weak self] (metadata, error) in
        
        guard let this = self else { return }
        imagesToUpload -= 1
        if let error = error {
          print(error.localizedDescription as Any)
          //self.alert(message: "\(error.localizedDescription)", title: "ERROR")
          //showSwiftMessageWithParams(theme: .warning, title: "Your product's Image could not be posted ", body: "A Database error occured")
          this.showToast(message: "image not uploaded")
        }
        else{
          print("storage ref : \(storageRef)")
          storageRef.child(name).downloadURL(completion: { (url, error) in
            guard error == nil, let url = url else {
              showSwiftMessageWithParams(theme: .error, title: "Image not Upload", body: "Your product's Image Could not be Uploaded.")
              
              return
            }
            let imageUrl = url.absoluteString
            this.uploadUrl(referenceOfProduct: referenceOfProduct, url: imageUrl, count: this.count, uid: uid)
            this.showToast(message: "Image uploaded Success")
            if imagesToUpload == 0 {
              //all images have been uploaded successfully
              //showToast(message: "All images posted Successfully.")
              completion(true)
            }
          })
        }
      }
      Count = Count + 1
    }
    
  }
  func dimBack(flag: Bool = true ) {
    DispatchQueue.main.async {
      self.viewDim.alpha = flag ? 0.3 : 0
    }
    
  }
  
  ///finish button action
  @IBAction func btnFinishPostingTapped(_ sender: Any) {
    
    

    
    
    
    if !(zipCodeTextField.text?.isEmpty)!  {
        
   
    
    let deviceUUID: String = (UIDevice.current.identifierForVendor?.uuidString)!
    guard let uid = Auth.auth().currentUser?.uid else{
      self.alert(message: "some error has occured", title: "ERROR")
      return
    }
    
    func listItem() {
      
      
      var val = [String:Any]()
      var bid = [String:Any]()
      //var time: Int64 = 0
      let ref = FirebaseDB.shared.dbRef
      let value = ["temporaryTimeStamp": ServerValue.timestamp()]
      ref.updateChildValues(value)
      var flagProductPostingCompleted = false
      dimBack()
      Timer.scheduledTimer(withTimeInterval: 3, repeats: false) {[weak self] (timer) in
        guard let this = self else { return }
        if !flagProductPostingCompleted {
          this.imgFidget.show()
          this.imgFidget.toggleRotateAndDisplayGif()
        }
      }
      ref.child("temporaryTimeStamp").observeSingleEvent(of: .value) { [weak self] (snapshot) in
        guard let strongSelf = self else { return }
        if let startTime = snapshot.value{
          print(startTime)
          guard let duration = strongSelf.previousData["duration"] as? Int else{
            flagProductPostingCompleted = true
            strongSelf.alert(message: "Add sufficient duration", title: "ERROR")
            return
          }
          var endTime = startTime as! Int64
          if duration != -1{
            let duration = (1000*(duration*24*3600))
            endTime = endTime + Int64(duration)
          }
          else{
            endTime = -1
          }
          
          
          
          if strongSelf.isJob {
            
            guard let companyName = strongSelf.nameOfCompanyTextField.text, companyName != "" else{
              
              showSwiftMessageWithParams(theme: .error, title: "Job Listing Error", body: "Please enter company name to continue")
              strongSelf.nameOfCompanyTextField.shake()
              return
            }
            
            
            let desc = strongSelf.detailOfCompanyTextField.text ?? ""
            
            let state = strongSelf.myState
            guard state != "" else{
              
              let title = "Job Listing Error"
              let message = "Please add location where job is available"
              showSwiftMessageWithParams(theme: .error, title: title, body: message )
              return
            }
            
            let r = FirebaseDB.shared.dbRef.child("images").child("Jobs").child("image")
            r.observeSingleEvent(of: .value, with: { [weak self] (snap) in
              
              
              let imageValue = snap.value as? String
              if imageValue != nil{
                
                val = ["uid": uid,
                       "token":deviceUUID,
                       "title":strongSelf.previousData["title"] as! String,
                       "benefits":strongSelf.previousData["benefits"] as! String,
                       "state":state ,
                       "startPrice":strongSelf.previousData["price"] as! String,
                       "description":strongSelf.previousData["description"] as! String,
                       "conditionValue":"\(strongSelf.previousData["conditionValue"] as! Int)",
                  "condition":strongSelf.previousData["condition"] as! String,
                  "employmentType":strongSelf.previousData["employmentType"] as! String,
                  "city":strongSelf.myCity ,
                  "chargeTime":startTime,
                  "startTime":startTime,
                  "endTime":endTime,
                  "imagesCount":"1",
                  "jobCategory":strongSelf.previousData["category"] as! String,
                  "acceptOffers": strongSelf.previousData["acceptOffer"] as! String,
                  "companyName": companyName,
                  "companyDescription":desc,
                  "payPeriod": strongSelf.previousData["payPeriod"] as! String,
                  "image0":imageValue!,
                  "currency_string" : strongSelf.previousData["currency_string"] as! String ,
                  "currency_symbol" : strongSelf.previousData["currency_symbol"] as! String
                  ] as [String:Any]
              }
              else{
                
                val = ["uid": uid,
                       "token":deviceUUID,
                       "title":strongSelf.previousData["title"] as! String,
                       "benefits":strongSelf.previousData["benefits"] as! String,
                       "state":state ,
                       "startPrice":strongSelf.previousData["price"] as! String,
                       "description":strongSelf.previousData["description"] as! String,
                       "conditionValue":"\(strongSelf.previousData["conditionValue"] as! Int)",
                  "condition":strongSelf.previousData["condition"] as! String,
                  "employmentType":strongSelf.previousData["employmentType"] as! String,
                  "city":strongSelf.myCity ,
                  "chargeTime":startTime,
                  "startTime":startTime,
                  "endTime":endTime,
                  "imagesCount":"1",
                  "jobCategory":strongSelf.previousData["category"] as! String,
                  "acceptOffers": strongSelf.previousData["acceptOffer"] as! String,
                  "companyName": companyName,
                  "companyDescription":desc,
                  "payPeriod": strongSelf.previousData["payPeriod"] as! String,
                    "currency_string" : strongSelf.previousData["currency_string"] as! String ,
                    "currency_symbol" : strongSelf.previousData["currency_symbol"] as! String,
                  "image0":"http://britsimonsays.com/wp-content/uploads/2014/10/JobSites.Feat_1.jpg"
                  
                  ] as [String:Any]
                
              }
              
              val["platform"] = "iOS"
              let ref3 = ref.child("products").child("Jobs").child("buy-it-now").child(state).childByAutoId()
              let flagAutoRelist = self?.previousData["autoReList"] as? Bool ?? false
              
              let valueAutoRelist = flagAutoRelist ? "yes" : "no"
              val["autoReList"] = valueAutoRelist
              ref3.updateChildValues(val, withCompletionBlock: { [weak self] (error, DBRef) in
                
                guard let strongSelfInner = self else { return }
                strongSelfInner.dimBack(flag: false)
                DispatchQueue.main.async { strongSelfInner.imgFidget.hide() }
                
                if let error = error {
                  showSwiftMessageWithParams(theme: .error, title: "Job Posting Failed", body: "Sorry, You Job could not be posted. Try Later. ")
                  print("Error: Job could not be posted. \n\n \(error.localizedDescription)")
                }else {
                  let key = ref3.key
                  let temp = ["auctionType":"buy-it-now","category":"Jobs","state":state ]
                    ref.child("users").child(uid).child("products").child("selling").child(key!).updateChildValues(temp)
                    //if Post is Successfully Submitted Finished comes to true and Set all memorys to default.
                    //Ahmed Baloch
                    
                   
                  strongSelfInner.performSegue(withIdentifier: "fromUploadToFinal", sender: nil)
                }
                
                
              })
            })
          }
            
            //!strongSelf.isJob
          else {
            //not a job
            
            let obj = Product(images: strongSelf.previousData["images"] as? [UIImage], title: strongSelf.previousData["title"] as! String, category: strongSelf.previousData["category"] as! String, condition: strongSelf.previousData["condition"] as! String, conditionValue: strongSelf.previousData["conditionValue"] as! Int, description: strongSelf.previousData["description"] as! String, price: strongSelf.previousData["price"] as? Int, quantity: strongSelf.previousData["quantity"] as? Int, duration: strongSelf.previousData["duration"] as! Int, acceptOffer: strongSelf.previousData["acceptOffer"] as? String, productType: strongSelf.previousData["productType"] as? String,city: strongSelf.myCity, state: strongSelf.myState,startingPrice: strongSelf.previousData["startingPrice"] as? Int,endPrice: strongSelf.previousData["reservePrice"] as? Int, currency_string: strongSelf.previousData["currency_string"] as! String,currency_symbol: strongSelf.previousData["currency_symbol"] as! String)
            
            if obj.state == "" {
              strongSelf.alert(message: "No state found, Plese provide a valid State", title: "Error")
              return
            }
            
            if obj.productType == "buy-it-now"{
              
              
              val = ["uid": uid,"token":deviceUUID,"title":obj.title,"state":obj.state,"startPrice":"\(obj.price!)","quantity":"\(obj.quantity!)","description":obj.description,"conditionValue":"\(obj.conditionValue)","condition":"\(obj.condition)","city":obj.city,"chargeTime":startTime,
                     "startTime":startTime,"endTime":endTime,"imagesCount":"\(obj.images?.count ?? 0 )","acceptOffers": obj.acceptOffer ?? "no", "currency_string" : obj.currency_string  , "currency_symbol": obj.currency_symbol  ] as [String:Any]
              
            }
              
            else{
              
              if obj.productType == "reserve"{
                
                bid = ["maxBid": "0","startPrice":"\(obj.startingPrice!)"]
                val = ["bids": bid ,"uid": uid,"token":deviceUUID,"title":obj.title,"state":obj.state,"startPrice":"\(obj.startingPrice!)","rPrice": "\(obj.endPrice!)" ,"description":obj.description,"conditionValue":"\(obj.conditionValue)","condition":"\(obj.condition)","city":obj.city,"chargeTime":startTime,
                       "startTime":startTime,"endTime":endTime,"imagesCount":"\(obj.images?.count  ?? 0 )", "currency_string" : obj.currency_string , "currency_symbol": obj.currency_symbol ] as [String:Any]
                
                
                
              }
              else{
                //non reserve
                bid = ["maxBid": "0","startPrice":"\(obj.startingPrice!)"]
                val = ["bids": bid ,"uid": uid,"token":deviceUUID,"title":obj.title,"state":obj.state,"startPrice":"\(obj.startingPrice!)","description":obj.description,"conditionValue":"\(obj.conditionValue)","condition":"\(obj.condition)","city":obj.city,"chargeTime":startTime,
                       "startTime":startTime,"endTime":endTime,"imagesCount":"\(obj.images?.count  ?? 0 )"  , "currency_string" : obj.currency_string , "currency_symbol": obj.currency_symbol] as [String:Any]
              }
              
              
            }
            
            val["platform"] = "iOS"
            let flagAutoRelist = self?.previousData["autoReList"] as? Bool ?? false
            let valueAutoRelist = flagAutoRelist ? "yes" : "no"
            val["autoReList"] = valueAutoRelist
            
            let ref2 = ref.child("products").child(obj.category).child(obj.productType!).child(obj.state).childByAutoId()
            ref2.updateChildValues(val, withCompletionBlock: { [weak self] (error, _ ) in
              guard let strongSelfInner = self else { return }
              guard error == nil else {
                print("Could not post product data to Database")
                showSwiftMessageWithParams(theme: .error, title: "Oops. Product was not posted successfully", body: "A Database error Occured")
                return
              }
              
              strongSelfInner.showToast(message: "Product Data Posted Successfully ")
              //upload image
              let key = ref2.key
              
              strongSelfInner.uploadProductImages(referenceOfProduct: ref2, uid: uid, product: obj ,imageName: startTime as! Int, completion: {[weak self ] (success) in
                
                guard let thisInner = self else { return }
                flagProductPostingCompleted = true
                DispatchQueue.main.async { thisInner.imgFidget.hide() }
                thisInner.dimBack(flag: false)
                
                guard success else {
                  
                  
                  thisInner.performSegue(withIdentifier: "fromUploadToFinal", sender: nil)
                  showSwiftMessageWithParams(theme: .warning, title: "Image Error", body: "Your Product was posted successfully but image could not be Posted. ")
                  return
                }
                
                
                
                thisInner.performSegue(withIdentifier: "fromUploadToFinal", sender: nil)
                if success, let auctionType = obj.productType{
                  
                  let temp = ["auctionType":auctionType,"category":obj.category,"state":obj.state , "currency_string" : obj.currency_string , "currency_symbol": obj.currency_symbol  ] as [String:Any]
                    ref.child("users").child(uid).child("products").child("selling").child(key!).updateChildValues(temp)
                  
                  
                  
                }else {
                  thisInner.showToast(message: "Could not add this Item to your Selling List")
                }
              })
              
              
              
            })
            //print(ref2)
            
            
            
          }
        }
      }
      
        }
        
    

    let alert = UIAlertController.init(title: "Item Listing", message: "Are you sure you want to list your item with the provided information ?", preferredStyle: .alert)
    let actionYes = UIAlertAction.init(title: "Yes, Proceed", style: .default) { (action) in
      listItem()
        }
        let actionCancel = UIAlertAction.init(title: "Update Information", style: .cancel)
        alert.addAction(actionYes)
        alert.addAction(actionCancel)
        self.present(alert, animated: true)
    }else {
        showSwiftMessageWithParams(theme: .error, title: "", body: "Please add location where item is available", durationSecs: 15, layout: .cardView, position: .center)
    }
    
   

   
  }
  
  
  @IBAction func zipCodeTextFieldAction(_ sender: Any) {
    
    
    
  }
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    if textField == nameOfCompanyTextField {
      detailOfCompanyTextField.becomeFirstResponder()
    }
    
    return true
  }
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField.tag == 2  {
        if (textField.text?.count)! > 6 {
            let maxLength = 6
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        
        
        
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        
        
        
        
        
        
        return allowedCharacters.isSuperset(of: characterSet)
    }
    return true
  }
  
  
  
  func resizeImage(image: UIImage) -> Data{
    
    
    
    var actualHeight:Float = Float(image.size.height)
    var actualWidth:Float = Float(image.size.width)
    var newHeight:Float = 0.0
    let newWidth:Float = 500.0
    
    let compressionQuality:Float = 0.25;//50 percent compression
    
    var aspectRatio:Float = actualWidth/actualHeight
    
    newHeight = newWidth/aspectRatio
    
    
    
    let maxRatio:Float = newWidth/newHeight;
    
    if (actualHeight > newHeight || actualWidth > newWidth)
    {
      if(aspectRatio < maxRatio)
      {
        //adjust width according to maxHeight
        aspectRatio = newHeight / actualHeight;
        actualWidth = aspectRatio * actualWidth;
        actualHeight = newHeight;
      }
      else if(aspectRatio > maxRatio)
      {
        //adjust height according to maxWidth
        aspectRatio = newWidth / actualWidth;
        actualHeight = aspectRatio * actualHeight;
        actualWidth = newWidth;
      }
      else
      {
        actualHeight = newHeight;
        actualWidth = newWidth;
      }
    }
    
    let height = Double(actualHeight)
    let width = Double(actualWidth)
    
    
    let rect = CGRect(x: 0.0, y: 0.0, width: width, height: height)
    UIGraphicsBeginImageContext(rect.size)
    image.draw(in: rect)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    let imageData = UIImagePNGRepresentation(img!)
    UIGraphicsEndImageContext()
    return imageData!//UIImage(data: imageData ?? Data())!
    
    
    
    
    
  }
  
  
  
}
