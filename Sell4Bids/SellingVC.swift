//
// MySellVc.swift
//  Sell4Bids
//
//  Created by admin on 10/9/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import XLPagerTabStrip

class SellingVC: UIViewController , IndicatorInfoProvider   {
  
  //MARK: - Properties
  
  @IBOutlet weak var collView: UICollectionView!
  @IBOutlet weak var fidgetImageView: UIImageView!
  @IBOutlet weak var imgVNoProduct: UIImageView!
  @IBOutlet weak var emptyProductMessage: UILabel!
  var countryCode = String()
  var numberOfColumns : CGFloat = {
    if UIDevice.current.userInterfaceIdiom == .pad { return 3 }
    else { return 2}
  }()
  
  //MARK: - variables
    var mySellArray : [ProductModel] = []
  var dbRef: DatabaseReference!
  private let leftAndRightPaddings: CGFloat = 6.0
  private let numberOfItemsPerRow: CGFloat = 2.0
  private let heightAdjustment: CGFloat = 30.0
  var nav:UINavigationController?
  
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fidgetImageView.isHidden = true
        fidgetImageView.image = nil
        print("Disappear")
        
    }
  override func viewDidLoad() {
    super.viewDidLoad()
    //passing data to of Selling Products to SellingViewController
    fidgetImageView.toggleRotateAndDisplayGif()
    DispatchQueue.main.async {
      self.fidgetImageView.isHidden = true
        self.fidgetImageView.image = nil
        
    }
    customizeCollectionView()
    getUserSellingData()
  }
   
    
  private func setupLeftBarBtns() {
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = UIColor.white
    
  }
  
  
  
  func hideCollectionView(hideYesNo : Bool) {
    
    emptyProductMessage.text = "Items you list for sale, appear here."
    if hideYesNo == false {
      collView.isHidden = false
      imgVNoProduct.isHidden = true
      fidgetImageView.isHidden = false
        fidgetImageView.image = nil
      emptyProductMessage.isHidden = true
    }
    else  {
      fidgetImageView.isHidden = true
        fidgetImageView.image = nil
      collView.isHidden = true
      imgVNoProduct.isHidden = false
      emptyProductMessage.isHidden = false
    }
  }
  
  func customizeCollectionView(){
    //custom collectionView Cell size
    
    let bounds = UIScreen.main.bounds
    
    var width = (bounds.size.width / numberOfColumns ) - (leftAndRightPaddings * 2)
    let layout = collView.collectionViewLayout as! UICollectionViewFlowLayout
    //layout.itemSize = CGSize(width, width + heightAdjustment)
    if UIDevice.current.userInterfaceIdiom == .phone { width = width - 1 }
    layout.itemSize = CGSize(width: width, height: width + heightAdjustment)
  }
  
  func getUserSellingData(){
    
    guard let userId = Auth.auth().currentUser?.uid else {
      self.hideCollectionView(hideYesNo: true)
      print("ERROR : user id is nil in MySellVC")
      fatalError()
    }
    dbRef = FirebaseDB.shared.dbRef.child("users").child(userId).child("products")
    dbRef.child("selling").observeSingleEvent(of: .value) { [weak self] (productsSnapshot) in
      guard let this = self else { return }
        this.mySellArray.removeAll()
      let hasChilds = productsSnapshot.hasChildren()
    
      this.collView.isHidden = !hasChilds
      this.emptyProductMessage.isHidden = hasChilds
      this.imgVNoProduct.isHidden = hasChilds
    
      
      guard let dictSellingProducts = productsSnapshot.value as? [String:AnyObject] else {
        this.hideCollectionView(hideYesNo: true)
        this.fidgetImageView.isHidden = true
        this.fidgetImageView.image = nil
        
        
        return
      }
      
      var i = 0
      for productkey in dictSellingProducts.keys.sorted() {
        
        guard let prodDict = dictSellingProducts[productkey] as? [String: AnyObject] else {
          print("ERROR : while getting user selling data")
          i += 1
          continue
        }
        guard let categoryName = prodDict["category"] as? String, categoryName.count > 0 else {
          print("ERROR: while geting CategoryName")
          i += 1
          continue
        }
        guard let auctionType = prodDict["auctionType"] as? String, auctionType.count > 0   else {
          print("ERROR: while geting auctionType")
          i += 1
          continue
        }
        guard let stateName = prodDict["state"] as? String , stateName.count > 0  else {
          print("ERROR: while geting stateName")
          i += 1
          continue
        }
        
 
       
        
      this.dbRef = FirebaseDB.shared.dbRef.child("products").child(categoryName).child(auctionType)
      let ref = this.dbRef.child(stateName ).child(productkey)
        print("Final ref : \(ref)")
      ref.observeSingleEvent(of: .value, with: { [weak self] (productSnapshot_) in
        //print(productSnapshot_)
          guard let this = self else { return }
          i += 1
          if productSnapshot_.childrenCount > 0  {
            if let productDict = productSnapshot_.value as? [String:AnyObject]  {
              //print(productDict["title"] as Any)
              let product = ProductModel(categoryName: categoryName, auctionType: auctionType, prodKey: productkey, productDict: productDict)
              
              
              if product.categoryName != nil && product.auctionType != nil && product.state != nil{
                this.mySellArray.append(product)
                
              }
              
              
              
            }else {
              print("ERROR: while fetchinh products Dicts")
            }
            
           
          }else {
            //print("productSnapshot.childrenCount > 0 failed")
          }
        
        
          DispatchQueue.main.async {
            this.hideCollectionView(hideYesNo: this.mySellArray.count > 0 ? false : true)
            this.fidgetImageView.isHidden = true
            this.fidgetImageView.image = nil
            
            this.collView.reloadData()
            
          }
        
        
      })
        
      }
    }
    
  }
  

  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    
    return IndicatorInfo.init(title: "Selling")
  }
    
  
  
}





//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension SellingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return mySellArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
    
    cell.layer.cornerRadius = 3.0
    cell.layer.masksToBounds = false
    cell.layer.shadowColor = UIColor.black.cgColor
    cell.layer.shadowOffset = CGSize(width: 0, height: 0)
    cell.layer.shadowOpacity = 0.6
    cell.sellImagevView.addShadowAndRound()
    let baseView = cell.viewShadow!
    baseView.layer.cornerRadius = 8
    baseView.clipsToBounds = true
    
    
    guard indexPath.row < mySellArray.count else {
      return cell
    }
    let product = mySellArray[indexPath.row]
    
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
    guard indexPath.row < mySellArray.count else { return }
    
    let selectedProduct = mySellArray[indexPath.row]
    let prodDetailsSB = getStoryBoardByName(storyBoardNames.prodDetails)
    let controller = prodDetailsSB.instantiateViewController(withIdentifier: "ProductDetailVc") as! ProductDetailVc
    controller.productDetail = selectedProduct
    //self.navigationController?.pushViewController(controller, animated: true)
    
    nav?.pushViewController(controller, animated: false)
//    self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 33, width: 50, height: 40)
  }
  
}



