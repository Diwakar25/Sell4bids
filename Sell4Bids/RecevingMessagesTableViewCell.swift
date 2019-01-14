//
//  chatTableViewCell.swift
//  chatPractice
//
//  Created by Admin on 9/17/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class RecevingMessagesTableViewCell: UITableViewCell {
  
  
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var backView: UIView!
  @IBOutlet weak var cell1Stack: UIStackView!
  @IBOutlet weak var messageLabel: UILabel!
  
  @IBOutlet weak var viewMessageText: UIView!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    //        self.backView.layer.borderColor = UIColor.red as! CGColor
    //        let subView = UIView()
    //        subView.backgroundColor = .white
    //        subView.translatesAutoresizingMaskIntoConstraints = false
    //        cell1Stack.addSubview(subView) // Important: addSubview() not addArrangedSubview()
    //
    //        // use whatever constraint method you like to
    //        // constrain subView to the size of stackView.
    //        subView.topAnchor.constraint(equalTo: cell1Stack.topAnchor).isActive = true
    //        subView.bottomAnchor.constraint(equalTo: cell1Stack.bottomAnchor).isActive = true
    //        subView.leftAnchor.constraint(equalTo: cell1Stack.leftAnchor).isActive = true
    //        subView.rightAnchor.constraint(equalTo: cell1Stack.rightAnchor).isActive = true
    
    // now add your arranged subViews...
    // cell1Stack.addArrangedSubview(subView)
    
    // self.cell1Stack.layer.backgroundColor = UIColor.white as! CGColor
    
    //        self.cell1Stack.layer.borderColor = UIColor.red as! CGColor
    //  self.cell1Stack.clipsToBounds = true
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
