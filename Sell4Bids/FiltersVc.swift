//
//  SellForBidsViewController.swift
//  Sell4Bids
//
//  Created by admin on 9/4/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import TGPControls
import Firebase
import Alamofire
import SwiftyJSON


class FiltersVc: UITableViewController,UICollectionViewDelegate {
  
  
  //MARK: - Properties
  @IBOutlet weak var categoriesTextField: UITextField!
  @IBOutlet weak var buyingOptionTextField: UITextField!
  @IBOutlet weak var stateTextField: UITextField!
  @IBOutlet weak var maxTextField: UITextField!
  @IBOutlet weak var minTextField: UITextField!
  @IBOutlet weak var slider: TGPDiscreteSlider!
  @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var Countrylist: UITextField!
    
    @IBOutlet weak var Zipcodetxt: UITextField!
    
    @IBOutlet weak var citytxt: UITextField!
     var titleview = Bundle.main.loadNibNamed("NavigationBarMainView", owner: self, options: nil)?.first as! NavigationBarMainView
    
    var categoryToFilter = "All"
  var buyingOptionToFilter = "Any"
  var stateToFilter = "NY"
  var conditionFilter = "Any"
  var priceMinFilter : Int?
  var priceMaxFilter: Int?
    var currency = String()
    var indiaZipCode: IndiaPinCodeModel?
    var UsaZipCode : USAZipCodeModel?
    
  //var priceMin
  //MARK: - Variables
  var dbRef:DatabaseReference!
  var databaseHandle:DatabaseHandle?
  var sliderData = ["Any","For Parts","Used","Reconditioned","Open box / Like new","New"]
  var selectedCategory:String?
  var selectedBuyingOption:String?
  var selectedStateName:String?
  let catPicker = UIPickerView()
  let picker2 = UIPickerView()
  let picker3 = UIPickerView()
  let countrypicker = UIPickerView()
  var endTimee:Double = 0
  var resultProductsArray = [ProductModel]()
  var filterProductArray = [ProductModel]()
  var allProductsArray = [ProductModel]()
  var buyItNowString = ""
  var reserveString = ""
  var nonReserveString = ""
  var selfWasPushed = false
  public var cityAndStateName = ""
  weak var delegate : filtersVCDelegate?
  @IBOutlet weak var btnDone: UIButton!
  //MARK:- Functions
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    if gpscountry == "USA" {
        self.Zipcodetxt.text = "10001"
        self.citytxt.text = "New York"
        self.stateTextField.text = "NY"
        self.minTextField.placeholder = "$ Min"
        self.maxTextField.placeholder = "$ Max"
    } else if gpscountry == "IN" {
        self.Zipcodetxt.text = "110026"
        self.citytxt.text = "Dehli"
        self.stateTextField.text = "Haryana"
        self.minTextField.placeholder = "₹ Min"
        self.maxTextField.placeholder = "₹ Max"
    }
    
    
    Zipcodetxt.text = zipCode
    citytxt.text = city
    stateTextField.text = stateName
    
