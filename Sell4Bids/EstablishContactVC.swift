//
//  EstablishContactVC.swift
//  Sell4Bids
//
//  Created by admin on 4/5/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
class EstablishContactVC: UIViewController {
  
  @IBOutlet weak var tableViewContactForm: UITableView!
  var labelNames = ["Name*", "Email Address*", "Mobile No*"]
  var errorMessages = ["Name is required", "Email Address is required", "Mobile No is required"]
  var errorsOccured = [false, false, false]
  var textFieldValues = ["", "", ""]
  
  @IBOutlet weak var viewHeadQuartersMapAndInfo: UIView!
  @IBOutlet weak var lblMessageIsRequired: UILabel!
  @IBOutlet weak var scrollViewMain: UIScrollView!
  @IBOutlet weak var btnSendMessage: UIButton!
  @IBOutlet weak var gmsMapView: GMSMapView!
  @IBOutlet weak var imgVFidget: UIImageView!
  @IBOutlet weak var textViewUserMessage: UITextView!
  let placeHolderText = "Your Concern/Query"
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    addLogoWithLeftBarButton()
    addDoneTabBarButtonToNav()
    setupViews()
    setupPlaceHolderForTextView()
    setupMapView()
    addKeyBoardObservers()
    // Do any additional setup after loading the view.
  }

  
  func setupPlaceHolderForTextView() {
    DispatchQueue.main.async {
      self.textViewUserMessage.text = self.placeHolderText
      self.textViewUserMessage.textColor = UIColor.lightGray
    }
  }
  func setupViews() {
    viewHeadQuartersMapAndInfo.makeRedAndRound()
    imgVFidget.toggleRotateAndDisplayGif()
    toggleFidgetVisibilityTo(hidden: true)
    textViewUserMessage.makeRedAndRound()
    btnSendMessage.makeRedAndRound()
    textViewUserMessage.tintColor = UIColor.black
  }
  
  func addDoneTabBarButtonToNav() {
    let barbutton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.barBtnInNavTapped))
    self.navigationItem.setLeftBarButton(barbutton, animated: true)
  }
  @objc func barBtnInNavTapped() {
    self.dismiss(animated: true, completion: nil)
  }
  
  func setupMapView() {
    
    DispatchQueue.main.async {
      let position = CLLocationCoordinate2D(latitude: 32.9483364, longitude: -96.8241543)
      let marker = GMSMarker(position: position)
      self.gmsMapView.camera = GMSCameraPosition(target: position, zoom: 15, bearing: 0, viewingAngle: 0)
      marker.title = "Brainplow"
      marker.map = self.gmsMapView
    }
  }
 
  func toggleFidgetVisibilityTo(hidden : Bool) {
    DispatchQueue.main.async {
      self.imgVFidget.isHidden = hidden
    }
  }
  
  func reloadTable() {
    DispatchQueue.main.async {
      self.tableViewContactForm.reloadData()
    }
  }
  
  func addKeyBoardObservers() {
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
  }
 
  @objc func keyboardWillShow(_ notification:Notification) {
    
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      tableViewContactForm.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
      //tableViewContactForm.scrollIndicatorInsets = tableViewContactForm.contentInset
    }
    
  }
  
  @objc func keyboardWillHide(_ notification:Notification) {
    if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      
      tableViewContactForm.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
      
    }
  }
  
  //MARK:- IBActions and user interaction
  
  @IBAction func btnSendMessageTapped(_ sender: UIButton) {
    reloadTable()
    if errorsOccured[0] {
      let indexPath = IndexPath.init(row: 0, section: 0)
      scrollViewMain.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
      tableViewContactForm.scrollToRow(at: indexPath, at: .bottom, animated: true)
      tableViewContactForm.reloadRows(at: [indexPath], with: .automatic)
      
    }else if errorsOccured[1] {
      let indexPath = IndexPath.init(row: 1, section: 0)
      scrollViewMain.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
      tableViewContactForm.scrollToRow(at: indexPath, at: .bottom, animated: true)
      tableViewContactForm.reloadRows(at: [indexPath], with: .automatic)
      
    }else if errorsOccured[2] {
      let indexPath = IndexPath.init(row: 2, section: 0)
      scrollViewMain.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
      tableViewContactForm.scrollToRow(at: indexPath, at: .bottom, animated: true)
      tableViewContactForm.reloadRows(at: [indexPath], with: .automatic)
    }
    else if textViewUserMessage.text.isEmpty || textViewUserMessage.text == placeHolderText{
      DispatchQueue.main.async {
        self.lblMessageIsRequired.isHidden = false
        self.textViewUserMessage.shake()
      }
    }else {
      let name = textFieldValues[0]
      let email = textFieldValues[1]
      let mobile = textFieldValues[2]
      let message = textViewUserMessage.text!
      
      saveUserQueryInDB(name: name, email: email, mobile: mobile, message: message)
      //print(name + email + mobile + (message ?? "default") )
    }
  }
 
  func saveUserQueryInDB(name :String, email : String, mobile: String, message: String) {
    let dbRef = FirebaseDB.shared.dbRef
    let autoIdKey = dbRef.child("user_queries").childByAutoId().key
    let valueDict = ["email":email , "message": message, "mobile": mobile, "name": name, "submission": "iOS", "qid": autoIdKey , "time": ServerValue.timestamp() ] as [String : Any]
    
    dbRef.child("user_queries").child(autoIdKey!).setValue(valueDict) { (error, dbRef) in
      
      guard error == nil else {
        showSwiftMessageWithParams(theme: .error, title: "Database error occured", body: "Could not send your query")
        return
        
      }
      showSwiftMessageWithParams(theme: .success, title: "Success", body: "Your query has been submitted successfully")
      
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
extension EstablishContactVC: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return labelNames.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellEstablishContact", for: indexPath) as? CellEstablishContact else {
      return UITableViewCell()
    }
    cell.label.text = labelNames[indexPath.row]
    cell.textField.tag = indexPath.row
    cell.textField.placeholder = labelNames[indexPath.row]
    cell.textField.delegate = self
    cell.textField.makeRedAndRound()
    cell.textField.tintColor = UIColor.black
    cell.lblErrorMessage.isHidden = !errorsOccured[indexPath.row]
    cell.lblErrorMessage.text = errorMessages[indexPath.row]
    if indexPath.row ==  2 { cell.textField.keyboardType = .numberPad }
    if indexPath.row == 1 { cell.textField.keyboardType = .emailAddress }
    return cell
  }
}

