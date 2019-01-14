//
//  CategoryDetailVCWithSimpleColV.swift
//  Sell4Bids
//
//  Created by admin on 1/10/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
class CategoryDetailVC: UIViewController,UISearchBarDelegate,UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        
    }
    
  //MARK:- Properties
  @IBOutlet weak var colVProducts: UICollectionView!
  //@IBOutlet weak var emptyProductMessage: UILabel!
  @IBOutlet weak var fidgetImageView: UIImageView!
  
    lazy var searchController = UISearchBar(frame: CGRect.zero)
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterprodArray = prodArray.filter({( candy : ProductModel) -> Bool in
        
            if candy.title!.lowercased().contains(searchText.lowercased()) {
                return candy.title!.lowercased().contains(searchText.lowercased())
            }
            self.colVProducts.reloadData()
            
            return false
        })
        
    }
    func isFiltering() -> Bool {
        return !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        
        return searchController.text?.isEmpty ?? true
    }
    

    
    //MARK:- Variables
  let CELLSTRING = "AnnotatedPhotoCell"
  lazy var prodArray = [ProductModel]()
  var filterprodArray = [ProductModel]()
    //var productdata = ProductModel()
  var currency = String()
  var country = String()
  var categoryName: String!
  lazy var endAtChargeTimes = [AuctionTypeAndState:CLongLong]()
  lazy private var jobsDataSource = [ProductModel]()
  var endAtChargeTime : CLongLong = -999
  lazy var blockedUserIdArray = [String]()
  
  var numOfColumns : CGFloat {
    if UIDevice.current.userInterfaceIdiom == .phone { return 2 }
    else { return 3 }
  }
  //for showing fidget after 2 seconds
  var downloadCompleted = false
  
  @IBOutlet weak var viewNoResults: NoResultsView!
  
    
    override func viewDidLayoutSubviews() {
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 40)
    }
  //MARK:- View Life Cycle
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    if country == "United States" {
        currency = "$"
        
    }else if country == "India" {
        currency = "₹"
    }
   
    //navigationItem.titleView = searchController
    filterprodArray = []
    searchController.delegate = self
    addLogoWithLeftBarButton()
    self.navigationItem.title = categoryName
    self.navigationController?.navigationBar.tintColor = UIColor.white
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = UIColor.white
    
    
    
    getUserBlockedList{ [weak self ] (complete) in
      guard let this = self else { return }
      //fetchAndDisplayData(flagFirstTime: true)
      this.fetchAndDislayDataOptimized(flagFirstTime: true)
    }
    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] (_) in
      guard let this = self else { return }
      if !this.downloadCompleted {
        this.fidgetImageView.toggleRotateAndDisplayGif()
      }
    }
    setupViews()
    
  }
  
  func setupViews() {
    if let layout = colVProducts?.collectionViewLayout as? PinterestLayout {
      layout.flagKeepHeaderHeightForHomeLayout = false
      layout.delegate = self
    }
    viewNoResults.lblOopsNoResults.text = "No Items found in this category "
    viewNoResults.lblTryChangingKeyWords.text = "Be the first to List Item in this Category!"
    
    viewNoResults.btnRight.setTitle("List Item", for: .normal)
    viewNoResults.btnRight.addTarget(self, action: #selector(btnListItemNoResultsTapped), for: .touchUpInside)
    
    viewNoResults.btnleft.addTarget(self, action: #selector(btnBackNoResultsTapped), for: .touchUpInside)
  }
  
  @objc func btnListItemNoResultsTapped() {
    
    tabBarController?.selectedIndex = 2
    btnBackNoResultsTapped()
    
  }
  
  @objc func btnBackNoResultsTapped() {
    navigationController?.popViewController(animated: true)
  }
  
  ///for each auction type (buy it now, or reserve) it stores endat values of each state in an array (array[0] stores endat of first state)
  func hideCollectionView(hideYesNo : Bool) {
    //emptyProductMessage.text = "No Items found. Try searching a different category"
    if hideYesNo == false {
      colVProducts.isHidden = false
     // imgVIew.isHidden = true
    //  fidgetImageView.isHidden = false
      //emptyProductMessage.isHidden = true
    }
    else  {
      //fidgetImageView.isHidden = true
      colVProducts.isHidden = true
      //fidgetImageView.isHidden = true
      fidgetImageView.image = #imageLiteral(resourceName: "no_product")
      //emptyProductMessage.isHidden = false
    }
    
  }
  //Pull down to refresh
  lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
    
    return refreshControl
  }()
  
  @objc func handleRefresh(_ refreshControl: UIRefreshControl){
    getUserBlockedList{(complete) in
      self.fetchAndDislayDataOptimized(flagFirstTime: true)
    }
  }//end Refreshing
  func getUserBlockedList(completion : @escaping (Bool) -> ()) {
    if let userId = Auth.auth().currentUser?.uid {
      
      FirebaseDB.shared.dbRef.child("users").child(userId).observe(.value, with: { [weak self] (snapshot) in
        guard let this = self else { return }
        this.blockedUserIdArray.removeAll()
        if let dictObj = snapshot.value as? NSDictionary {
          if let blockedPerson = dictObj.value(forKeyPath: "blockedPersons") as? NSDictionary {
            for value in blockedPerson {
              let blockedPerson = value.key as! String
              this.blockedUserIdArray.append(blockedPerson)
            }
            
            // print(blockedPerson.)
          }
        }
        completion(true)
      })
    }
    
  }
  
  ///for counting that all the auction type and states have been traversed. and reload data now
  var NumOfProductsProcessed = 0
  var totalitemsToProcess = DB_Names.auctionTypes.count * DB_Names.statesAbbrevArray.count
  ///for the selected category, loop all the auction types and return data.
  private func fetchAndDislayDataOptimized(flagFirstTime: Bool) {
    
    
    let categoryQuery = FirebaseDB.shared.dbRef.child("products").child(categoryName)
    let auctionTypesArray = DB_Names.auctionTypes
    
    
    
    for auctionType in auctionTypesArray {
      let auctionTypeRef = categoryQuery.child(auctionType)
        print("actiontype = \(auctionType)")
        //show State Products
      for keyStateName in DB_Names.statesAbbrevArray
      {
        
      
        print("State = \(keyStateName)")
        print("DB_Name = \(stateName)")
       
        
        
        
        let stateRef = auctionTypeRef.child(stateName)
        
        
        let auctionTypeAndState = AuctionTypeAndState(hashValue: 0, auctionType: auctionType, State: keyStateName)
        var queryForEachState :DatabaseQuery!
        if flagFirstTime {
          
          queryForEachState = stateRef.queryLimited(toLast: UInt(paginationFirstTimeConstant))
        }else {
          
          queryForEachState = stateRef.queryEnding(atValue: self.endAtChargeTimes[auctionTypeAndState]).queryLimited(toLast: UInt(6) )
        }
        
        
        
       self.continueFetchingData(flagFirstTime: flagFirstTime, queryForEachState: queryForEachState, keyAuctionType: auctionType, state: keyStateName)
        
        }
        
      
        
        
      
    }
    }
  
  
  fileprivate func checkAndReload(_ strongSelf: CategoryDetailVC) {
    if strongSelf.totalitemsToProcess == strongSelf.NumOfProductsProcessed {
      strongSelf.reloadColView()
      if strongSelf.prodArray.count <= 0 {
        strongSelf.viewNoResults.fadeIn()
      }else {
        
        strongSelf.downloadAndSaveImages(completion: { (success) in
          
          DispatchQueue.main.async {
            strongSelf.fidgetImageView.isHidden = true
            strongSelf.hideCollectionView(hideYesNo: false)
            strongSelf.reloadColView()
            
            
          }
        })
      }
      
      
    }
  }
  
  private func continueFetchingData( flagFirstTime : Bool, queryForEachState: DatabaseQuery, keyAuctionType: String, state : String) {
    
    var arrCurrentFetchedProducts = [ProductModel]()
    let auctionTypeAndState = AuctionTypeAndState(hashValue: 0, auctionType: keyAuctionType, State: state)
    queryForEachState.observeSingleEvent(of: .value, with: { [weak self] (StateDataSnapShot) in
      //call download and save images when
      
      
      guard let strongSelf = self else { return }
      DispatchQueue.main.async {
        strongSelf.fidgetImageView.isHidden = true
      }
      strongSelf.NumOfProductsProcessed += 1
      
      strongSelf.checkAndReload(strongSelf)
      
      //print("total items : \(strongSelf.totalitemsToProcess)")
      //print("Processed items : \(strongSelf.NumOfProductsProcessed)")
      
      for stateSnap in StateDataSnapShot.children.allObjects as! [DataSnapshot]
      {
        guard let prodDict = stateSnap.value as? [String:AnyObject] else {
          strongSelf.hideCollectionView(hideYesNo: true)
          continue
        }
        //avoid duplication here
        let key = stateSnap.key
        print("Product Key = \(key)")
        if flagFirstTime {
          //just add to data source. no need to check for avoiding duplication
          let productObj = ProductModel(categoryName: strongSelf.categoryName, auctionType: keyAuctionType, prodKey: key, productDict: prodDict)
          
          
          guard let userId = productObj.userId else {
            strongSelf.fidgetImageView.isHidden = true
            continue
          }
          
          if (!strongSelf.blockedUserIdArray.contains(userId)){
            
            var isVisible = true
            if let visibility = productObj.Visibility {
              if visibility == "hidden" { isVisible = false }
            }
            if isVisible {
              arrCurrentFetchedProducts.append(productObj)
            }
          }
        }else {
          // !flagFirstTime
          guard strongSelf.endAtChargeTimes.count > 0 else {
            print ("guard endAtChargeTimes.count >0 failed in \(strongSelf)")
            return
          }
          let thisStatesEndAt = strongSelf.endAtChargeTimes[auctionTypeAndState]
          
          let productModel = ProductModel(categoryName: strongSelf.categoryName, auctionType: keyAuctionType, prodKey: key, productDict: prodDict)
          
            
            guard let country = productModel.country else {
                print("Error node not found")
                return
            }
            print("country == \(country)")
            self?.country = country
            
          //to avoid duplication
          if productModel.chargeTime != thisStatesEndAt {
            let title = (productModel.title ?? "Not Available" )
            productModel.title = title
            //print("Going to append \(title)")
            guard let userId = productModel.userId else {
              strongSelf.fidgetImageView.isHidden = true
              continue
            }
            if (!strongSelf.blockedUserIdArray.contains(userId)){
              var isVisible = true
              if let visibility = productModel.Visibility {
                if visibility == "hidden" { isVisible = false }
              }
              if isVisible {
                arrCurrentFetchedProducts.append(productModel)
              }
              
            }
            
          
          
          }else {
            print("Detected Duplication")
          }
            
        
        }
        
        guard arrCurrentFetchedProducts.count > 0 else {
          //print("guard let arrCurrentFetchedProducts.count > 0 failed in \(this)")
          DispatchQueue.main.async {
            strongSelf.fidgetImageView.isHidden = true
          }
          continue
        }
        let firstsChargeTime = arrCurrentFetchedProducts[0].chargeTime
        
        //self.endAtChargeTimes[AuctionTypeAndState] = firstsChargeTime
        strongSelf.endAtChargeTimes[auctionTypeAndState] = firstsChargeTime
        
        arrCurrentFetchedProducts = arrCurrentFetchedProducts.reversed()
        for currentProd in arrCurrentFetchedProducts{
          if !strongSelf.prodArray.contains(currentProd) {
            strongSelf.prodArray.append(currentProd)
            
            if strongSelf.totalitemsToProcess == strongSelf.NumOfProductsProcessed {
              strongSelf.checkAndReload(strongSelf)
            }
          }
        }
      }
    })
  }
  
  func downloadAndSaveImages( completion: @escaping Completion ) {
    //var i = 0
    for x in prodArray {
        print("City = \(x.city)")
        print("State = \(x.state)")
        print("Country = \(x.country)")
        if x.country == "United States" {
            currency = "$"
        }else if x.country == "India" {
            currency = "₹"
        }
    }
    var processedItems = 0
    for product in self.prodArray {
      let photoIndex = self.prodArray.index(where: { (aProduct:ProductModel) -> Bool in
        return aProduct.productKey == product.productKey
      })
      if let urlStr = product.imageUrl0 , let url = URL.init(string: urlStr) {
        let downloader = SDWebImageDownloader(sessionConfiguration: URLSessionConfiguration.default)
        downloader.downloadImage(with: url, options: SDWebImageDownloaderOptions.allowInvalidSSLCertificates, progress: nil) { [weak self] (image_, data, error, success) in
          guard let strongSelf = self else { return }
          processedItems += 1
          if let image = image_ {
            
            var array = [UIImage]()
            let cellSpacing :CGFloat = 8
            let numOfColumns :CGFloat = 3
            let scaledWidth = (strongSelf.view.frame.width / numOfColumns) - ( cellSpacing * numOfColumns )
            //scaling because images have large heights. e.g 720 x 1024 etc
            let scaledImage = imageWithImage(sourceImage: image, scaledToWidth:scaledWidth )
            array.append(scaledImage)
            strongSelf.prodArray[photoIndex!].imagesArray = array
            
            
          }else {
            strongSelf.prodArray[photoIndex!].imagesArray?.insert(#imageLiteral(resourceName: "placeholder"), at: 0 )
            
          }
          if processedItems == strongSelf.prodArray.count {
            completion(true)
          }
          
        }
        
      }else {
        processedItems += 1
        self.prodArray[photoIndex!].imagesArray?.append(#imageLiteral(resourceName: "placeholder"))
      }
    }
  }

  //MARK:- IBActions and user interaction
  @objc func  bidNowBtnTapped(_ sender:UIButton){
    let indexPath = IndexPath.init(row: sender.tag, section: 0)
    colVProducts.delegate?.collectionView!(colVProducts, didSelectItemAt: indexPath)
  }
  
  func reloadColView() {
    let layout = self.colVProducts.collectionViewLayout as? PinterestLayout
    layout?.cache.removeAll()
    self.colVProducts.reloadData()
    layout?.prepare()
  }
}


//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CategoryDetailVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,
UICollectionViewDataSourcePrefetching
{
  func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    for indexpath in indexPaths {
      if let prodImageUrl = prodArray[indexpath.row].imageUrl0 {
        let downloader = SDWebImageDownloader.init()
        downloader.downloadImage(with: URL.init(string: prodImageUrl), options: .highPriority, progress: nil) { [weak self] (image, data, error, success) in
          if let image = image, let strongSelf = self {
            let cellSpacing :CGFloat = 8
            let numOfColumns :CGFloat = 3
            let scaledWidth = (strongSelf.view.frame.width / numOfColumns) - ( cellSpacing * numOfColumns )
            //scaling because images have large heights. e.g 720 x 1024 etc
            let scaledImage = imageWithImage(sourceImage: image, scaledToWidth:scaledWidth )
            let images = [scaledImage]
            strongSelf.prodArray[indexpath.row].imagesArray = images

          }
        }
      }


    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     if  isFiltering() {
        return filterprodArray.count
    }
    return prodArray.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELLSTRING, for: indexPath) as? AnnotatedPhotoCell else {
      print("\nError: Could not deque a cell. returning ")
      return CollectionViewCell()
    }
    
    if isFiltering() {
        let product = filterprodArray[indexPath.row]
        cell.categoryPriceLabel.text = product.title
        if let imageArray = product.imagesArray {
            cell.categoryImageView.image = imageArray[0]
        }else {
            var imageUrlToUse = String()
            var urlFound = false
            if let imageURL = product.imageUrl0 { imageUrlToUse = imageURL
                urlFound = true
            }
            if let imageURL = product.imageUrl1, !urlFound { imageUrlToUse = imageURL
                urlFound = true
            }
            if let imageURL = product.imageUrl2, !urlFound { imageUrlToUse = imageURL
                urlFound = true
            }
            if let imageURL = product.imageUrl3, !urlFound { imageUrlToUse = imageURL
                urlFound = true
            }
            if let imageURL = product.imageUrl4, !urlFound { imageUrlToUse = imageURL }
            
            cell.categoryImageView.sd_setImage(with: URL(string: imageUrlToUse), placeholderImage: #imageLiteral(resourceName: "emptyImage"))
        }
        cell.layer.cornerRadius = 3.0
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowOpacity = 0.6
        
        cell.categoryImageView.sd_setShowActivityIndicatorView(true)
        cell.categoryBidNowBtn.addTarget(self, action: #selector(bidNowBtnTapped), for: .touchUpInside)
        cell.categoryBidNowBtn.tag = indexPath.row
        cell.categoryContainerView.layer.cornerRadius = 8
        cell.categoryContainerView.clipsToBounds = true
        cell.categoryPriceLabel.text = product.title
        cell.categoryBidNowBtn.backgroundColor = UIColor(red:255/255, green:27/255, blue:34/255, alpha:0.8)
        
        if product.auctionType == "buy-it-now"{
            cell.categoryBidNowBtn.setTitle("Buy at \(product.currency_symbol ?? "$")\(product.startPrice!)", for: .normal)
            if let quantity =  product.quantity, quantity == 0 {
                cell.categoryBidNowBtn.setTitle("Sold \(product.currency_symbol ?? "$") \(product.startPrice ?? 0 )", for: .normal)
                cell.categoryBidNowBtn.backgroundColor =  UIColor(red:255/255, green:27/255, blue:34/255, alpha:0.8)
            }
            
           
            
        }
            
        else  {
            cell.categoryBidNowBtn.setTitle("Bid at \(product.currency_symbol ?? "$")\(product.startPrice ?? 0)", for: .normal)
            
        }
        if product.categoryName == "Jobs"{
            cell.categoryBidNowBtn.setTitle("Apply at \(product.currency_symbol ?? "$")\(product.startPrice ?? 0)", for: .normal)
        }
        if product.startPrice == 0 {
            cell.categoryBidNowBtn.setTitle("Free", for: .normal)
        }
        
        
        if let timeRemaining =  product.timeRemaining, timeRemaining < 0 && product.endTime! > 0 {
            cell.categoryBidNowBtn.backgroundColor = UIColor(red:184/255, green:184/255, blue:184/255, alpha:1)
        }
        else if product.timeRemaining == nil {
            //no time remaining node is present
            //get current server time and compare with end time. and grey out the button if current time >= end time
            getCurrentServerTime { (success, currentTime) in
                if success {
                    let currentTimeInt64 = Int64(currentTime)
                    if let endTime = product.endTime {
                        if currentTimeInt64 >= endTime { cell.categoryBidNowBtn.backgroundColor = UIColor(red:184/255, green:184/255, blue:184/255, alpha:1) }
                    }
                }
            }
        }
        
        return cell
    
        
    }else {
        let product = prodArray[indexPath.row]
        cell.categoryPriceLabel.text = product.title
        if let imageArray = product.imagesArray {
            cell.categoryImageView.image = imageArray[0]
        }else {
            var imageUrlToUse = String()
            var urlFound = false
            if let imageURL = product.imageUrl0 { imageUrlToUse = imageURL
                urlFound = true
            }
            if let imageURL = product.imageUrl1, !urlFound { imageUrlToUse = imageURL
                urlFound = true
            }
            if let imageURL = product.imageUrl2, !urlFound { imageUrlToUse = imageURL
                urlFound = true
            }
            if let imageURL = product.imageUrl3, !urlFound { imageUrlToUse = imageURL
                urlFound = true
            }
            if let imageURL = product.imageUrl4, !urlFound { imageUrlToUse = imageURL }
            
            cell.categoryImageView.sd_setImage(with: URL(string: imageUrlToUse), placeholderImage: #imageLiteral(resourceName: "emptyImage"))
        }
        
        cell.layer.cornerRadius = 3.0
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowOpacity = 0.6
        
        cell.categoryImageView.sd_setShowActivityIndicatorView(true)
        cell.categoryBidNowBtn.addTarget(self, action: #selector(bidNowBtnTapped), for: .touchUpInside)
        cell.categoryBidNowBtn.tag = indexPath.row
        cell.categoryContainerView.layer.cornerRadius = 8
        cell.categoryContainerView.clipsToBounds = true
        cell.categoryPriceLabel.text = product.title
        cell.categoryBidNowBtn.backgroundColor =  UIColor(red:0.85, green:0.11, blue:0.13, alpha:1.0)
        
        if product.auctionType == "buy-it-now"{
            cell.categoryBidNowBtn.setTitle("Buy at \(product.currency_symbol ?? "$")\(product.startPrice ?? 0 )", for: .normal)
            if let quantity =  product.quantity, quantity == 0 {
                cell.categoryBidNowBtn.setTitle("Sold \(product.currency_symbol ?? "$") \(product.startPrice ?? 0 )", for: .normal)
                cell.categoryBidNowBtn.backgroundColor = UIColor(red:184/255, green:184/255, blue:184/255, alpha:1)
            }
            
        }
            
        else  {
            cell.categoryBidNowBtn.setTitle("Bid at \(product.currency_symbol ?? "$")\(product.startPrice ?? 0 )", for: .normal)
            
        }
        if product.categoryName == "Jobs"{
            cell.categoryBidNowBtn.setTitle("Apply at \(product.currency_symbol ?? "$")\(product.startPrice ?? 0 )", for: .normal)
        }
        if product.startPrice == 0 {
            cell.categoryBidNowBtn.setTitle("Free", for: .normal)
        }
        
        
        if let timeRemaining =  product.timeRemaining, timeRemaining < 0 && product.endTime! > 0 {
            cell.categoryBidNowBtn.backgroundColor = UIColor(red:184/255, green:184/255, blue:184/255, alpha:1)
        }
        else if product.timeRemaining == nil {
            //no time remaining node is present
            //get current server time and compare with end time. and grey out the button if current time >= end time
            getCurrentServerTime { (success, currentTime) in
                if success {
                    let currentTimeInt64 = Int64(currentTime)
                    if let endTime = product.endTime {
                        if currentTimeInt64 >= endTime { cell.categoryBidNowBtn.backgroundColor = UIColor(red:184/255, green:184/255, blue:184/255, alpha:1) }
                    }
                }
            }
        }
        
           return cell
    }

    }
    
    
 
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let selectedProduct = prodArray[indexPath.row]
    let sbName = storyBoardNames.prodDetails
    let sbProdDetails = getStoryBoardByName(sbName)
    let controller = sbProdDetails.instantiateViewController(withIdentifier: "ProductDetailVc") as! ProductDetailVc
    controller.productDetail = selectedProduct
    navigationController?.pushViewController(controller, animated: true)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / numOfColumns
    return CGSize(width: itemSize, height: itemSize)
  }
  
  
}

//MARK: - PINTEREST LAYOUT DELEGATE
extension CategoryDetailVC : PinterestLayoutDelegate {
  
  // 1. Returns the photo height
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
    
//    guard let products = prodArray else {
//      return 250
//    }
    guard let array = prodArray[indexPath.item].imagesArray, array.count > 0 else {
      return 250
    }
    let photo = array[0]
    if photo.size.height == 0 {
      return 250
    }
    
    let height = photo.size.height
    //if height > 400 && height <= 600  { height = height * 0.5 }
    let lblNameHeight: CGFloat = 30
    
    let btnHeight : CGFloat = 40
    let numberOfColumns = 3
    let insets = collectionView.contentInset
    let contentWidth = collectionView.bounds.width - (insets.left + insets.right)
    let columnWidth = contentWidth / CGFloat(numberOfColumns)
    let font = UIFont.boldSystemFont(ofSize: 17)
    
    if let title = prodArray[indexPath.row].title  {
      
      
      let estimatedHeight = title.height(withConstrainedWidth: columnWidth, font: font) + 5
      print("estimate height for title : \(title) : \(estimatedHeight)")
      return height + estimatedHeight + btnHeight
      
    }
    
    
    return height + lblNameHeight + btnHeight
    
  }
  
}

//MARK:- UIScrollViewDelegate
extension CategoryDetailVC : UIScrollViewDelegate {
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if scrollView == colVProducts {
      let currentOffset = scrollView.contentOffset.y
      let maxOffset = scrollView.contentSize.height  - scrollView.frame.size.height
      
      if maxOffset - currentOffset <= 50 {
        //getDataOfJobs()
        fetchAndDislayDataOptimized(flagFirstTime: true)
      }
    }
    
  }
}

