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

class FollowingVc: UIViewController, IndicatorInfoProvider {
  
  //Mark: - Properties
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var emptyMessage: UILabel!
  @IBOutlet weak var fidgetImageView: UIImageView!
  
  //Mark: - variables
  var nav:UINavigationController?
  var followingArray = [UserModel]()
  
  var dbRef: DatabaseReference!
  var imageUrl = ""
    @IBOutlet weak var errorimg: UIImageView!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    fidgetImageView.toggleRotateAndDisplayGif()
    dbRef = Database.database().reference()
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = UIColor.white
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getFollowinglist()
  }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        fidgetImageView.isHidden = true
        fidgetImageView.image = nil
        print("Disappear")
        
    }
  
  func hideCollectionView(hideYesNo : Bool) {
    
    emptyMessage.text = "People, you follow, appear here"
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
  func getFollowinglist(){
    self.fidgetImageView.isHidden = false
    guard let userID = Auth.auth().currentUser?.uid else {
      print("ERROR: while getting user ID")
      return
    }
    dbRef.child("users").child(userID).child("followings").observeSingleEvent(of: .value) { (followerSnapshot) in
      self.followingArray.removeAll()
      if followerSnapshot.childrenCount > 0 {
        guard let followingList = followerSnapshot.value as? NSDictionary else {
          print("ERROR: while getting followers list")
          self.hideCollectionView(hideYesNo: true)
          return
        }
        for follower in followingList {
          guard let userId = follower.key as? String else {return}
          self.dbRef.child("users").child(userId).observeSingleEvent(of: .value, with: { (userSnapshot) in
            guard let userDict = userSnapshot.value as? [String:AnyObject] else {return}
            let userList =  UserModel(userId: userId, userDict: userDict)
            self.followingArray.append(userList)
            self.fidgetImageView.isHidden = true
            self.fidgetImageView.image = nil
            
            DispatchQueue.main.async {
              self.hideCollectionView(hideYesNo: false)
              self.tableView.reloadData()
              
            }
          })
        }
      }else{
        self.hideCollectionView(hideYesNo: true)
      }
    }
  }
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo.init(title: "Followings")
  }
  
}
//Mark: - UITableViewDataSource,UITableViewDelegate

extension FollowingVc: UITableViewDataSource,UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return followingArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard followingArray.count > 0 else {
      print("following arry count is 0 ")
      return UITableViewCell()
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
    let followingInfo = followingArray[indexPath.row]
    cell.followingUserNameLabel.text = followingInfo.name
    if let imageUrl = followingInfo.image {
      cell.FollwingUserImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named:"emptyImage"))
    }
    if followingInfo.averageRating != 0 {
      if let totalRating = followingInfo.averageRating {
        
        cell.followingCosmosView.rating = Double(totalRating)
        
      }
      if let totalrating = followingInfo.totalRating {
        cell.followingRating.text = "( Total ratings- \(totalrating)  )"
      }
    }
    else {
      cell.followingCosmosView.rating = 5
      cell.followingRating.text = "Not rated yet"
    }
    cell.selectionStyle = UITableViewCellSelectionStyle.none
    cell.followingCosmosView.settings.updateOnTouch = false
    cell.updateUIForFollowing()
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectUser = followingArray[indexPath.row]
    let productDetailsSB = getStoryBoardByName(storyBoardNames.prodDetails)
    let controller = productDetailsSB.instantiateViewController(withIdentifier: "UserProfileVc") as! SellerProfileVC
    controller.userData = selectUser
    
    nav?.pushViewController(controller, animated: false)
//    self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 33, width: 50, height: 40)
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 130
  }
  
}

