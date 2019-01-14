//
//  SellerImageVC.swift
//  Sell4Bids
//
//  Created by MAC on 03/09/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class SellerImageVC: UIViewController {
  
  var userImage : UIImage? = nil
  @IBOutlet weak var btnDone: ButtonLarge!
  @IBOutlet weak var userImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    userImageView.image = userImage
    btnDone.addShadowAndRound()
    // Do any additional setup after loading the view.
  }
  
  
  @IBAction func btnDoneTapped(_ sender: UIButton) {
    dismiss(animated: true)
  }
  
}
