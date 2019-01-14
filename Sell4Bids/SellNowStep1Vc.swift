//
//  uploadImagesVC.swift
//  socialLogins
//
//  Created by H.M.Ali on 10/2/17.
//  Copyright © 2017 Admin. All rights reserved.
//
import UIKit
import AVFoundation
import BSImagePicker
import Photos

var Finished: Bool = false



class SellNowStep1Vc: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate {
  //MARK:- Properties
  @IBOutlet weak var takePictureBackgroundBtn: DesignableButton!
  @IBOutlet weak var selectPictureBackgroundBtn: DesignableButton!
  @IBOutlet weak var nextBtn: DesignableButton!
  @IBOutlet weak var scroll: PassTouchesScrollView!
  @IBOutlet weak var descriptionTextField: UITextField!
  @IBOutlet weak var backgroundMiddleView: UIView!
  @IBOutlet weak var imageCollection: UICollectionView!
  @IBOutlet weak var viewPhotoTopAndColView: UIView!
  @IBOutlet weak var mainImage: UIImageView!
  @IBOutlet weak var mainImageCancelBtn: DesignableButton!
  @IBOutlet weak var viewTakePhotoSelectPhoto: UIView!
  @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var ChoiceBtn: UISwitch!
    
    let vc = BSImagePickerViewController()
  
  // @IBOutlet weak var middleConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var lastView: UIView!
  @IBOutlet weak var choiceView: UIView!
  
  //job ViewOutlets
  @IBOutlet weak var jobScrollView: UIScrollView!
  @IBOutlet weak var employmentTypeTextField: textFieldWithNoCopyPasteSelect!
  @IBOutlet weak var jobTitleTextField: DesignableUITextField!
  @IBOutlet weak var medicalBtn: UIButton!
  @IBOutlet weak var medicalLabel: UILabel!
  @IBOutlet weak var PTOBtn: UIButton!
  @IBOutlet weak var PTOLabel: UILabel!
  @IBOutlet weak var fourBtn: UIButton!
  @IBOutlet weak var fourLabel: UILabel!
  @IBOutlet weak var jobTitleView: UIView!
  @IBOutlet weak var employmentTypeView: UIView!
  @IBOutlet weak var benefitView: UIView!
  @IBOutlet weak var viewTitle: UIView!
  @IBOutlet weak var topViewTakePhotoToSafe8: NSLayoutConstraint!
  @IBOutlet weak var topViewTakePhotoSelPhotoToImageMain8: NSLayoutConstraint!
  var image = UIImage()
    
