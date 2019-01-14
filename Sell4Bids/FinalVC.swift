//
//  FinalVCViewController.swift
//  Sell4Bids
//
//  Created by H.M.Ali on 11/4/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class FinalVC: UIViewController {
    
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var doneMessage: UILabel!
    var defaults = UserDefaults.standard
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
        super.viewDidLoad()
        addDoneLeftBarBtn()
        addLeftHomeBarButtonToTop()
        Finished = true
         defaults.set(Finished, forKey: "Finished")
        
        //VC1
        self.defaults.set(false, forKey: "ChoiceBtnoNoff")
        self.defaults.set("", forKey: "JobTitle")
        self.defaults.set("Select Employment Type", forKey: "EmployType")
        self.defaults.set(false, forKey: "MedicalCheckBox")
        self.defaults.set(false, forKey: "PTOCheckBox")
        self.defaults.set(false, forKey: "401K")
        self.defaults.set("", forKey: "ItemTitle")
        
        
        //VC2
        defaults.set("Select Category", forKey: "category")
        defaults.set("Select Job Category", forKey: "JobCategory")
        defaults.set(0, forKey: "condition")
        defaults.set(0, forKey: "JobCondition")
        defaults.set("Detailed description of Job", forKey: "JobDescription")
        defaults.set("Detailed description of Item", forKey: "description")
        
        //VC3
        self.defaults.set("", forKey: "Price")
        self.defaults.set("", forKey: "quantity")
        self.defaults.set(false, forKey: "ListIndefinitely")
        self.defaults.set("7 Days", forKey: "ListDuration")
        self.defaults.set(false, forKey: "AcceptOffers")
        self.defaults.set(false, forKey: "AutomaticRelisting")
        self.defaults.set("", forKey: "AuctionStartingPrice")
        self.defaults.set(false, forKey: "AddReservePrice")
        self.defaults.set("", forKey: "ReservePrice")
        self.defaults.set("Monthly", forKey: "AuctionListDuratoin")
        self.defaults.set(false, forKey: "AuctionAutoLIst")
        self.defaults.set("", forKey: "JobSalary")
        self.defaults.set("Monthly", forKey: "Payperiodtext")
        self.defaults.set(false, forKey: "JobListInfinity")
        self.defaults.set("7 Days", forKey: "JobListduration")
        self.defaults.set(false, forKey: "JobAcceptOffer")
        
        //VC4
        self.defaults.set("USA", forKey: "SelectedCountry")
        self.defaults.set("Enter Zip Code", forKey: "City_State_ZipCode")
        self.defaults.set("", forKey: "LocationFromZip")
        self.defaults.set(false, forKey: "LocateMeCheckStatus")
        self.defaults.set("", forKey: "CompanyName")
        self.defaults.set("", forKey: "CompanyDetails")
        
        
        
        
        
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.title = "Item listing successful"
        //   self.navigationController?.navigationItem.setHidesBackButton(true, animated: false)
        // self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        btnDone.addShadowAndRound()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func doneBtnAction(_ sender: DesignableButton) {
      
      let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
}
