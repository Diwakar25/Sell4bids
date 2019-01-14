//
//  CustomTableViewCell.swift
//  Sell4Bids
//
//  Created by admin on 9/9/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Cosmos
class CustomTableViewCell: UITableViewCell {
  
  
  //MARK: - Properties
  @IBOutlet weak var lblText: UILabel!
  @IBOutlet weak var tableViewImage: UIImageView!
  
  @IBOutlet weak var contentVieww: UIView!
  @IBOutlet weak var backgroundCardViewF: UIView!
  
  //FollowerVC Properties
  @IBOutlet weak var userImage: UIImageView!
  @IBOutlet weak var userName: UILabel!
  @IBOutlet weak var cosmosViewRating: CosmosView!
  
  
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var btnMarkPaid: UIButton!
  
  
  //FollowingVC properties
  
  @IBOutlet weak var FollwingUserImageView: UIImageView!
  @IBOutlet weak var followingUserNameLabel: UILabel!
  @IBOutlet weak var backgroundcardView: UIView!
  @IBOutlet weak var ContentViewww: UIView!
  @IBOutlet weak var followingCosmosView: CosmosView!
  @IBOutlet weak var followingRating: UILabel!
  
  
  //BlockVC Preoperties
  
  @IBOutlet weak var contentViewBlock: UIView!
  @IBOutlet weak var blockUserImageView: UIImageView!
  @IBOutlet weak var blockUserNameLabel: UILabel!
  @IBOutlet weak var backgroundCardViewOfBlockUser: UIView!
  @IBOutlet weak var blockCosmosView: CosmosView!
  @IBOutlet weak var blockRating: UILabel!
  
  //View Offers Properties
  
  @IBOutlet weak var contentViewOffers: UIView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var boughtPriceLabel: UILabel!
  @IBOutlet weak var quantityLabel: UILabel!
  @IBOutlet weak var backgroundCardViewOffers: UIView!
  @IBOutlet weak var CosmosRatingOrders: CosmosView!
  @IBOutlet weak var acceptBtn: DesignableButton!
  @IBOutlet weak var rejectBtn: DesignableButton!
  
  @IBOutlet weak var sendOfferBtn: DesignableButton!
  
  @IBOutlet weak var viewYouMarked: UIView!
  
  @IBOutlet weak var btnYouMarkedPaid: UIButton!
  //Bidding History
  
  
  @IBOutlet weak var bidingUserName: UILabel!
  @IBOutlet weak var rateUserLabel: UILabel!
  @IBOutlet weak var bidPrice: UILabel!
  @IBOutlet weak var bidingContenView: UIView!
  @IBOutlet weak var bidingCardView: UIView!
  @IBOutlet weak var highestbidder: UILabel!
  
  // Jobs List Properties
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var jobCategoryLabel: UILabel!
  @IBOutlet weak var startPriceLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var payPeriodLabel: UILabel!
  @IBOutlet weak var jobsContentView: UIView!
  @IBOutlet weak var jobsCardView: UIView!
  
  //viewOffersVCCell
  @IBOutlet weak var viewRating: UIView!
  @IBOutlet weak var viewAcceptRejSendCountOffer: UIView!
  @IBOutlet weak var viewShareLocation: UIView!
  @IBOutlet weak var btnShareLocation: UIButton!
  @IBOutlet weak var lblLocationStatus: UILabel!
  @IBOutlet weak var constraintBidNameToCenter: NSLayoutConstraint!
  
  @IBOutlet weak var constraintBidNameTopToHighestBidder: NSLayoutConstraint!
  
  @IBOutlet weak var lblCeilingAmount: UILabel!
  
  @IBOutlet weak var lblCeilingAmountStatic: UILabel!
  func updateUIForFollowing(){
    
    backgroundcardView.backgroundColor = UIColor.white
    ContentViewww.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
    backgroundcardView.layer.cornerRadius = 3.0
    backgroundcardView.layer.masksToBounds = false
    backgroundcardView.layer.shadowColor = UIColor.black.cgColor
    backgroundcardView.layer.shadowOffset = CGSize(width: 0, height: 0)
    backgroundcardView.layer.shadowOpacity = 0.8
    
    //Following
    FollwingUserImageView.layer.borderWidth = 2
    FollwingUserImageView.layer.borderColor = UIColor.red.cgColor
    FollwingUserImageView.layer.cornerRadius = FollwingUserImageView.frame.width/2
    FollwingUserImageView.layer.masksToBounds = false
    FollwingUserImageView.clipsToBounds = true
    
  }
  func updateUIForFollower()
  {
    backgroundCardViewF.backgroundColor = UIColor.white
    contentVieww.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
    backgroundCardViewF.layer.cornerRadius = 3.0
    backgroundCardViewF.layer.masksToBounds = false
    backgroundCardViewF.layer.shadowColor = UIColor.black.cgColor
    backgroundCardViewF.layer.shadowOffset = CGSize(width: 0, height: 0)
    backgroundCardViewF.layer.shadowOpacity = 0.8
    
    userImage.layer.borderWidth = 2
    userImage.layer.borderColor = UIColor.red.cgColor
    userImage.layer.cornerRadius = userImage.frame.width/2
    userImage.layer.masksToBounds = false
    userImage.clipsToBounds = true
  }
  func updateUIForBlockedUser()
  {
    backgroundCardViewOfBlockUser.backgroundColor = UIColor.white
    contentViewBlock.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
    backgroundCardViewOfBlockUser.layer.cornerRadius = 3.0
    backgroundCardViewOfBlockUser.layer.masksToBounds = false
    backgroundCardViewOfBlockUser.layer.shadowColor = UIColor.black.cgColor
    backgroundCardViewOfBlockUser.layer.shadowOffset = CGSize(width: 0, height: 0)
    backgroundCardViewOfBlockUser.layer.shadowOpacity = 0.8
    
    blockUserImageView.layer.borderWidth = 2
    blockUserImageView.layer.borderColor = UIColor.red.cgColor
    blockUserImageView.layer.cornerRadius = blockUserImageView.frame.width/2
    blockUserImageView.layer.masksToBounds = false
    blockUserImageView.clipsToBounds = true
  }
  func addShadows(){
    backgroundCardViewOffers.backgroundColor = UIColor.white
    contentViewOffers.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
    backgroundCardViewOffers.layer.cornerRadius = 3.0
    backgroundCardViewOffers.layer.masksToBounds = false
    backgroundCardViewOffers.layer.shadowColor = UIColor.black.cgColor
    backgroundCardViewOffers.layer.shadowOffset = CGSize(width: 0, height: 0)
    backgroundCardViewOffers.layer.shadowOpacity = 0.4
    
  }
  func updateUIForBiding(){
    bidingCardView.backgroundColor = UIColor.white
    bidingContenView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
    bidingCardView.layer.cornerRadius = 3.0
    bidingCardView.layer.masksToBounds = false
    bidingCardView.layer.shadowColor = UIColor.black.cgColor
    bidingCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
    bidingCardView.layer.shadowOpacity = 0.4
    
  }
  func updateUIForJobs(){
    jobsCardView.backgroundColor = UIColor.white
    jobsContentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
    jobsCardView.layer.cornerRadius = 3.0
    jobsCardView.layer.masksToBounds = false
    jobsCardView.layer.shadowColor = UIColor.black.cgColor
    jobsCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
    jobsCardView.layer.shadowOpacity = 0.4
    
  }
  
}
