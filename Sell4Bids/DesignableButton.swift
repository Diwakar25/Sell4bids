//
//  DesignableButton.swift
//  socialLogins
//
//  Created by Irfan on 9/28/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableButton: UIButton {
    
    @IBInspectable var BorderWidth : CGFloat = 0{
        didSet{
            self.layer.borderWidth = BorderWidth
        }
    }
    
    @IBInspectable var BorderColor : UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = BorderColor.cgColor
        }
    }
    
    @IBInspectable var CornerRadius : CGFloat = 0{
        didSet{
            self.layer.cornerRadius = CornerRadius
        }
    }
  

}
