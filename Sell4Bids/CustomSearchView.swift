//
//  CustomSearchView.swift
//  Sell4Bids
//
//  Created by admin on 06/12/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class CustomSearchView: UIView {

    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var menubtn: UIButton!
    @IBOutlet weak var micbtn: UIButton!
    
    @IBOutlet weak var invitebtn: UIButton!
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 25)
    }
    
    override func awakeFromNib() {
        layer.cornerRadius = 6
    
        layer.masksToBounds = true
        
    }

}

