//
//  CellEstablishContact.swift
//  Sell4Bids
//
//  Created by admin on 4/5/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class CellEstablishContact: UITableViewCell {

  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var lblErrorMessage: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
