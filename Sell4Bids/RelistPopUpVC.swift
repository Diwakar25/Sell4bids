//
//  RelistPopUpVC.swift
//  Sell4Bids
//
//  Created by H.M.Ali on 11/6/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
protocol IsRelistItemDelegate {
  func dataChange(checkRelist: Bool)
}
class RelistPopUpVC: UIViewController,UITextFieldDelegate {
  //MARK:- Properties
  
  @IBOutlet weak var mainView: UIView!
  @IBOutlet weak var startPriceLabel: UILabel!
  @IBOutlet weak var startPriceTFO: UITextField!
  @IBOutlet weak var reservePriceLabel: UILabel!
  @IBOutlet weak var reservePriceTFO: UITextField!
  @IBOutlet weak var numberOfDaysLabel: UILabel!
  @IBOutlet weak var dayTFO: UITextField!
  @IBOutlet weak var topConstraint: NSLayoutConstraint!
  
  
  //Mark:- Variables
  var completed = Bool()
  var auctionType = ""
  var isRelist = false
  var list = ["3 Days","5 Days","7 Days","15 Days","21 Days","30 Days"]
  var picker = UIPickerView()
  var previousData = [String:Any]()
  var delegate:IsRelistItemDelegate?
    var selecteditem : ProductModel?
  override func viewDidLoad() {
    super.viewDidLoad()
    print("currencySymbol == \(selecteditem?.currency_symbol)")
    reservePriceTFO.delegate = self
    startPriceTFO.delegate = self
    picker.delegate = self
    dayTFO.inputView = picker
    
    
    createToolBar(textField: dayTFO)
    
    designView(acutionType: auctionType)
    // Do any additional setup after loading the view.
    setupViews()
  }
  
  private func setupViews() {
    startPriceTFO.makeRedAndRound()
    reservePriceTFO.makeRedAndRound()
    dayTFO.makeRedAndRound()
  }
  
  
  func designView(acutionType: String)
  {
    if self.previousData["auctionType"] as! String == "reserve"{
      self.reservePriceTFO.isHidden = false
      self.reservePriceLabel.isHidden = false
      topConstraint.constant = self.reservePriceLabel.frame.height+self.reservePriceTFO.frame.height+10+15+15
    }
    else{
      self.reservePriceTFO.isHidden = true
      self.reservePriceLabel.isHidden = true
      self.topConstraint.constant = 15
    }
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
    if dayTFO.isFirstResponder{
      dayTFO.endEditing(true)
    }
  }
  
  
  
  @IBAction func closeBtnAction(_ sender: UIButton) {
    
    self.dismiss(animated: true, completion: nil)
    
  }
  