extension EstablishContactVC : UITextFieldDelegate {
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    guard !(textField.text?.isEmpty)! else {
      errorsOccured[textField.tag] = true
      return
    }
    print("text fields tag : \(textField.tag)")
    textFieldValues.insert(textField.text!, at: textField.tag)
    //email validation
    if textField.tag == 1 {
      guard let email = textField.text , isEmailValid(text: email) else {
        errorsOccured[1] = true
        errorMessages[1] = "A Valid Email is required"
        return
      }
    }
    
  }
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    errorsOccured[textField.tag] = false
    return true
  }
  
  //TextFieldShouldReturn
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let tag = textField.tag
    print("tag is \(tag)")
    
    textField.resignFirstResponder()
    
    if tag < 2 {
      
      let nextTfTag = tag + 1
      
      let indexPathOfNextTfield = IndexPath.init(row: nextTfTag, section: 0)
      
      guard let cell =  tableViewContactForm.cellForRow(at: indexPathOfNextTfield) as? CellEstablishContact else {
        print("Could not cast editTableViewCell as? EditMyProfileVC. Going to return ")
        return true
        
      }
      cell.textField.becomeFirstResponder()
      tableViewContactForm.scrollToRow(at: indexPathOfNextTfield, at: .top, animated: true)
    }else {
      textViewUserMessage.becomeFirstResponder()
      scrollViewMain.setContentOffset(CGPoint.init(x: 0, y: 400), animated: true)
    }
    return true
  }
}

extension EstablishContactVC : UITextViewDelegate {
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if text == "\n" {
      textView.resignFirstResponder()
      
      return false
    }
    return true
  }
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == placeHolderText {
      DispatchQueue.main.async {
        textView.textColor = UIColor.black
        textView.text = ""
      }
    }
  }
  func textViewDidEndEditing(_ textView: UITextView) {
    print("text view's text is \(textView.text)" )
    guard let text = textView.text else {
      return
    }
    if text == "" || text == "\n" {
      DispatchQueue.main.async {
        textView.textColor = UIColor.lightGray
        textView.text = self.placeHolderText
      }
    }else {
      if text != placeHolderText {
        DispatchQueue.main.async {
          self.lblMessageIsRequired.isHidden = true
        }
      }
      
    }
  }
}
