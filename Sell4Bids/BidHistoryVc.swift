//
//  BidHistoryVc.swift
//  Sell4Bids
//
//  Created by admin on 11/2/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
class BidHistoryVc: UIViewController {
  //Mark:- Properties
  @IBOutlet weak var emptyMessage: UILabel!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var fidgetImageView: UIImageView!
  var prodBelongsToOwner = false
  //start Price in bids nod of product node. have to compare to largest bid. we don't have to show max bid. instead show start price
  var currentStartPrice : String?
  //Mark:-  Variables
  public var productDetail:ProductModel!
  var dbRef:DatabaseReference!
  var biddingArray = [OrderModel]()
  var currentWinnerID = ""
  var userData : UserModel?
  override func viewDidLoad() {
    super.viewDidLoad()
    dbRef = Database.database().reference()
    fidgetImageView.toggleRotateAndDisplayGif()
    getBidingData()
    self.navigationItem.title = "Bid History"
    self.navigationController?.navigationBar.tintColor = UIColor.white
    //hide names of bidders logged In user is not owner of this product
    guard let prodUserId = productDetail.userId else {
      return
    }
    if SessionManager.shared.userId == prodUserId {
      //product owner
      prodBelongsToOwner = true
    }
    
  }
  
  func hideCollectionView(hideYesNo : Bool) {
    emptyMessage.text = "No Bids Received."
    if hideYesNo == false {
      tableView.isHidden = false
      fidgetImageView.isHidden = false
      emptyMessage.isHidden = true
    }
    else  {
      fidgetImageView.isHidden = true
      tableView.isHidden = true
      emptyMessage.isHidden = false
    }
  }
  
  func getBidingData(){
    fidgetImageView.isHidden = false
    let productId = productDetail.productKey
    if productDetail.auctionType != "buy-it-now" {
      dbRef.child("products").child(productDetail.categoryName!).child(productDetail.auctionType!).child(productDetail.state!).child(productId!).observeSingleEvent(of: .value) { [weak self] (snapshot) in
        guard let this = self else { return }
        let dictObjt = snapshot.value as? NSDictionary
        if let orders = dictObjt?.value(forKey: "bids") as? NSDictionary
        {
          if let startPrice = dictObjt?.value(forKey: "startPrice") as? String {
            this.currentStartPrice = startPrice
          }
          if let winnerKey = orders.value(forKey: "winner") {
            this.currentWinnerID = winnerKey as! String
            this.hideCollectionView(hideYesNo: false)
            for ordersUserId in orders {
              let userId = ordersUserId.key
              if let ordersDict = ordersUserId.value as? NSDictionary {
                this.hideCollectionView(hideYesNo: false)
                var checkName = "Sell4Bids User"
                if let name  =  ordersDict.value(forKey: "name"){
                  checkName = name as! String
                }
                let price  = ordersDict.value(forKey: "bid")
                var checkQuantity = "1"
                if let quantity = ordersDict.value(forKey: "boughtQuantity"){
                  checkQuantity = quantity as! String
                }
                
                let newOrder:OrderModel = OrderModel(name: checkName, boughtPrice: price as? String, boughtQuantity: checkQuantity, rating: nil, uid: userId as? String)
                this.biddingArray.append(newOrder)
                
                
              }
            }
            this.fidgetImageView.isHidden = true
            
            this.biddingArray.sort(by: { (order1:OrderModel, order2:OrderModel) -> Bool in
              guard let price1 = order1.boughtPrice , let price2 = order2.boughtPrice else {
                print("guard let price1 = order1.boughtPrice , let price2 = order2.boughtPrice failed")
                return false
              }
              guard let price1Int = Int(price1) , let price2Int = Int(price2) else { return false }
              return price1Int > price2Int
            })
            
            let test = this.biddingArray
            for bid in test {
              print(bid.boughtPrice ?? "Default Price")
            }
            DispatchQueue.main.async {
              this.tableView.reloadData()
            }
          }else {
            this.hideCollectionView(hideYesNo: true)
          }
        }
        
        
      }
    }
    
    
  }
  
}

extension BidHistoryVc: UITableViewDataSource,UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return biddingArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
    let orderData = biddingArray[indexPath.row]
    //handle name
    if prodBelongsToOwner {
      //show full names
      cell.bidingUserName.text = orderData.name
      
    }else {
      //not owner is viewing so obscure the names
      guard let name = orderData.name else { return cell }
      if let orderUserID = orderData.uid, orderUserID == SessionManager.shared.userId {
        cell.bidingUserName.text = "You"
      }else {
        cell.bidingUserName.text = hideBidderName(name: name)
      }
      
    }
    //hande price
    
    let loggedInUserId = SessionManager.shared.userId
    // Only show max bid amount to max bidder
    if loggedInUserId == currentWinnerID  {
      //showing actual amount to max bidder
      if let price = orderData.boughtPrice,  let orderUID = orderData.uid
      {
        guard let startPrice = currentStartPrice else { return cell }
        
        if orderUID == currentWinnerID {
          cell.bidPrice.text =  "$\(startPrice) "
          cell.lblCeilingAmount.isHidden = false
          cell.lblCeilingAmountStatic.isHidden = false
          cell.lblCeilingAmount.text = "$\(price)"
        }else {
          cell.bidPrice.text = price
        }
        
        
      }
    }else {
      guard let startPrice = currentStartPrice else { return cell }
      guard let price = orderData.boughtPrice else { return cell }
      guard let bidInt = Int(price) else { return cell}
      guard let startPriceInt = Int(startPrice) else { return cell }
      if bidInt > startPriceInt {
        cell.bidPrice.text =  "$" + startPrice
      }else {
        cell.bidPrice.text = "$" + price
      }
      
    }
    cell.updateUIForBiding()
    if currentWinnerID == orderData.uid! {
      //have to show highest bidder
      if let endTime = productDetail.timeRemaining {
        if endTime < 0 {
          cell.highestbidder.text = "Winner"
          cell.bidingCardView.backgroundColor =  UIColor(red: 1.5, green: 0, blue: 0, alpha: 0.05)
          cell.backgroundColor = UIColor(red: 1.5, green: 0, blue: 0, alpha: 0.05)
        }
      }else {
        cell.highestbidder.text = "Highest Bidder"
      }
      
      
      //cell.bidPrice.text = startp
    }else {
      cell.highestbidder.isHidden = true
      cell.constraintBidNameToCenter.isActive = true
      cell.constraintBidNameTopToHighestBidder.isActive = false
    }
    cell.selectionStyle = .none
    
    return cell
    
    
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let orderData = biddingArray[indexPath.row]
    if currentWinnerID == orderData.uid! {
      //this cell shows highest bidder label
      //and if winner is view, also have to show ceiling label
      if currentWinnerID == SessionManager.shared.userId { return 120 }
      else { return 90 }
    }
    else {
      return 50
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
//    let controller = storyboard?.instantiateViewController(withIdentifier: "UserProfileVc") as! UserProfileVc
//    let orderData = biddingArray[indexPath.row]
//    guard let id = orderData.uid else { return }
//    controller.userIdToDisplayData = id
//    navigationController?.pushViewController(controller, animated: true)
  }
  
  func hideBidderName (name : String) ->  String {
    var newName = ""
    for (i, char ) in name.enumerated() {
      newName += String( i == 0 || i == 1 ? char : "*" )
    }
    return newName
  }
}