    func getAssetThumbnail(asset: [PHAsset]) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        imageList.removeAll()
        option.isSynchronous = true
        for assets in asset {
            manager.requestImage(for: assets, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                thumbnail = result!
                self.imageList.append(thumbnail)
                self.imageCollection.reloadUsingDispatch()
            })
           
        }
        
        print("Images = \(self.imageList.count)")
       
       return thumbnail
    }
    
    
  //MARK:- Variables
  var imageList = [UIImage]()
  var imagePicker = UIImagePickerController()
  var picker2 = UIImagePickerController()
  var category: String = ""
  var picker = UIPickerView()
  var employmentType = ["Select Employment Type","Contract Hire","Employee's Choice", "Full-Time","Internship","Temporary"]
  var benefits = ""
  var isJob = false
  var isFirst = true
    var defaults = UserDefaults.standard
  //MARK:- View Life Cycle
  
  @IBOutlet weak var viewTakePhoto: UIView!
  @IBOutlet weak var viewSelectPhoto: UIView!
  ///8, -100 for showing/hiding
  @IBOutlet weak var topViewTopAndColV: NSLayoutConstraint!
  @IBOutlet weak var heightViewTakeAndSelectPhoto: NSLayoutConstraint!
  
  @IBOutlet weak var heightViewTitle: NSLayoutConstraint!
  
  private func toggleShowTopImage(flag: Bool) {
    if flag {
      topViewTopAndColV.constant = 50
      viewPhotoTopAndColView.fadeIn()
    }
    else {
      topViewTopAndColV.constant = -350
      viewPhotoTopAndColView.fadeOut()
    }
  }
  
  @IBOutlet weak var topViewTitleToViewImageAndColV: NSLayoutConstraint!
  
  @IBOutlet weak var topViewTitleToViewTakePhotoSelPhoto: NSLayoutConstraint!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if self.defaults.value(forKey: "Finished") as? Bool != nil {
        let finish = self.defaults.value(forKey: "Finished") as! Bool
        Finished = finish
    }
    

    
    self.defaults.set(self.ChoiceBtn.isOn, forKey: "ChoiceBtnoNoff")
    if self.defaults.value(forKey: "ChoiceBtnoNoff") as? Bool != nil {
        let btn = self.defaults.value(forKey: "ChoiceBtnoNoff") as? Bool
        self.ChoiceBtn.isOn = btn!
    }
    

    if isJob {
    
        if self.defaults.value(forKey: "JobTitle") as? String != nil {
            let value = self.defaults.value(forKey: "JobTitle") as? String
            self.jobTitleTextField.text = value
        }
        
        if self.defaults.value(forKey: "EmployType") as? String != nil {
            let value = self.defaults.value(forKey: "EmployType") as? String
            self.employmentTypeTextField.text = value
        }
        
        if self.defaults.value(forKey: "MedicalCheckBox") as? Bool != nil {
            let value = self.defaults.value(forKey: "MedicalCheckBox") as? Bool
            self.medicalBtn.isSelected = value!
        }
        
        if self.defaults.value(forKey: "PTOCheckBox") as? Bool != nil {
            let value = self.defaults.value(forKey: "PTOCheckBox") as? Bool
            self.PTOBtn.isSelected = value!
        }
        
        if self.defaults.value(forKey: "401K") as? Bool != nil {
            let value = self.defaults.value(forKey: "401K") as? Bool
            self.fourBtn.isSelected = value!
        }
        
        
        
    }else {
        
      
        if self.defaults.value(forKey: "ItemTitle") as? String != nil {
            let value = self.defaults.value(forKey: "ItemTitle") as? String
            self.descriptionTextField.text = value
        }
        
    }
    
    
    
    
    

    mainImage.layer.cornerRadius = 12
    
    self.tabBarController?.tabBar.isHidden = true
    toggleEnableIQKeyBoard(flag: true)
    self.navigationItem.title = "List Your Item"
    self.navigationController?.navigationBar.tintColor = UIColor.white
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = UIColor.white
    
    jobScrollView.isHidden = true
    
    backgroundView.isHidden = true
    backgroundMiddleView.isHidden = true
    imagePicker.delegate = self
    picker2.delegate = self
   // imageList.append(UIImage(named: "post_photo_add")!)
    descriptionTextField.delegate = self
    
    nextBtn.addShadowView()
    scroll.delegate = self
    scroll.delegatePass = self as? PassTouchesScrollViewDelegate
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: Notification.Name.UIKeyboardWillShow, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    
    
    descriptionTextField.autocorrectionType = .no
    selectPictureBackgroundBtn.addShadowView()
    takePictureBackgroundBtn.addShadowView()
    
    
    createPicker(textField: employmentTypeTextField)
    createToolBar(textField: employmentTypeTextField)
    // employmentTypeTextField.inputView = picker
    
    employmentTypeTextField.delegate = self
    jobTitleTextField.delegate = self
    descriptionTextField.delegate = self
    
    
    //checkPermissionOfCamera()
    
    toggleShowTopImage(flag: false)
    setupViews()
    
    addDoneTabBarButtonToNav()
  }
    
    
    @objc func barBtnInNavTapped() {
        tabBarController?.selectedIndex = 0
    }
    
  
  func addDoneTabBarButtonToNav() {
    
    let barbuttonHome = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(self.barBtnInNav))
    barbuttonHome.image = UIImage(named: "BackArrow24")
    
    let button = UIButton.init(type: .custom)
    button.setImage( #imageLiteral(resourceName: "hammer_white")  , for: UIControlState.normal)
    button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20) //CGRectMake(0, 0, 30, 30)
    let barButton = UIBarButtonItem.init(customView: button)
    
    self.navigationItem.leftBarButtonItems = [barbuttonHome, barButton]
  }
  
  
  @objc func barBtnInNav() {
    tabBarController?.selectedIndex = 0
  }
  
  
  
  private func setupViews() {
    
    
    jobTitleTextField.makeCornersRound()
    employmentTypeTextField.makeCornersRound()
    let gesture = UITapGestureRecognizer(target: self, action: #selector(self.placeHolderImageTapped))
    mainImage.addGestureRecognizer(gesture)
    DispatchQueue.main.async {
      self.imageCollection.isHidden = true
      self.mainImageCancelBtn.isHidden = true
    }
    nextBtn.addShadowView()
    viewTakePhoto.makeRedAndRound()
    viewSelectPhoto.makeRedAndRound()
    viewPhotoTopAndColView.addShadow()
    addLeftHomeBarButtonToTop()
    viewTitle.addShadow()
    choiceView.addShadow()
    
    mainImageCancelBtn.makeRound()
    jobTitleTextField.makeRedAndRound()
    medicalBtn.makeCornersRound()
    medicalBtn.addBorderWithColorAndWidth(color: UIColor.darkGray.cgColor, width: 2)
    PTOBtn.makeCornersRound()
    PTOBtn.addBorderWithColorAndWidth(color: UIColor.darkGray.cgColor, width: 2)
    fourBtn.makeCornersRound()
    fourBtn.addBorderWithColorAndWidth(color: UIColor.darkGray.cgColor, width: 2)
    nextBtn.addShadowAndRound()
    jobTitleView.addShadow()
    viewPhotoTopAndColView.addShadow()
    viewTakePhotoSelectPhoto.addShadow()
    viewTitle.addShadow()
    employmentTypeView.addShadow()
    benefitView.addShadow()
    
  }
  
  @objc private func placeHolderImageTapped() {
    print("btnAddImageTapped() " )
    viewTakePhotoSelectPhoto.shake()
  }
  
  func checkPermissionOfCamera(){
    if AVCaptureDevice.authorizationStatus(for: .video) == .authorized{
    }
    else{
      
      getPermission(type: "camera")
    }
  }
  
  func getPermission(type: String){
    let alert = UIAlertController(title: "\"Sell4Bids\" Would Like to Access the Camera", message: "This app requires access to camera.", preferredStyle: .alert)
    
    let dontAllow = UIAlertAction(title: "Don\'t Allow", style: .default, handler: nil)
    let ok = UIAlertAction(title: "OK", style: .default) { (action) in
      if type == "camera"{
        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
      }
    }
    
    alert.addAction(dontAllow)
    alert.addAction(ok)
    self.present(alert, animated: true, completion: nil)
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "fromStep1ToStep2"{
      
      let data = sender as! [String:Any]
      let destination = segue.destination as! StepTwoVC
      
      if isJob == true{
        destination.isJob = true
        destination.jobValues = data
        
      }
      else{
        
        
        destination.isJob = false
        destination.previousData = data
      }
    }
    
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    
    if imageList.count < imageCollection.numberOfItems(inSection: 0){
      imageList.append(UIImage(named: "post_photo_add")!)
    }
    
    print(self.imageList.count)
    print(imageCollection.numberOfItems(inSection: 0))
  }
  
  override func viewDidLayoutSubviews() {
    if Env.isIphoneSmall {
      heightViewTakeAndSelectPhoto.constant = 150
      heightViewTitle.constant = 100
    }else if Env.isIphoneMedium {
      heightViewTakeAndSelectPhoto.constant = 180
      heightViewTitle.constant = 120
    }else if Env.isIpad {
      heightViewTakeAndSelectPhoto.constant = 210
      heightViewTitle.constant = 130
    }
  }
  @objc func handleKeyboardHide(notification: Notification)
  {
    //self.topConstraint.constant = 10
    //self.fbIcon.isHidden = false
    //self.bottomSpace.constant = 0
    //bottomSpaceOfTableView.constant = 0
    
    
  }
  
  @objc func handleKeyboardNotification(notification: Notification){
    
    if let userInfo = notification.userInfo{
      
      let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
      print(descriptionTextField.frame.height)
      print(descriptionTextField.frame.origin.y)
      print(keyboardFrame.origin.y)
      
      
      
      if (descriptionTextField.frame.origin.y + descriptionTextField.frame.height) > keyboardFrame.origin.y {
        
        let y = ( (descriptionTextField.frame.origin.y + ((descriptionTextField.frame.height) * 2)) - keyboardFrame.origin.y )
        self.scroll.setContentOffset(CGPoint(x: 0, y: y), animated: true)
      }
      
      print(descriptionTextField.frame.origin.y)
      print(self.descriptionTextField.frame.origin.y)
      
      print(keyboardFrame)
      
    }
  }
  
  
  
  
//    MARK:- Image picker controller
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    picker.dismiss(animated: true, completion: nil)
    self.mainImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    if imageList.count > 0{
      self.imageList.removeLast(1)

      self.imageList.append(mainImage.image!)
      self.imageList.append(UIImage(named: "post_photo_add")!)
      toggleShowTopImage(flag: true)
      UIView.animate(withDuration: 0.3, animations: {
        self.view.removeConstraint(self.topViewTitleToViewTakePhotoSelPhoto)
        self.view.addConstraint(self.topViewTitleToViewImageAndColV)
      })

      DispatchQueue.main.async {
        self.viewTakePhotoSelectPhoto.isHidden = true
        self.viewPhotoTopAndColView.isHidden = false
        self.mainImageCancelBtn.isHidden = false
        self.imageCollection.isHidden = false
        self.backgroundMiddleView.isHidden = true
        self.backgroundView.isHidden = true
      }

    }

    self.imageCollection.reloadData()
  }
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first{
      if touch.view == self.backgroundView{
        self.backgroundMiddleView.isHidden = true
        self.backgroundView.isHidden = true

      }
      if touch.view != self.descriptionTextField {//&& touch.view != imageCollection{
        if descriptionTextField.isFirstResponder == true{
          descriptionTextField.resignFirstResponder()
        }
      }


      if touch.view != jobTitleTextField && jobTitleTextField.isFirstResponder{
        jobTitleTextField.resignFirstResponder()
      }
    }
  }
  
  
  //MARK:- IBActions and user interaction
  
  @IBAction func homeBarBtnTapped(_ sender: Any) {
    self.tabBarController?.selectedIndex = 0  
  }
  @IBAction func takePictureAction(_ sender: Any) {
    
    let i = UserDefaults.standard.object(forKey: "isFirstCameraAccess") as? Bool
    
    if AVCaptureDevice.authorizationStatus(for: .video) != .authorized{
      if i != nil{
        // not first
        
        checkPermissionOfCamera()
      }
      else{
        //first
        
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
          
          imagePicker.sourceType = .camera
        
          isFirst = false
          UserDefaults.standard.set(false, forKey: "isFirstCameraAccess")
          self.present(imagePicker, animated: true, completion: nil)
          
        }
        else{
          self.alert(message: "No camera availabe", title: "ERROR")
        }
        
        
      }
    }else{
      if UIImagePickerController.isSourceTypeAvailable(.camera){
        
        imagePicker.sourceType = .camera
        
        isFirst = false
        UserDefaults.standard.set(false, forKey: "isFirstCameraAccess")
        self.present(imagePicker, animated: true, completion: nil)
        
      }
      else{
        self.alert(message: "No camera availabe", title: "ERROR")
      }
    }
    
    
  }
  
  
  
  @IBAction func takePictureBackgroundBtnAction(_ sender: Any) {
    if UIImagePickerController.isSourceTypeAvailable(.camera)
    {
      backgroundMiddleView.hide()
      self.backgroundView.isHidden = true
      picker2.sourceType = .camera
      self.present(picker2, animated: true, completion: nil)
    }
    else{
      self.alert(message: "No camera availabe", title: "ERROR")
    }
  }
  
    
    
    @IBAction func showImagePicker(_ sender: UIButton) {
        
     imageList.removeAll()

        
        
        vc.maxNumberOfSelections = 14
        
      
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            print("Selected: \(asset)")
                                            
        }, deselect: { (asset: PHAsset) -> Void in
            print("Deselected: \(asset)")
            print("assests = \(asset.mediaType)")
        }, cancel: { (assets: [PHAsset]) -> Void in
            print("Cancel: \(assets)")
        }, finish: { (assets: [PHAsset]) -> Void in
            
            print("Finish: \(assets)")
            
            
                self.image = self.getAssetThumbnail(asset: assets)
            if self.imageList.count > 0 || self.imageList.count < 14 {
                
                
                
                            self.imageList.append(UIImage(named: "post_photo_add")!)
                
               
                
                DispatchQueue.main.async {
                    self.mainImage.image = self.image
                    self.viewTakePhotoSelectPhoto.isHidden = true
                    self.viewPhotoTopAndColView.isHidden = false
                    self.mainImageCancelBtn.isHidden = false
                    self.imageCollection.isHidden = false
                    self.backgroundMiddleView.isHidden = true
                    self.backgroundView.isHidden = true
                    
                  
                }
                
            }
            
            
           
            
            
            
        }, completion: nil)
        
        
        self.imageCollection.reloadUsingDispatch()
    
        if imageList.count < 0 {
            self.viewPhotoTopAndColView.isHidden = true
            self.toggleShowTopImage(flag: false)
            self.view.removeConstraint(self.topViewTitleToViewImageAndColV)
            self.view.addConstraint(self.topViewTitleToViewTakePhotoSelPhoto)
            self.backgroundView.isHidden = true
            self.backgroundMiddleView.isHidden = true
            self.viewTakePhotoSelectPhoto.isHidden = false
            self.viewTakePhotoSelectPhoto.isHidden = false
        }
        
        self.toggleShowTopImage(flag: true)
        UIView.animate(withDuration: 0.3, animations: {
            self.view.removeConstraint(self.topViewTitleToViewTakePhotoSelPhoto)
            self.view.addConstraint(self.topViewTitleToViewImageAndColV)
        })
        
    }
    
    
  
  @IBAction func selectPictureBtnAction(_ sender: Any) {
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
    {
      self.imagePicker.sourceType = .photoLibrary
      self.present(imagePicker, animated: true, completion: nil)
    }
    else{
      self.alert(message: "No photo library available", title: "ERROR")
    }
    
  }
  @IBAction func selectPictureBackgroundBtnAction(_ sender: Any) {
    bs_presentImagePickerController(vc, animated: true,
                                    select: { (asset: PHAsset) -> Void in
                                        print("Selected: \(asset)")
                                        
    }, deselect: { (asset: PHAsset) -> Void in
        print("Deselected: \(asset)")
        print("assests = \(asset.mediaType)")
    }, cancel: { (assets: [PHAsset]) -> Void in
        print("Cancel: \(assets)")
    }, finish: { (assets: [PHAsset]) -> Void in
        
        print("Finish: \(assets)")
        
        
        self.image = self.getAssetThumbnail(asset: assets)
        if self.imageList.count > 0 || self.imageList.count < 14 {
            
            
            
            self.imageList.append(UIImage(named: "post_photo_add")!)
            
            
            
            DispatchQueue.main.async {
                self.mainImage.image = self.image
                self.viewTakePhotoSelectPhoto.isHidden = true
                self.viewPhotoTopAndColView.isHidden = false
                self.mainImageCancelBtn.isHidden = false
                self.imageCollection.isHidden = false
                self.backgroundMiddleView.isHidden = true
                self.backgroundView.isHidden = true
                
                
            }
            
        }
        
        
        
        
        
        
    }, completion: nil)
    
    
    self.imageCollection.reloadUsingDispatch()
    
    if imageList.count < 0 {
        self.viewPhotoTopAndColView.isHidden = true
        self.toggleShowTopImage(flag: false)
        self.view.removeConstraint(self.topViewTitleToViewImageAndColV)
        self.view.addConstraint(self.topViewTitleToViewTakePhotoSelPhoto)
        self.backgroundView.isHidden = true
        self.backgroundMiddleView.isHidden = true
        self.viewTakePhotoSelectPhoto.isHidden = false
        self.viewTakePhotoSelectPhoto.isHidden = false
    }
    
    self.toggleShowTopImage(flag: true)
    UIView.animate(withDuration: 0.3, animations: {
        self.view.removeConstraint(self.topViewTitleToViewTakePhotoSelPhoto)
        self.view.addConstraint(self.topViewTitleToViewImageAndColV)
    })
    
  }

  
  
  @IBAction func mainImageCancelBtnAction(_ sender: Any) {
    
    if self.imageList.count > 1{
      if let tag = mainImage.tag as? Int{
        
        let indexPath = IndexPath(row: tag, section: 0)
       
            print("Photo tag == \(indexPath)")
            self.imageList.remove(at: imageList.count-2)
            if (imageList.count - 2) >= 0{
                self.mainImage.image = self.imageList[imageList.count - 2]
                self.mainImage.tag = imageList.count - 2
            }
            else{
                self.mainImage.image = self.imageList[0]
                viewPhotoTopAndColView.isHidden = true
                toggleShowTopImage(flag: false)
                self.view.removeConstraint(topViewTitleToViewImageAndColV)
                self.view.addConstraint(topViewTitleToViewTakePhotoSelPhoto)
                backgroundView.isHidden = true
                backgroundMiddleView.isHidden = true
                viewTakePhotoSelectPhoto.isHidden = false
                viewTakePhotoSelectPhoto.isHidden = false
            }
        }
        
        self.imageCollection.reloadData()
    }
    else{
//        if self.imageList.count > 1 {
//            self.mainImage.image = nil
//        }
      viewPhotoTopAndColView.isHidden = true
      toggleShowTopImage(flag: false)
      self.view.removeConstraint(topViewTitleToViewImageAndColV)
      self.view.addConstraint(topViewTitleToViewTakePhotoSelPhoto)
        backgroundView.isHidden = true
        backgroundMiddleView.isHidden = true
        viewTakePhotoSelectPhoto.isHidden = false
        viewTakePhotoSelectPhoto.isHidden = false
    }
    
    
  }
  
  @IBAction func nextBtnAction(_ sender: Any) {
    
    Finished = false
    self.defaults.set(self.ChoiceBtn.isOn, forKey: "ChoiceBtnoNoff")
    
    if isJob {
        
        self.defaults.set(self.jobTitleTextField.text, forKey: "JobTitle")
        self.defaults.set(self.employmentTypeTextField.text, forKey: "EmployType")
        self.defaults.set(self.medicalBtn.isSelected, forKey: "MedicalCheckBox")
        self.defaults.set(self.PTOBtn.isSelected, forKey: "PTOCheckBox")
        self.defaults.set(self.fourBtn.isSelected, forKey: "401K")
        
        
    }else {
        
        self.defaults.set(self.descriptionTextField.text, forKey: "ItemTitle")
        
    }
    
    
    
    
    self.defaults.set(Finished, forKey: "Finished")
    if isJob {
        if  (jobTitleTextField.text?.count)! < 5 || (jobTitleTextField.text?.count)! > 120  {
            showSwiftMessageWithParams(theme: .error, title: "Error", body: "Title text lenght should be more then 5 charactors and less then 120 charactors ")
            
            return
        }
    }else {
        if  (descriptionTextField.text?.count)! < 5 || (descriptionTextField.text?.count)! > 120  {
            showSwiftMessageWithParams(theme: .error, title: "Error", body: "Title text lenght should be more then 5 charactors and less then 120 charactors ")
            
            return
        }
    }
   
    
    
    if isJob == true{
       
        
      if self.jobTitleTextField.text == ""{
     
        showSwiftMessageWithParams(theme: .error, title: "Error", body: "Please enter Job Title")
        return
      }
      if self.employmentTypeTextField.text == "Select Employment Type" || self.employmentTypeTextField.text == "" {
        //self.alert(message: "Please select employment type from dropdown", title: "Employment Type")
        employmentTypeTextField.shake()
        showSwiftMessageWithParams(theme: .error, title: "Error", body: "Please Select an Employment Type.")
        
        return
      }
      //print(self.employmentTypeTextField.text)
      
      if medicalBtn.isSelected == true{
        if self.benefits == ""{
          self.benefits = "Medical"
        }
        else if self.benefits.contains("Medical")==false{
          self.benefits = self.benefits+",Medical"
        }
      }
      if PTOBtn.isSelected == true{
        if self.benefits == ""{
          self.benefits = "PTO"
        }
        else if self.benefits.contains("PTO")==false{
          self.benefits = self.benefits+",PTO"
        }
      }
      
      if fourBtn.isSelected == true{
        if self.benefits == ""{
          self.benefits = "401(k)"
        }
        else if self.benefits.contains("401(k)")==false{
          self.benefits = self.benefits+",401(k)"
        }
      }
      
      let dic = ["title":self.jobTitleTextField.text,"employmentType":self.employmentTypeTextField.text,"benefits":self.benefits] as [String:Any]
      
      self.performSegue(withIdentifier: "fromStep1ToStep2", sender: dic)
      print(self.benefits)
      
      
    }
      
    else{
      if self.imageList.count <= 1{
        
         showSwiftMessageWithParams(theme: .error, title: "Add Image", body: "Upload at least one product image")
      }
      else if self.descriptionTextField.text == ""{
        
               showSwiftMessageWithParams(theme: .error, title: "Error", body: "Please enter title for your item,based on title item will be shown in search results.")
   return
      }
      else{
        //let index = self.imageList.count
       // self.imageList.remove(at: index)
        let dic = ["imageList": self.imageList as [UIImage], "title": descriptionTextField.text] as! [String: Any]
        self.performSegue(withIdentifier: "fromStep1ToStep2", sender: dic)
        
        
        
        
      }
    }
  }
  @IBAction func switchAction(_ sender: UISwitch) {
    
    if sender.isOn{
      scroll.isHidden = true
      jobScrollView.isHidden = false
      self.isJob = true
      print("on")
    }
    else{
      jobScrollView.isHidden = true
      scroll.isHidden = false
      self.isJob = false
      print("off")
    }
  }
  
  @IBAction func medicalBtnAction(_ sender: DesignableButton) {
    
    sender.isSelected = !sender.isSelected
    
    if sender.isSelected == true{print("MedicalSelected")
      DispatchQueue.main.async {
        sender.layer.borderColor = UIColor.clear.cgColor
      }
     
    }else {
      DispatchQueue.main.async {
        sender.layer.borderColor = UIColor.darkGray.cgColor
      }
    }
    
  }
  

  @IBAction func PTOBtnAction(_ sender: DesignableButton) {
    
    sender.isSelected = !sender.isSelected
    
    if sender.isSelected == true{
      sender.layer.borderColor = UIColor.clear.cgColor
      print("PTOSelected")
    
    }else {
      DispatchQueue.main.async {
        sender.layer.borderColor = UIColor.darkGray.cgColor
      }
    }
  }
  
  
  @IBAction func fourBtnAction(_ sender: DesignableButton) {
    
    sender.isSelected = !sender.isSelected
    
    if sender.isSelected == true{
      sender.layer.borderColor = UIColor.clear.cgColor
      print("fourSelected")
      
    }else {
      DispatchQueue.main.async {
        sender.layer.borderColor = UIColor.darkGray.cgColor
      }
    }
  }
  
}

