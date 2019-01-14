//
//  Ext_ProdDetailsTableVC_TableV.swift
//  Sell4Bids
//
//  Created by MAC on 24/07/2018.
//  Copyright © 2018 admin. All rights reserved.
//

//MARK: - TableViewDelegate, TableViewDataSource


extension ProductDetailTableVc {
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 1.0 : 32
    }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let cell = tableView.cellForRow(at: indexPath)
    cell?.selectionStyle = UITableViewCellSelectionStyle.none
    
    if indexPath.row == 4 {
      print("select user")
      let selectUser = UserArray[0]
      let controller = storyboard?.instantiateViewController(withIdentifier: "UserProfileVc") as! SellerProfileVC
      controller.userData = selectUser
      controller.delegate = self
      navigationController?.pushViewController(controller, animated: true)
      
      
    }
    if indexPath.row == 12 {
      ShareButtonPressed(UIButton())
    }
    if indexPath.row == 13 {
      print("Add to watch list")
      
      if(!isWatchList){
        
        
        //setting Auction value
        self.dbRef.child("users").child(self.currentUserId).child("products").child("watching").child(self.productData.productKey!).child("auction").setValue(self.productData.auctionType)
        
        //setting categoryName
        self.dbRef.child("users").child(self.currentUserId).child("products").child("watching").child(self.productData.productKey!).child("category").setValue(self.productData.categoryName)
        //setting state
        self.dbRef.child("users").child(self.currentUserId).child("products").child("watching").child(self.productData.productKey!).child("state").setValue(self.productData.state)
        
        // Code in this block will trigger when OK button tapped.
        
        
        self.alert(message: "Item has been added to your Watch List" , title: "My Sell4Bids watch List")
        
        
      } else {
        self.dbRef.child("users").child(self.currentUserId).child("products").child("watching").child(self.productData.productKey!).removeValue()
        
        self.alert(message: "This Item has been Removed from Your Watch List" , title: "My Sell4Bids watch List")
        
      }
      
    }
    if indexPath.row == 14 {
      print("View Offers")
      
      let controller = storyboard?.instantiateViewController(withIdentifier: "ViewOffersVc")  as! ViewOffersVc
      controller.productDetail = productData
      
      navigationController?.pushViewController(controller, animated: true)
    }
    if indexPath.row == 15 {
      print("bidding history")
      let controller = storyboard?.instantiateViewController(withIdentifier: "BidHistoryVc")  as! BidHistoryVc
      controller.productDetail = productData
      
      controller.userData = self.UserArray[0]
      navigationController?.pushViewController(controller, animated: true)
      
    }
    if indexPath.row == 16 {
      print("your offer will be accpted")
      
    }
    if indexPath.row == 17 {
      print("Buyer with highest bid will be winner")
    }
    if indexPath.row == 18 {
      print("You rated this")
      
      
    }
    
    if indexPath.row == 20 {
      print("Report an Item")
      
      if(!isReport){
        
        let alertController = UIAlertController(title: "Report item", message: "Are you sure you want to report this item? ", preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
          
          let controller = self.storyboard?.instantiateViewController(withIdentifier: "ReportItemPopUpVc")  as! ReportItemPopUpVc
          controller.productDataArray = self.productData
          //pass image
          if self.imageUrlStringsForProduct.count > 0 {
            let indexpath = IndexPath.init(row: 0, section: 0)
            let cell = self.sliderCollView.cellForItem(at: indexpath) as! ImageCollectionViewCell
            if let firstImage = cell.productImageView.image {
              controller.image = firstImage
            }
            
          }
          controller.modalPresentationStyle = .overCurrentContext
          self.present(controller, animated: true, completion: nil)
          
          
          
        }
        alertController.addAction(OKAction)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
          print("Cancel button tapped");
        }
        alertController.addAction(cancelAction)
        
        // Present Dialog message
        self.present(alertController, animated: true, completion:nil)
      }
      else {
        
        let alertController = UIAlertController(title: "Report item", message: "Are you sure you want to delete the report", preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
          
          self.dbRef.child("productsReports").child(self.productData.productKey!).removeValue()
          
          
          print("Ok button tapped");
          
        }
        alertController.addAction(OKAction)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
          print("Cancel button tapped")
        }
        alertController.addAction(cancelAction)
        
        // Present Dialog message
        self.present(alertController, animated: true, completion:nil)
      }
    }
    
  }
  
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if productData.userId == SessionManager.shared.userId {
            return 0
        }else {
            return 70
        }
        
        
    }
   
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let _ = productData else {
      return 0
    }
    if indexPath.row == 0 {
      //cell images horizontal
      if imageUrlStringsForProduct.count <= 1{
        return 0
      }else {
        if UIDevice.isSmall { return 55 }
        else if UIDevice.isMedium { return 55 }
        else if Env.isIpad { return 55 }
        return super.tableView(tableView, heightForRowAt: indexPath)
      }
    }
    //bidding time
    if indexPath.row == 1  {
      if flagShowCellLisingEnded {
        return super.tableView(tableView, heightForRowAt: indexPath)
      }else if flagWonItem {
        return 100
        }
      return 0
    }
    if indexPath.row == 1{
      //cell timer
      if let producEndtime = productData.endTime {
        let intEndTime = (producEndtime as NSNumber).intValue
        
        if intEndTime == -1 {
          return 0
        }else if flagWonItem {
                let height =  lblWonItem.text!.height(withConstrainedWidth: tableView.frame.width - 16 , font: UIFont.boldSystemFont(ofSize: 25 ))
                 return height + 35 + 20
            }else {
                 return super.tableView(tableView, heightForRowAt: indexPath)
            }
      
          
        }
      }
      
      
      
    
    

    if indexPath.row == 2 {
      guard let title = productData.title else {
        return super.tableView(tableView, heightForRowAt: indexPath)
      }
     
        if UIDevice.modelName.contains("iPhone") {
            let titleHeight = title.height(withConstrainedWidth: tableView.frame.width - 16 , font: UIFont.boldSystemFont(ofSize: 25 ))
            return titleHeight + 35 + 20
        }else {
            let titleHeight = title.height(withConstrainedWidth: tableView.frame.width - 16 , font: UIFont.boldSystemFont(ofSize: 45 ))
            return titleHeight + 35 + 20
        }
     
      
    }
    else if indexPath.row == 3 {
      //cell quantity.
      //don't show quantity in bidding items, only in buy it now
      let auctionType = self.productData.auctionType ?? "NA"
      if auctionType != "buy-it-now" || self.isJob {
        return 0
      }else {
        return 40
        }
        
    }
    else if indexPath.row == 4 {
        
        if UIDevice.modelName.contains("iPhone") {
            guard let parent = self.parent as? ProductDetailVc , parent.flagWasPushedFromSellerProfile else {
                return super.tableView(tableView, heightForRowAt: indexPath) + 20
            }
            return 0
        }else {
            
            guard let parent = self.parent as? ProductDetailVc , parent.flagWasPushedFromSellerProfile else {
                return super.tableView(tableView, heightForRowAt: indexPath) + 30
            }
            return 0
        }
      
    }
    else if indexPath.row == 5{
      if (!self.isJob){
        return 0
      }else {
       
        return super.tableView(tableView, heightForRowAt: indexPath ) + 20
      }
    }
    else if indexPath.row == 6{
      if (!self.isJob){
        return 0
      }else {
        return super.tableView(tableView, heightForRowAt: indexPath)
      }
    }
    else if indexPath.row == 7{
      if (!self.isJob){
        return 0
      }else {
        return super.tableView(tableView, heightForRowAt: indexPath)
      }
    }
    else if indexPath.row == 8{
      if (!self.isJob){
        return 0
      }else {
        return super.tableView(tableView, heightForRowAt: indexPath)
      }
    }
    else if indexPath.row == 9 {
      guard let desc = productData.description else {
        return super.tableView(tableView, heightForRowAt: indexPath)
      }
      
      let textHeight = desc.height(withConstrainedWidth: tableView.frame.width, font: UIFont.boldSystemFont(ofSize: Env.isIpad ? 45: 20 ))
      return textHeight + 20 + 20
      
    }else if indexPath.row == 10 {
        guard let desc = productData.description else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
        
        let textHeight = desc.height(withConstrainedWidth: tableView.frame.width, font: UIFont.boldSystemFont(ofSize: Env.isIpad ? 45: 20 ))
        if UIDevice.modelName.contains("iPhone") {
            return 50
            
        }else {
            return 60
        }
        
        
    }
    else if indexPath.row == 13  {
      //dont show "Add to watch list to seller"
      print("if indexPath.row == 13")
      if self.currentuserId == productData.userId{
        return 0
      }else {
        return super.tableView(tableView, heightForRowAt: indexPath)
      }
      
      
    }
    else if indexPath.row == 14  {
      //height for View Offers
      if self.currentuserId == productData.userId && productData.auctionType == "buy-it-now"{
        return super.tableView(tableView, heightForRowAt: indexPath)
      } else {
        return 0
      }
    }
    else if indexPath.row == 15 {
      //height for biding history
      if  productData.auctionType != "buy-it-now"{
        return super.tableView(tableView, heightForRowAt: indexPath)
      } else {
        return 0
      }
    }
      
    else if indexPath.row == 16 {
      //your offer has been sent will be accpted soon
      
      if (self.isOrder){
        //if order is already accepted, don't show this cell
        if buyerHasRatedThisProduct || flagGiveOptionToRate {
          return 0
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
      }
      else {
        return 0
      }
    }
    else if indexPath.row == 17 {
      if (!self.isBid){
        return 0
      }
      if timeStackView.isHidden { return 0 }
      else {
        return super.tableView(tableView, heightForRowAt: indexPath)
      }
      
    }
    else if indexPath.row == 18 {
      //you rated this
      if(!buyerHasRatedThisProduct){
        return 0
      }
      else {
        return super.tableView(tableView, heightForRowAt: indexPath)
      }
    }
    else if indexPath.row == 19 {
      //rate your experience
      if(!flagGiveOptionToRate){
        return 0
      }
      else {
        return super.tableView(tableView, heightForRowAt: indexPath)
      }
    }
    else if indexPath.row == 20 {
      if(!ischeckReport){
        
        return 0
        
      }
      else {
        return super.tableView(tableView, heightForRowAt: indexPath)
      }
    }
      //product owner actions | Button stack
    else if indexPath.row == 21 {
      //print("indexPath.row : 21")
      //hide users Button section
      //let height = self.view.frame.height
      
      if currentUserId == productData.userId {
        var count = 0
        if !acceptOffersBtn.isHidden { count = count + 1 }
        
        if self.newOrderBtn.isHidden == false{
          count = count + 1
        }
        
        if self.stockBtn.isHidden == false {
          count = count + 1
        }
        if self.productVisibilityBTn.isHidden == false{
          count = count + 1
        }
        
        if self.relistBtn.isHidden == false{
          count = count + 1
        }
        if flagShowBtnEndListing {
            
            print("Endlisting btn \(count)")
          count = count + 1
        }
        if !turboChargeBtn.isHidden { count = count + 1 }
        var temp = Int()
        if count <= 3 {
            temp = 100
        }else {
            temp = 50
        }
        if UIDevice.current.userInterfaceIdiom == .pad { temp = 60 + 10}
        print("\nCount is \(count)")
        let value = CGFloat(count*temp)
        return value
      }else {
        return 0
      }
    }
    else if indexPath.row ==  22 {
      //view counter offer cell
      if !flagShowViewCounterOffer {
        return 0
      }else {
        return 140
      }
    }
      
    else if indexPath.row == 23{
      if !flagShowBtnMarkPaid {
        return 0
      }
      if !flagShowCellMarkPaid { return 0 }
    }
      
      //empty space for buyer buttons
    else if indexPath.row == 24 {
      if flagShowBuyerButtons { return 50 }
      return 0
    }
    
    return super.tableView(tableView, heightForRowAt: indexPath)
    
  }
  
  
}
