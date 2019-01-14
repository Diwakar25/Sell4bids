//
//  Ext_ProdDetailsTableVC_Delegates.swift
//  Sell4Bids
//
//  Created by MAC on 24/07/2018.
//  Copyright © 2018 admin. All rights reserved.
//

//MARK:- EndListingVCDelegate
import Firebase


extension ProductDetailTableVc : EndListingVCDelegate {
  
  func endListingButtonTapped(endListingReasonIndex: Int, endListingReasonString: String) {
    guard flagProductReferenceSet else {
      return
    }
    print("prodReference = \(prodReference)")
    let ref = FirebaseDB.shared.dbRef
    ref.child("items").child(productData.productKey!).child("endTime").setValue(86573726)
    prodReference.child("endTime").setValue(86573726) { [weak self] (error_, dbRef) in
      guard let this = self else { return }
      if let error = error_ {
        //self.showToast(message: "Could not update Listing time ")
        this.alert(message: "Sorry, Could not end Listing of your item. ")
        print(error.localizedDescription)
      }else{
//        self!.checkAndEnableEndListingButton()
        this.alert(message: "Successfully ended listing time of your Item ")
        //now get this time and store in self product Data to refresh the timer
        this.prodReference.child("endTime").observe(.value, with: { [weak self](snap) in
          guard let thisInner = self else { return }
          guard let endTime = snap.value as? Int64 else {
            print("guard let endTime = snap.value as? Int64 failed")
            return
          }
          self!.productData.endTime = endTime
          //update timer value
          
//          _ = Timer.scheduledTimer(timeInterval: 1, target: thisInner, selector: #selector(thisInner.updateTimer(currentTime:  )), userInfo: nil, repeats: true)
          //write in prod -> endListing a new push key having value dict
          //write end listing reason in product node // [reason : "reasonString" , value: "1"]
          thisInner.writeReasonInProductNode(reasonStr: endListingReasonString, reasonIndex: endListingReasonIndex)
          thisInner.writeReasonInMainNode(reasonStr: endListingReasonString, reasonIndex: endListingReasonIndex)
          //write in dbref.child("endListing").child("prodKey").push key
          
          }, withCancel: { (error) in
            this.showToast(message: "Could not get updated value of time remaining from Database ")
        })
      }
    }
  }
  
  func writeReasonInProductNode(reasonStr: String, reasonIndex: Int) {
    guard flagProductReferenceSet else {
      print("guard flagProductReferenceSet else failed in writeReasonInProductNode in \(self).Going to return")
      return
    }
    let newUniqueRef = prodReference.child("endListing").childByAutoId()
    //[reason : "reasonString" , value: "1"]
    let endListingDict = ["reason": reasonStr, "value": reasonIndex] as [String : Any]
    newUniqueRef.setValue(endListingDict) { (error, ref) in
      if let error = error {
        self.showToast(message: "Could not write reason for endListing in product ")
        print(error.localizedDescription)
      }else {
        //success
        print("Written reason for end listing in database")
      }
    }
  }
  
  func writeReasonInMainNode(reasonStr: String, reasonIndex: Int) {
    guard let key = productData.productKey else {
      print("guard let key = productData.productKey failed in writeReasonInMainNode. Going to return")
      return
    }
    let endListingDict = ["reason": reasonStr, "value": reasonIndex] as [String : Any]
    FirebaseDB.shared.dbRef.child("endListing").child(key).childByAutoId().setValue(endListingDict) { (error, ref) in
      if let error = error {
        self.showToast(message: "Could not write reason for endListing in Database")
        print(error.localizedDescription)
      }else {
        //success
        print("Written reason for end listing in database")
        
      }
    }
    
  }
  
}



extension ProductDetailTableVc: UpdateProdQuantityPopUpVCDelegate {
  func quantityUpdated(quantity: String) {
    self.quantityLabel.text = "Quantity in Stock : \(quantity) Items"
  }
}


extension ProductDetailTableVc : sellerProfileVCDelegate {
  
  func productTapped(_ product: ProductModel) {
    self.productData = product
    imageUrlStringsForProduct.removeAll()
    let indexPath = IndexPath.init(row: 0, section: 0)
    tableViewProdDetails.scrollToRow(at: indexPath , at: .top, animated: true)
    if let parent = self.parent as? ProductDetailVc {
      parent.performViewDidLoad()
    }
    performViewDidLoad()
  }
  
  
}
