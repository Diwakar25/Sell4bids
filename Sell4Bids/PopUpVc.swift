//
//  PopUpVc.swift
//  Sell4Bids
//
//  Created by admin on 10/12/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class PopUpVc: UIViewController {
    //Mark: - Properties
    
    @IBOutlet weak var popupView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
popupView.layer.cornerRadius = 8
popupView.layer.masksToBounds =     true
        // Do any additional setup after loading the view.
    }
  
    @IBAction func closePopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