    Countrylist.text = gpscountry
    Zipcodetxt.delegate = self
    self.tabBarController?.tabBar.isHidden = true
    minTextField.delegate = self
    maxTextField.delegate = self
    dbRef = FirebaseDB.shared.dbRef
    self.navigationItem.title = "Filters"
    self.navigationController?.navigationBar.tintColor = UIColor.white
      //self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 33, width: 20, height: 40)
    self.view.endEditing(true)
    //calling functions
    createCategoryPicker()
    createToolbar()
    
    
   slider.addTarget(self, action: #selector(handleValueChange(_:)), for: .valueChanged)
    
   // stateTextField.text = cityAndStateName
    categoriesTextField.text = categoryToFilter
    buyingOptionTextField.text = buyingOptionToFilter
    getSearchResult { (complete) in
        print("complete")
        
    }
    setupViews()
    addRefreshBarButtonToNav()
    
  }
  
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 2 {
//            return 0
//        }else {
//            return 100
//        }
//    }
//
  private func setupLeftBarButtons() {
    let cancelBarBtn = UIBarButtonItem.init(title: "Cancel", style: .done, target: self, action: #selector(cancelTabBtnTapped))
    
    let button = UIButton.init(type: .custom)
    button.setImage( #imageLiteral(resourceName: "hammer_white")  , for: UIControlState.normal)
    button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20) //CGRectMake(0, 0, 30, 30)
    let barButton = UIBarButtonItem.init(customView: button)
    
    navigationItem.leftBarButtonItems = [cancelBarBtn, barButton]
  }
  private func setupViews() {
    
    if !selfWasPushed {
      setupLeftBarButtons()
    }
    categoriesTextField.makeCornersRound()
    buyingOptionTextField.makeCornersRound()
    stateTextField.makeCornersRound()
    slider.makeCornersRound()
    minTextField.makeCornersRound()
    maxTextField.makeCornersRound()
    Countrylist.makeCornersRound()
    Zipcodetxt.makeCornersRound()
    citytxt.makeCornersRound()
    
  //  btnDone.makeCornersRound()
    let appColor = UIColor(red: 0.76, green: 0.25, blue: 0.18 , alpha: 1.0)
    Countrylist.layer.borderColor = appColor.cgColor
    Countrylist.layer.borderWidth = 2.0
    Zipcodetxt.layer.borderColor = appColor.cgColor
    Zipcodetxt.layer.borderWidth = 2.0
    citytxt.layer.borderColor = appColor.cgColor
    citytxt.layer.borderWidth = 2.0
    categoriesTextField.layer.borderColor = appColor.cgColor
    categoriesTextField.layer.borderWidth = 2.0
    buyingOptionTextField.layer.borderColor = appColor.cgColor
    buyingOptionTextField.layer.borderWidth = 2.0
    stateTextField.layer.borderColor = appColor.cgColor
    stateTextField.layer.borderWidth = 2.0
    minTextField.layer.borderColor = appColor.cgColor
    minTextField.layer.borderWidth = 2.0
    maxTextField.layer.borderColor = appColor.cgColor
    maxTextField.layer.borderWidth = 2.0
    //sortingView.layer.borderColor = appColor.cgColor
    //sortingView.layer.borderWidth = 2.0
    slider.layer.borderWidth = 2.0
    slider.layer.borderColor = appColor.cgColor
    minTextField.keyboardType = UIKeyboardType.numberPad
    maxTextField.keyboardType = UIKeyboardType.numberPad
    
    
  }
  
  private func addRefreshBarButtonToNav() {
    
    let barBtnRefresh = UIBarButtonItem.init(title: "Reset All", style: .done, target: self, action: #selector(refreshBtnInNavTapped))
    //let barBtnRefresh = UIBarButtonItem(customView: button)
    navigationItem.rightBarButtonItem = barBtnRefresh
    
  }
  
  @objc private func refreshBtnInNavTapped() {
    print("Going to refresh the filters")
    DispatchQueue.main.async {
      
      self.categoriesTextField.text = "All"
      self.buyingOptionTextField.text = "Any"
      self.slider.value = 0
      self.minTextField.text = ""
      self.maxTextField.text = ""
      self.priceMaxFilter = nil
      self.priceMaxFilter = nil
    }
    DispatchQueue.main.async {
      self.resignFirstResponder()
      self.view.endEditing(true)
    }
    
    
  }
  
  @objc func cancelTabBtnTapped(){
    if selfWasPushed {
      self.navigationController?.popViewController(animated: true)
    }else {
      //was presented
      dismiss(animated: true, completion: nil)
    }
    
  }

  func dismissKeyboard(){
    view.endEditing(true)
  }

  func createCategoryPicker() {
    
    
    catPicker.delegate = self
    picker2.delegate = self
   // picker3.delegate = self
    countrypicker.delegate = self
    categoriesTextField.inputView = catPicker
    buyingOptionTextField.inputView = picker2
    //stateTextField.inputView = picker3
    Countrylist.inputView = countrypicker
    //Customization
    catPicker.backgroundColor = .white
  }

  func createToolbar(){
    let toolBar = UIToolbar()
    toolBar.sizeToFit()
    //customozation
    toolBar.barTintColor = .gray
    toolBar.tintColor = .black
    
    let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(FiltersVc.dismissKeyBoard))
    toolBar.setItems([doneButton], animated: false)
    toolBar.isUserInteractionEnabled = true
    categoriesTextField.inputAccessoryView = toolBar
    buyingOptionTextField.inputAccessoryView = toolBar
    
    
  }

  @objc func dismissKeyBoard(){
    view.endEditing(true)
  }
 
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    dismissKeyBoard()
    
  }
  
  func getSearchResult(completion: @escaping(Bool)->()){
    dbRef.child("products").observeSingleEvent(of: .value) { (productSnapshot) in
      if productSnapshot.childrenCount > 0 {
        guard let productSnapshotValue = productSnapshot.value as? [String:AnyObject] else {
          print("ERROR: cating as [string: anyObject]")
          return
        }
        for(categoryNameKey,categoryValues) in productSnapshotValue {
           
                guard let categoryValueDict = categoryValues as? [String:AnyObject] else {
                    print("ERROR: while looping on category")
                    return
                }
            
         
          for(auctionTypeKey,auctionTypeValues) in categoryValueDict {
            
                
          
            guard let auctionTypeDict  = auctionTypeValues as? [String:AnyObject] else {
              print("ERROR: while looping on auction Type")
              return
            }
                
            for(_,stateNameValues) in auctionTypeDict {
              guard let stateNameDict = stateNameValues as? [String:AnyObject] else {
                print("ERROR: while looping on sof AMERICA ")
                return
              }
                
              for(productKey,productsValues) in stateNameDict {
                guard let productDict = productsValues as? [String:AnyObject] else{
                  print("ERROR: while looping on product keys ")
                  return
                }
              
                    let product = ProductModel(categoryName: categoryNameKey, auctionType: auctionTypeKey, prodKey: productKey, productDict: productDict)
                    self.allProductsArray.append(product)
            
                
               
                }
              
              
            
          
        }
        }
        }
        completion(true)
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if(segue.identifier == "done"){
      //® var slectedState = stateTextField.text
      if let homeVc = segue.destination as? HomeVC_New{
        //Giving ProductModel data to ProductDetailTableViewController
        
        homeVc.categoryToFilter = self.categoryToFilter
        homeVc.buyingOptionToFilter = self.buyingOptionToFilter
        homeVc.stateToFilter =  stateName
        homeVc.cityAndStateName = self.cityAndStateName
        homeVc.priceMinFilter = self.priceMinFilter
        homeVc.priceMaxFilter = self.priceMaxFilter
        homeVc.flagIsFilterApplied = true
        
        self.navigationController?.pushViewController(homeVc, animated: true)
        
        
        
      }
      else{
        print("could not unwrap vc")
      }
    }
  }
    
    
   
  //MARK: - Actions
  @objc func handleValueChange(_ sender: TGPDiscreteSlider)
  {
    let value = Int(sender.value)
    self.conditionLabel.text = sliderData[value]
  }
  
  @objc func doneBtn(){
    //filterNewData()
    self.performSegue(withIdentifier: "done", sender: self)
  }
  
  @IBAction func btnDoneFilteringTapped(_ sender: UIButton) {
    //filterNewData()
    fetchingMethod = "zipcode"
    endkey = nil
    
    if (minTextField.text! > maxTextField.text!) {
       let alertbox = UIAlertController(title: "Range Error", message: "Max Price must be greater than Min Price", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertbox.addAction(ok)
        
        self.present(alertbox, animated: true, completion: nil)
        
    }
    
    if (categoriesTextField.text != "All") {
      guard !(categoriesTextField.text?.isEmpty)! else {
        print("category text field is empty")
        return
      }
        
        
      categoryToFilter = categoriesTextField.text!
    }
    buyingOptionToFilter = buyingOptionTextField.text!
    stateToFilter = stateName
    conditionFilter = conditionLabel.text ?? "Any"
    
    if let text = minTextField.text, text.count > 0 {
        priceMinFilter = (text.replacingOccurrences(of: "\(currency)", with: "") as NSString ).integerValue
    }
    if let textMax = maxTextField.text, textMax.count > 0 {
        priceMaxFilter = (textMax.replacingOccurrences(of: "\(currency)", with: "") as NSString).integerValue
    }
    priceMinFilter = priceMinFilter == nil ? -1 : priceMinFilter
    priceMaxFilter = priceMaxFilter == nil ? -1 : priceMaxFilter
  
    
    delegate?.btnDoneFiltersTapped(categoryToFilter, buyingOptionToFilter, stateToFilter, "All", priceMinFilter!, priceMaxFilter!)
    self.navigationController?.popViewController(animated: true)
  
    //self.performSegue(withIdentifier: "done", sender:self )
    
    
  tabBarController?.selectedIndex = 0
        
        
    
     print("Statename Filter btn press = \(stateToFilter)")
    
    
    }

    
  
  
  var check = true
  @IBAction func minPrice(_ sender: Any) {
    if check{
      let temp = minTextField.text
        if temp?.contains("\((currency ?? "$"))") == false{
        DispatchQueue.main.async {
            self.minTextField.text = "\((self.currency ?? "$"))" + temp!
        }
        
        check = false
      }
      else{
        check = false
      }
      
    }
    if minTextField.text == ""{
      check = true
    }
    
    
  }
  
  var maxPriceCheck = true
  @IBAction func maxPriceTextFieldAction(_ sender: Any) {
    if maxPriceCheck{
      if let temp = maxTextField.text {
        if temp.contains("\(currency ?? "$")") == false {
          DispatchQueue.main.async {
            self.maxTextField.text = "\(self.currency ?? "$")" + temp
          }
          
          maxPriceCheck = false
        }
      }else {
        maxPriceCheck = false
      }
    }
    if maxTextField.text == "" {
      maxPriceCheck = true
    }
    
  }
  
}


//MARK: - UIPickerViewDelegate,UIPickerViewDataSource
extension FiltersVc: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if pickerView == catPicker {
      //for selecting all input
      return categoriesArray.count + 1
    }
    else if pickerView == picker2 {
      //for selecting all input
      return buyOptionArray.count + 1
    }else if pickerView == countrypicker {
    //for selecing country input
       return countryList.count
    }else {
        return  1
    }
    
  }
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if pickerView == catPicker {
      if row == 0 { return "All" }
      return categoriesArray[row - 1]
    }
    else if pickerView == picker2{
      if row == 0 { return "Any" }
      return buyOptionArray[row - 1 ]
    }else if pickerView == countrypicker {
        return countryList[row]
    }else {
        return " "
    }
    
  }
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if pickerView == catPicker {
      if row == 0 {
        categoryToFilter = "All"
      }
      else {
        categoryToFilter = categoriesArray[row - 1]
       
      }
      categoriesTextField.text =  categoryToFilter
    }//end if pickerView == catPicker {
    else if pickerView == picker2 {
      if row == 0 {
        buyingOptionToFilter = "Any"
      }
      else {
        buyingOptionToFilter = buyOptionArray[ row - 1 ]
        
      }
      buyingOptionTextField.text = buyingOptionToFilter
      
    }else if pickerView == countrypicker {
        
        if countryList[row] == "USA" {
             currency = "$"
            
             minTextField.placeholder = "\(currency) Min"
             maxTextField.placeholder = "\(currency) Max"
            self.stateTextField.text = "NY"
            self.citytxt.text = "NewYork"
            self.Zipcodetxt.text = "10001"
        }else if countryList[row] == "IN" {
             currency = "₹"
            minTextField.placeholder = "\(currency) Min"
            maxTextField.placeholder = "\(currency) Max"
            self.stateTextField.text = "Haryana"
            self.citytxt.text = "Dehli"
            self.Zipcodetxt.text = "110026"
        }
       
        
        
        
        if let text = minTextField.text, text.count > 0 {
            priceMinFilter = (text.replacingOccurrences(of: "\(currency)", with: "") as NSString ).integerValue
        }
        if let textMax = maxTextField.text, textMax.count > 0 {
            priceMaxFilter = (textMax.replacingOccurrences(of: "\(currency)", with: "") as NSString).integerValue
        }
        
        
     Countrylist.text = countryList[row]
        
        
        
    
    }//end else if pickerView == picker2 {
    
    
  }
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let cell = tableView.cellForRow(at: indexPath)
    cell?.selectionStyle = UITableViewCellSelectionStyle.none
  }
}


