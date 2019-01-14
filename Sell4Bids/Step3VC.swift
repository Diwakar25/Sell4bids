//
//  Step3VC.swift
//  socialLogins
//
//  Created by H.M.Ali on 10/6/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth
import IQKeyboardManagerSwift

class Step3VC: UIViewController,UITextFieldDelegate {
  
    
    @IBAction func btnpayperoidshow(_ sender: Any) {
        showPayPeroid()
    }
    
    
    @IBAction func btnshowlistindefinitely(_ sender: Any) {
        
        showListIndefinitely()
    }
    
    @IBAction func btnshowlistingduration(_ sender: Any) {
   
        showListingDuration()
    
    
    }
    
    
    
    
    
    @IBOutlet weak var listdurationheight: NSLayoutConstraint!
    @IBAction func listingdurationBtn(_ sender: Any) {
        
        showListingdaysmessage()
    }
    @IBOutlet weak var reservepricelabel: UILabel!
    
    @IBAction func btntouchlistingitem(_ sender: Any) {
        
        showListingdetials()
   
    }
    
    
    
    
  //MARK:- Properties
  @IBOutlet weak var withReservePriceView: UIView!
  @IBOutlet weak var withoutReservePriceView: UIView!
  @IBOutlet weak var lastView: UIView!
  @IBOutlet weak var viewBidding: UIView!
  @IBOutlet weak var viewBuyItNow: UIView!
  @IBOutlet weak var acceptOfferView: DesignableView!
  @IBOutlet weak var listIdefinitelyView: DesignableView!
   
    
  @IBOutlet weak var viewSegmentControl: UIView!
  @IBOutlet weak var nextBtn: DesignableButton!
  
  
  //textFields
  
  @IBOutlet weak var priceTextField: DesignableUITextField!
  
  @IBOutlet weak var StartingPriceTextField: DesignableUITextField!
  @IBOutlet weak var reservePriceTextField: DesignableUITextField!
  @IBOutlet weak var reserveTFPicker: textFieldWithNoCopyPasteSelect!
  @IBOutlet weak var withoutReserveTFPicker: DesignableUITextField!
  @IBOutlet weak var duration: UITextField!
  @IBOutlet weak var quantityTextField: DesignableUITextField!
  
  
  //buttons
  
  @IBOutlet weak var viewListingDuration: UIView!
  @IBOutlet weak var btnCheckListIndefinitely: DesignableButton!
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  
  @IBOutlet weak var btnCheckAcceptOffers: UIButton!
  @IBOutlet weak var topConstraintOfAcceptOffer: NSLayoutConstraint!
  
  
  //job view outlets
  
  @IBOutlet weak var jobView: UIView!
  @IBOutlet weak var jobSalaryView: UIView!
  @IBOutlet weak var jobDetailView: UIView!
  @IBOutlet weak var payPeriodView: DesignableView!
  @IBOutlet weak var listIndefinitelyView: UIView!
  @IBOutlet weak var listingDurationView: DesignableView!
  @IBOutlet weak var jobAcceptOfferView: DesignableView!
  
  @IBOutlet weak var btnAddReservePriceTick: UIButton!
  
  
  //TextFields
  @IBOutlet weak var jobPayPeriodTextField: DesignableUITextField!
  @IBOutlet weak var jobListingDurationTextField: DesignableUITextField!
  @IBOutlet weak var jobSalaryTextField: UITextField!
  
  
  //Buttons
  @IBOutlet weak var jobListIndefinitelyBtn: DesignableButton!
  @IBOutlet weak var jobAcceptOfferBtn: DesignableButton!
  
  
  //constraints
  @IBOutlet weak var jobDetailViewHeight: NSLayoutConstraint!
  @IBOutlet weak var payPeriodViewHeight: NSLayoutConstraint!
  @IBOutlet weak var acceptOfferTopSpace: NSLayoutConstraint!
  
  
  @IBOutlet weak var btnAutoRelistWithoutReserve: UIButton!
  
  @IBOutlet weak var viewListDuration: UIView!
  
  
  //MARK:- Variables
  
  var previousData = [String:Any]()
  var picker1 = UIPickerView()
  var picker2 = UIPickerView()
  var picker3 = UIPickerView()
  var picker4 = UIPickerView()
  var picker5 = UIPickerView()
  
  var accceptOfferFlag = false
  var listIndefinitelyFlag = false
  var reservePriceFlag = false
  var acceptOffers = "no"
  var country = String()
  var currency_String = String()
  var currency_Symbol = String()
    var defaults = UserDefaults.standard
  
  var list = ["3 Days","5 Days","7 Days","10 Days", "15 Days","21 Days","30 Days"]
  var list2 = ["3 Days","5 Days","7 Days", "10 Days", "15 Days"]
  var payPeriodArray = ["Daily", "BiWeekly", "Weekly", "Monthly","Project based"]
  var selectedDuration: String?
  var isJob = false
  
  
  var check = true
  var withCheck = true
  var startingPriceCheck = true
  var salaryCheck = true
    var currencyChar : Character = "$"
  
  @IBOutlet weak var viewAcceptOffers: UIView!
  @IBOutlet weak var lblListIndefinitely: UILabel!
  @IBOutlet weak var viewAutomaticRelisting: UIView!
  
  @IBOutlet weak var btnAutoRelistReserved: UIButton!
  
  @IBOutlet weak var viewAutoRelistWithoutReserve: UIView!
  
