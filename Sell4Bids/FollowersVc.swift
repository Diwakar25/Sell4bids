//
//  FollowersVc.swift
//  Sell4Bids
//
//  Created by admin on 10/16/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import Cosmos
import XLPagerTabStrip

class FollowersVc: UIViewController , IndicatorInfoProvider {
  
  //MARK: - Properties
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var emptyMessage: UILabel!
  @IBOutlet weak var fidgetImageView: UIImageView!
  
  
  //MARK: - variables
  var nav:UINavigationController?
  var followerArray = [UserModel]()
  var followerProductsArray = [ProductModel]()
  var dbRef: DatabaseReference!
  
    @IBOutlet weak var errorimg: UIImageView!
    var imageUrl = ""
  override func viewDidLoad() {
    super.viewDidLoad()
    fidgetImageView.toggleRotateAndDisplayGif()
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = UIColor.white
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getFollowerlist()
  }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fidgetImageView.isHidden = true
        fidgetImageView.image = nil
        print("Disappear")
        
    }
  func hideCollectionView(hideYesNo : Bool) {
    
    emptyMessage.text = "People, who follow you, appear here"
    if hideYesNo == false {
      tableView.isHidden = false
      fidgetImageView.isHidden = true
        fidgetImageView.image = nil
      emptyMessage.isHidden = true
      errorimg.isHidden = true
        
    }
    else  {
      fidgetImageView.isHidden = true
        fidgetImageView.image = nil
        
      tableView.isHidden = true
      emptyMessage.isHidden = false
         errorimg.isHidden = false
    }
  }
  func getFollowerlist(){
    dbRef = Database.database().reference()
    guard let userID = Auth.auth().currentUser?.uid else {
      print("ERROR: while getting user ID")
      return
    }
    dbRef.child("users").child(userID).child("followers").observeSingleEvent(of: .value) { (followerSnapshot) in
      self.followerArray.removeAll()
      if followerSnapshot.childrenCount > 0 {
        guard let followersList = followerSnapshot.value as? NSDictionary else {
          print("ERROR: while getting followers list")
          self.hideCollectionView(hideYesNo: true)
          return
        }
        for follower in followersList {
          guard let userId = follower.key as? String else {return}
          self.dbRef.child("users").child(userId).observeSingleEvent(of: .value, with: { (userSnapshot) in
            guard let userDict = userSnapshot.value as? [String:AnyObject] else {return}
            let userList =  UserModel(userId: userId, userDict: userDict)
            self.followerArray.append(userList)
            self.fidgetImageView.isHidden = true
            self.fidgetImageView.image = nil
            DispatchQueue.main.async {
              self.hideCollectionView(hideYesNo: false)
              self.tableView.reloadData()
            }
          })
        }
      }else {
        self.hideCollectionView(hideYesNo: true)
      }
    }
  }//end func
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo.init(title: "Followers")
  }
}
//Mark: - UITableViewDataSource,UITableViewDelegate

extension FollowersVc: UITableViewDataSource,UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return followerArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard followerArray.count > 0 else {
      print("following arry count is 0 ")
      return UITableViewCell()
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
    let follwersInfo = followerArray[indexPath.row]
    cell.userName.text = follwersInfo.name
    if let imageUrl = follwersInfo.image {
      cell.userImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named:"emptyImage"))
    }
    
    if follwersInfo.averageRating != 0 {
      if let Rating = follwersInfo.averageRating {
        
        cell.cosmosViewRating.rating = Double(Rating)
        
      }
      if let totalrating = follwersInfo.totalRating {
        cell.ratingLabel.text = "( Total ratings- \(totalrating)  )"
      }
    }
    else {
      cell.cosmosViewRating.rating = 5
      cell.ratingLabel.text = "Not rated yet"
    }
    //
    cell.selectionStyle = UITableViewCellSelectionStyle.none
    cell.cosmosViewRating.settings.updateOnTouch = false
    cell.updateUIForFollower()
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectUser = followerArray[indexPath.row]
    let productDetailsSB = getStoryBoardByName(storyBoardNames.prodDetails)
    let controller = productDetailsSB.instantiateViewController(withIdentifier: "UserProfileVc") as! SellerProfileVC
    controller.userData = selectUser
    controller.userProductArray = followerProductsArray
    nav?.pushViewController(controller, animated: false)
//    self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 33, width: 50, height: 40)
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 130
  }
}

