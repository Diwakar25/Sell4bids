//
//  DesignableView.swift
//  socialLogins
//
//  Created by Irfan on 9/28/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
@IBDesignable
class DesignableView: UIView{
    @IBInspectable var BorderWidth : CGFloat = 0{
        didSet{
            self.layer.borderWidth = BorderWidth
        }
    }
    @IBInspectable var BorderColor : UIColor = UIColor.black{
        didSet{
            self.layer.borderColor = BorderColor.cgColor
        }
    }
}

//class GradientView: UIButton {
//
//    @IBInspectable var FirstColor : UIColor = UIColor.clear{
//        didSet{
//            updateView()
//        }
//    }
//
//    @IBInspectable var SecondColor : UIColor = UIColor.clear{
//        didSet{
//            updateView()
//        }
//    }
//
//    @IBInspectable var MixingPlace : NSNumber = 0
//
//        {
//        didSet{
//            updateView()
//
//        }
//    }
//
//    override class var layerClass: AnyClass{
//                get{
//                    return CAGradientLayer.self
//                }
//            }
//
//    func updateView(){
//        let layer = self.layer as! CAGradientLayer
//        layer.colors = [FirstColor.cgColor, SecondColor.cgColor]
//        layer.locations = [MixingPlace]
//        layer.startPoint = CGPoint(x: 0.0   , y: 0.5)
//        layer.endPoint = CGPoint(x: 0.5, y: 1.0)
//    }

//}
