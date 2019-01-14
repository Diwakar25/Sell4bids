//MARK: - UICollectionViewDelegate, UICollectionViewDataSource


extension HomeVC_New : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
  
   
    

    
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == self.colVProducts {
      if flagIsFilterApplied {
       
        return productsArray.count
      }
      else
      {
        //print("Get numberOfItemsInSection", section, productsArray.count)
        print("Product items in collectionview \(productsArray.count)")
        return productsArray.count
        //return number of rows in section
      }
    }
    else {
      //print("Get numberOfItemsInSection", section, categoriesImagesArray.count)
         print("Product items in collectionview \(categoriesImagesArray.count)")
      return categoriesImagesArray.count
        
      
    }
  }
  
    
    
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
   
    if collectionView == colVProducts {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedPhotoCell", for: indexPath as IndexPath) as! AnnotatedPhotoCell
      
      cell.layer.cornerRadius = 3.0
      cell.layer.masksToBounds = false
      cell.layer.shadowColor = UIColor.black.cgColor
      cell.layer.shadowOffset = CGSize(width: 0, height: 0)
      cell.layer.shadowOpacity = 0.6
      cell.mainContainerView.layer.cornerRadius = 8
      cell.mainContainerView.clipsToBounds = true
      print("will Appear = \(willAppear)")
      
      cell.mainBidNowBtn.addShadowAndRound()
      
      if  !flagIsFilterApplied{
        //filter not applied
        guard indexPath.row < productsArray.count else { return cell }
        let product = productsArray[indexPath.item]
       
        var imageUrlStrToUse = ""
        if let imageUrl0 = product.imageUrl1 { imageUrlStrToUse = imageUrl0 }
        else if let imageUrl1 = product.imageUrl0 { imageUrlStrToUse = imageUrl1 }
        else if let imageUrl2 = product.imageUrl2 { imageUrlStrToUse = imageUrl2 }
        else if let imageUrl3 = product.imageUrl3 { imageUrlStrToUse = imageUrl3 }
        else if let imageUrl4 = product.imageUrl4 { imageUrlStrToUse = imageUrl4 }
        
        if let _ = URL.init(string: imageUrlStrToUse) {
          cell.mainImageView.sd_setImage(with: URL(string: imageUrlStrToUse), placeholderImage: #imageLiteral(resourceName: "emptyImage") )
        }else {
          cell.mainImageView.image = #imageLiteral(resourceName: "emptyImage")
            
        }
        
        cell.mainBidNowBtn.addTarget(self, action: #selector(HomeVC_New.bidNowBtnTapped), for: .touchUpInside)
        cell.mainBidNowBtn.tag = indexPath.item
        
        cell.mainImageView.sd_setShowActivityIndicatorView(true)
        cell.titleLabel.text = product.title
        cell.mainBidNowBtn.backgroundColor =  UIColor(red:255/255, green:27/255, blue:34/255, alpha:0.8)
        
    
        
        if product.auctionType == "buy-it-now"{
            
          cell.mainBidNowBtn.setTitle("Buy at \(product.currency_symbol ?? "$")\(product.startPrice ?? 0)", for: .normal)
          
          if let quantity = product.quantity, quantity <= 0 {
            cell.mainBidNowBtn.setTitle("Sold at \(product.currency_symbol ?? "$")\(product.startPrice ?? 0)", for: .normal)
            cell.mainBidNowBtn.backgroundColor = UIColor(red:184/255, green:184/255, blue:184/255, alpha:1)
          }
          
        }
        else  {
          cell.mainBidNowBtn.setTitle("Bid at \(product.currency_symbol ?? "$" )\(product.startPrice ?? 0)", for: .normal)
          
        }
        if product.categoryName == "Jobs"{
          cell.mainBidNowBtn.setTitle("Apply Now", for: .normal)
        }
        if product.startPrice == 0 {
          cell.mainBidNowBtn.setTitle("Free", for: .normal)
        }
        //this case is when product was opened atleast one time before listing ended, so timeremaining exists
        if let timeRemaining =  product.timeRemaining, timeRemaining < 0  && product.endTime != -1 {
          cell.mainBidNowBtn.backgroundColor = UIColor(red:184/255, green:184/255, blue:184/255, alpha:1)
        }
        else if product.timeRemaining == nil {
          //no time remaining node is present
          //get current server time and compare with end time. and grey out the button if current time >= end time
          getCurrentServerTime { (success, currentTime) in
            if success {
              let currentTimeInt64 = Int64(currentTime)
              if let endTime = product.endTime {
                if currentTimeInt64 >= endTime { cell.mainBidNowBtn.backgroundColor =  UIColor(red:184/255, green:184/255, blue:184/255, alpha:1) }
              }
            }
          }
        }
        
      }
      else if flagIsFilterApplied && indexPath.item < productsArray.count {
       
        
        let product = productsArray[indexPath.item]
        
        var imageUrlStrToUse = ""
        if let imageUrl0 = product.imageUrl0 { imageUrlStrToUse = imageUrl0 }
        else if let imageUrl1 = product.imageUrl1 { imageUrlStrToUse = imageUrl1 }
        else if let imageUrl2 = product.imageUrl2 { imageUrlStrToUse = imageUrl2 }
        else if let imageUrl3 = product.imageUrl3 { imageUrlStrToUse = imageUrl3 }
        else if let imageUrl4 = product.imageUrl4 { imageUrlStrToUse = imageUrl4 }
        
        if let _ = URL.init(string: imageUrlStrToUse) {
          cell.mainImageView.sd_setImage(with: URL(string: imageUrlStrToUse), placeholderImage: #imageLiteral(resourceName: "placeholder") )
        }else {
          cell.mainImageView.image = #imageLiteral(resourceName: "emptyImage")
        }
        
        
        
        cell.mainBidNowBtn.addTarget(self, action: #selector(HomeVC_New.bidNowBtnTapped), for: .touchUpInside)
        cell.mainBidNowBtn.tag = indexPath.item
        cell.mainContainerView.layer.cornerRadius = 8
        cell.mainContainerView.clipsToBounds = true
        cell.mainImageView.sd_setShowActivityIndicatorView(true)
        cell.titleLabel.text = product.title
         
        if product.auctionType == "buy-it-now"{
          cell.mainBidNowBtn.setTitle("Buy at \(product.currency_symbol ?? "$")\(product.startPrice ?? 0)", for: .normal)
          if let quantity = product.quantity , quantity <= 0 {
            cell.mainBidNowBtn.setTitle("Sold at \(product.currency_symbol ?? "$")\(product.startPrice!)", for: .normal)
            cell.mainBidNowBtn.backgroundColor =  UIColor(red:184/255, green:184/255, blue:184/255, alpha:1)
          }
          
        }
          
        else  {
          cell.mainBidNowBtn.setTitle("Bid at \(product.currency_symbol ?? "$" )\(product.startPrice ?? 0)", for: .normal)
          
        }
        if product.categoryName == "Jobs"{
          cell.mainBidNowBtn.setTitle("Apply Now", for: .normal)
        }
        if product.startPrice == 0 {
          cell.mainBidNowBtn.setTitle("Free", for: .normal)
        }
        
        cell.mainBidNowBtn.backgroundColor =  UIColor(red:0.85, green:0.11, blue:0.13, alpha:1.0)
        if let timeRemaining = product.timeRemaining, timeRemaining < 0  && product.endTime != -1 {
          cell.mainBidNowBtn.backgroundColor = UIColor(red:184/255, green:184/255, blue:184/255, alpha:1)
        }
        else if product.timeRemaining == nil {
          //no time remaining node is present
          //get current server time and compare with end time. and grey out the button if current time >= end time
          getCurrentServerTime { (success, currentTime) in
            if success {
              let currentTimeInt64 = Int64(currentTime)
              if let endTime = product.endTime {
                if currentTimeInt64 >= endTime { cell.mainBidNowBtn.backgroundColor =  UIColor(red:184/255, green:184/255, blue:184/255, alpha:1) }
              }
            }
          }
        }
        
        
        
      }
     // cell.titleLabel.font = AdaptiveLayout.normalBold
      
      return cell
    }
    else {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoriesCell
     
    print("indexPath ====\(indexPath.item)")
            
      cell.categoriesNameLabel.text = categoriesArray[indexPath.item]
      //let fontSize = AdaptiveLayout.fontForCategoriesHorizontal()
     // cell.categoriesNameLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
      cell.imageView.image = categoriesImagesArray[indexPath.item]
      
      //cell.img.contentMode = .scaleAspectFit
      cell.imageView.contentMode = .scaleAspectFit
      cell.imageView.clipsToBounds = true
        
      // cell.backgroundColor = UIColor.white
      return cell
    
       
    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    
    if collectionView == self.colVProducts {
       
      
        
        self.tabBarController?.tabBar.isHidden = false
      selectedProduct = productsArray[indexPath.item]
        
      let storyBoard_ = UIStoryboard.init(name: storyBoardNames.prodDetails , bundle: nil)
      let controller = storyBoard_.instantiateViewController(withIdentifier: "ProductDetailVc") as! ProductDetailVc
      controller.productDetail = selectedProduct
      
      navigationController?.pushViewController(controller, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
      
//        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 33, width: 20, height: 40)
        
    }
    else {
         self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = false
      let selectedCat = categoriesArray[indexPath.item]
      if  selectedCat == "Jobs" {
        let storyBoard = UIStoryboard.init(name: storyBoardNames.tabs.categoriesTab, bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "jobsVc") as! jobsVc
        controller.categoryName = selectedCat
        controller.flagWasPushed = true
        navigationController?.pushViewController(controller, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
       // self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 33, width: 20, height: 40)
        
        //self.present(controller, animated: true)
        
      }
      else  {
         self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = false
        let storyBoard = UIStoryboard.init(name: storyBoardNames.tabs.categoriesTab , bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "CategoryDetailVC") as! CategoryDetailVC
        controller.categoryName = selectedCat
        navigationController?.pushViewController(controller, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
//        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 33, width: 20, height: 40)
//        
      }
    }
  }
    
    private func estimateFrameForText(text: String) -> CGRect {
        //we make the height arbitrarily large so we don't undershoot height in calculation
        
        let height: CGFloat = 1000
        
        
        
        let size = CGSize(width: self.view.frame.width , height: height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)]
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
//    if collectionView == colVProducts{
//      let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
//
//      return CGSize(width: itemSize, height: itemSize)
//    }
//    else {
//
//      let size: CGSize = categoriesArray[indexPath.row].size(withAttributes: nil)
//      let headerheight = AdaptiveLayout.returnHeaderHeightForDevice()
//      let heightForLabel = headerheight * 0.35
//      let cellHeight = headerheight - heightForLabel + 10
//      return CGSize(width: size.width + 45.0, height: cellHeight  )
//
//    }

//
    let padding: CGFloat = 60
    var height = CGFloat()
    //estimate each cell's height
    
    //        var mx = messages
    //        mx.sort(){$0.message!.count > ($1.message?.count)!}
    
    var width = CGFloat((categoriesArray[indexPath.item].widthOfString(usingFont: UIFont.systemFont(ofSize: 17))))
    var widthipad = CGFloat((categoriesArray[indexPath.item].widthOfString(usingFont: UIFont.systemFont(ofSize: 22))))
    
    let heighth = categoriesArray[indexPath.item].height(constraintedWidth: width, font: UIFont.boldSystemFont(ofSize: 22))
    
        height = estimateFrameForText(text: categoriesArray[indexPath.item]).height + padding
    print("width === \(width)")
    print("widthipad == \(widthipad)")
    if width < 90 {
        width += 50
    }
    if widthipad < 115 {
        widthipad += 50
    }
    
    print("heibjkfjght == \(heighth)")
    print("Textheight == \(height)")
    
    
    if UIDevice.modelName.contains("iPhone") {
         return CGSize(width: width , height: 95)
    }else {
         return CGSize(width: widthipad , height: 100)
    }
   
  }
  
//  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//    let width = collectionView.frame.width
//    let height : CGFloat = 70
//    
//    return .init(width: width, height: height)
//    
//  }
    
    
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
    switch kind {
    case UICollectionElementKindSectionHeader:
      
      let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! HeaderView
      
      headerView.collView.delegate = self
      headerView.collView.dataSource = self
      headerView.buttonView.addShadowView()
      headerView.collView.register(UINib(nibName: "CategoriesCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    
      
      
      
      headerView.cityNameAndStateNameLabel.text = cityAndStateName
      if UIDevice.modelName.contains("iPhone") {
          headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 115)
      }else {
          headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 135)
      }
    
      //headerView.cityNameAndStateNameLabel =
      //var gesture = UITapGestureRecognizer(target: self, action: "userTappedOnLink")
      // if labelView is not set userInteractionEnabled, you must do so
      let resetTapAction = UITapGestureRecognizer(target: self, action: #selector(self.resetLabelTapped(_:)))
      headerView.resetLabel.isUserInteractionEnabled = true
      headerView.resetLabel.addGestureRecognizer(resetTapAction)
      // city label tapped
      let cityTapAction = UITapGestureRecognizer(target: self, action: #selector(self.cityLabelactionTapped(_:)))
      headerView.cityNameAndStateNameLabel.isUserInteractionEnabled = true
      headerView.cityNameAndStateNameLabel.addGestureRecognizer(cityTapAction)
      
      
      
      let heightForDevice = AdaptiveLayout.returnHeaderHeightForDevice()
      let spacing : CGFloat = 5
      //headerView.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: heightForDevice + spacing)
      
      return headerView
      
    default://I only needed a header so if not header I return an empty view
      return UICollectionReusableView()
    }
    
    
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
    
    
    
    
}

//MARK:- Toggles
extension HomeVC_New {
   func toggleShowViewNoResults(flag : Bool) {
    DispatchQueue.main.async {
      self.viewNoResults.alpha = flag ? 1 : 0
    }
  }
   func toggleDimBack(_ flag : Bool) {
    DispatchQueue.main.async {
      self.dimView.alpha = flag ? 0.3 : 0
    }
  }
}



extension HomeVC_New: PinterestLayoutDelegate {

  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat{
 
    let defaultHeight :CGFloat = 250
    
    

    
    guard let array = productsArray[indexPath.row].imagesArray, array.count > 0 else {
        
      print("returning default height for \(indexPath)")

      return defaultHeight
    }
    print("array imges = \(array.count)")
      print("Called PinterestLayoutDelegate")
    //print("index path .row : \(indexPath.row)")
    //print("got item in images array")
    let photo = array[0]
    print("photo size is : \(photo.size)")
    if photo.size.height == 0 {
      return defaultHeight
    }

    
    var height = CGFloat()
   
   print("Height == \(productObj.height_ratio)")
    if UIDevice.modelName.contains("iPhone") {
         height = CGFloat(productObj.height ?? 250.0) * CGFloat(productObj.height_ratio ?? 0.75)
    }else {
         height = CGFloat(productObj.height ?? 250.0)  * CGFloat(productObj.height_ratio ?? 0.75)
    }
   
    
//   ProductModel
   
    //print("photo size for index path \(indexPath): \(photo.size)")
    let loading : CGFloat = 80
    let lblNameHeight: CGFloat = 18
    let btnHeight : CGFloat = 50
    let numberOfColumns = 3
    let insets = collectionView.contentInset
    let contentWidth = collectionView.bounds.width - (insets.left + insets.right)
    let columnWidth = contentWidth / CGFloat(numberOfColumns)
    let font = UIFont.boldSystemFont(ofSize: 17)
    if let title = productsArray[indexPath.row].title  {
    
      
      let estimatedHeight = title.height(withConstrainedWidth: columnWidth, font: font)
      //print("estimate height for title : \(title) : \(estimatedHeight)")
      return height + estimatedHeight + btnHeight
      
    }
    
    return height + lblNameHeight + btnHeight
    
  }
    
    
   
}
//Tariq bahi Disable this Funcationality.
//MARK:- UIScrollViewDelegate
extension HomeVC_New : UIScrollViewDelegate {
    
    
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    
    
    if scrollView == colVProducts {
        
      let currentOffset = scrollView.contentOffset.y
      let maxOffset = scrollView.contentSize.height - scrollView.frame.height
     
        let height = self.colVProducts.contentSize.height
        
     print("contentoffset = \(scrollView.contentOffset.y)")
        print("scrollview height = \(scrollView.frame.height )")
       
        self.fidgetImageView.isHidden = true
        fidget.stopfiget(fidgetView: fidgetImageView)
    
        itemLoadingDescrib.isHidden = true
        
         scrollView.contentSize = CGSize(width: scrollView.frame.size.height, height: height  )
    scrollView.contentInset.bottom += 100
        scrollView.delegate = self
        
         print("Height == \(scrollView.contentSize.height)")

        print("maxoffset == \(maxOffset) // == Currentoffset = \(currentOffset)")
        print( "maxoffset- currentoffset = \(maxOffset - currentOffset)")
     
        if  maxOffset - currentOffset <= 0 {
              self.fetchAndDisplayData()
          
          
            
        }
    }

  }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if(velocity.y>0) {
            //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
            UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                //self.navigationController?.setToolbarHidden(true, animated: true)
                self.SellUStuff.isHidden = false
                self.tabBarController?.tabBar.isHidden = true
             
               
                
                
                print("Hide")
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                //self.navigationController?.setToolbarHidden(false, animated: true)
                  self.tabBarController?.tabBar.isHidden = false
                self.SellUStuff.isHidden = true
                print("Unhide")
            }, completion: nil)
        }
    }
    
   

}

extension HomeVC_New: SWRevealViewControllerDelegate {
  
  func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
    if position == FrontViewPosition.left {
      isOpen = 0
    }else {
      isOpen = 1
    }
  }
}

extension HomeVC_New : filtersVCDelegate {
  func btnDoneFiltersTapped(_ category: String, _ auction: String, _ cityAndState: String, _ condition: String, _ priceMin: Int, _ priceMax: Int) {
    self.categoryToFilter = category
    self.buyingOptionToFilter = auction
   self.cityAndStateName = "\(city), \(stateName)"
    
    print("city = \(city)")
    let parts = self.cityAndStateName!.components(separatedBy: ",")
   // stateName = parts[1].replacingOccurrences(of: " ", with: "")
   // self.conditionToFilter = condition
    self.priceMinFilter = priceMin
    self.priceMaxFilter = priceMax
    self.flagIsFilterApplied = true
    productsArray.removeAll()
    colVProducts.reloadData()
    
    
    fetchAndDisplayData()
    //self.stateToFilter = state
  }
  
  
}

extension HomeVC_New {
  func checkFilteredData() {
    if FilteredDataFromFilterVcArray != nil && FilteredDataFromFilterVcArray.count >= 0{
      if FilteredDataFromFilterVcArray.count == 0 {
        self.flagIsFilterApplied = true
        //self.colVProducts.isHidden = true
        // emptyProductMessage.text = "No result Found, Try different Filter"
        hideCollectionView(hideYesNo: true)
        
      }else {
        self.flagIsFilterApplied = true
      }
      
    }else {
     self.flagIsFilterApplied = false
    }
    
  }
  
  func checkInternetAndShowNoResults() -> Bool{
    //check internet is available
    if !InternetAvailability.isConnectedToNetwork() {
      
      toggleShowViewNoResults(flag: true)
      fidgetImageView.isHidden = true
        fidget.stopfiget(fidgetView: fidgetImageView)
      return false
    }
    return true
  }
  func hideCollectionView(hideYesNo : Bool) {
    
    emptyProductMessage.text = "No products found, try searching with different filters"
    if hideYesNo == false {
      // colVProducts.isHidden = false
      fidgetImageView.isHidden = false
      emptyProductMessage.isHidden = true
    }
    else  {
      fidgetImageView.isHidden = true
        fidget.stopfiget(fidgetView: fidgetImageView)
      //colVProducts.isHidden = true
      // imgeView.isHidden = false
      emptyProductMessage.isHidden = false
    }
  }
  
  func setCustomBackImage() {
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = UIColor.white
  }
}

//MARK:- UISearchBarDelegate
extension HomeVC_New: UISearchBarDelegate{
  
  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    let searchVCStoryBoard = getStoryBoardByName(storyBoardNames.searchVC)
    let searchVC = searchVCStoryBoard.instantiateViewController(withIdentifier: "SearchVC")
    self.navigationController?.view.backgroundColor = UIColor.clear
    self.navigationController?.pushViewController(searchVC, animated: true)
    
    return false
  }
}

