//
//  MyChatCell.swift
//  Sell4Bids
//
//  Created by H.M.Ali on 11/2/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class MyChatCell: UITableViewCell {
  
    @IBOutlet weak var lastMessage: UILabel!
    
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  
  @IBOutlet weak var onlineTextLabel: UILabel!
  @IBOutlet weak var unreadCountLabel: UILabel!
  
  @IBOutlet weak var userImageView: UIImageView!
  
  @IBOutlet weak var lblUserInitials: UILabel!
 
    
    @IBOutlet weak var itemImage: UIImageView!
    
    
    
    override func awakeFromNib() {
    super.awakeFromNib()
    
    
    
    // Initialization code
    statusLabel.layer.cornerRadius = 7.5
    
    unreadCountLabel.layer.cornerRadius = unreadCountLabel.frame.height/2
    
    
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
}