    @IBOutlet weak var viewDuration: UIView!
    @IBOutlet weak var viewAutoRelistBuyNow: UIView!
  
  @IBOutlet weak var btnAutoRelistBuyNow: UIButton!
  //MARK:- View Life Cycle
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
    
  override func viewDidLoad() {

    
    duration.rightView?.frame = CGRect(x: 10, y: 10, width: 10, height: 10)
    if isJob {
        viewSegmentControl.isHidden = true
    }else{
        viewSegmentControl.isHidden = false
    }
    super.viewDidLoad()
    
    print("Before Saved Price = \(priceTextField.text)")
    
    
    //Save Half item post in Memory
    //Ahmed Baloch
    if Finished == false {
        
        if isJob {
           
            
            if self.defaults.value(forKey: "JobSalary") as? String != nil {
                let value = self.defaults.value(forKey: "JobSalary") as? String
                self.jobSalaryTextField.text = value!
            }
            
            
            if self.defaults.value(forKey: "Payperiodtext") as? String != nil {
                let value = self.defaults.value(forKey: "Payperiodtext") as? String
                print("Value = \(value)")
                self.jobPayPeriodTextField.text = value!
            }
            
            
            if self.defaults.value(forKey: "JobListInfinity") as? Bool != nil {
                let value = self.defaults.value(forKey: "JobListInfinity") as? Bool
                self.jobListIndefinitelyBtn.isSelected = value!
                if jobListIndefinitelyBtn.isSelected == true{
                    self.listingDurationView.isHidden = true
                    listIndefinitelyFlag = true
                    self.acceptOfferTopSpace.constant = 10
                    print(self.payPeriodView.frame.height)
                    
                }
                else{
                    self.listingDurationView.isHidden = false
                    self.listIndefinitelyFlag = false
                    self.acceptOfferTopSpace.constant = self.payPeriodView.frame.height+20
                    
                }
                
                
            }
            
           
            if self.defaults.value(forKey: "JobListduration") as? String != nil {
                let value = self.defaults.value(forKey: "JobListduration") as? String
                self.jobListingDurationTextField.text = value!
            }
            
           
            
            if self.defaults.value(forKey: "JobAcceptOffer") as? Bool != nil {
                let value = self.defaults.value(forKey: "JobAcceptOffer") as? Bool
                self.jobAcceptOfferBtn.isSelected = value!
            }
            
            
            
        }else {
            if self.defaults.value(forKey: "Price") as? String != nil {
                let value = self.defaults.value(forKey: "Price") as? String
                
                print("Price = \(value)")
                priceTextField.text = value
            }
            
            if self.defaults.value(forKey: "quantity") as? String != nil {
                quantityTextField.text = self.defaults.value(forKey: "quantity") as? String
            }
            
            if self.defaults.value(forKey: "ListIndefinitely") as? Bool != nil {
                let value = self.defaults.value(forKey: "ListIndefinitely") as! Bool
                
                self.btnCheckListIndefinitely.isSelected = value
                
                if isJob == true{
                    if btnCheckListIndefinitely.isSelected == true{
                        self.listingDurationView.isHidden = true
                        listIndefinitelyFlag = true
                        self.acceptOfferTopSpace.constant = 10
                        print(self.payPeriodView.frame.height)
                        
                    }
                    else{
                        self.listingDurationView.isHidden = false
                        self.listIndefinitelyFlag = false
                        self.acceptOfferTopSpace.constant = self.payPeriodView.frame.height+20
                        
                    }
                    
                }
                else{
                    if btnCheckListIndefinitely.isSelected {
                        
                        viewListingDuration.isHidden = true
                        //topConstraintOfAcceptOffer.constant =  (viewListingDuration.frame.height * -1)
                        listIndefinitelyFlag = true
                        
                        
                        viewAcceptOffers.isHidden = true
                        
                        viewAutoRelistBuyNow.isHidden = true
                    }
                    else{
                        
                        viewListingDuration.isHidden = false
                        listIndefinitelyFlag = false
                        viewAcceptOffers.isHidden = false
                        viewAutoRelistBuyNow.isHidden = false
                        
                        //topConstraintOfAcceptOffer.constant = 8
                        
                    }
                    
                    
                    if self.defaults.value(forKey: "AuctionStartingPrice") as? String != nil {
                        let value = self.defaults.value(forKey: "AuctionStartingPrice") as? String
                        self.StartingPriceTextField.text = value!
                    }
                    
                   
                    
                    if self.defaults.value(forKey: "AddReservePrice") as? Bool != nil {
                        let value =  self.defaults.value(forKey: "AddReservePrice") as? Bool
                        self.btnAddReservePriceTick.isSelected = value!
                      
                        
                    }
                    

                    if self.defaults.value(forKey: "AuctionListDuratoin") as? String != nil {
                        let value = self.defaults.value(forKey: "AuctionListDuratoin") as? String
                        self.withoutReserveTFPicker.text = value!
                    }
                    
                    if self.defaults.value(forKey: "AuctionAutoLIst") as? Bool != nil {
                        let value = self.defaults.value(forKey: "AuctionAutoLIst") as? Bool
                        self.btnAutoRelistReserved.isSelected = value!
                    }
                }
            }
            
            if self.defaults.value(forKey: "ListDuration") as? String != nil {
                self.duration.text = self.defaults.value(forKey: "ListDuration") as? String
            }
            
            if self.defaults.value(forKey: "AcceptOffers") as? Bool != nil {
                self.btnCheckAcceptOffers.isSelected = self.defaults.value(forKey: "AcceptOffers") as! Bool
            }
            
            if self.defaults.value(forKey: "AutomaticRelisting") as? Bool != nil {
                self.btnAutoRelistBuyNow.isSelected = self.defaults.value(forKey: "AutomaticRelisting") as! Bool
            }
            
            
            
            if self.defaults.value(forKey: "AuctionListDuratoin") as? String != nil {
                let value = self.defaults.value(forKey: "AuctionListDuratoin") as? String
                self.reserveTFPicker.text = value!
            }
            
         
            
            if self.defaults.value(forKey: "ReservePrice") as? String != nil {
                let value = self.defaults.value(forKey: "ReservePrice") as? String
                reservePriceTextField.text = value!
            }
            
        }
        
      
        
        
        
    }
    
    
    

    if gpscountry == "USA" {
        self.currency_String = "US Dollars"
        self.currency_Symbol = "$"
        self.currencyChar = "$"
        
    }else if gpscountry == "IN" {
        self.currency_String = "Indains rupees"
        self.currency_Symbol = "₹"
        self.currencyChar = "₹"
    }
    addLeftHomeBarButtonToTop()
    addDoneLeftBarBtn()
    //addDoneButtonOnKeyboard()
    navigationItem.title = "Pricing"
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = UIColor.white
    //delegate
    priceTextField.delegate = self
    StartingPriceTextField.delegate = self
    reservePriceTextField.delegate = self
    quantityTextField.delegate = self
    jobPayPeriodTextField.delegate = self
    jobListingDurationTextField.delegate = self
    jobSalaryTextField.delegate = self
    
    nextBtn.addShadowView()

    if gpscountry == "USA" {
          StartingPriceTextField.placeholder = "$"
         jobSalaryTextField.placeholder = "$"
        priceTextField.placeholder = "$"
    }else if gpscountry
        == "IN" {
        StartingPriceTextField.placeholder = "₹"
         jobSalaryTextField.placeholder = "₹"
         priceTextField.placeholder = "₹"
    }
   
    
    withoutReservePriceView.isHidden = false
    withReservePriceView.isHidden = true
    
    
    //create picker
    picker1.delegate = self
    picker2.delegate = self
    picker3.delegate = self
    picker4.delegate = self
    picker5.delegate = self
    
    
    duration.inputView = picker1
    withoutReserveTFPicker.inputView = picker2
    reserveTFPicker.inputView = picker3
    jobPayPeriodTextField.inputView = picker4
    jobListingDurationTextField.inputView = picker5
    
    //createToolbar
    createToolBar(textField: duration)
    createToolBar(textField: withoutReserveTFPicker)
    createToolBar(textField: reserveTFPicker)
    createToolBar(textField: jobPayPeriodTextField)
    createToolBar(textField: jobListingDurationTextField)
    
    
//    withoutReserveTFPicker.text = "3 Days"
//    reserveTFPicker.text = "3 Days"
//    jobPayPeriodTextField.text = "Monthly"
//    jobListingDurationTextField.text = "7 Days"
    
    let font = AdaptiveLayout.HeadingBold
    
    segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: font],
                                            for: .normal)
    priceTextField.keyboardType = .numberPad
    
    
    if isJob == true{
      self.jobView.isHidden = false
      self.viewBuyItNow.isHidden = true
      self.viewBidding.isHidden = true
      jobDetailView.addShadowView()
      jobSalaryView.addShadowView()
      
    }
    else{
      self.jobView.isHidden = true
      self.viewBuyItNow.isHidden = false
      self.viewBidding.isHidden = true
    }
    
    //topConstraintOfAcceptOffer.constant = 70
    
    setupViews()
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    enableIQKeyBoardManager(flag: false)
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    enableIQKeyBoardManager()
  }
  
  //MARK:- Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "fromStep3ToStep4"{
      let destination = segue.destination as! Step4VC
      destination.previousData = sender as! [String: Any]
      
      if isJob == true{
        destination.isJob = true
      }
      else{
        destination.isJob = false
      }
    }
  }
  
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first{
      if isJob == true{
        
        if self.jobSalaryTextField.isFirstResponder{
          jobSalaryTextField.resignFirstResponder()
        }
        
      }
      else if segmentedControl.selectedSegmentIndex == 0{
        if touch.view != quantityTextField && touch.view != priceTextField{
          if quantityTextField.isFirstResponder{
            
            quantityTextField.resignFirstResponder()
          }
          else if priceTextField.isFirstResponder{
            
            priceTextField.resignFirstResponder()
          }
          
        }
      }
      else{
        if touch.view != StartingPriceTextField && touch.view != reservePriceTextField {
          if StartingPriceTextField.isFirstResponder{
            
            StartingPriceTextField.resignFirstResponder()
          }
          else if reservePriceTextField.isFirstResponder{
            
            reservePriceTextField.resignFirstResponder()
          }
          
        }
      }
    }
  }
  ///adds done button on keyboard

  
  
  
}//end of view controller


