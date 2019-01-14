//
//  commented code.swift
//  Sell4Bids
//
//  Created by admin on 2/12/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

//filters
//  func filterNewData() {
//
//    var categoryFilteredArray = [ProductModel]()
//    var buyingOptionFilteredArray = [ProductModel]()
//    var stateFilteredArray = [ProductModel]()
//    var minPriceFilteredArray = [ProductModel]()
//    var maxPriceFilteredArray = [ProductModel]()
//    var conditionListFilteredArray = [ProductModel]()
//    var currentFilteredArray = [ProductModel]()
//    //categories filter
//    //
//    if (categoriesTextField.text != "" && categoriesTextField.text != "All") {
//
//      categoryFilteredArray = self.allProductsArray.filter{(item)-> Bool in
//        //print(item.title)
//        let category = categoriesTextField.text?.lowercased()
//        if let itemCat = item.categoryName {
//          return(itemCat.lowercased().contains(category!))
//        }else{
//          return false
//        }
//
//
//      }
//
//      //var allFilteredArray = [ProductModel]()
//
//      for categoryItem in categoryFilteredArray {
//        //allFilteredArray.append(categoryItem)
//        currentFilteredArray.append(categoryItem)
//      }
//    }
//
//
//    /////////////////////////////////////////////
//
//    //buy-it-now
//    //reserve
//    //non-reserve
//    //buying option filter
      
