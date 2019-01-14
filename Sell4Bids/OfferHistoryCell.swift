//
//  OfferHistoryCell.swift
//  Sell4Bids
//
//  Created by MAC on 16/07/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class OfferHistoryCell: UITableViewCell {

  static var dateFormatter = DateFormatter()
  let timeZone = TimeZone.init(secondsFromGMT: 3600 * 5)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

  
  func setup(with offerModel : offerHistoryModel) {
    
    //setup views
    self.cardViewBuyerActivity.addShadowAndRound()
    self.cardViewSellerActivity.addShadowAndRound()
    
    //show hide
    let buyerOffer = offerModel.person.lowercased().contains("buyer")
    let price = offerModel.price, quantity = offerModel.quantity
    self.viewBuyerActivity.isHidden = !buyerOffer
    self.viewSellerActivity.isHidden = buyerOffer
    let messageType = offerModel.type
    
    OfferHistoryCell.dateFormatter.dateStyle = .long
    OfferHistoryCell.dateFormatter.timeStyle = .short
    //OfferHistoryCell.dateFormatter.timeZone = timeZone
    let date = Date.init(timeIntervalSince1970: TimeInterval(offerModel.timeStamp / 1000))
    let time = OfferHistoryCell.dateFormatter.string(from: date)
    
    if buyerOffer{
      self.lblBuyerMessage.text = offerModel.message + "          "
      self.lblDateBuyer.text = "\(time)"
      self.lblPriceAndQuantityBuyer.isHidden = messageType.lowercased().contains("message")
      self.lblPriceAndQuanBuyer.isHidden = messageType.lowercased().contains("message")
      self.lblPriceAndQuanBuyer.text = "$" + price + " x " + quantity
    }else {
      self.lblSellerMessage.text = offerModel.message
      self.lblDateSeller.text = "\(time)"
      self.lblPriceAndQuantitySeller.isHidden = messageType.lowercased().contains("message")
      self.lblPriceAndQuanSeller.isHidden = messageType.lowercased().contains("message")
      self.lblPriceAndQuanSeller.text = "$" + price + " x " + quantity
      
//      let layer = cardViewSellerActivity.layer
//      layer.backgroundColor = UIColor.clear.cgColor
//      layer.shadowColor = UIColor.black.cgColor
//      layer.shadowOffset = CGSize(width: 0, height: 1.0)
//      layer.shadowOpacity = 0.2
//      layer.shadowRadius = 4.0
//
//
//      let containerView = sellerCardContainer!
//      containerView.layer.cornerRadius = 8
//      containerView.layer.masksToBounds = true
      
      
    }
  }
  //Buyer View
  @IBOutlet weak var cardViewBuyerActivity: UIView!
  @IBOutlet weak var lblDateBuyer: UILabel!
  @IBOutlet weak var viewBuyerActivity: UIView!
  
  @IBOutlet weak var lblBuyerMessage: UILabel!
  @IBOutlet weak var lblPriceBuyer: UILabel!
  
  @IBOutlet weak var lblPriceAndQuanBuyer: UILabel!
  
  @IBOutlet weak var lblPriceAndQuantityBuyer: UILabel!
  //Seller Activity
  @IBOutlet weak var viewSellerActivity: UIView!
  
  @IBOutlet weak var cardViewSellerActivity: UIView!
  
  @IBOutlet weak var lblDateSeller: UILabel!
  
  @IBOutlet weak var lblSellerMessage: UILabel!
  
  @IBOutlet weak var lblPriceAndQuanSeller: UILabel!
  
  @IBOutlet weak var lblPriceAndQuantitySeller: UILabel!
  
  @IBOutlet weak var sellerCardContainer: UIView!
  
}