//MARK:- UITextFieldDelegate
extension FiltersVc : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
            if textField.tag == 3 {
                
                
        if Countrylist.text == "IN" {
           
            Alamofire.request("http://postalpincode.in/api/pincode/\(self.Zipcodetxt.text!)", method: .get, encoding: JSONEncoding.default).responseJSON{(response) in
                switch response.result {
                    
                case .success(_):
                    print("datazip = \(response.value)")
                    let swiftyJson = JSON(response.result.value)
                    print("swiftyJson = \(swiftyJson)")
                    if swiftyJson["Message"].string != "No records found" {
                        let postOffice = swiftyJson["PostOffice"]
                        for result in postOffice {
                            print("Country = \(result.1["Country"].string!)")
                            self.indiaZipCode = IndiaPinCodeModel.init(name: result.1["Name"].string!, description: result.1["Description"].string!, branchType: result.1["BranchType"].string!, deliveryStatus: result.1["DeliveryStatus"].string!, taluk: result.1["Taluk"].string!, circle: result.1["Circle"].string!, district: result.1["District"].string!, division:  result.1["Division"].string!, region: result.1["Region"].string!, state: result.1["State"].string!, country: result.1["Country"].string!)
                          
                            self.citytxt.text = self.indiaZipCode?.district!
                            self.stateTextField.text = self.indiaZipCode?.state!
                            zipCode = self.Zipcodetxt.text!
                            
                            city = result.1["District"].string!
                            gpscountry = "IN"
                            self.cityAndStateName = "\(city) , \(stateName) \(zipCode)"
                            stateName = result.1["State"].string!
                            print("Statename from api = \(result.1["State"].string!)")
                             print("statename = \(stateName)")
                            self.titleview.citystateZIpcode.text = self.cityAndStateName
                        }
                    }else {
                        showSwiftMessageWithParams(theme: .error, title: "Zip Code not found!", body: "")
                    }
                    
                case .failure(let error):
                    print("error = \(error)")
                }
                
               
                
            }
         
        }else if Countrylist.text  == "USA"{
            print("zipcode USA = \(Zipcodetxt.text!)")
        
           
            Alamofire.request("http://ziptasticapi.com/\(self.Zipcodetxt.text!)", method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
                switch response.result {
                    
                case .success(_):
                    print("USA response = \(response.description)")
                    let swiftyJson = JSON(response.result.value)
                    print("USA response = \(swiftyJson)")
                
                    if swiftyJson["error"].string != "Zip Code not found!"  {
                        self.UsaZipCode = USAZipCodeModel.init(country: swiftyJson["country"].string!, state: swiftyJson["state"].string!, city: swiftyJson["city"].string!)
                        self.citytxt.text = self.UsaZipCode?.city
                        self.stateTextField.text = self.UsaZipCode?.state
                        zipCode = self.Zipcodetxt.text!
                        city = self.citytxt.text!
                        stateName = self.stateTextField.text!
                        gpscountry = "USA"
                        self.cityAndStateName = "\(self.UsaZipCode?.city) , \(self.UsaZipCode?.state) \(self.Zipcodetxt.text!)"
                        self.titleview.citystateZIpcode.text = self.cityAndStateName
                    }else {
                        showSwiftMessageWithParams(theme: .error, title: swiftyJson["error"].string!, body: "")
                    }
                
                case .failure(let error):
                    print("error \(error)")
                }
                
            }
            
            
        
        }
        
    }
    }
    
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    if textField == categoriesTextField || textField == buyingOptionTextField
      || textField == stateTextField {
      
      return false
      
    }else if textField == minTextField || textField == maxTextField {
      print(string)
      var areCharsValid = false
      //only allow decimal in price text fields
      let allowedChars = CharacterSet.decimalDigits
      let inputSet = CharacterSet.init(charactersIn: string)
      areCharsValid = allowedChars.isSuperset(of: inputSet)
      return areCharsValid
      
    }//end else if textField == minTextField || textField == maxTextField
    
    return true
  }//end function
  
}

protocol filtersVCDelegate: class {
  func btnDoneFiltersTapped(_ category : String, _ auction : String, _ citAndState: String, _ condition: String, _ priceMin : Int, _ priceMax : Int  )
    
    

}