  @IBAction func updateBtnAction(_ sender: UIButton) {
    
    let auctionType = self.previousData["auctionType"] as! String
    
    
    var sPrice = self.startPriceTFO.text
    var rPrice = self.reservePriceTFO.text
    var day = self.dayTFO.text
    var intStartPrice = 0
    var intReservePrice = 0
    var intDay : Int64 = 0
    var aborted = false
    let alert = UIAlertController(title: "SUCCESSFULL", message: "Your item Re-listed Successfully", preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) in
        
        self.dismiss(animated: true, completion: nil)
        
        
        
    })
    
    alert.addAction(ok)
    //to get IntStartPrice
    //this can be null
    
    if selecteditem?.currency_symbol == "$" {
        if sPrice != nil && sPrice != "" && sPrice != "$"{
            
            var  i = sPrice?.characters.index(of: "$")
            
            sPrice?.remove(at: i!)
            
            
            intStartPrice = Int(sPrice!)!
            
        }else {
            intStartPrice = 0
        }
    
    }else if selecteditem?.currency_symbol == "₹" {
        if sPrice != nil && sPrice != "" && sPrice != "₹"{
            
            var  i = sPrice?.characters.index(of: "₹")
            
            sPrice?.remove(at: i!)
            
            
            intStartPrice = Int(sPrice!)!
            
        }else {
            intStartPrice = 0
        }
    }
      
   
    
    //for reserve Price
    //this can be null too
    if selecteditem?.currency_symbol == "$" {
        if sPrice != nil && sPrice != "" && sPrice != "$"{
            
            var  i = sPrice?.characters.index(of: "$")
            
//            sPrice?.remove(at: i! )
//
//
//            intStartPrice = Int(sPrice!)!
            
        }else {
            intStartPrice = 0
        }
        
    }else if selecteditem?.currency_symbol == "₹" {
        if sPrice != nil && sPrice != "" && sPrice != "₹"{
            
            let  i = sPrice?.characters.index(of: "₹")
            
//            sPrice?.remove(at: i!)
//
//
//            intStartPrice = Int(sPrice!)!
            
        }else {
            intStartPrice = 0
        }
    }
    
    
    
    //For day textField
    
    if day != nil && day != ""{
      
      var array = day?.components(separatedBy: " ")
      print(array![0])
      if array![0] != ""{
        intDay = Int64(array![0])!
        
        intDay = intDay*24*60*60*1000
      }
      else{
        self.alert(message: "Please select feasible duration", title: "ERROR")
        return
      }
    }
    else{
      self.alert(message: "Please select feasible duration", title: "ERROR")
      return
    }
    
    
    if intReservePrice != 0 && intStartPrice != 0{
      
      if intReservePrice <= intStartPrice{
        self.alert(message: "Reserve Price can never be lesser than Start Price", title: "ERROR")
        return
      }
      
      
    }
    
    
    var ref = Database.database().reference()
    var ref2 = Database.database().reference()
    var dic = ["temporaryTimeStamp":ServerValue.timestamp()]
    var ref3 = Database.database().reference()
    

    ref.updateChildValues(dic)
    
    ref.child("temporaryTimeStamp").observeSingleEvent(of: .value) { (snapshot) in
        
        
        
        if let  currentTime = snapshot.value as? Int64{
          
            ref2.child("products").child(self.previousData["category"] as! String).child(self.previousData["auctionType"] as! String).child(self.previousData["state"] as! String).child(self.previousData["productID"] as! String).runTransactionBlock { (mutableData) -> TransactionResult in
                
                if var data = mutableData.value as? [String:Any]{
                    
                    if let endTime = data["endTime"] as? Int64{
                        
                        print("End Time == \(endTime)")
                        let dif = currentTime - endTime
                        
                        if dif <= 0 || endTime == -1{
                            //nhi hoga relist
                            
                            
                            
                        }
                        else{
                            //hoga relist
                            
                            
                            if self.previousData["auctionType"] as! String == "buy-it-now"{
                                
                                if intStartPrice != 0{
                                    //To Store StartPrice
                                    var startPrice = data["startPrice"] as? String
                                    
                                    if startPrice != nil{
                                        
                                        if intStartPrice != 0{
                                            data["startPrice"] = "\(intStartPrice)"
                                        }
                                        
                                    }else{
                                        DispatchQueue.main.async {
                                            self.alert(message: "No start Price Found", title: "ERROR")
                                        }
                                        
                                    }
                                }
                                
                                
                                //To store Days
                                
                                // data["endTime"] = intDay
                                
                            }
                            else{
                                
                                var bids = data["bids"] as? [String:Any]
                                
                                if bids != nil && bids?.count != 0{
                                    
                                    print(bids)
                                    if intStartPrice != 0{
                                        bids?.removeAll()
                                        bids?.updateValue("0", forKey: "maxBid")
                                        bids?.updateValue("\(intStartPrice)", forKey: "startPrice")
                                    }
                                        
                                    else{
                                        var temp = bids!["startPrice"] as? String
                                        if temp != nil && temp != ""{
                                            bids?.removeAll()
                                            bids?.updateValue("0", forKey: "maxBid")
                                            bids?.updateValue(temp, forKey: "startPrice")
                                        }
                                        else{
                                            DispatchQueue.main.async {
                                                self.alert(message: "Some Inernal Error has occeured", title: "ERROR")
                                                aborted = true
                                                // TransactionResult.abort()
                                            }
                                            self.completed = false
                                            aborted = true
                                            TransactionResult.abort()
                                        }
                                        
                                    }
                                    
                                    data["bids"] = bids
                                    
                                }//if bid not found
                                else{
                                    DispatchQueue.main.async {
                                        self.alert(message: "Some Inernal Error has occeured", title: "ERROR")
                                    }
                                    self.completed = false
                                    aborted = true
                                    TransactionResult.abort()
                                }
                                
                                if auctionType == "reserve" && aborted != true{
                                    
                                    var reserveP = data["rPrice"] as? String
                                    var startP = data["startPrice"] as? String
                                    //for reservePrice
                                    //reservePRice di h lkn startPRice nhi di
                                    if intReservePrice != 0 && intStartPrice == 0{
                                        
                                        
                                        if startP != nil{
                                            if intReservePrice > Int(startP!)!{
                                                data["rPrice"] = "\(intReservePrice)"
                                            }
                                            else if intReservePrice < Int(startP!)!{
                                                DispatchQueue.main.async {
                                                    self.alert(message: "Start Price is: "+"\(startP)"+" Please provide Reserve PRice greater than "+"\(startP)", title: "ERROR")
                                                }
                                                self.completed = false
                                                aborted = true
                                                TransactionResult.abort()
                                            }
                                        }
                                        else{
                                            DispatchQueue.main.async {
                                                self.alert(message: "Some Inernal Error has occeured", title: "ERROR")
                                            }
                                            self.completed = false
                                            aborted = true
                                            TransactionResult.abort()
                                        }
                                        
                                    }
                                        //reservePRice nhi di lkn startPrice di h
                                    else if intReservePrice == 0 && intStartPrice != 0{
                                        
                                        if intStartPrice < Int(reserveP!)! {
                                            //good to do taks
                                            data["startPrice"] = "\(intStartPrice)"
                                        }
                                        else if intStartPrice > Int(reserveP!)!{
                                            //problem
                                            DispatchQueue.main.async {
                                                self.alert(message: "Reserve Price is: "+"\(reserveP)"+" Please provide Reserve PRice greater than "+"\(reserveP)", title: "ERROR")
                                            }
                                            self.completed = false
                                            aborted = true
                                            self.completed = false
                                            TransactionResult.abort()
                                        }
                                        
                                        
                                        
                                    }
                                        //dono nhi di
                                    else if intReservePrice == 0 && intStartPrice == 0{
                                        //do nothing
                                    }
                                    else if intReservePrice != 0 && intStartPrice != 0 && aborted != true{
                                        
                                        data["startPrice"] = "\(intStartPrice)"
                                        data["rPrice"] = "\(intReservePrice)"
                                        
                                        
                                    }
                                    
                                    
                                    
                                    
                                }
                                    
                                    //for non reserve
                                else if aborted != true{
                                    
                                    //hiven start price
                                    if intStartPrice != 0{
                                        
                                        var temp = data["startPrice"] as? String
                                        if temp != nil && temp != ""{
                                            
                                            data["startPrice"] = "\(intStartPrice)"
                                            
                                        }
                                        else{
                                            DispatchQueue.main.async {
                                                self.alert(message: "Some Inernal Error has occeured", title: "ERROR")
                                            }
                                            self.completed = false
                                            aborted = true
                                            TransactionResult.abort()
                                            
                                        }
                                        
                                        
                                    }
                                    else{
                                        //do nothing with start price
                                    }
                                    
                                }
                                
                            }
                            
                            //to update new Days (endtime)
                            if aborted != true{
                                var endTime = data["endTime"] as? Int64
                                if endTime != nil{
                                    
                                    // var time = currentTime+intDay
                                    endTime = currentTime + intDay
                                    data["endTime"] = endTime
                                    ref2.child("items").child((self.selecteditem?.productKey!)!).child("endTime").setValue(endTime)
                                    
                                }
                                else{
                                    DispatchQueue.main.async {
                                        self.alert(message: "Some Inernal Error has occeured", title: "ERROR")
                                    }
                                    self.completed = true
                                    aborted = true
                                    TransactionResult.abort()
                                }
                                
                                
                            }
                            if aborted != true{
                                mutableData.value = data
                            }
                            
                            
                            
                        }
                        
                        
                           self.present(alert, animated: true, completion: nil)
                    }
                    else{
                        print("no endTime Found")
                    }
                    
                }
                else{
                    print("no data found in transaction block")
                }
                
                
                
                
                
                
                //self.present(alert, animated: true, completion: nil)
                self.isRelist = true
                self.delegate?.dataChange(checkRelist: self.isRelist)
                
                DispatchQueue.main.async {
                    
                }
                
                
                return TransactionResult.success(withValue: mutableData)
            }
        
        
        }
        
        
        
    }
    
  }
  
  var reservePriceCheck = true
  @IBAction func reservePriceTextFieldAction(_ sender: UITextField) {
    
    if selecteditem?.currency_symbol == "$" {
        
        
        if reservePriceCheck{
            let temp = sender.text
            if temp?.contains("$")==false{
                sender.text = "$" + temp!
                reservePriceCheck = false
            }
            else{
                reservePriceCheck = false
            }
            
        }
    }else if selecteditem?.currency_symbol == "₹" {
        if reservePriceCheck{
            let temp = sender.text
            if temp?.contains("₹")==false{
                sender.text = "₹" + temp!
                reservePriceCheck = false
            }
            else{
                reservePriceCheck = false
            }
            
        }
    }
    
    
    
    if sender.text == ""{
      reservePriceCheck = true
    }
    
    
  }
  
  
  var startPriceCheck = true
  @IBAction func startPriceTextFieldAction(_ sender: UITextField) {
    
    if selecteditem?.currency_symbol == "$" {
        if startPriceCheck{
            let temp = sender.text
            if temp?.contains("$")==false{
                sender.text = "$" + temp!
                startPriceCheck = false
            }
            else{
                startPriceCheck = false
            }
            
        }
        if sender.text == ""{
            startPriceCheck = true
        }
        
    }else if selecteditem?.currency_symbol == "₹" {
        if startPriceCheck{
            let temp = sender.text
            if temp?.contains("₹")==false{
                sender.text = "₹" + temp!
                startPriceCheck = false
            }
            else{
                startPriceCheck = false
            }
            
        }
        if sender.text == ""{
            startPriceCheck = true
        }
        
    }
   
  }
  
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    var touch = touches.first
    
    if touch?.view != reservePriceTFO && reservePriceTFO.isFirstResponder{
      reservePriceTFO.resignFirstResponder()
    }
    else if touch?.view != startPriceTFO && startPriceTFO.isFirstResponder{
      startPriceTFO.resignFirstResponder()
    }
    else if touch?.view != dayTFO && dayTFO.isFirstResponder{
      dayTFO.resignFirstResponder()
    }
    
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    
    
    if textField == startPriceTFO || textField == reservePriceTFO{
      
      var temp = string//priceTextField.text
        if selecteditem?.currency_symbol == "$" {
             temp = temp.replacingOccurrences(of: "$", with: "")
        }else if selecteditem?.currency_symbol == "₹" {
             temp = temp.replacingOccurrences(of: "₹", with: "")
        }
     
      
      let allowedCharacters = CharacterSet.decimalDigits
      let characterSet = CharacterSet(charactersIn: temp)
      let result = allowedCharacters.isSuperset(of: characterSet)
      if result == false{
        let alert = UIAlertController(title: "ERROR", message: "Please enter Numbers only", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if self.selecteditem?.currency_symbol == "$" {
                textField.text = "$"
            }else if self.selecteditem?.currency_symbol == "₹" {
                textField.text = "₹"
            }
            
        })
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
      }
      return true
      
     
    }
    return true
  }
  
}


extension RelistPopUpVC : UIPickerViewDelegate, UIPickerViewDataSource{
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return list.count
    
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return list[row]
    //return list[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if dayTFO.isFirstResponder {
      
      dayTFO.text = list[row]
      
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
    
    label.font = UIFont.boldSystemFont(ofSize: 30)
    label.text = list[row]
    return label
  }
}