//    if (buyingOptionTextField.text != "" && buyingOptionTextField.text != "Any") {
//
//      var arrayToUse = [ProductModel]()
//      //no filters previously
//      if currentFilteredArray.count == 0 {
//        //we have to user apply filter to  allProductsArray and store in
//        arrayToUse = allProductsArray
//      }else {
//        //we have to user currentFilteredArray
//        for item in currentFilteredArray {
//          arrayToUse.append(item)
//        }
//        arrayToUse = currentFilteredArray
//      }
//
//      if self.buyingOptionTextField.text == "Buy Now"{
//        buyItNowString = "buy-it-now"
//
//        buyingOptionFilteredArray = arrayToUse.filter{(item)-> Bool in
//
//          //let auctionTypeSearch:NSString = (item.auctionType as? NSString)!
//          if let itemAuctionType = item.auctionType {
//            if itemAuctionType == buyItNowString { return true } else { return false}
//          }else {
//            return false
//          }
//        }
//
//      }
//      else if self.buyingOptionTextField.text == "Bidding" {
//        reserveString = "reserve"
//        nonReserveString = "non-reserve"
//
//        //buyItNowString = "buy-it-now"
//
//        buyingOptionFilteredArray = arrayToUse.filter{(item)-> Bool in
//
//          if let itemAuctionType = item.auctionType {
//            if itemAuctionType == reserveString {
//              print ("item auction type is reserve")
//
//            }
//            if itemAuctionType == nonReserveString {
//              print ("item auction type is non-reserve")
//
//            }
//            var no = 1
//            if itemAuctionType == reserveString || itemAuctionType == nonReserveString {
//              print("returning true from Bidding: Item :\(no)")
//              no = no + 1
//              return true
//
//            } else {
//              print("returning false from Bidding: Item :\(no)")
//              no = no + 1
//              return false
//
//            }
//          }else {
//            return false
//          }
//        }
//
//      }
//      //filtered till buying option
//      currentFilteredArray = buyingOptionFilteredArray
//    }
//
//    /////////////////////////////////////////////
//    //State Filters
//    /////////////////////////////////////////////
//    if !(stateTextField.text?.isEmpty)! {
//
//      //geting the state Name
//      var states = ""
//
//      var stateArray =  self.stateTextField.text?.components(separatedBy: ", ")
//      states = stateArray![1]
//      print(states)
//      //if wali kahani
//      var arrayToUse = [ProductModel]()
//      //no filters previously
//      if currentFilteredArray.count == 0 {
//        //we have to user apply filter to  allProductsArray and store in
//        arrayToUse = allProductsArray
//      }else {
//        //we have to user currentFilteredArray
//        for item in currentFilteredArray {
//          arrayToUse.append(item)
//        }
//        // arrayToUse = currentFilteredArray
//      }
//
//      stateFilteredArray = arrayToUse.filter{(item)-> Bool in
//
//        if let itemState = item.state {
//          return(itemState.lowercased().contains(states.lowercased()))
//        }else{
//          return false
//        }
//
//
//      }
//      //copy statearray into currentFiltered Array
//      currentFilteredArray.removeAll()
//      for stateItem in stateFilteredArray {
//        currentFilteredArray.append(stateItem)
//      }
//    }
//    //filtered till state
//
//    //////////////////////
//    //Price min Filter
//    //////////////////////
//
//    if !((minTextField.text?.isEmpty)!)
//    {
//      guard var minTextField = minTextField.text else{return}
//      let removeDollarSign = minTextField.characters.index(of: "$")
//      if removeDollarSign != nil {
//        minTextField.remove(at: removeDollarSign!)
//      }
//      var arrayToUse = [ProductModel]()
//      //no filters previously
//      if currentFilteredArray.count == 0 {
//        //we have to user apply filter to  allProductsArray and store in
//        arrayToUse = allProductsArray
//      }else {
//        //we have to user currentFilteredArray
//        for item in currentFilteredArray {
//          arrayToUse.append(item)
//        }
//        arrayToUse = currentFilteredArray
//      }
//      var minPriceInt = 0
//      var minPriceFromDbInt = 0
//
//      minPriceFilteredArray = arrayToUse.filter{(item)-> Bool in
//
//        minPriceInt = Int(minTextField)!
//        print(minPriceInt)
//        if let minPrice = item.startPrice {
//          minPriceFromDbInt = minPrice
//
//          return( (minPriceInt) <= (minPriceFromDbInt) )
//
//        }else{
//          return false
//        }
//
//
//      }
//      currentFilteredArray.removeAll()
//      for minPriceItem in minPriceFilteredArray {
//        currentFilteredArray.append(minPriceItem)
//      }
//
//    }
//    if !((maxTextField.text?.isEmpty)!)
//    {
//      guard var maxTextField = minTextField.text else{return}
//      let removeDollarSign = maxTextField.characters.index(of: "$")
//      if removeDollarSign != nil {
//        maxTextField.remove(at: removeDollarSign!)
//      }
//      var arrayToUse = [ProductModel]()
//      //no filters previously
//      if currentFilteredArray.count == 0 {
//        //we have to user apply filter to  allProductsArray and store in
//        arrayToUse = allProductsArray
//      }else {
//        //we have to user currentFilteredArray
//        for item in currentFilteredArray {
//          arrayToUse.append(item)
//        }
//        arrayToUse = currentFilteredArray
//      }
//      var maxPriceInt = 0
//      var maxPriceFromDbInt = 0
//
//
//      maxPriceFilteredArray = arrayToUse.filter{(item)-> Bool in
//        maxPriceInt = Int(maxTextField)!
//
//        if let maxPrice = item.startPrice {
//          maxPriceFromDbInt = Int(maxPrice)
//          return ((maxPriceInt) >= (maxPriceFromDbInt) )
//        }
//        else {
//          return false
//        }
//
//      }
//      currentFilteredArray.removeAll()
//      for maxPriceItem in maxPriceFilteredArray {
//        currentFilteredArray.append(maxPriceItem)
//      }
//
//    }
//
//    ///////////////////////
//    //Condition List filter
//    ///////////////////////
//    if conditionLabel.text != "Any"{
//
//      var arrayToUse = [ProductModel]()
//      //no filters previously
//      if currentFilteredArray.count == 0 {
//        //we have to user apply filter to  allProductsArray and store in
//        arrayToUse = allProductsArray
//      }else {
//        //we have to user currentFilteredArray
//        for item in currentFilteredArray {
//          arrayToUse.append(item)
//        }
//        arrayToUse = currentFilteredArray
//      }
//
//
//      conditionListFilteredArray = arrayToUse.filter{(item)-> Bool in
//        //print(item.condition)
//        let conditionList = conditionLabel.text
//        if let itemCondition = item.condition {
//          return(itemCondition.lowercased().contains(conditionList!.lowercased()))
//        }
//        else{
//          return false
//        }
//
//
//      }
//      //copy statearray into currentFiltered Array
//      currentFilteredArray.removeAll()
//      for codititonListItem in conditionListFilteredArray {
//        currentFilteredArray.append(codititonListItem)
//      }
//
//    }
//
//    print("Number of filtered items : \(currentFilteredArray.count)")
////    for currentItem in currentFilteredArray {
////      //print("Items cat : \(currentItem.categoryName!)")
////      //print("Items Buying Option : \(currentItem.auctionType!)")
////    }
//    self.resultProductsArray = currentFilteredArray
//
//
//  }