//MARK:- Picker View
extension Step3VC : UIPickerViewDelegate, UIPickerViewDataSource{
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if pickerView == picker1 || pickerView == picker5{
      return list.count
    }
    else if pickerView == picker4{
      return self.payPeriodArray.count
    }
    else{
      return list2.count
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if pickerView == picker1 || pickerView == picker5{
      return list[row]
    }
    else if pickerView == picker4{
      return self.payPeriodArray[row]
    }
    else{
      return list2[row]
    }
    //return list[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectedDuration = list[row]
    if isJob == true{
      
      if jobPayPeriodTextField.isFirstResponder{
        jobPayPeriodTextField.text = self.payPeriodArray[row]
      }
      else if jobListingDurationTextField.isFirstResponder{
        jobListingDurationTextField.text = list[row]
      }
      
    }
    else if viewBuyItNow.isHidden == false && viewBidding.isHidden == true{
      duration.text = selectedDuration
    }
    else{
      if withoutReservePriceView.isHidden == false && withReservePriceView.isHidden == true{
        withoutReserveTFPicker.text = selectedDuration
        
      }
      else{
        reserveTFPicker.text = selectedDuration
      }
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    var label : UILabel
    
    if let view = view as? UILabel{
      label = view
    }
    else{
      label = UILabel()
    }
    label.textColor = .black
    label.textAlignment = .center
    label.font = AdaptiveLayout.normalBold
    if pickerView == picker1 || pickerView == picker5{
      label.text = list[row]
    }
    else if pickerView == picker4{
      label.text = payPeriodArray[row]
    }
    else{
      label.text = list2[row]
    }
    return label
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == jobSalaryTextField {
      textField.resignFirstResponder()
    }
    else if textField == priceTextField {
      textField.resignFirstResponder()
      quantityTextField.becomeFirstResponder()
    }
    return true
  }
    
   
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.tag == 6 || textField.tag == 8 || textField.tag == 9 || textField.tag == 10 {
        print("called Editing")
        var price = textField.text
            let i = price!.characters.index(of: currencyChar)
            if i != nil {
                
                price!.remove(at: i!)
            }else {
                print("called Editing nil")
            }
        textField.text = price!
        }
        
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
      
        if textField.tag == 6 || textField.tag == 8 || textField.tag == 9 || textField.tag == 10 {
        
            let temp = textField.text
            if gpscountry == "USA" {
                if temp?.contains(currency_Symbol)==false  {
                    textField.text = currency_Symbol + temp!
                    check = true
                }
            }else if  gpscountry == "IN" {
                if temp?.contains(currency_Symbol)==false  {
                    textField.text = currency_Symbol + temp!
                    self.check = true
                }
            }
           
     
        
        }
        
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
      
        
    }
    
    
   
   
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
   
    
    if textField.tag == 6 || textField.tag == 7 || textField.tag == 8 || textField.tag == 9 || textField.tag == 10 {
        if (textField.text?.count)! > 5 {
            let maxLength = 6
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
  
  func showInfoPopup(_ title : String, _ message: String ) {
    
    showSwiftMessageWithParams(theme: .info, title: title, body: message, durationSecs: -1, layout: .cardView, position: .center)
    
  }
    
    
    func showListingdetials() {
        let title = "Listing Duration"
        let messageText = "Number of days until you will recieve offers on listed item. You can relist item when this item is ended."
        
        showSwiftMessageWithParams(theme: .info, title: title, body: messageText, durationSecs: -1, layout: .cardView, position: .center)
    }
    
    
    
    func showAutoRelistInfoPopup() {
        let title = "Automatic Relisting"
        let messageText = "Your item will be automatically relisted after 1 hour when sale is ended."
        
        showSwiftMessageWithParams(theme: .info, title: title, body: messageText, durationSecs: -1, layout: .cardView, position: .center)
    }
    
    
    func showListingdaysmessage() {
        let title = "Listing Duration"
        let messageText = "Number of days when bidding will be ended highest bidder will be declared as winner."
        
        showSwiftMessageWithParams(theme: .info, title: title, body: messageText, durationSecs: -1, layout: .cardView, position: .center)
    }
    
    
    func showPayPeroid() {
        let title = "Pay Period"
        let messageText = "Duration when user will be get paid."
        
        showSwiftMessageWithParams(theme: .info, title: title, body: messageText, durationSecs: -1, layout: .cardView, position: .center)
    }
    
    func showListIndefinitely() {
        let title = "List Indefinitely"
        let messageText = "Listing time of item will not end.Buyers can send offers any time. However you end listing any time you want, from item detail page after listing the item."
        
        showSwiftMessageWithParams(theme: .info, title: title, body: messageText, durationSecs: -1, layout: .cardView, position: .center)
    }
    
    func showListingDuration() {
        let title = "Listing Duration"
        let messageText = "Number of days until you will receive offers on listed item. You can relist item when this time is ended."
        
        showSwiftMessageWithParams(theme: .info, title: title, body: messageText, durationSecs: -1, layout: .cardView, position: .center)
    }
    
    func showAcceptOffers() {
        let title = "Accept Offers"
        let messageText = "Buyer will be able to send you offers on different prices instead of fixed price."
        
        showSwiftMessageWithParams(theme: .info, title: title, body: messageText, durationSecs: -1, layout: .cardView, position: .center)
    }
    
    
}

  
  


//MARK:- Actions
extension Step3VC {

    
    
    
  
  @IBAction func btnInfoListIndefTapped(_ sender: UIButton) {
    
    let message = PromptMessages.listIndefinitelyDescription
    let title = PromptTitles.listIndefinite
    showInfoPopup(title, message)
    
  }
  
  @IBAction func btnInfoAcceptOffersTapped(_ sender: UIButton) {
    let message = PromptMessages.acceptOffersInfo
    let title = PromptTitles.acceptOffers
    showInfoPopup(title, message)
  }
  
  //buy now
  @IBAction func btnInfoAutoRelistTapped(_ sender: UIButton) {
    showAutoRelistInfoPopup()
  }
  
  //auction
  @IBAction func btninfoAutmaticRelisting(_ sender: UIButton) {
    showAutoRelistInfoPopup()
  }
  
  @IBAction func btnAutoRelistBuyNowTapped(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
  }
  @IBAction func btnAutoRelistWithoutReserveTapped(_ sender: UIButton) {
    
    sender.isSelected = !sender.isSelected
    
  }
  
  @IBAction func btnAutoRelistReserveTapped(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
  }
  
  
  
  @IBAction func segmentValueAction(_ sender: Any) {
    
    if btnAddReservePriceTick.isSelected==false{
        reservePriceTextField.isHidden = true
        reservepricelabel.isHidden = true
        
        reservePriceFlag = false
        withoutReservePriceView.isHidden = false
        withReservePriceView.isHidden = true
    }
    else{
        reservepricelabel.isHidden = false
        reservePriceTextField.isHidden = false
        reservePriceFlag = true
        withoutReservePriceView.isHidden = true
        withReservePriceView.isHidden = false
    }
    
    
    
    if segmentedControl.selectedSegmentIndex == 0{
      self.jobView.isHidden = true
      viewBuyItNow.isHidden = false
      viewBidding.isHidden = true
    }
    else{
      self.jobView.isHidden = true
      viewBuyItNow.isHidden = true
      viewBidding.isHidden = false
    }
  }
  
  @IBAction func checkBox(_ sender: DesignableButton) {
    
    sender.isSelected = !sender.isSelected
    
    if isJob == true{
      if sender.isSelected == true{
        self.listingDurationView.isHidden = true
        listIndefinitelyFlag = true
        self.acceptOfferTopSpace.constant = 10
        print(self.payPeriodView.frame.height)
        
      }
      else{
        self.listingDurationView.isHidden = false
        self.listIndefinitelyFlag = false
        self.acceptOfferTopSpace.constant = self.payPeriodView.frame.height+20
        
      }
      
    }
    else{
      if sender.isSelected {
        
        viewListingDuration.isHidden = true
        //topConstraintOfAcceptOffer.constant =  (viewListingDuration.frame.height * -1)
        listIndefinitelyFlag = true
        
        
        viewAcceptOffers.isHidden = true
        
        viewAutoRelistBuyNow.isHidden = true
      }
      else{
       
        viewListingDuration.isHidden = false
        listIndefinitelyFlag = false
        viewAcceptOffers.isHidden = false
        viewAutoRelistBuyNow.isHidden = false
        
        //topConstraintOfAcceptOffer.constant = 8
        
      }
    }
    print("Done")
  }
  
  @IBAction func editingChage(_ sender: UITextField) {
    
    
    
  }
 
  @IBAction func price(_ sender: Any) {
    
    
   
  }
  
  
  
  
  @IBAction func reservePriceTextFieldAction(_ sender: Any) {
   
    
  }
  
  
  @IBAction func startingPriceTextFieldAction(_ sender: Any) {
   
  }
  
  @IBAction func addReserveBtnAction(_ sender: DesignableButton) {
    
    sender.isSelected = !sender.isSelected
    if sender.isSelected==false{
      reservePriceTextField.isHidden = true
     reservepricelabel.isHidden = true
        
        reservePriceFlag = false
      withoutReservePriceView.isHidden = false
      withReservePriceView.isHidden = true
    }
    else{
        reservepricelabel.isHidden = false
      reservePriceTextField.isHidden = false
      reservePriceFlag = true
      withoutReservePriceView.isHidden = true
      withReservePriceView.isHidden = false
    }
    
  }
  
  @IBAction func acceptOfferBtnAction(_ sender: DesignableButton) {
    
    sender.isSelected = !sender.isSelected
    if sender.isSelected == true{
      
      accceptOfferFlag = true
      acceptOffers = "yes"
      //viewToHide.isHidden = true
      //topConstraintOfAcceptOffer.constant = 10
    }
    else{
      accceptOfferFlag = false
      //viewToHide.isHidden = false
      
      //topConstraintOfAcceptOffer.constant = (10+listIdefinitelyView.frame.height+10)
      
    }
    print("Done")
    
  }
  
  @IBAction func nextBtnAction(_ sender: Any) {
    
    jobSalaryTextField.becomeFirstResponder()
    
    //Save half item post on Memory
    //Ahmed Baloch
    if Finished == false {
    if isJob {
        self.defaults.set(self.jobSalaryTextField.text, forKey: "JobSalary")
        self.defaults.set(jobPayPeriodTextField.text, forKey: "Payperiodtext")
        self.defaults.set(self.jobListIndefinitelyBtn.isSelected, forKey: "JobListInfinity")
        self.defaults.set(self.jobListingDurationTextField.text, forKey: "JobListduration")
        self.defaults.set(self.jobAcceptOfferBtn.isSelected, forKey: "JobAcceptOffer")
    }else {
        
        self.defaults.set(priceTextField.text, forKey: "Price")
        self.defaults.set(quantityTextField.text, forKey: "quantity")
        self.defaults.set(btnCheckListIndefinitely.isSelected, forKey: "ListIndefinitely")
        self.defaults.set(duration.text, forKey: "ListDuration")
        self.defaults.set(btnCheckAcceptOffers.isSelected, forKey: "AcceptOffers")
        self.defaults.set(btnAutoRelistBuyNow.isSelected, forKey: "AutomaticRelisting")
        self.defaults.set(StartingPriceTextField.text, forKey: "AuctionStartingPrice")
        self.defaults.set(btnAddReservePriceTick.isSelected, forKey: "AddReservePrice")
        self.defaults.set(reservePriceTextField.text, forKey: "ReservePrice")
        self.defaults.set(reserveTFPicker.text, forKey: "AuctionListDuratoin")
        self.defaults.set(btnAutoRelistReserved.isSelected, forKey: "AuctionAutoLIst")
        
        
    }
    }
        
    
    
    var dic = [String:Any]()
    var days = 0
    if isJob == true{
      segmentedControl.isHidden = true
      guard !(jobSalaryTextField.text?.isEmpty)! else{
        //self.alert(message: "Please enter valid Salary", title: "ERROR")
        showSwiftMessageWithParams(theme: .error, title: "Listing Error", body: "Please enter salary amount in text field")
        jobSalaryTextField.shake()
        return
      }
      var salary = jobSalaryTextField.text!
      print(salary)
        if gpscountry == "USA" {
            if salary != "" && salary != "\(currency_Symbol)"{
                let i = salary.characters.index(of: currencyChar)
                if i != nil{
                    salary.remove(at: i!)
                }
                print(salary)
            }
            else{
                showSwiftMessageWithParams(theme: .error, title: "Listing Error", body: "Please enter valid salary amount in text field")
                return
            }
        }else if gpscountry == "IN" {
            if salary != "" && salary != "\(currency_Symbol)"{
                let i = salary.characters.index(of: currencyChar)
                if i != nil{
                    salary.remove(at: i!)
                }
                print(salary)
            }
            else{
                showSwiftMessageWithParams(theme: .error, title: "Listing Error", body: "Please enter valid salary amount in text field")
                return
            }
        }
      
      guard let intSalary = Int(salary), intSalary >= 1 else{
        showSwiftMessageWithParams(theme: .error, title: "Listing Error", body: "Please enter valid salary amount in text field")
        return
      }
      
      if self.listIndefinitelyFlag == false{
        
        //                //check null
        guard let dur = self.jobListingDurationTextField.text else{
          self.alert(message: "Please select feasible duration", title: "ERROR")
          return
        }
        
        var array = dur.components(separatedBy: " ")
        print(array[0])
        if !array[0].isEmpty {
          days = Int(array[0])!
        }
        else{
          self.alert(message: "Please select feasible duration", title: "ERROR")
          return
        }
        
        print(days)
        
      }
      else {
        days = -1
      }
      
      guard let pay = self.jobPayPeriodTextField.text else{
        self.alert(message: "please select valid pay period", title: "ERROR")
        showSwiftMessageWithParams(theme: .error, title: "Listing Error", body: "Please select valid pay period")
        return
      }
      
      
        dic = ["title":self.previousData["title"]as Any,"employmentType":self.previousData["employmentType"] as Any,"benefits":self.previousData["benefits"],"category":self.previousData["category"] as! String,"condition":self.previousData["condition"] as! String,"conditionValue":self.previousData["conditionValue"] as! Int,"description":previousData["description"] as! String, "price": salary as! String,"duration":days,"payPeriod":pay,"acceptOffer":self.acceptOffers, "currency_string" : self.currency_String , "currency_symbol" : self.currency_Symbol ]  as [String: Any]
      
      dic["autoRelist"] = false
     
      self.performSegue(withIdentifier: "fromStep3ToStep4", sender: dic)
    }
      
    
        
      //end isJob == true
    else{
        segmentedControl.isHidden = false
        guard var price = priceTextField.text else{
            showSwiftMessageWithParams(theme: .error, title: "Listing Error", body: "Please enter price for your item.")
            return
        }
      if segmentedControl.selectedSegmentIndex == 0{
        
        //buy it now
        var days = 0
        
        guard let quantity = Int(quantityTextField.text!), quantity >= 1 else{
           showSwiftMessageWithParams(theme: .error, title: "Listing Error", body: "Please enter valid quantity.")
           
          return
        }
        
        
        guard var salaryprice = jobSalaryTextField.text else{
            showSwiftMessageWithParams(theme: .error, title: "Listing Error", body: "Please enter Salary for your item.")
            return
        }
        
        
        print(quantity)
        
        
        if segmentedControl.selectedSegmentIndex == 1 {
       
        
        
        
        if salaryprice == ""{
            showSwiftMessageWithParams(theme: .error, title: "Listing Error", body: "Please enter Salary for your item.")
            
            return
        }
        
      
            
            
            let i = salaryprice.characters.index(of:currencyChar)
            if i != nil {
                
                salaryprice.remove(at: i!)
        
            
        }
        
        
        
        print(price)
        guard let intSalaryPrice = Int(salaryprice) , intSalaryPrice >= 1 else{
            self.alert(message: "Please enter valid price", title: "ERROR")
            return
        }
        
        }else {
        
        
       
        
        
      
        if price == ""{
            showSwiftMessageWithParams(theme: .error, title: "Listing Error", body: "Please enter price for your item.")
          
          return
        }
        
        print(price)
        //
      
           
            let j = price.characters.index(of: currencyChar)
        
            if j != nil {
                
                 price.remove(at: j!)
            }else {
                self.alert(message: "Please enter valid price", title: "ERROR")
                return
            }
         
    
        
        print(price)
       
        }
        guard let intPrice = Int(price) , intPrice >= 1 else{
            self.alert(message: "Please enter valid price", title: "ERROR")
            return
        }
        print(intPrice)
        
        if self.listIndefinitelyFlag == false{
          
          //                //check null
          guard let dur = self.duration.text else{
           
             showSwiftMessageWithParams(theme: .error, title: "Listing Error", body: "Please select feasible duration")
            return
          }
          //
          //                //get days
          var array = dur.components(separatedBy: " ")
          print(array[0])
          if !array[0].isEmpty {
            days = Int(array[0])!
          }
          else{
           
             showSwiftMessageWithParams(theme: .error, title: "Listing Error", body: "Please select feasible duration")
            return
          }
          
          
          
        }
        else{
          days = -1
        }
        
        
        dic = ["images": previousData["images"] as! [UIImage],"title":self.previousData["title"] as! String, "category":previousData["category"] as! String,"condition":previousData["condition"] as! String,"conditionValue":previousData["conditionValue"] as! Int,"description":previousData["description"] as! String,"price":intPrice as! Int,"quantity":quantity as! Int,"duration":days as! Int,"acceptOffer":self.acceptOffers as! String,"productType":"buy-it-now", "currency_string" : self.currency_String , "currency_symbol" : self.currency_Symbol ] as [String:Any]
        let flagAutoRelist = btnAutoRelistBuyNow.isSelected
        dic["autoReList"] = flagAutoRelist
      }
      else{
        //Auction type
        var days = 0
        var intStartingPrice = -1
        var intReservePrice = -1
        var type = ""
        //shoud not be empty
        
       
        guard !(StartingPriceTextField.text?.isEmpty)! else{
          self.alert(message: "Please enter Starting price", title: "ERROR")
            showSwiftMessageWithParams(theme: .error, title: "Listing Error", body: "Please enter Starting price")
          return
        }
        //print(startingPrice)
        
      
        let startingPrice = StartingPriceTextField.text!.replacingOccurrences(of: "\(currency_Symbol)", with: "")
        //print(startingPrice)
       
        intStartingPrice = Int(startingPrice) ?? 0
        guard let startingpriceval = Int(startingPrice) , startingpriceval >= 1 else{
            self.alert(message: "Please enter valid price", title: "ERROR")
            return
        }
        type = "non-reserve"
        //var dur = 3
        var flagAutoRelist = false
        if reservePriceFlag == true{
          guard !(reservePriceTextField.text?.isEmpty)! else{
              showSwiftMessageWithParams(theme: .error, title: "Listing Error", body: "Please enter Reserve price")
            
            return
          }
          let reservePrice = reservePriceTextField.text!.replacingOccurrences(of: "\(currency_Symbol)", with: "")
          print(reservePrice)
          
          guard let reservePriceInt = Int(reservePrice) else {
            self.alert(message: .strInternalErrorOccured)
            return
          }
          intReservePrice = reservePriceInt
          
          if intStartingPrice >= intReservePrice{
            showSwiftMessageWithParams(theme: .error, title: "Listing Error", body: "Reserve price must be greater than Starting price")
          
            return
          }
          type = "reserve"
          if btnAutoRelistReserved.isSelected { flagAutoRelist = true }
          
          guard let dur = reserveTFPicker.text else{
            //
             showSwiftMessageWithParams(theme: .error, title: "Listing Error", body: "Please select a duration for listing")
            
            return
          }
          
          var array = dur.components(separatedBy: " ")
           
          if array.count > 0 && array.count != 0 {
            if Int(array[0]) != nil {
                  days = Int(array[0])!
            }
          
          }
          else{
            showSwiftMessageWithParams(theme: .error, title: "Listing Error", body: "Please select feasible duration")
            
            return
          }
          
          
        }else {
          //!reservePriceFlag
          if btnAutoRelistWithoutReserve.isSelected { flagAutoRelist = true }
          
          guard let dur = withoutReserveTFPicker.text else{
            //
            showSwiftMessageWithParams(theme: .error, title: "Listing Error", body: "Please select a duration for listing")
            
            return
          }
          
          var array = dur.components(separatedBy: " ")
          
            if array.count > 0  && array.count != 0 {
                if array[0] != nil {
                     days = Int(array[0]) ?? 0
                }else {
                    
                }
           
          }
          else{
             showSwiftMessageWithParams(theme: .error, title: "Listing Error", body: "Please select feasible duration")
            
            return
          }
          
        }
        
        
        dic = ["images": previousData["images"] as! [UIImage],"title":self.previousData["title"] as! String, "category":previousData["category"] as! String,"condition":previousData["condition"] as! String,"conditionValue":previousData["conditionValue"] as! Int,"description":previousData["description"] as! String,"duration": days,"productType":type,"startingPrice":intStartingPrice,"reservePrice":intReservePrice, "currency_string" : currency_String , "currency_symbol" : currency_Symbol] as [String:Any]
        showToast(message: "Selected days = \(days)")
        dic["autoReList"] = flagAutoRelist
      }
      let autoRel = dic["autoReList"]
      print("autoRelist is \(autoRel as Any)")
      self.performSegue(withIdentifier: "fromStep3ToStep4", sender: dic)
      
        }
        
    
    
    }

}

//MARK:- Private functions

extension Step3VC {
  
  
  func addNextButtonToPriceTextField()
  {
    let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    doneToolbar.barStyle = .default
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let done: UIBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(self.nextBtnTfPriceTapped))
    done.tintColor = colorRed
    
    let items = [flexSpace, done]
    doneToolbar.items = items
    doneToolbar.sizeToFit()
    
    priceTextField.inputAccessoryView = doneToolbar
  }
  
  @objc func nextBtnTfPriceTapped() {
    priceTextField.resignFirstResponder()
    quantityTextField.becomeFirstResponder()
  }
  
  
  private func setupViews() {
    
    priceTextField.keyboardType = .decimalPad
    btnAddReservePriceTick.addBorderWithColorAndWidth(color: colorRedPrimay.cgColor, width: 2)
    StartingPriceTextField.makeCornersRound()
    btnAddReservePriceTick.makeCornersRound()
    withoutReserveTFPicker.makeCornersRound()
    reservePriceTextField.makeCornersRound()
    
    //view listing duration
    viewListingDuration.makeCornersRound()
    viewAcceptOffers.makeCornersRound()
    nextBtn.addShadowAndRound()
    btnCheckListIndefinitely.addBorderWithColorAndWidth(color: colorRedPrimay.cgColor   , width: 2)
    btnCheckListIndefinitely.makeCornersRound()
    btnCheckAcceptOffers.addBorderWithColorAndWidth(color: colorRedPrimay.cgColor, width: 2)
    btnCheckAcceptOffers.makeCornersRound()
    jobSalaryTextField.makeCornersRound()
    viewSegmentControl.addShadowView()
    segmentedControl.addShadowAndRound()
    priceTextField.makeRedAndRound()
    quantityTextField.makeRedAndRound()
    StartingPriceTextField.makeRedAndRound()
    reservePriceTextField.makeRedAndRound()
    viewListDuration.makeRedAndRound()
   // withoutReservePriceView.makeRedAndRound()
    reserveTFPicker.RightImage = #imageLiteral(resourceName: "dropArrow")
    reserveTFPicker.RightPadding = 10
    //listIdefinitelyView.makeRedAndRound()
    listIndefinitelyView.makeRedAndRound()
    viewListingDuration.makeRedAndRound()
    viewAcceptOffers.makeRedAndRound()
    btnCheckAcceptOffers.makeRedAndRound()
    jobSalaryTextField.makeRedAndRound()
    //JOB
    payPeriodView.makeRedAndRound()
    jobPayPeriodTextField.RightImage = #imageLiteral(resourceName: "dropArrow")
    jobPayPeriodTextField.RightPadding = 20
    listingDurationView.makeRedAndRound()
    jobListIndefinitelyBtn.makeRedAndRound()
    acceptOfferView.makeRedAndRound()
    jobAcceptOfferBtn.makeRedAndRound()
    
    //shadows
    jobSalaryView.addShadow()
    jobDetailView.addShadow()
    jobView.addShadow()
    viewBidding.addShadow()
    viewBuyItNow.addShadow()
    
    
    viewAutomaticRelisting.makeRedAndRound()
    
    btnAutoRelistReserved.makeRedAndRound()
    viewAutoRelistWithoutReserve.makeRedAndRound()
    viewDuration.makeRedAndRound()
    btnAutoRelistWithoutReserve.makeRedAndRound()
    btnAutoRelistWithoutReserve.isSelected = true
    btnAutoRelistReserved.isSelected = true
    
    addNextButtonToPriceTextField()
    viewAutoRelistBuyNow.makeRedAndRound()
    btnAutoRelistBuyNow.makeRedAndRound()
    listIdefinitelyView.makeRedAndRound()
    listIndefinitelyView.makeRedAndRound()
    
    if isJob {
      jobSalaryTextField.becomeFirstResponder()
    }else {
    
      priceTextField.becomeFirstResponder()
    }
    
  }
  
  func addDoneButtonOnKeyboard(){
    let doneToolBar : UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
    
    doneToolBar.barStyle = UIBarStyle.default
    
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(DonebuttonTapped))
    
    var items = [UIBarButtonItem]()
    items.append(flexSpace)
    items.append(done)
    
    doneToolBar.items = items
    doneToolBar.sizeToFit()
    
    self.quantityTextField.inputAccessoryView = doneToolBar
    
  }
  
