//
//  ChatNavi.swift
//  Sell4Bids
//
//  Created by admin on 06/11/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class ChatNavi: UIView {

    @IBOutlet weak var userImg: UIImageView!
    
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    var navi = UINavigationController()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
 
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 130)
    }
    
    
    override func awakeFromNib() {
      
        
    }

}
