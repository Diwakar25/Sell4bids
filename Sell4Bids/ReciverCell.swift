//
//  ReciverCell.swift
//  Sell4Bids
//
//  Created by admin on 24/10/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class ReciverCell: UICollectionViewCell {
    

    @IBOutlet weak var MessageView: UIView!
    
    
    @IBOutlet weak var textviewwidth: NSLayoutConstraint!
    
    @IBOutlet weak var textviewheight: NSLayoutConstraint!
    
   
   
    @IBOutlet weak var messageText: UILabel!

    @IBOutlet weak var dateLabel: UILabel!
   
  
    
   
    
    override func awakeFromNib() {
        
       
        
//       MessageView.layer.cornerRadius = 12
//       MessageView.layer.backgroundColor =  UIColor(red:  0/255, green: 137/255, blue: 249/255, alpha: 1).cgColor
        
        
       // messageText.layer.backgroundColor = UIColor(red:  0/255, green: 137/255, blue: 249/255, alpha: 1).cgColor
       
      //  messageText.layer.cornerRadius = 2.5
      
    }
    
 
}
