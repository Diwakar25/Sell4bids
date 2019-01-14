//
//  SenderCell.swift
//  Sell4Bids
//
//  Created by admin on 24/10/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class SenderCell: UICollectionViewCell {

    
    @IBOutlet weak var itemviewmessage: UIView!
    
    @IBOutlet weak var itemmessageheight: NSLayoutConstraint!
    
    @IBOutlet weak var textmessagewidth: NSLayoutConstraint!
    
  
    
   
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var ReciverText: UILabel!


 
    
   
    
  
  
    
   
    
    
    override func awakeFromNib() {
     
        itemviewmessage.layer.cornerRadius = 12
//        itemviewmessage.layer.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
//        
        //itemview.layer.cornerRadius = 8
       // MessageView.layer.cornerRadius = 8
     
       // ReciverText.layer.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        
       // MessageView.layer.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
       
        
    }
    
  
}
public extension UIView {
    public func pin(to view: UIView) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}
