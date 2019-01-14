//
//  offerHistoryTableVC.swift
//  Sell4Bids
//
//  Created by MAC on 16/07/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

struct offerHistoryModel {
  let message: String
  let person: String
  let price : String
  let timeStamp: Int64
  let quantity : String
  //"normal"
  let type: String
}
class offerHistoryTableVC: UIViewController {
  
  @IBOutlet weak var tableViewOfferHistory: UITableView!
  
  
  var product : ProductModel?
  
  var offerHistoryArray : [offerHistoryModel]?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

  override func viewDidLoad() {
    addLogoWithLeftBarButton()
    self.title = "Offer History"
    getAndDisplayOfferHistory()
  }
  
  private func getAndDisplayOfferHistory() {
    
    guard let product = product else { return }
    getOfferHistoryForProduct(product) { [weak self] (success, offerHistoryArray_) in
      guard let strongSelf = self , let array = offerHistoryArray_ else { return }
      strongSelf.offerHistoryArray = array
      strongSelf.offerHistoryArray!.sort(by: { (model1:offerHistoryModel, model2:offerHistoryModel) -> Bool in
        return model1.timeStamp < model2.timeStamp
      })
      
      strongSelf.tableViewOfferHistory.reloadUsingDispatch()
      
    }
    
  }
  
  typealias handlerGetOfferHistory = ( Bool, [offerHistoryModel]? ) -> ()
  private func getOfferHistoryForProduct( _ product : ProductModel, completion: @escaping handlerGetOfferHistory ) {
    guard product.isDataValid() else {
      showToast(message: "Could not get history due to Invalid product Data")
      return
    }
    let cat = product.categoryName!, auctionType = product.auctionType!
    let state = product.state!, key = product.productKey!
    
    let buyerId = SessionManager.shared.userId
    let dbRef = FirebaseDB.shared.dbRef
    var prodRef = dbRef.child(FBKeys.products).child(cat)
    prodRef = prodRef.child(auctionType).child(state).child(key)
    prodRef = prodRef.child(FBKeys.offerHistory).child(buyerId)
    //print("final prodRef : \(prodRef)")
    
    let ref_offer_history = dbRef.child(FBKeys.offerHistory).child(key).child(buyerId)
  
    ref_offer_history.observeSingleEvent(of: .value) { (offerHistorySnap) in
      guard let offerHistoryTopDict = offerHistorySnap.value as? [String:Any] else {
        return
      }
      var offerHistoryArray_ = [offerHistoryModel]()
      for (_, offerHistoryNode ) in offerHistoryTopDict.enumerated() {
        
        guard let offerHistoryDict = offerHistoryNode.value as? [String:Any] else {
          //print("offerHistoryDict = offerHistoryNode.value as? [String:Any] failed ")
          continue
        }
        //print("offerHistoryDict : \(offerHistoryDict)")
        guard let message = offerHistoryDict["message"] as? String,
        let person = offerHistoryDict["person"] as? String,
        let timeStamp = offerHistoryDict["time"] as? Int64,
        let type = offerHistoryDict["type"] as? String
        
        else {
          print("warning. invalid offer data in dict : \(offerHistoryDict )")
          completion(false, nil)
          continue
        }
        let price = offerHistoryDict["price"] as? String ?? "NA"
        let quantity = offerHistoryDict["quantity"] as? String ?? "NA"
        
        let offerModel = offerHistoryModel.init(message: message, person: person, price: price, timeStamp: timeStamp, quantity: quantity, type: type)
        offerHistoryArray_.append(offerModel)
        
      }
      completion(true, offerHistoryArray_)
      
    }
    
  }

}

//MARK:- UITableViewDataSource UITableViewDelegate

extension offerHistoryTableVC : UITableViewDataSource, UITableViewDelegate {
  
  static var cellId =  "offerHistoryCell"
  static var cellSpacing : CGFloat = 8
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    guard let array = offerHistoryArray else { return 0 }
    return array.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: offerHistoryTableVC.cellId, for: indexPath) as? OfferHistoryCell else {
      return UITableViewCell()
    }
    let currentOffer = offerHistoryArray![indexPath.section]
    //
    cell.setup(with: currentOffer)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let normalHeght : CGFloat = 90
    guard let offerHistoryArray = offerHistoryArray else { return normalHeght }
    let type = offerHistoryArray[indexPath.section].type
    if type.lowercased().contains("normal") { return normalHeght}
    else { return 70 }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return offerHistoryTableVC.cellSpacing
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = UIColor.clear
    return headerView
  }
}