  @objc private func DonebuttonTapped() {
    DispatchQueue.main.async {
      self.quantityTextField.resignFirstResponder()
    }
    
  }
  
  
  func createDayPicker(textField: UITextField){
    
    let pickerView = UIPickerView()
    pickerView.delegate = self
    textField.inputView = pickerView
    
  }
  func createToolBar(textField: UITextField){
    
    let toolBar = UIToolbar()
    toolBar.sizeToFit()
    let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDone)
    )
    toolBar.setItems([doneBtn], animated: false)
    toolBar.isUserInteractionEnabled = true
    
    //toolBar.barTintColor = UIColor.red
    toolBar.tintColor = UIColor.red
    
    textField.inputAccessoryView = toolBar
    
  }
  
  @objc func handleDone()
  {
    if isJob == true{
      if jobListingDurationTextField.isFirstResponder{
        jobListingDurationTextField.endEditing(true)
        
      }
      else if jobPayPeriodTextField.isFirstResponder{
        jobPayPeriodTextField.endEditing(true)
      }
      
      
    }
    else if viewBuyItNow.isHidden == false && viewBidding.isHidden == true{
      duration.endEditing(true)
    }
    else{
      if withoutReservePriceView.isHidden == false && withReservePriceView.isHidden == true{
        withoutReserveTFPicker.endEditing(true)
      }
      else{
        reserveTFPicker.endEditing(true)
      }
    }
    
    
  }
  
}
