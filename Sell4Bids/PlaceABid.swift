//
//  PlaceABid.swift
//  Sell4Bids
//
//  Created by admin on 3/27/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Firebase
var messagTitle = "Message"
var messageContent = ""
var successStatus = false
func placeBidOnProductWithValue(bidValue: Int, product:ProductModel, completion: @escaping (Bool, String, String) -> () ){
  
  guard let state = product.state, let category = product.categoryName,
  let prodId = product.productKey, let auctionType = product.auctionType else{
    //completion(false, "Bid not placed", "Sorry, Could not place bid because of Invalid Product Data")
    messagTitle = "Bid not placed"
    messageContent = "Sorry, Could not place bid because of Invalid Product Data"
    successStatus = false
    
    return
  }
  
  let prodRef = FirebaseDB.shared.dbRef.child("products").child(category).child(auctionType).child(state).child(prodId)
  
  let myName = SessionManager.shared.name
  //run a transaction to place a bid. transaction because either all data is saved successfully or nothing is changed
  
  prodRef.runTransactionBlock({ (currentBidData: MutableData) -> TransactionResult in
    ///value of bids node
    if var bidsValue = currentBidData.value as? [String:Any]{
      
      let myID = SessionManager.shared.userId
      if let startValue = bidsValue["startPrice"] as? String{
        //if user bid less than
        if bidValue < Int(startValue)!{
          DispatchQueue.main.async {
            //completion(false ,"Bid Again", "Bid Amount must be greater than $\(startValue)")
            messagTitle = "Bid Again"
            messageContent = "Bid Amount must be greater than $\(startValue)"
             successStatus = false
          }
          TransactionResult.abort()
        }
        else if bidValue >= Int(startValue)! {
          
            if var bids = bidsValue["bids"] as? [String:Any]{
            
            if let maxBid = bids["maxBid"] as? String{
              
              let IntMaxBid = Int(maxBid)!
              
              //initilly, max bid is 0, so this is first bid
              if IntMaxBid == 0{
                //set value of maxBid
                bids["maxBid"] = "\(bidValue)"
                let dic = ["bid":"\(bidValue)","name":myName]
                bids.updateValue(dic, forKey: myID)
                bids.updateValue(myID, forKey: "winner")
                print("It was first bid")
                
                bidsValue.updateValue(bids, forKey: "bids")
                messagTitle = "Bid Placed Successfully"
                messageContent = "Your bid was placed successfully. Currently, you are the High bidder"
                 successStatus = true
              }
                
                //Case2
                //bid value is greater than maximum bid
              else if bidValue > IntMaxBid{
                
                let winnerID = bids["winner"] as! String
                
                //winner is bidding again to increase his bid
                //no need to update start price
                if winnerID == myID{
                  
                  bids["maxBid"] = "\(bidValue)"
                  let dic = ["bid":"\(bidValue)","name":myName]
                  bids.updateValue(dic, forKey: myID)
                  
                  bidsValue.updateValue(bids, forKey: "bids")
                  //completion(true, "Bid increased Successfully", "Congrats. Your bid was increased succesfully. You are currently the highest bidder ")
                  messagTitle = "Bid increased Successfully"
                  messageContent = "Your bid was increased succesfully. Currently, you are the high bidder"
                   successStatus = true
                }//end if winnerID == myID
                  
                else{
                  
                  bids["startPrice"] = "\(IntMaxBid+1)"
                  bids["maxBid"] = "\(bidValue)"
                  bids["winner"] = myID
                  
                  let dic = ["bid":"\(bidValue)","name":myName]
                  bids.updateValue(dic, forKey: myID)
                  
                  bidsValue.updateValue(bids, forKey: "bids")
                  bidsValue.updateValue("\(IntMaxBid+1)", forKey: "startPrice")
                  //completion(true, "Bid Placed", "Your bid was placed successfully, You are currently the highest bidder")
                  messagTitle = "Bid Placed Successfully"
                  messageContent = "Your bid was placed successfully. Currently, you are the high bidder."
                   successStatus = true
                }
                
                
              }
                
                //case3
              else if bidValue < IntMaxBid{
                
                let winnerID = bids["winner"] as! String
                
                
                //no need to update start price
                if winnerID == myID{
                  //showAlert(title: "")
                  //completion(false, "Sorry, No one can decrease bid", "You are currently the highest bidder, we will buy this item for you at least possible price (only $1 more than second highest bid)")
                  messagTitle = "Can't Decrease Bid"
                  messageContent = "You are currently the highest bidder, we will buy this item for you at least possible price (only $1 more than second highest bid)"
                   successStatus = true
                  
                }
                  
                else{
                  //some other user trying to bid less than maximum but greater than startPrice
                  bids["startPrice"] = "\(bidValue+1)"
                  let dic = ["bid":"\(bidValue)","name":myName]
                  bids.updateValue(dic, forKey: myID)
                  
                  bidsValue.updateValue(bids, forKey: "bids")
                  bidsValue.updateValue("\(bidValue+1)", forKey: "startPrice")
                  
                  //completion(true, "Bid Placed",  "Your bid was placed but you are down bid. Please increase your bid by bidding again." )
                  messagTitle = "Bid Placed"
                  messageContent = "Your bid was placed successfully but you have been outbid by another bidder. Try bidding again"
                  successStatus = true
                }
                
              }
                
                //case4
              else if bidValue == IntMaxBid{
                
                let winnerID = bids["winner"] as! String
                
                //subcase 1
                if winnerID == myID{
                  //completion(true, "Attention", "You are already maxBidder with the same amount")
                  messagTitle = "Bid Error"
                  messageContent = "Your bid amount is equal to your previous value. You can increase your bid by entering larger value."
                  successStatus = false
                }
                else{
                  
                  bids["startPrice"] = "\(bidValue)"
                  
                  let dic = ["bid":"\(bidValue)","name":myName]
                  bids.updateValue(dic, forKey: myID)
                  
                  bidsValue.updateValue(bids, forKey: "bids")
                  bidsValue.updateValue("\(IntMaxBid)", forKey: "startPrice")
                  
                  messagTitle = "Bid Placed"
                  messageContent = "You bid amount is equal to Current winner's Bid Amount. Sell4Bids follow first-come first-serve principle. Please increase your bid by bidding again."
                  successStatus = true
                  
                  //completion(true, "Bid Placed", "You bid amount is equal to Current winner's Bid Amount. Sell4Bids follow first-come first-serve principle. Please increase your bid by bidding again.")
                  
                
                }
              }
            }
          }
          currentBidData.value = bidsValue
      }
        
      }
      
    }
    
    return TransactionResult.success(withValue: currentBidData)
  }) { (error, status, snapshot) in
    if error != nil{
      
      //self.alert(message: "\(String(describing: error?.localizedDescription))", title: "ERROR")
      completion(false, "Transaction Error", "Sorry, Could not Place your bid")
      print("TransactionResult error : \(String(describing: error?.localizedDescription))")
      
    }
    else{
      //update buying node
      let ref = Database.database().reference().child("users").child(SessionManager.shared.userId).child("products").child("buying").child(category)
      let value = ["auctionType": auctionType ,"myBid":"\(bidValue)","category": category,"state": state]
      ref.updateChildValues(value)
      
      //self.showAlert(title: "Bid placed", message: "Bid placed SUCESSFULLY")
      completion(successStatus, messagTitle, messageContent)
      
      
    }
  }

}
