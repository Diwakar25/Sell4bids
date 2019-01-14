//
//  HomeVCExtension_Actions.swift
//  Sell4Bids
//
//  Created by MAC on 17/07/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
extension HomeVC_New {
  
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
       mikeTapped()
    }
  @objc func resetLabelTapped(_ sender: UITapGestureRecognizer) {
    //searchController.isActive = false
    categoryToFilter = "All"
    buyingOptionToFilter = "Any"
    cityAndStateName = "New York, NY"
    stateName = "NY"
    flagIsFilterApplied = false
    fetchAndDisplayData()
    emptyProductMessage.isHidden = true
    productsArray.removeAll()
    //print(productsArray.count)
    //self.colVProducts.reloadData()
   
    
  }
  @objc func cityLabelactionTapped(_ sender: UITapGestureRecognizer) {
    guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "FiltersVc") as? FiltersVc else {return}
    controller.selfWasPushed = true
    controller.cityAndStateName = cityAndStateName ?? "New York, NY"
    controller.delegate = self
    
    if flagIsFilterApplied {
        controller.categoryToFilter = self.categoryToFilter
        controller.buyingOptionToFilter = self.buyingOptionToFilter
        
    }
    controller.stateToFilter = stateName
    self.navigationController?.pushViewController(controller, animated: true)
    }
  
  @objc func  bidNowBtnTapped(_ sender:UIButton){
    let indexPathRow = sender.tag
    
    let arrayToUse = flagIsFilterApplied ? FilteredDataFromFilterVcArray : productsArray
    guard let array = arrayToUse else {
      showToast(message: "Sorry, Unexpected Error. No Product Data ")
      return
    }
    let selectedProduct = array[indexPathRow]
    let mainSB = getStoryBoardByName(storyBoardNames.prodDetails)
    let controller = mainSB.instantiateViewController(withIdentifier: "ProductDetailVc") as! ProductDetailVc
    controller.productDetail = selectedProduct
    navigationController?.pushViewController(controller, animated: true)
  }
  
  
  //MARK: - IBActions and user interaction
  
  @IBAction func btnTryAgainNoResultsTapped(_ sender: UIButton) {
    downloadAndShowData()
  }
  
  @IBAction func btnFilterRightTapped(_ sender: Any) {
    
    guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "FiltersVc") as? FiltersVc else {return}
    controller.selfWasPushed = true
    controller.cityAndStateName = cityAndStateName ?? "New York, NY"
    controller.delegate = self
    
    if flagIsFilterApplied {
      controller.categoryToFilter = self.categoryToFilter
      controller.buyingOptionToFilter = self.buyingOptionToFilter
      
    }
    controller.stateToFilter = stateName
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  @objc func mikeTapped() {
    let searchSB = getStoryBoardByName(storyBoardNames.searchVC)
    let searchVC = searchSB.instantiateViewController(withIdentifier: "SearchVC") as! SearchVc
    searchVC.flagShowSpeechRecBox = true
    self.navigationController?.pushViewController(searchVC, animated: true)
  }
  @objc func handleRefresh(_ refreshControl: UIRefreshControl){
   
    DispatchQueue.main.async {

   
         fetchingMethod = "zipcode"
        endkey = nil
       
       
        count = 0 
      self.fetchAndDisplayData()
        self.emptyProductMessage.isHidden = true
      self.dimView.isHidden = false
      self.fidgetImageView.isHidden = false
      self.refreshControl.beginRefreshing()
      self.refreshControl.endRefreshing()
    }
    
    
   
//
//    getCurrenState{ (complete,state,city,zip)  in
//
//
//
//        self.getUserBlockedList{(complete) in
//
//        DispatchQueue.main.async {
//            print("refresh\(state!)")
//            print("product count == \(self.productsArray.count)")
//                self.colVProducts.reloadData()
//                refreshControl.endRefreshing()
//          self.dimView.isHidden = true
//          self.fidgetImageView.isHidden = true
//        }
//      }
//    }
  }
}
