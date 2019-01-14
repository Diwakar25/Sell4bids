//
//  UserBidsVc.swift
//  Sell4Bids
//
//  Created by admin on 10/10/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import XLPagerTabStrip

class BuyingAndBidsVC: UIViewController , IndicatorInfoProvider{
  //Mark: - Properties
  
  @IBOutlet weak var collView: UICollectionView!
  @IBOutlet weak var fidgetImageView: UIImageView!
  @IBOutlet weak var emptyProductMessage: UILabel!
  @IBOutlet weak var imgeView: UIImageView!
  
  //Mark: - Variables
  var nav:UINavigationController?
  var buyingProductsArray = [ProductModel]()
  var dbRef: DatabaseReference!
  var databaseHandle:DatabaseHandle?
 
  private let leftAndRightPaddings: CGFloat = 6.0
  private var numberOfItemsPerRow: CGFloat = 2
  private let heightAdjustment: CGFloat = 30.0
  var blockedUserIdArray = [String]()
  
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
   
    
    
    if UIDevice.current.userInterfaceIdiom == .pad { numberOfItemsPerRow = 3 }
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = UIColor.white
    
    dbRef = FirebaseDB.shared.dbRef
    
    //passing data to of Selling Products to SellingViewController
    //custom collectionView Cell size
    
