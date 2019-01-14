//
//  DesignableTextField.swift
//  socialLogins
//
//  Created by Irfan on 10/4/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DesignableUITextField: UITextField{
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= RightPadding
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateLeftView()
        }
    }
    
    @IBInspectable var RightImage: UIImage?{
        didSet{
            updateRightView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    @IBInspectable var RightPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateLeftView()
        }
    }
    @IBInspectable var BorderWidth: CGFloat = 0{
        didSet{
        self.layer.borderWidth = BorderWidth
        }
    }
    @IBInspectable var BorderColor: UIColor = UIColor.black {
        didSet{
            self.layer.borderColor = BorderColor.cgColor
        }
    }
    
    func updateLeftView() {
        if let image = leftImage {
            leftViewMode = UITextFieldViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 13, height: 20))
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextFieldViewMode.never
            leftView = nil
        }
        
        // Placeholder text color
      //  attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedStringKey.foreg
        
    }
    
    
    func updateRightView(){
        if let image = RightImage{
            self.rightViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
            imageView.image = image
            imageView.tintColor = color
            rightView = imageView
        }
        else{
            rightViewMode = .never
            rightView = nil
        }
        
       // attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: color])
    }
    
}