//MARK:-  UIPickerViewDelegate, UIPickerViewDataSource
extension SellNowStep1Vc: UIPickerViewDelegate, UIPickerViewDataSource{
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return employmentType.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return employmentType[row]
    //return list[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    employmentTypeTextField.text = employmentType[row]
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
    
    label.text = employmentType[row]
    
    return label
  }
  
  
  
  func createPicker(textField: UITextField){
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
    employmentTypeTextField.endEditing(true)
    
  }
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SellNowStep1Vc: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let height: CGFloat = self.imageCollection.frame.height
    let width : CGFloat = self.imageCollection.frame.width
    if UIDevice.modelName.contains("iPhone 5s") {
         return CGSize(width: width/5, height: height)
    }else {
         return CGSize(width: width/8, height: height)
    }
   
    
    
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
   print("images list = \(imageList.count)")
    return imageList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! cellVC
   
    cell.cellImage.image = imageList[indexPath.row]
    return cell
    
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    if imageList[indexPath.row] != UIImage(named: "post_photo_add")
    {
      mainImage.image = imageList[indexPath.row]
      mainImage.tag = indexPath.row



    }
    else{
      if self.imageList.count <= 14{
        self.backgroundView.isHidden = false
        self.viewTakePhotoSelectPhoto.isHidden = true
        self.backgroundMiddleView.isHidden = false
      }
      else{

        showSwiftMessageWithParams(theme: .error, title: "Uploading photos", body: "You can add at max 14 Images.")
        return
        self.backgroundMiddleView.isHidden = true
        self.backgroundView.isHidden = true
      }

    }
  }
}

//MARK:- UITextFieldDelegate
extension SellNowStep1Vc : UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == descriptionTextField{
       
        if textField.isFirstResponder{
        textField.resignFirstResponder()
        return true
      }
    }
    
    if textField == jobTitleTextField{
      if textField.isFirstResponder{
        employmentTypeTextField.becomeFirstResponder()
      }
    }
    return true
  }
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if textField == employmentTypeTextField{
      return true
    }
    return true
  }
  
  ///for disabling the employment type text field entering text
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField == employmentTypeTextField {
      return false
    }
    return true
  }
}
