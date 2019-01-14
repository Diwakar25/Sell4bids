//
//  designableSlider.swift
//  newProduct
//
//  Created by admin on 9/19/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

@IBDesignable
class designableSlider: UISlider {


    @IBInspectable var thumbImage: UIImage? {
        didSet {
            setThumbImage(thumbImage, for: .normal)
        }
    }
    
    @IBInspectable var thumbHighlited: UIImage? {
        didSet {
            setThumbImage(thumbHighlited, for: .highlighted)
        }
        
    }
    
    @IBInspectable var trackImage: UIImage? {
        didSet{
            setMaximumTrackImage(trackImage, for: .normal)
        }
    }

}
