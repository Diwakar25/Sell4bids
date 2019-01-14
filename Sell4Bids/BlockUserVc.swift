//
//  BlockUserVc.swift
//  Sell4Bids
//
//  Created by admin on 10/16/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import Cosmos
import XLPagerTabStrip

class BlockUserVc: UIViewController, IndicatorInfoProvider {
  //Mark: - Properties
  
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var emptyMessage: UILabel!
  @IBOutlet weak var fidgetImageView: UIImageView!
  @IBOutlet weak var cosmosViewRating: CosmosView!
  @IBOutlet weak var totalRatingLabel: UILabel!
  
    @IBOutlet weak var errorimg: UIImageView!
    
  
  
  //Mark: - variables
  var nav:UINavigationController?
  var blockedUserArray = [UserModel]()
  var dbRef: DatabaseReference!
  var imageUrl = ""
  
  let currentUserId = Auth.auth().currentUser?.uid
  
  override func viewDidLoad() {
    super.viewDidLoad()
    fidgetImageView.toggleRotateAndDisplayGif()
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = UIColor.white
    
    // tableView.separatorColor = UIColor(white: 0.95 , alpha:1)
    
    // Do any additional setup after loading the view.
    dbRef = Database.database().reference()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    blockedUsersData()
  }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fidgetImageView.isHidden = true
        fidgetImageView.image = nil
        print("Disappear")
        
    }
  func hideCollectionView(hideYesNo : Bool) {
    
    emptyMessage.text = "People, you block, appear here"
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
  
  func blockedUsersData(){
    let userID = Auth.auth().currentUser?.uid
    fidgetImageView.isHidden = false
    
    dbRef.child("users").child(userID!).observe(.value) { (snapshot) in
      self.blockedUserArray.removeAll()
      // Get user value
      if let dict = snapshot.value as? NSDictionary {
        
        if let blockedUsers = dict.value(forKey: "blockedPersons") as? NSDictionary {
          self.hideCollectionView(hideYesNo: false)
          
          for value in blockedUsers{
            
            //Block User Id
            let userId = value.key
            
            self.dbRef.child("users").child(userId as! String).observeSingleEvent(of: .value, with: { (snapshot) in
              if let dictObj = snapshot.value as? NSDictionary {
                let userName = dictObj.value(forKey: "name")
                if let userImage = dictObj.value(forKey: "image")
                {
                  self.imageUrl = userImage as! String
                }
                var checkRating = "0"
                if let rating = dictObj.value(forKey: "averagerating") {
                  checkRating = rating as! String
                  
                }
                
                var checktotalRating = "0"
                if let totalrating = dictObj.value(forKey: "totalratings") {
                  checktotalRating = totalrating as! String
                  
                }
                
                let ratingInt = (checkRating as NSString).floatValue
                let totalratingInt = (checktotalRating as NSString).floatValue
                
                
                let blockedUser:UserModel = UserModel(name: userName as? String ?? "Sell4Bids User", image: self.imageUrl , userId: userId as? String ?? "" , averageRating: ratingInt, totalRating: totalratingInt, email: "", zipCode: "", state: "", watching: 0, follower: 0, following: 0 , totalListing: 0, buying: 0, bought: 0, unReadMessage: 0, unReadNotify: 0)
                
                
                self.blockedUserArray.append(blockedUser)
                
                
              }
              self.fidgetImageView.isHidden = true
                self.fidgetImageView.image = nil
              DispatchQueue.main.async {
                self.hideCollectionView(hideYesNo: false)
                self.tableView.reloadData()
              }
              
            }) { (error) in
              print(error.localizedDescription)
              
            }
          }
          
          
          
        }
        else {
          self.hideCollectionView(hideYesNo: true)
        }
        
      }
    }
    
  }
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo.init(title: "Block List")
  }
}
//Mark: - UITableViewDataSource,UITableViewDelegate

extension BlockUserVc: UITableViewDataSource,UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return blockedUserArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard blockedUserArray.count > 0 else {
      print("blockedUserArray count is 0")
      return UITableViewCell()
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
    let followingInfo = blockedUserArray[indexPath.row]
    cell.blockUserNameLabel.text = followingInfo.name
    cell.blockUserImageView.sd_setImage(with: URL(string: followingInfo.image ?? "" ), placeholderImage: UIImage(named:"emptyImage"))
    if followingInfo.averageRating != 0 {
      if let totalRating = followingInfo.averageRating {
        cell.blockCosmosView.rating = Double(totalRating)
        
      }
      if let totalrating = followingInfo.totalRating {
        cell.blockRating.text = "( Total ratings- \(totalrating)  )"
      }
      
    }
    else {
      cell.blockCosmosView.rating = 5
      cell.blockRating.text = "Not rated yet"
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyle.none
    cell.blockCosmosView.settings.updateOnTouch = false
    cell.updateUIForBlockedUser()
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let blockedPerson = blockedUserArray[indexPath.row]
    
    let alertController = UIAlertController(title: "Unblock Person", message: "Do you want to unblock this person ? ", preferredStyle: .alert)
    
    // Create OK button
    let OKAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
      self.dbRef.child("users").child(self.currentUserId!).child("blockedPersons").child(blockedPerson.userId!).removeValue()
      self.dbRef.child("users").child(blockedPerson.userId!).child("blockedBy").child(self.currentUserId!).removeValue()
      
      // Code in this block will trigger when OK button tapped.
      print("Ok button tapped");
      //self.blockedUsersData()
    }
    alertController.addAction(OKAction)
    
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
      print("Cancel button tapped")
    }
    alertController.addAction(cancelAction)
    
    // Present Dialog message
    self.present(alertController, animated: true, completion:nil)
    
    
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 130
  }
  
  
  
}


