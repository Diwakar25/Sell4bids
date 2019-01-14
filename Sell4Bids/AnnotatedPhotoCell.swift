//
//  Photo.swift
//  Sell4Bids
//
//  Created by admin on 12/19/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class AnnotatedPhotoCell: UICollectionViewCell {
    
    
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var bidNowBtn: DesignableButton!
  
  //Category Properties
  @IBOutlet weak var categoryBidNowBtn: DesignableButton!
  @IBOutlet weak var categoryImageView: UIImageView!
  @IBOutlet weak var categoryPriceLabel: UILabel!
  @IBOutlet weak var categoryContainerView: UIView!
  //Main Vc Properties
  
  
  @IBOutlet weak var mainContainerView: UIView!
  @IBOutlet weak var mainImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var mainBidNowBtn: UIButton!
  
 
    
    
  override func awakeFromNib() {
    super.awakeFromNib()
    self.fade_Out()
  }
    

  
  func setupWith(product : ProductModel ) {
    
    
    
    let cell = self
    cell.categoryPriceLabel.text = product.title
    if let imageURL = product.imageUrl0 {
      cell.categoryImageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "emptyImage"))
    }
    
    cell.layer.cornerRadius = 3.0
    cell.layer.masksToBounds = false
    cell.layer.shadowColor = UIColor.black.cgColor
    cell.layer.shadowOffset = CGSize(width: 0, height: 0)
    cell.layer.shadowOpacity = 0.6
    
    cell.categoryImageView.sd_setShowActivityIndicatorView(true)
    
    cell.categoryContainerView.layer.cornerRadius = 8
    cell.categoryContainerView.clipsToBounds = true
    cell.categoryPriceLabel.text = product.title
    cell.categoryBidNowBtn.backgroundColor = UIColor(red:255/255, green:27/255, blue:34/255, alpha:0.8)
    
    if product.auctionType == "buy-it-now"{
      cell.categoryBidNowBtn.setTitle("Buy at \(product.currency_symbol ?? "$")\(product.startPrice!)", for: .normal)
      if let quantity =  product.quantity, quantity == 0 {
        cell.categoryBidNowBtn.setTitle("Sold at \(product.currency_symbol ?? "$")\(product.startPrice!)", for: .normal)
        cell.categoryBidNowBtn.backgroundColor = UIColor(red:184/255, green:184/255, blue:184/255, alpha:1)
      }
       
      
    }
      
    else  {
      cell.categoryBidNowBtn.setTitle("Bid at \(product.currency_symbol ?? "$")\(product.startPrice!)", for: .normal)
      
    }
    if product.categoryName == "Jobs"{
      cell.categoryBidNowBtn.setTitle("Apply Now", for: .normal)
    }
    if product.startPrice == 0 {
      cell.categoryBidNowBtn.setTitle("Free", for: .normal)
    }
    
    
    
    
    if let timeRemaining =  product.timeRemaining, timeRemaining < 0 && product.endTime! > 0 {
      cell.categoryBidNowBtn.backgroundColor = UIColor(red:184/255, green:184/255, blue:184/255, alpha:1)
    }
    else if product.timeRemaining == nil {
      //no time remaining node is present
      //get current server time and compare with end time. and grey out the button if current time >= end time
      getCurrentServerTime { (success, currentTime) in
        if success {
          let currentTimeInt64 = Int64(currentTime)
          if let endTime = product.endTime {
            if currentTimeInt64 >= endTime { cell.categoryBidNowBtn.backgroundColor = UIColor(red:184/255, green:184/255, blue:184/255, alpha:1)}
          }
        }
      }
    }
    
  }
    
    
}
