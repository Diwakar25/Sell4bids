//
//  AuthTextField.swift
//  Sell4Bids
//
//  Created by admin on 8/20/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class AuthTextField: UITextField {
  
  override func awakeFromNib() {
    setup()
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    //setupButton()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  
  func setup() {
    
    //for 4 - 5 " screens
    var fontSize : CGFloat = 28
    if Env.isIpad { fontSize = 28 }
    else if UIDevice.isSmall { fontSize = 24 }
    
    font = UIFont.boldSystemFont(ofSize: fontSize)
    
    
  }
  
}