    let bounds = UIScreen.main.bounds
    let width = (bounds.size.width  / numberOfItemsPerRow) - (leftAndRightPaddings * 2) 
    let layout = collView.collectionViewLayout as! UICollectionViewFlowLayout
    //layout.itemSize = CGSize(width, width + heightAdjustment)
    layout.itemSize = CGSize(width: width, height: width + heightAdjustment)
    emptyProductMessage.text = "Items you are currently in the process of buying and have bid on, appear here"
    getAndSaveBlockedUserIDs{ (complete) in
      self.getUserBuyingData()
    }
   //  self.getUserBuyingData()
    
  }
  override func viewWillAppear(_ animated: Bool) {
    
  }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        fidgetImageView.isHidden = true
        fidgetImageView.image = nil
        print("Disappear")
        
    }
  
  
  override func viewDidDisappear(_ animated: Bool) {
    
    //buyingProductsArray.removeAll()
    //blockedUserIdArray.removeAll()
    
  }
  
  func hideCollectionView(hideYesNo : Bool) {
    
    
    if hideYesNo == false {
      collView.isHidden = false
      imgeView.isHidden = true
      fidgetImageView.isHidden = false
        fidgetImageView.image = nil
      emptyProductMessage.isHidden = true
    }
    else  {
      fidgetImageView.isHidden = true
        fidgetImageView.image = nil
        
      collView.isHidden = true
      imgeView.isHidden = false
      emptyProductMessage.isHidden = false
    }
  }
  
  func getAndSaveBlockedUserIDs(completion : @escaping (Bool) -> ()) {
    
    buyingProductsArray.removeAll()
    guard let userId = Auth.auth().currentUser?.uid else { return }
    dbRef.child("users").child(userId).observeSingleEvent(of: .value) { (userSnapshot) in
      
      guard let dictObj = userSnapshot.value as? NSDictionary ,
      let blockedPerson = dictObj.value(forKeyPath: "blockedPersons") as? NSDictionary else {
        completion(false)
        return
        
      }
      for value in blockedPerson {
        guard let blockedPerson = value.key as? String else {
          print("ERROR: while getting user Blocked Id ")
          return
        }
        self.blockedUserIdArray.append(blockedPerson)
      }
      completion(true)
    }
    
  }
  
  func getUserBuyingData(){
     fidgetImageView.isHidden = false
    
    guard let userId = Auth.auth().currentUser?.uid else {
      self.hideCollectionView(hideYesNo: true)
      print("ERROR : user id is nil in MySellVC")
      showToast(message: "User id is nil")
      return
    }
    
    print("user id \(userId)")
    var flagDownloadCompleted = false
    Timer.scheduledTimer(withTimeInterval: TimeInterval(Constants.fidgetSpinAfterSeconds), repeats: false) { (timer) in
      if !flagDownloadCompleted { self.fidgetImageView.toggleRotateAndDisplayGif() }
      
    }
    dbRef.child("users").child(userId).child("products").child("buying").observeSingleEvent(of: .value) { (productsSnapshot) in
      flagDownloadCompleted = true
      DispatchQueue.main.async {
        self.fidgetImageView.isHidden = true
        self.fidgetImageView.image = nil
      }
      guard let buyingProduct = productsSnapshot.value as? [String:AnyObject] else {
        
        self.hideCollectionView(hideYesNo: true)
        
        
        self.hideCollectionView(hideYesNo: true)
        
        return
        
      }
      for productkey in buyingProduct.keys.sorted() {
        
        guard let prodDict =  buyingProduct[productkey] as? [String:AnyObject] else {
          print("ERROR : while getting user selling data")
          continue
        }
        guard let categoryName = prodDict["category"] as? String else {
          print("ERROR: while geting CategoryName")
          continue
        }
        guard let auctionType = prodDict["auctionType"] as? String  else {
          print("ERROR: while geting auctionType")
          continue
        }
        guard let stateName = prodDict["state"] as? String  else {
          print("ERROR: while geting stateName")
          continue
        }
        
       self.dbRef.child("products").child(categoryName ).child(auctionType).child(stateName ).child(productkey).observeSingleEvent(of: .value, with: { [weak self] (productSnapshot) in
          guard let this = self else { return }
          if productSnapshot.childrenCount > 0 {
            guard let productDict = productSnapshot.value as? [String:AnyObject] else {
              print("ERROR: while fetchinh products Dicts")
              return
            }
            let product = ProductModel(categoryName: categoryName, auctionType: auctionType, prodKey: productkey, productDict: productDict)
            if product.categoryName != nil && product.auctionType != nil && product.state != nil{
              guard let userId = product.userId else {return}
              if (!this.blockedUserIdArray.contains(userId)){
                this.buyingProductsArray.append(product)
              }
            }
            DispatchQueue.main.async {
              this.hideCollectionView(hideYesNo: false)
              this.fidgetImageView.isHidden = true
                this.fidgetImageView.image = nil
              this.collView.reloadData()
            }
          }else if this.buyingProductsArray.count <= 0 {
            DispatchQueue.main.async {
              self?.emptyProductMessage.show()
              self?.imgeView.show()
            }
          }
        })
        
      }
    }
    
  }
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo.init(title: "Buying & Bids")
  }
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension BuyingAndBidsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return buyingProductsArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ColVCellBuyingAndBids else {
      print("\nError: Could not deque a cell in \(self). Going to return")
      return UICollectionViewCell()
    }
    guard indexPath.row < buyingProductsArray.count else {
      print("guard indexPath.row > buyingProductsArray.count failed in \(self)")
      return cell
    }
    let product = buyingProductsArray[indexPath.row]
    //adding shadows and rounding
    cell.imgVProduct.addShadowAndRound()
    cell.layer.cornerRadius = 3.0
    cell.layer.masksToBounds = false
    cell.layer.shadowColor = UIColor.black.cgColor
    cell.layer.shadowOffset = CGSize(width: 0, height: 0)
    cell.layer.shadowOpacity = 0.6
    
    let baseView = cell.viewContainer!
    baseView.layer.cornerRadius = 8
    baseView.clipsToBounds = true
    
    
    //setting title
    DispatchQueue.main.async {
      var strQuantity = " "
      if let quantity = product.quantity {
        if quantity != -1 {
          strQuantity.append(" x \(quantity)")
        }
      }
      
      cell.lblTitleProduct.text = product.title
      if let price = product.startPrice {
        cell.lblPriceProduct.text = "\(product.currency_symbol ?? "$")\(price)\(strQuantity)"
      }
      
    }
    
    if let imageUrl = product.imageUrl0 {
      cell.imgVProduct.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "emptyImage"))
    }
    
    
    return cell
    
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard buyingProductsArray.count > 0 else {
      return
    }
    let selectedProduct = buyingProductsArray[indexPath.row]
    
    let prodDetailsSB = getStoryBoardByName(storyBoardNames.prodDetails)
    let controller = prodDetailsSB.instantiateViewController(withIdentifier: "ProductDetailVc") as! ProductDetailVc
    controller.productDetail = selectedProduct
    
    nav?.pushViewController(controller, animated: false)
//    self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 33, width: 50, height: 40)
  }
  
  
}




