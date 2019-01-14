//
//  ImageCollectionViewCell.swift
//  Sell4Bids
//
//  Created by admin on 8/25/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productHiddenBlurEffect: UIVisualEffectView!
    
    @IBOutlet weak var productHiddenLabel: UILabel!
    @IBOutlet weak var imageViewProduct: UIImageView!
    
    //MARK: - Properties
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var labelCell: UILabel!
    
    @IBOutlet weak var myImage: UIImageView!
    
    //properties of MySell4Bids
    
    @IBOutlet weak var sellImagevView: UIImageView!
    
    @IBOutlet weak var titleCellLabel: UILabel!
    
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblPriceProduct: UILabel!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
}
