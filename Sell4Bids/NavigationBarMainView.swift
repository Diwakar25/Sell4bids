//
//  NavigationBarMainView.swift
//  Sell4Bids
//
//  Created by admin on 09/11/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class NavigationBarMainView: UIView {

    @IBOutlet weak var menuBtn: UIButton!
    
    
    @IBOutlet weak var searchBarButton: UIButton!
    
    @IBOutlet weak var micBtn: UIButton!
    
    @IBOutlet weak var filterbtn: UIButton!
    
    @IBOutlet weak var citystateZIpcode: UILabel!
    
    @IBOutlet weak var inviteBtn: UIButton!
   
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
//    override func layoutMarginsDidChange() {
//    frame =  CGRect(x:3, y: 0, width: UIScreen.main.bounds.width, height: 40)
//
//    }
   
    override var intrinsicContentSize: CGSize {
       
        return CGSize(width: UIScreen.main.bounds.width, height: 25)
    }
    
    override func awakeFromNib() {
        print("State Name = \(citystateZIpcode.text)")
      
      
        layer.cornerRadius = 6
        layer.masksToBounds = true
        
    }

    
}