//func searchDB(){
//  
//  //self.fidgetImageView.isHidden = false
//  
//  dbRef.child("products").observeSingleEvent(of: .value) { (searchSnapshot) in
//    // self.searchProductArray.removeAll()
//    if let categorySnapshotValue = searchSnapshot.value as? [String:Any]{
//      // self.hideCollectionView(hideYesNo : false)
//      //looping for each category in /products
//      for (categoryNameKey,categoryName) in categorySnapshotValue {
//        
//        let auctionTypeValue = categoryName as! [String: Any]
//        //looping for each AuctionType /products/category
//        for(auctionTypeKey,auctionType) in auctionTypeValue{
//          
//          let stateNameValues = auctionType as! [String: Any]
//          
//          //looping for each cityName /products/category/AuctionType
//          
//          for(_,stateName) in stateNameValues {
//            
//            let cityNameValue = stateName as! [String: Any]
//            //looping for each product values /products/category/AuctionType/keys
//            for(producyKey,product) in cityNameValue
//            {
//              // let producyKeyValues = key
//              guard let productDict = product as? [String:AnyObject] else {return}
//              
//              let product = ProductModel(categoryName: categoryNameKey, auctionType: auctionTypeKey, prodKey: producyKey, productDict: productDict)
//              guard let title = product.title, let categoryName = product.categoryName,let visibility = product.Visibility, let desc = product.description else {return}
//              if visibility == "shown" {
//                if title.lowercased().contains( self.searchString.lowercased()) {
//                  self.searchProductArray.append(product)
//                  DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//                    
//                  }
//                }
//              }
//            }
//            
//          }
//          
//        }
//        
//        
//      }
//      
//      //  completion(true)
//      //self.fidgetImageView.isHidden = true
//      
//      
//      
//    }
//    
//  }
//  
//  
//}

///////////////////////////sending emails on orders and bidding ////////
/////////////////////////////////////////////////////////////////////////

//  func getSellerData(id: String, completion: @escaping(_ name: String?,_ sellingActivities: String,_ buyingActivities: String,_ email: String,_ status: Bool)->()){
//
//
//    let ref = Database.database().reference().child("users").child(id)
//    ref.observeSingleEvent(of: .value) { (snapshot) in
//
//
//      if let data = snapshot.value as? [String:Any]{
//
//        print(snapshot.value as Any)
//
//        var config = data["configs"] as? [String:Any]
//        var sellingActivities = ""
//        var buyingActivities = ""
//        if config != nil{
//
//          if config!["sellingActivities"] as? String != nil{
//            sellingActivities = config!["sellingActivities"] as! String
//          }
//          else{
//            sellingActivities = "on"
//          }
//
//          if config!["buyingActivities"] as? String != nil{
//            buyingActivities = config!["buyingActivities"] as! String
//          }
//          else{
//            buyingActivities = "on"
//          }
//        }
//        else{
//          sellingActivities = "on"
//          buyingActivities = "on"
//        }
//
//
//
//        let name = data["name"] as? String
//
//        let email = data["email"] as? String
//
//        if name != nil && email != nil{
//          completion(name!, email!, sellingActivities, buyingActivities, true)
//          //completion(name!, email!, true)
//        }
//        else if name == nil && email == nil{
//          completion("no name", "no email", "no activities", "no activities", false)
//          // completion("no name", "no email", false)
//        }
//        else if name == nil{
//          completion(nil, email!, sellingActivities, buyingActivities, true)
//          //completion(nil, email!, true)
//        }
//        else if email == nil{
//          completion("no name", "no email", "no activities", "no activities", false)
//          //completion(name!, "no email", false)
//        }
//
//
//      }
//
//    }
//
//  }


//start SendEmail function
//  func sendEmail(sellerID: String, url: String, key: String, recipientEmail: String, quantity: String, unitPrice: Int, productTitle: String, recipientName: String, senderName: String,title: String, subTitile: String){
//
//    let totalAmount = unitPrice * Int(quantity)!
//
//
//    let urlComponents = NSURLComponents(string: url)
//    urlComponents?.queryItems = [
//      URLQueryItem(name: "key", value: self.apiKey),
//      URLQueryItem(name: "to", value: recipientEmail),
//      URLQueryItem(name: "quantity", value: quantity),
//      URLQueryItem(name: "unitPrice", value:"\(unitPrice)"),
//      URLQueryItem(name: "title", value: title),
//      URLQueryItem(name: "subTitle", value: subTitile),
//      URLQueryItem(name: "productTitle", value: productTitle),
//      URLQueryItem(name: "totalAmount", value: "\(totalAmount)"),
//      URLQueryItem(name: "receiverName", value: recipientName)
//    ]
//
//
//
//    Alamofire.request((urlComponents?.url)!).responseJSON(completionHandler: { (response) in
//      print(response.request as Any)
//      print(response.response as Any)
//      print(response.result)
//    })
//
//  }//end sendEmail function

