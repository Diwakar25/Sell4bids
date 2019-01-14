//
//  BoughtAndWinsVc.swift
//  Sell4Bids
//
//  Created by admin on 10/10/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import XLPagerTabStrip

class BoughtAndWinsVc: UIViewController, IndicatorInfoProvider {
  
  
  //MARK: - Properties
  
  @IBOutlet weak var collView: UICollectionView!
  @IBOutlet weak var emptyProductMessage: UILabel!
  @IBOutlet weak var imgeView: UIImageView!
  
  @IBOutlet weak var fidgetImageView: UIImageView!
  
  //MARK: - Variables
  private let leftAndRightPaddings: CGFloat = 32.0
  private var numberOfItemsPerRow: CGFloat  {
    if UIDevice.current.userInterfaceIdiom == .phone { return 2 }
    else { return 3 }
  }
  private let heightAdjustment: CGFloat = 30.0
  var nav:UINavigationController?
  var boughtProductsArray = [ProductModel]()
  var dbRef: DatabaseReference!
  var databaseHandle:DatabaseHandle?
  var blockedUserIdArray = [String]()
  var currency = String()
  var country = String()
  //MARK:- Functions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
   
    dbRef = FirebaseDB.shared.dbRef
    fidgetImageView.toggleRotateAndDisplayGif()
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = UIColor.white
    //custom collectionView Cell size
    
    let bounds = UIScreen.main.bounds
    let width = (bounds.size.width - leftAndRightPaddings) / numberOfItemsPerRow
    let layout = collView.collectionViewLayout as! UICollectionViewFlowLayout
    //layout.itemSize = CGSize(width, width + heightAdjustment)
    layout.itemSize = CGSize(width: width, height: width + heightAdjustment)
    
    getUserBlockedList{(complete) in
      self.getUserBuyingData()
    }
    
  }
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    
  }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        fidgetImageView.isHidden = true
        fidgetImageView.image = nil
        print("Disappear")
        
    }
  
  func hideCollectionView(hideYesNo : Bool) {
    
    emptyProductMessage.text = "Items you buy or win after bidding, appear here"
    print("HIde Yes No = \(hideYesNo)")
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
  
  
  func getUserBlockedList(completion : @escaping (Bool) -> ()) {
    
    guard let userId = Auth.auth().currentUser?.uid else {return}
    dbRef.child("users").child(userId).observeSingleEvent(of: .value) { (userSnapshot) in
      guard let dictObj = userSnapshot.value as? NSDictionary else{return}
      guard let blockedPerson = dictObj.value(forKeyPath: "blockedPersons") as? NSDictionary else {return}
      for value in blockedPerson {
        guard let blockedPerson = value.key as? String else {
          print("ERROR: while getting user Blocked user Id's ")
          return
        }
        self.blockedUserIdArray.append(blockedPerson)
      }
    }
    completion(true)
  }
  
  func getUserBuyingData(){
  fidgetImageView.isHidden = false
    
    guard let userId = Auth.auth().currentUser?.uid else {
      self.hideCollectionView(hideYesNo: true)
      print("ERROR : user id is nil in MySellVC")
      fatalError()
    }
    boughtProductsArray.removeAll()
   
    dbRef.child("users").child(userId).child("products").child("bought").observeSingleEvent(of: .value) { (productsSnapshot) in
      guard let userProducts = productsSnapshot.value as? [String:AnyObject] else {
        self.fidgetImageView.isHidden = true
        self.fidgetImageView.image = nil
        self.hideCollectionView(hideYesNo: true)
        return
      }
      
      guard let buyingProduct = productsSnapshot.value as? [String:AnyObject] else {
        self.fidgetImageView.isHidden = true
        self.fidgetImageView.image = nil
        self.hideCollectionView(hideYesNo: true)
        
        print("ERROR : while getting user selling data")
        return
      }
      for productKey in buyingProduct.keys.sorted() {
        
        guard let prodDict =  buyingProduct[productKey] as? [String:AnyObject] else {
          print("ERROR : while getting user selling data")
          return
        }
        if let stateName = prodDict["state"] as? String {
          if let categoryName = prodDict["category"] as? String {
            if let auctionType = prodDict["auctionType"]   as? String {
              self.dbRef.child("products").child(categoryName ).child(auctionType).child(stateName).child(productKey).observeSingleEvent(of: .value, with: { (productSnapshot) in
                if productSnapshot.childrenCount > 0 {
                  guard let productDict = productSnapshot.value as? [String:AnyObject] else {
                    print("ERROR: while fetchinh products Dicts")
                    return
                  }
                  let product = ProductModel(categoryName: categoryName , auctionType: auctionType, prodKey: productKey, productDict: productDict)
                  if product.categoryName != nil && product.auctionType != nil && product.state != nil{
                    guard let userId = product.userId else {return}
                    if (!self.blockedUserIdArray.contains(userId)){
                      self.boughtProductsArray.append(product)
                    }
                    
               
                    
                  }
                  DispatchQueue.main.async {
                    self.hideCollectionView(hideYesNo: false)
                    self.fidgetImageView.isHidden = true
                    self.fidgetImageView.image = nil
                    self.collView.reloadData()
                    
                  }
                }
              })
            }else {
              self.hideCollectionView(hideYesNo: true)
            }
          }else {
            self.hideCollectionView(hideYesNo: true)
          }
        }else {
          self.hideCollectionView(hideYesNo: true)
        }
      }
    }
    
  }
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo.init(title: "Bought & Wins")
  }
  
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension BoughtAndWinsVc: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return boughtProductsArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
    cell.sellImagevView.addShadowAndRound()
    cell.layer.cornerRadius = 3.0
    cell.layer.masksToBounds = false
    cell.layer.shadowColor = UIColor.black.cgColor
    cell.layer.shadowOffset = CGSize(width: 0, height: 0)
    cell.layer.shadowOpacity = 0.6
    
    let baseView = cell.viewShadow!
    baseView.layer.cornerRadius = 8
    baseView.clipsToBounds = true
    
    
    guard indexPath.row > -1 else {
        print("guard indexPath.row > -1 failed in \(self)")
        return UICollectionViewCell()
    }
    let product = boughtProductsArray[indexPath.row]
    
    if let imageUrl = product.imageUrl0 {
      cell.sellImagevView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "emptyImage"))
    }
    DispatchQueue.main.async {
      var strQuantity = " "
      if let quantity = product.quantity {
        if quantity != -1 {
          strQuantity.append(" x \(quantity)")
        }
      }
      
      cell.titleCellLabel.text = product.title
      if let price = product.startPrice {
        cell.lblPriceProduct.text = "\(product.currency_symbol ?? "$")\(price)\(strQuantity)"
      }
      
    }
    
    return cell
    
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let selectedProduct = boughtProductsArray[indexPath.row]
    let prodDetailsSB = getStoryBoardByName(storyBoardNames.prodDetails)
    let controller = prodDetailsSB.instantiateViewController(withIdentifier: "ProductDetailVc") as! ProductDetailVc
    controller.productDetail = selectedProduct
    nav?.pushViewController(controller, animated: false)
    self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 33, width: 50, height: 40)
  }
  
  
}





