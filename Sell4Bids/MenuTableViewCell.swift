//
//  MenuTableViewCell.swift
//  Sell4Bids
//
//  Created by admin on 8/29/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    //MARK: - Properties
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var menuLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