//sendEmailOnBidding function
//  func sendEmailOnBidding(sellerID: String, url: String, key: String, recipientEmail: String,userBid: String, sellingPrice: String, productTitle: String, recipientName: String, senderName: String,title: String, subTitile: String){
//
//    let urlComponents = NSURLComponents(string: url)
//    urlComponents?.queryItems = [
//      URLQueryItem(name: "key", value: self.apiKey),
//
//      URLQueryItem(name: "to", value: recipientEmail),
//      URLQueryItem(name: "sellingPrice", value: sellingPrice),
//      URLQueryItem(name: "title", value: title),
//      URLQueryItem(name: "subTitle", value: subTitile),
//      URLQueryItem(name: "productTitle", value: productTitle),
//      URLQueryItem(name: "userBid", value: userBid),
//      URLQueryItem(name: "receiverName", value: recipientName)
//    ]
//
//
//
//    Alamofire.request((urlComponents?.url)!).responseJSON(completionHandler: { (response) in
//      print(response.request as Any)
//      print(response.response as Any)
//      print(response.result)
//    })
//
//
//
//
//  }

//  func sendNotification(id: String, title: String, message: String){
//    let url = "https://us-central1-sell4bids-4affe.cloudfunctions.net/sendNotification/"
//    let urlComponents = NSURLComponents(string: url)
//    urlComponents?.queryItems = [
//      URLQueryItem(name: "key", value: self.apiKey),
//      URLQueryItem(name: "id", value: id),
//      URLQueryItem(name: "title", value: title),
//      URLQueryItem(name: "message", value: message)
//    ]
//
//    Alamofire.request((urlComponents?.url)!).responseJSON { (response) in
//      print(response.response as Any )
//      print(response.response as Any)
//      print(response.result)
//    }
//
//  }

