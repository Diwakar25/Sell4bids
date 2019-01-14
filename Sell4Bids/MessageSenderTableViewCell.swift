//
//  Cell2.swift
//  chatPractice
//
//  Created by Admin on 9/17/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class MessageSenderTableViewCell: UITableViewCell {

    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var cell2Stack: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!    
  
  @IBOutlet weak var viewMessageText: UIView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
