//
//  WatchingListVc.swift
//  Sell4Bids
//
//  Created by admin on 10/18/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import XLPagerTabStrip
class ActiveWatchListVc: UIViewController , IndicatorInfoProvider{
  
  
  
  //MARK: - Properties
  @IBOutlet weak var collView: UICollectionView!
  @IBOutlet weak var fidgetImageView: UIImageView!
  @IBOutlet weak var emptyMessage: UILabel!
  
  //MARK: - variables
  private let leftAndRightPaddings: CGFloat = 32.0
  private let numberOfItemsPerRow: CGFloat = 2.0
  private let heightAdjustment: CGFloat = 30.0
  
    @IBOutlet weak var errorimg: UIImageView!
    var nav:UINavigationController?
  var watchListArray = [ProductModel]()
  var dbRef: DatabaseReference!
  var serverTime:NSNumber = 0
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    //  dbRef = Database.database().reference()
    fidgetImageView.toggleRotateAndDisplayGif()
    
    DispatchQueue.main.async {
        self.getAndDisplayActiveWatchList()
    }
    
    
    
    cutomizeCollectionView()
    
    navigationItem.title = "My Watch List"
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = UIColor.white
    let barItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(backBtnTap))
    navigationItem.leftBarButtonItem = barItem
    
    //settingServentCurrentTime()
    //  serverCurrentTime()
  }
  
  @objc func backBtnTap(){
    dismiss(animated: true, completion: nil)
    
  }
  override func viewDidAppear(_ animated: Bool) {
   
   
    }
  
  func cutomizeCollectionView(){
    //custom collectionView Cell size
    
    let bounds = UIScreen.main.bounds
    let width = (bounds.size.width - leftAndRightPaddings) / numberOfItemsPerRow
    let layout = collView.collectionViewLayout as! UICollectionViewFlowLayout
    //layout.itemSize = CGSize(width, width + heightAdjustment)
    layout.itemSize = CGSize(width: width, height: width + heightAdjustment)
  }
  
  func hideCollectionView(hideYesNo : Bool) {
    
    emptyMessage.text = "Active Watch List is Empty"
    if hideYesNo == false {
      collView.isHidden = false
      
      fidgetImageView.isHidden = false
      emptyMessage.isHidden = true
        errorimg.isHidden = true
    }
    else  {
      fidgetImageView.isHidden = true
        fidgetImageView.image = nil
      collView.isHidden = true
      
      emptyMessage.isHidden = false
        errorimg.isHidden = false
    }
  }
  
  func settingServentCurrentTime(){
    dbRef.child("times").child("startTime").setValue(ServerValue.timestamp())
  }
  
  func getAndDisplayActiveWatchList(){
    dbRef = FirebaseDB.shared.dbRef
    guard let userId = Auth.auth().currentUser?.uid else {return}
    fidgetImageView.isHidden = false
    dbRef.child("users").child(userId).observeSingleEvent(of: .value) { [weak self] (dataSnapShot) in
      
      guard let this = self else { return }
      this.watchListArray.removeAll()
      guard let userDict = dataSnapShot.value as? NSDictionary else {
        print("ERROR: while geting dataSnapshot")
        return
      }
      guard let products = userDict.value(forKey: "products")else  {
        this.hideCollectionView(hideYesNo: true)
        print("ERROR: while getting users/Products")
        return
      }
      //self.hideCollectionView(hideYesNo: false)
      guard let productsDict  = products as? NSDictionary else {
        print("ERROR: while geting User Products lis")
        return
      }
      guard let watching = productsDict.value(forKey: "watching") as? NSDictionary else {
        this.hideCollectionView(hideYesNo: true)
        print("ERROR: while geting watching keys")
        return
      }
      for (productkey,watchList) in watching {
        guard let watchDict = watchList as? [String:AnyObject] else {
          print("ERROR: while geting watch DICT")
          continue
        }
        guard let categoryName = watchDict["category"] as? String,
        let auctionType = watchDict["auction"] as? String,
        let state = watchDict["state"] as? String else { continue }
        this.dbRef.child("products").child(categoryName).child(auctionType).child(state).child(productkey as! String).observeSingleEvent(of: .value, with: { [weak self] (productsnapshot) in
          guard let this = self else { return }
          guard let productDict = productsnapshot .value as? [String:AnyObject] else {
            print("ERROR: while geting product Dict")
            return
          }
          let product = ProductModel(categoryName: categoryName, auctionType: auctionType, prodKey: productkey as! String, productDict: productDict)
          guard let endTime = product.endTime else {return}
          let currentTime = Date().millisecondsSince1970
          if  endTime > currentTime || endTime == -1 {
            this.watchListArray.append(product)
          }
          DispatchQueue.main.async {
            this.fidgetImageView.isHidden = true
            this.fidgetImageView.image = nil
            this.collView.reloadData()
            
          }
        })
      }
    }
  }
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo.init(title: "Watch List")
  }
  

}

extension ActiveWatchListVc: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return watchListArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WatchListStartCell
    
    cell.layer.cornerRadius = 3.0
    cell.layer.masksToBounds = false
    cell.layer.shadowColor = UIColor.black.cgColor
    cell.layer.shadowOffset = CGSize(width: 0, height: 0)
    cell.layer.shadowOpacity = 0.6
    
    let baseView = cell.ViewSell
    baseView!.layer.cornerRadius = 8
    baseView!.clipsToBounds = true
    baseView!.addShadowView()
    
   
    cell.ImageItem.addShadowView()
    let product = watchListArray[indexPath.row]
   
   
    if let imageUrl = product.imageUrl0 {
      cell.ImageItem.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "emptyImage"))
    }
    cell.ImageTitle.text = product.title
    cell.ImageTitle.font.withSize(18)
 
    return cell
    
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    
        let selectedProduct = self.watchListArray[indexPath.row]
        let prodDetailsSB = getStoryBoardByName(storyBoardNames.prodDetails)
        let controller = prodDetailsSB.instantiateViewController(withIdentifier: "ProductDetailVc") as! ProductDetailVc
        controller.productDetail = selectedProduct
        
        self.nav?.pushViewController(controller, animated: true)
 
    
    
    
    //self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 33, width: 50, height: 40)
  }
  
  
}