//  func sendEmailWrapper(bidderTitle: String, bidderSubTitle: String,sellerTitle: String,sellerSubTitle: String, userBid: String, sellingPrice: String,myName: String){
//
//    guard let ownerID = self.previousData["ownerID"] as? String else{
//      DispatchQueue.main.async {
//        self.alert(message: "Can't send Email because of Internal ERROR", title: "ERROR")
//        return
//      }
//
//      return
//    }
//    // var myName = UserDefaults.standard.object(forKey: "name")
//
//    self.getSellerData(id: ownerID, completion: { (ownerName, ownerEmail, ownerSellingActivities, ownerBuyingActivities, status) in
//      if status == true{
//
//        if ownerName != nil{
//
//          if myName != nil{
//
//            if sellerSubTitle == "You received bid "{
//              if ownerSellingActivities == "on"{
//                //self.sendNotification(id: ownerID, title: "Bid received", message: "You received bid on "+"\(self.previousData["title"] as! String)")
//                //self.sendEmailOnBidding(sellerID: ownerID, url: "https://us-central1-sell4bids-4affe.cloudfunctions.net/sendBidMail/", key: self.apiKey, recipientEmail: ownerEmail, userBid: userBid, sellingPrice: sellingPrice, productTitle: self.previousData["title"] as! String, recipientName: ownerName!, senderName: myName as! String, title: sellerTitle, subTitile: "You received bid from "+"\(myName)")
//              }
//              //sellerSubTitle = "You received bid from "+"\(myName)"
//            }else{
//              if ownerSellingActivities == "on"{
//                //self.sendNotification(id: ownerID, title: "Bid received", message: "You received bid on "+"\(self.previousData["title"] as! String)")
//                //self.sendEmailOnBidding(sellerID: ownerID, url: "https://us-central1-sell4bids-4affe.cloudfunctions.net/sendBidMail/", key: self.apiKey, recipientEmail: ownerEmail, userBid: userBid, sellingPrice: sellingPrice, productTitle: self.previousData["title"] as! String, recipientName: ownerName!, senderName: myName as! String, title: sellerTitle, subTitile: sellerSubTitle)
//              }
//            }
//
//
//            if let myEmail = UserDefaults.standard.object(forKey: "email"){
//              if self.myBuyingActivities == "on"{
//                //self.sendEmailOnBidding(sellerID: ownerID, url: "https://us-central1-sell4bids-4affe.cloudfunctions.net/sendBidMail/", key: self.apiKey, recipientEmail: myEmail as! String, userBid: userBid, sellingPrice: sellingPrice, productTitle: self.previousData["title"] as! String, recipientName: myName as! String, senderName: "Team Sell4Bids", title:bidderTitle , subTitile: bidderSubTitle)
//
//              }
//            }
//          }
//          else{
//            if ownerSellingActivities == "on"{
//              //self.sendNotification(id: ownerID, title: "Bid received", message: "You received bid on "+"\(self.previousData["title"] as! String)")
//              //self.sendEmailOnBidding(sellerID: ownerID, url: "https://us-central1-sell4bids-4affe.cloudfunctions.net/sendBidMail/", key: self.apiKey, recipientEmail: ownerEmail, userBid: userBid, sellingPrice: sellingPrice, productTitle: self.previousData["title"] as! String, recipientName: ownerName!, senderName: "User", title: sellerTitle, subTitile: sellerSubTitle)
//
//            }
//
//            if let myEmail = UserDefaults.standard.object(forKey: "email"){
//
//
//              if self.myBuyingActivities == "on"{
//
//                //self.sendEmailOnBidding(sellerID: ownerID, url: "https://us-central1-sell4bids-4affe.cloudfunctions.net/sendBidMail/", key: self.apiKey, recipientEmail: myEmail as! String, userBid: userBid, sellingPrice: sellingPrice, productTitle: self.previousData["title"] as! String, recipientName: "Respected User", senderName: "Team Sell4Bids", title: bidderTitle, subTitile: bidderSubTitle)
//
//              }
//            }
//
//          }
//
//        }
//        else{
//
//          if myName != nil{
//
//            if sellerSubTitle == "You received bid "{
//              if ownerSellingActivities == "on"{
//                //self.sendNotification(id: ownerID, title: "Bid received", message: "You received bid on "+"\(self.previousData["title"] as! String)")
//                //self.sendEmailOnBidding(sellerID: ownerID, url: "https://us-central1-sell4bids-4affe.cloudfunctions.net/sendBidMail/", key: self.apiKey, recipientEmail: ownerEmail, userBid: userBid, sellingPrice: sellingPrice, productTitle: self.previousData["title"] as! String, recipientName: "Respected User", senderName: myName as! String, title: sellerTitle, subTitile: "You received bid from "+"\(myName)")
//              }
//            }else{
//              if ownerSellingActivities == "on"{
//                //self.sendNotification(id: ownerID, title: "Bid received", message: "You received bid on "+"\(self.previousData["title"] as! String)")
//                //self.sendEmailOnBidding(sellerID: ownerID, url: "https://us-central1-sell4bids-4affe.cloudfunctions.net/sendBidMail/", key: self.apiKey, recipientEmail: ownerEmail, userBid: userBid, sellingPrice: sellingPrice, productTitle: self.previousData["title"] as! String, recipientName: "Respected User", senderName: myName , title: sellerTitle, subTitile: sellerSubTitle)
//              }
//            }
//
//
//
//            if let myEmail = UserDefaults.standard.object(forKey: "email"){
//
//              if self.myBuyingActivities == "on"{
//                //self.sendEmailOnBidding(sellerID: ownerID, url: "https://us-central1-sell4bids-4affe.cloudfunctions.net/sendBidMail/", key: self.apiKey, recipientEmail: myEmail as! String, userBid: userBid, sellingPrice: sellingPrice, productTitle: self.previousData["title"] as! String, recipientName: myName , senderName: "Team Sell4Bids", title: bidderTitle, subTitile: bidderSubTitle)
//              }
//
//            }
//
//          }
//          else{
//
////            if ownerSellingActivities == "on"{
////              //self.sendNotification(id: ownerID, title: "Bid received", message: "You received bid on "+"\(self.previousData["title"] as! String)")
////              //self.sendEmailOnBidding(sellerID: ownerID, url: "https://us-central1-sell4bids-4affe.cloudfunctions.net/sendBidMail/", key: self.apiKey, recipientEmail: ownerEmail, userBid: userBid, sellingPrice: sellingPrice, productTitle: self.previousData["title"] as! String, recipientName: "Respected User", senderName: myName , title: sellerTitle, subTitile: sellerSubTitle)
////            }
//
////            if let myEmail = UserDefaults.standard.object(forKey: "email"){
////
////              if self.myBuyingActivities == "on"{
////                //self.sendEmailOnBidding(sellerID: ownerID, url: "https://us-central1-sell4bids-4affe.cloudfunctions.net/sendBidMail/", key: self.apiKey, recipientEmail: myEmail as! String, userBid: userBid, sellingPrice: sellingPrice, productTitle: self.previousData["title"] as! String, recipientName: "Respected User", senderName: "Team Sell4Bids", title: bidderTitle, subTitile: bidderSubTitle)
////
////              }
////            }
//          }
//        }
//      }
//    })
//
//
//
//  }
///gets status of selling activities, buying activities [on or off]
