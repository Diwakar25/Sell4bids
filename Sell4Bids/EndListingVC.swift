//
//  EndListingVC.swift
//  Sell4Bids
//
//  Created by admin on 2/16/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class EndListingVC: UIViewController {
  
  // MARK: - Properties
  let strItemOutOfStock = "Item is out of stock"
  let strIWillListLater = "I will re-list later"
  let strNotIterested = "I am not interested to sell"
  let strNotAvailable = "Item is no longer available"
  let strNotReceiving = "Not receiving desired bids/offers"
  let strOther = "Other"
  var arrayEndListingReasons = [String]()
  weak var delegate : EndListingVCDelegate!
  let cellIdentifier = "EndListingReasonTableVCell"
  @IBOutlet weak var tableViewEndListingReasons: UITableView!
  
  @IBOutlet weak var btnCancelEnding: UIButton!
  @IBOutlet weak var btnEndListing: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    arrayEndListingReasons = [strItemOutOfStock, strIWillListLater, strNotIterested, strNotAvailable, strNotReceiving, strOther]
    self.title = "End Listing of Your Item"
    setupViews()
    
  }
  private func setupViews(){
    
    btnEndListing.makeRedAndRound()
    btnEndListing.addShadowAndRound()
    btnCancelEnding.addShadowAndRound()
  }
  
  
  // MARK: - IBActions and user interaction
  
  @IBAction func btnCancelTapped(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func btnEndListingTapped(_ sender: UIButton) {
    if EndListingVC.selectedReasonIndex < 0 {
      showToast(message: "Please select an option ")
    }else{
      print("Going to end the listing of this user")
      let alert = UIAlertController(title: "Item Listing", message: "You will not receive any orders/offers untill you relist this item. Are you sure you want to end item listing?", preferredStyle: .alert)
      let actionYes = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
        let index = EndListingVC.selectedReasonIndex
        guard index > -1 else {
          print("guard index > 0 else failed")
          self.showToast(message: "Internal error occured. Please select an option again")
          return
        }
        self.delegate.endListingButtonTapped(endListingReasonIndex: index, endListingReasonString: self.arrayEndListingReasons[index])
        self.navigationController?.popViewController(animated: true)
        
      })
      let actionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
      alert.addAction(actionYes)
      alert.addAction(actionCancel)
      self.present(alert, animated: true, completion: nil)
      
    }
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
protocol EndListingVCDelegate: class {
  func endListingButtonTapped(endListingReasonIndex: Int, endListingReasonString: String)
}
extension EndListingVC: UITableViewDataSource, UITableViewDelegate {
  
  static var selectedReasonIndex = 0
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrayEndListingReasons.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier , for: indexPath) as? EndListingReasonTableVCell else {
      print("Could not deque a EndListingReasonTableVCell in \(self)")
      return UITableViewCell()
    }
    if EndListingVC.selectedReasonIndex == indexPath.row
    {
      UIView.transition(with: cell.imgRadio, duration: 1, options: .transitionCrossDissolve, animations: {
        cell.imgRadio.image = #imageLiteral(resourceName: "radioOn")
      }, completion: nil)
      
      
    }else {
      cell.imgRadio.image = #imageLiteral(resourceName: "radioOff")
    }
    cell.lblEndListingReason.text = arrayEndListingReasons[indexPath.row]
    
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("selected row at \(indexPath)")
    EndListingVC.selectedReasonIndex = indexPath.row
    tableView.reloadData()
  }
  
  
}
