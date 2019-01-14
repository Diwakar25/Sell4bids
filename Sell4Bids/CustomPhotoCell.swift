//
//  CustomPhotoCell.swift
//  Sell4Bids
//
//  Created by admin on 12/27/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class CustomPhotoCell: UICollectionViewCell {
    
  @IBOutlet weak var imageView: UIImageView!
  
  @IBOutlet weak var containerView: UIView!
  override func awakeFromNib() {
    super.awakeFromNib()
    containerView.layer.cornerRadius = 6
    containerView.layer.masksToBounds = true
  }
}
