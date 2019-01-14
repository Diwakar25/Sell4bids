//
//  ExtHomeVC_Downloading.swift
//  Sell4Bids
//
//  Created by MAC on 17/07/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Firebase
import SDWebImage


extension HomeVC_New {

    func fetchDisplayData() {
        
        print("FetchandDisplayData..........")
        //fetchDataBoolen = false
        var itemIndex = 0
        
        var totalitemsToProcess = categoriesArray.count * DB_Names.auctionTypes.count
        var NumOfProductsProcessed = 0
        //    if flagIsFilterApplied && !flagFirstTime {
        //      return
        //    }
        //
        
        self.downloadCompleted = false
        toggleDimBack(true)
        fidget.stopfiget(fidgetView: (self.fidgetImageView)!)
        //    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] (timer) in
        //      guard let this = self else { return }
        //        if !(self?.downloadCompleted)! {
        //
        //        this.fidgetImageView.show()
        //      }else {
        //        this.fidgetImageView.hide()
        //
        //
        //        }
        //        if (self?.colVProducts.scrollsToTop)! {
        //            this.fidgetImageView.hide()
        //        }
        //
        //
        //    }
        //var flagSkipCategory = false
        var queryForUsersState : DatabaseQuery!
        
        var prodDict = [String:AnyObject]()
        var key = String()
        var arrCurrentFetchedProducts = [ProductModel]()
        var categories = categoriesArray
        let jobs = categories[0]
        
        
        categories.remove(at: 0)
        categories.insert(jobs, at: 3)
        let qString = "\u{F8FF}"
        let cString = qString.cString(using: String.Encoding.unicode)
        var limit = 0
        
        endAt = endkey
        print("endkey == \(endAt)")
        if fetchingMethod == "zipcode" {
            
            if (endAt == nil) {
                
                print("endAt Zipcode == \(endAt)")
                
                limit = 12
                
                queryForUsersState = FirebaseDB.shared.dbRef.child("items").queryOrdered(byChild: "zipcode_time")
                    .queryStarting(atValue: "\(gpscountry)_\(zipCode)_").queryEnding(atValue: "\(gpscountry)_\(zipCode)_"+"\\uff8f").queryLimited(toLast: UInt(limit))
                
                
                
                print("Endkey-ZipCode == \(zipCode)")
                print("Country == \(gpscountry)")
                print("City == \(city)")
                print("state == \(stateName)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.itemFidgetSpinner.isHidden = false
                    self.itemLoadingDescrib.isHidden = false
                    
                    self.itemLoadingDescrib.text = "Loading items in your zip code \(zipCode)"
                }
                
                
                
            }
            else {
                
                print("endAt ZipCode Not Empty == \(endAt)")
                
                limit = 15
                
                
                queryForUsersState = FirebaseDB.shared.dbRef.child("items").queryOrdered(byChild: "zipcode_time")
                    .queryStarting(atValue: "\(gpscountry)_\(zipCode)_").queryEnding(atValue: endkey ).queryLimited(toLast: UInt(limit))
                
                print("Endkey-2nd-ZipCode == \(endkey)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.itemFidgetSpinner.isHidden = false
                    self.itemLoadingDescrib.isHidden = false
                    
                    self.itemLoadingDescrib.text = "Loading items in your zip code \(zipCode)"
                }
                
                
                
            }
            
        }else if fetchingMethod == "state"{
            
            if (endAt == nil) {
                
                print("endAt State == \(endAt)")
                
                limit = 12
                
                queryForUsersState = FirebaseDB.shared.dbRef.child("items").queryOrdered(byChild: "state_time")
                    .queryStarting(atValue: "\(gpscountry)_\(stateName)_").queryEnding(atValue: "\(gpscountry)_\(stateName)_"+"\\uff8f").queryLimited(toLast: UInt(limit))
                
                print("Endkey State == \(endkey)")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.itemFidgetSpinner.isHidden = false
                    self.itemLoadingDescrib.isHidden = false
                    
                    self.itemLoadingDescrib.text = "Loading items in your state \(stateName)"
                    
                }
                
                
                
                
            }
            else {
                
                print("endAt State Not Empty == \(endAt)")
                
                limit = 15
                
                queryForUsersState = FirebaseDB.shared.dbRef.child("items").queryOrdered(byChild: "state_time")
                    .queryStarting(atValue: "\(gpscountry)_\(stateName)_").queryEnding(atValue: endkey).queryLimited(toLast: UInt(limit))
                
                print("Endkey 2nd State == \(endkey)")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.itemFidgetSpinner.isHidden = false
                    self.itemLoadingDescrib.isHidden = false
                    
                    self.itemLoadingDescrib.text = "Loading items in your state \(stateName)"
                }
                
                
                
            }
        }
        
        
        
        
        var currentAuctionIndex = 0
        
        queryForUsersState.observe( .value, with: { [weak self] (StateDataSnapShot) in
            
            self!.itemFidgetSpinner.isHidden = true
            self!.itemLoadingDescrib.isHidden = true
            
            
            self!.itemLoadingDescrib.text = ""
            print("StateDataSnapShot = \(StateDataSnapShot.childrenCount)")
            
            print("called")
            currentAuctionIndex += 1
            guard let thisInner = self else { return }
            NumOfProductsProcessed += 1
            checkReloadConditionAndReload()
            
            thisInner.downloadCompleted = true
            thisInner.toggleDimBack(false)
            thisInner.fidgetImageView.isHidden = true
            fidget.stopfiget(fidgetView: (self?.fidgetImageView)!)
            //print("inside queryForThisState")
            //print(queryForThisState)
            //print(StateDataSnapShot.value!)
            
            
            
            
            //        self!.itemFidgetSpinner.isHidden = true
            //          self!.downloadeditems = true
            
            
            //track index of current item
            
            
            
            //print("  - Going to query state for its products : \(stateName)")
            //iterating each item
            for stateSnap in StateDataSnapShot.children.allObjects as! [DataSnapshot]
            {
                print("StateDataSnapShot Loop == \(StateDataSnapShot.children.allObjects.count)")
                prodDict = (stateSnap.value as? [String:AnyObject])!
                //avoid duplication here
                print("prodict = \(prodDict)")
                key = stateSnap.key
                
                print("Printing key  \(key)")
                if thisInner.flagIsFilterApplied {
                    
                    
                    print("buyingOptionToFilter = \(thisInner.buyingOptionToFilter)")
                    fetchingMethod = "zipcode"
                    
                    
                    
                    
                    if thisInner.buyingOptionToFilter == "Bidding" {
                        
                        if prodDict["itemCategory"] as! String != nil && prodDict["itemAuctionType"] as! String != nil && key != nil && prodDict != nil {
                            if prodDict["itemAuctionType"] as! String == "reserve" || prodDict["itemAuctionType"] as! String == "non-reserve" {
                                self!.productObj = ProductModel.init(categoryName: prodDict["itemCategory"] as! String , auctionType: prodDict["itemAuctionType"] as! String, prodKey: key, productDict: prodDict)
                                
                                print("Bidding")
                            }
                        }
                        
                        
                    }else if thisInner.buyingOptionToFilter == "Buy Now" {
                        
                        if prodDict["itemCategory"] as? String != nil && prodDict["itemAuctionType"] as? String != nil && key != nil && prodDict != nil {
                            
                            if prodDict["itemAuctionType"] as! String == "buy-it-now" {
                                self!.productObj = ProductModel.init(categoryName: prodDict["itemCategory"] as! String , auctionType: prodDict["itemAuctionType"] as! String, prodKey: key, productDict: prodDict)
                            }
                        }
                    }else {
                        if prodDict["itemCategory"] as? String != nil && prodDict["itemAuctionType"] as? String != nil && key != nil && prodDict != nil {
                            
                            self!.productObj = ProductModel.init(categoryName: prodDict["itemCategory"] as! String , auctionType: prodDict["itemAuctionType"] as! String, prodKey: key, productDict: prodDict)
                        }
                    }
                }else {
                    if prodDict["itemCategory"] as? String != nil && prodDict["itemAuctionType"] as? String != nil && key != nil && prodDict != nil {
                        
                        self!.productObj = ProductModel.init(categoryName: prodDict["itemCategory"] as! String , auctionType: prodDict["itemAuctionType"] as! String, prodKey: key, productDict: prodDict)
                        
                    }
                }
                
                
                //                self!.productObj = ProductModel.init(categoryName: prodDict["itemCategory"] as! String , auctionType: prodDict["itemAuctionType"] as! String, prodKey: key, productDict: prodDict)
                
                
                
                
                
                
                
                
                //price filter
                if let productPrice = self!.productObj.startPrice {
                    if let priceMin = thisInner.priceMinFilter, priceMin != -1 , productPrice < priceMin {
                        continue
                    }
                    if let priceMax = thisInner.priceMaxFilter, priceMax != -1 , productPrice > priceMax {
                        continue
                    }
                }
                guard let userId = self!.productObj.userId else {
                    print("guard let userId = productObj.userId failed")
                    thisInner.fidgetImageView.isHidden = true
                    fidget.stopfiget(fidgetView: (self?.fidgetImageView)!)
                    NumOfProductsProcessed += 1
                    continue
                }
                if (!thisInner.blockedUserIdArray.contains(userId)){
                    var visible = true
                    if let visibilty = self!.productObj.Visibility {
                        if visibilty == "hidden" { visible = false}
                    }
                    if visible { arrCurrentFetchedProducts.append(self!.productObj) }
                    
                }
                
                
                
                
                
                
                
                
                print("itemIndex = \(itemIndex)")
                
                
                
                //          // print("endkey = \(endkey)")
                //            guard arrCurrentFetchedProducts.count > 0 else {
                //                DispatchQueue.main.async {
                //                    thisInner.fidgetImageView.isHidden = true
                //                    fidget.stopfiget(fidgetView: (self?.fidgetImageView)!)
                //                }
                //                //print("guard arrCurrentFetchedProducts.count > 0 failed in \(self)")
                //
                //                thisInner.hideCollectionView(hideYesNo: false)
                //                return
                //
                //            }
                //
                //            let firstsChargeTime = arrCurrentFetchedProducts[0].chargeTime
                //            thisInner.endAtChargeTimes[catNameAndAucType] = firstsChargeTime
                thisInner.productsArray.append(contentsOf: arrCurrentFetchedProducts)
                //print("currentAuctionIndex : \(currentAuctionIndex)")
                //            if currentAuctionIndex == numOfAuctionTypes {
                //                //print("All auction types completed, going to downloand and save images")
                //                //thisInner.downloadAndSaveImages()
                //            }
                
                
                DispatchQueue.main.async {
                    self!.colVProducts.collectionViewLayout.invalidateLayout()
                    thisInner.downloadAndSaveImages { completed in
                        print(completed)
                    }
                    thisInner.fidgetImageView.isHidden = true
                    thisInner.reloadColView()
                    fidget.stopfiget(fidgetView: (self?.fidgetImageView)!)
                    thisInner.dimView.isHidden = true
                    thisInner.colVProducts.reloadUsingDispatch()
                    
                    thisInner.emptyProductMessage.isHidden = true
                }
                
                
                if fetchingMethod == "state" {
                    if itemIndex == 1 {
                        guard let state_time = thisInner.productObj.state_time else {
                            
                            print("state_time is not found.")
                            return
                        }
                        endkey = state_time
                        
                        
                    }
                    
                    if (endkey == nil) {
                        guard let state_time = thisInner.productObj.state_time else {
                            
                            print("state_time is not found.")
                            return
                        }
                        endkey = state_time
                    }
                }else {
                    if itemIndex == 1 {
                        guard let zipcode_time = thisInner.productObj.zipcode_time else {
                            
                            print("zipcode_time is not found.")
                            return
                        }
                        endkey = zipcode_time
                    }
                    if (endkey == nil) {
                        guard let zipcode_time = thisInner.productObj.zipcode_time else {
                            print("zipcode_time is not found.")
                            return
                        }
                        endkey = zipcode_time
                    }
                }
                
                print("endkey == \(itemIndex) : \(endAt)")
                
                
                itemIndex += 1
                self!.productsArray = self!.uniq(source: self!.productsArray)
                
                
                
                
            }
            
            print("StateDataSnapShot.children.allObjects.count = \(StateDataSnapShot.children.allObjects.count)")
            
            
            
            
            
            
            
            // fetchDataBoolen = true
            
            
            
            
            
            
            
            
            
            //        else {
            //
            //            self!.itemFidgetSpinner.isHidden = true
            //             self!.colVProducts.isScrollEnabled = false
            //            self!.itemLoadingDescrib.text = ""
            //            //print("going to call fetch and display data")
            //            thisInner.fidgetImageView.isHidden = true
            //            fidget.stopfiget(fidgetView: (self?.fidgetImageView)!)
            //            if thisInner.productsArray.count <= 0 {
            //
            //                DispatchQueue.main.async {
            //
            //                    thisInner.dimView.isHidden = true
            //                    thisInner.emptyProductMessage.isHidden = false
            //
            //                }
            //            }
            //
            //        }
            //
            //
            
            
            
            if StateDataSnapShot.children.allObjects.count < 12 && StateDataSnapShot.children.allObjects.count < 15 {
                count += 1
                
                if fetchingMethod == "zipcode" {
                    print("Zipcode APPLIED")
                    fetchingMethod = "state"
                    
                    
                    endkey = nil
                    
                    
                    
                    thisInner.fetchAndDisplayData()
                    
                    
                }else if fetchingMethod == "state" {
                    if StateDataSnapShot.children.allObjects.count <= 2 {
                        print("No more items found in this area.....")
                    }
                }
                
            }
            
            
        })
        
        
        
        
        
        
        
        //
        //
        //    for category in categories {
        //
        //      if categoryToFilter != "All" {
        //        //some thing was selected from filtersVC
        //        if category != categoryToFilter {
        //          //this category was not selected from filters so skip
        //          //flagSkipCategory = true
        //          continue
        //        }
        //      }
        //
        //      let catEncoded = category.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        //      //let catRef = FirebaseDB.shared.dbRef.child(FBKeys.products).child(catEncoded)
        //      //print("cat Ref: \(catRef) " )
        //
        //
        //      //iterating through auction types
        //
        //      for (keyAuctionType ) in DB_Names.auctionTypes {
        //
        //        //handling filters for auction type
        //        if self.buyingOptionToFilter.lowercased().contains("buy")  && (keyAuctionType.lowercased().contains("reserve") )
        //
        //          ||
        //
        //          self.buyingOptionToFilter.lowercased().contains("bid") && keyAuctionType.lowercased().contains("buy"){
        //          print("skipped the following combination of auction type ")
        //          print("buyingOptionToFilter : \(self.buyingOptionToFilter) " )
        //          //print("keyAuctionType : \(keyAuctionType) ")
        //          continue
        //
        //        }
        //
        //        let catNameAndAucType = CategoryAndAuctionType(hashValue: 0, catName: category, auctionType: keyAuctionType)
        //
        //        //print(stateValueDict)
        //        let numOfAuctionTypes = 3
        //
        //
        //
        //        //auction type filter applied ? we have two auction types. buy now and bidding
        //
        //        let thisStatesEndAt = self.endAtChargeTimes[catNameAndAucType]
        //
        //        //to avoid duplication
        //
        //        let productModel = ProductModel(categoryName: category, auctionType: keyAuctionType, prodKey: key, productDict: prodDict)
        //
        //                            if productModel.chargeTime != thisStatesEndAt {
        //                                guard let userId = productModel.userId else {
        //                                    self.fidgetImageView.isHidden = true
        //                                    fidget.stopfiget(fidgetView: (self.fidgetImageView)!)
        //                                    return
        //                                }
        //                                if (self.blockedUserIdArray.contains(userId)){
        //                                    var visible = true
        //                                    if let visibilty = productModel.Visibility {
        //                                        if visibilty == "hidden" { visible = false}
        //                                    }
        //                                    if visible {
        //                                        //download image for this product
        //                                        arrCurrentFetchedProducts.append(productModel)
        //
        //
        //                                    }
        //
        //                                }
        //
        //                            }else {
        //
        //                                print("Detected Duplication")
        //
        //                            }
        //
        //
        //        //for storing the endat's of each product in corresponding to auctionType and State
        //
        //
        //
        //
        //
        //
        //      }
        //
        //    }
        //
        
        
        func checkReloadConditionAndReload() {
            print("totalItemsToProcess : \(totalitemsToProcess)")
            print("NumOfProductsProcessed : \(NumOfProductsProcessed)")
            // reloadColView()
            if totalitemsToProcess == NumOfProductsProcessed {
                reloadColView()
                
                downloadAndSaveImages { [weak self] (success) in
                    guard let this = self else { return }
                    
                    if success {
                        DispatchQueue.main.async {
                            this.reloadColView()
                        }
                    }
                }
                
            }
            
        }
        
    }
    
    
    
    ///downloads 1 image of the product for each product in products array for height calculation in heightForPhoto
    fileprivate func downloadAndSaveImages ( completion: @escaping (Bool) -> () ) {
        var i = 0
        //let dispatchGroup = DispatchGroup.init()
        
        
        for product in productsArray {
            
            guard let photoIndex = self.productsArray.index(where: { (aProduct:ProductModel) -> Bool in
                return aProduct.productKey == product.productKey
                
            }) else {
                print("no product found in downloadAndSaveImages function  ")
                print("product : \(product)")
                i += 1
                continue
                
            }
            if let images =  product.imagesArray, images.count > 0 {
                i += 1
                continue
            }
            var imageUrlToUse : URL?
            if let urlStr = product.imageUrl0 , let url = URL.init(string: urlStr) {
                imageUrlToUse = url
            }else if let urlStr = product.imageUrl1 , let url = URL.init(string: urlStr) {
                imageUrlToUse = url
            }else if let urlStr = product.imageUrl2 , let url = URL.init(string: urlStr) {
                imageUrlToUse = url
            }else if let urlStr = product.imageUrl3 , let url = URL.init(string: urlStr) {
                imageUrlToUse = url
            }else if let urlStr = product.imageUrl4 , let url = URL.init(string: urlStr) {
                imageUrlToUse = url
            }
            
            guard let imageUrl = imageUrlToUse else {
                i += 1
                //print("no image url found for \(product.title as Any)")
                var array = [UIImage]()
                array.append(#imageLiteral(resourceName: "emptyImage"))
                self.productsArray[photoIndex].imagesArray = array
                continue
            }
            //print("i in outside : \(i)")
            //print("image url is \(imageUrl)")
            
            // dispatchGroup.enter()
            
            downloader.shouldDecompressImages = false
            downloader.downloadImage(with: imageUrl, options: SDWebImageDownloaderOptions.lowPriority, progress: nil) {[weak self] (image_, data, error, success) in
                guard let strongSelf = self else { return }
                
                i += 1
                
                if let image = image_ {
                    
                    var array = [UIImage]()
                    
                    let cellSpacing :CGFloat = 8
                    let colvNumOfColumns :CGFloat = 3
                    let width = (strongSelf.view.frame.width / colvNumOfColumns) - cellSpacing * colvNumOfColumns
                    //print("before scaling, image size \(image.size)")
                    let scaledImage = imageWithImage(sourceImage: image, scaledToWidth: width)
                    //print("after scaling, image size \(scaledImage.size)")
                    array.append(scaledImage)
                    guard photoIndex < strongSelf.productsArray.count else { return }
                    
                    strongSelf.productsArray[photoIndex].imagesArray = array
                    
                }else {
                    
                    //print("could not download image with url : \(imageUrlToUse)")
                    //print("product title : \(product.title as Any)")
                    
                    var array = [UIImage]()
                    array.append(#imageLiteral(resourceName: "emptyImage") )
                    guard photoIndex < strongSelf.productsArray.count else { return }
                    strongSelf.productsArray[photoIndex].imagesArray = array
                    
                }
                //dispatchGroup.leave()
                //print("i = \(i)")
                
                
                
            }
            
        }
        
        
        // dispatchGroup.notify(queue: .global()) {
        //
        //      print("i = \(i)")
        //      print("strongSelf.productsArray.count \(self.productsArray.count)")
        //
        //        self.reloadColView()
        //      completion(true)
        //
        //
        //    }
        
    }
}

extension HomeVC_New {
    func getUserBlockedList(completion : @escaping (Bool) -> ()) {
        guard let userId = Auth.auth().currentUser?.uid  else {return}
        dbRef.child("users").child(userId).observeSingleEvent(of: .value) { (snapshot) in
            self.blockedUserIdArray.removeAll()
            if let dictObj = snapshot.value as? NSDictionary {
                if   let blockedPerson = dictObj.value(forKeyPath: "blockedPersons") as? NSDictionary {
                    for value in blockedPerson {
                        let blockedPerson = value.key as! String
                        self.blockedUserIdArray.append(blockedPerson)
                    }
                    
                    // print(blockedPerson.)
                }
            }
            completion(true)
        }
        
        
    }
}

extension Array where Element: Equatable {
    func removeDuplicates() -> Array {
        return reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
}
