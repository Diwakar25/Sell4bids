//
//  ReportItemPopUpVc.swift
//  Sell4Bids
//
//  Created by admin on 11/2/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import SwiftMessages
class ReportItemPopUpVc: UIViewController {
  
  @IBOutlet weak var dimView: UIView!
  @IBOutlet weak var PopUpVIew: UIView!
  @IBOutlet weak var messageTextArea: UITextView!
  @IBOutlet weak var btnSendReport: UIButton!
  @IBOutlet weak var imgViewProduct: UIImageView!
  var image : UIImage?
  @IBOutlet weak var visualEffectView: UIVisualEffectView!
  
  var productDataArray:ProductModel!
  var dbRef: DatabaseReference!
  let currentuserId = Auth.auth().currentUser?.uid
  var effect : UIVisualEffect!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    effect = visualEffectView.effect
    visualEffectView.effect = nil
    
    if let image = image {
      self.imgViewProduct.image = image
      visualEffectView.effect = effect
    }
    
  
    
    
    DispatchQueue.main.async {
      self.messageTextArea.becomeFirstResponder()
    }
    
    btnSendReport.addShadowAndRound()
    dbRef = FirebaseDB.shared.dbRef
    
    toggleDimBack(flag: true)

    messageTextArea.layer.borderWidth = 2.0
    messageTextArea.layer.borderColor = UIColor.red.cgColor
    messageTextArea.tintColor = colorRedPrimay
    messageTextArea.layer.cornerRadius = 6
    PopUpVIew.layer.cornerRadius = 8
    PopUpVIew.clipsToBounds = true
  }
  
  
  func toggleDimBack(flag : Bool) {
    DispatchQueue.main.async {
      self.dimView.alpha = flag ? 0.3 : 0
    }
  }
  
  @IBAction func cancelButton(_ sender: Any) {
    
    dismiss(animated: true, completion: nil)
  }
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func reportButtontapped(_ sender: Any) {
    
    if messageTextArea.text.isEmpty  {
      self.alert(message: "Please Share your Thoughts about this item", title: "Report item")
    }else {
      
      self.dbRef.child("productsReports").child(productDataArray.productKey!).child("auctionType").setValue(self.productDataArray.auctionType)
      
      //setting categoryName
      self.dbRef.child("productsReports").child(productDataArray.productKey!).child("category").setValue(self.productDataArray.categoryName)
      //setting state
      self.dbRef.child("productsReports").child(productDataArray.productKey!).child("reports").child(self.currentuserId!).child("report").setValue(messageTextArea.text!)
      self.dbRef.child("productsReports").child(productDataArray.productKey!).child("reports").child(self.currentuserId!).child("reportingTime").setValue(ServerValue.timestamp())
      self.dbRef.child("productsReports").child(productDataArray.productKey!).child("state").setValue(self.productDataArray.auctionType)
      
      self.PopUpVIew.fadeOut() 
      let title = "Item Reported Successfully."
      let message = "Item is reported to Customer Support, they will review the item and take action accordingly . Thanks for your co-operation"
      
      showSwiftMessageWithParams(theme: .success, title: title, body: message, durationSecs: 3, layout: MessageView.Layout.cardView, position: .center) { (complete) in
        
        self.dismiss(animated: true, completion: nil)
      }
      
      
    }
    
  }
  
  
  
  
}
