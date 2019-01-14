//
//  EndedWatchList.swift
//  Sell4Bids
//
//  Created by admin on 11/7/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import XLPagerTabStrip

class EndedWatchListVc: UIViewController, IndicatorInfoProvider {

    @IBOutlet weak var viewSell: UIView!
    //MARK:- Properties
    @IBOutlet weak var fidgetImageView: UIImageView!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var emptyMessage: UILabel!
    
    //MARK: - Variables
    private let leftAndRightPaddings: CGFloat = 32.0
    private let numberOfItemsPerRow: CGFloat = 2.0
    private let heightAdjustment: CGFloat = 30.0
    
    @IBOutlet weak var errorimg: UIImageView!
    var nav:UINavigationController?
    var endedListArray = [ProductModel]()
    var dbRef: DatabaseReference!
    var serverTime:NSNumber = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        fidgetImageView.toggleRotateAndDisplayGif()
        // Do any additional setup after loading the view.
      
      
       cutomizeCollectionView()
        
        navigationItem.title = "My Watch List"
      // myWatchListData()
      myEndedListData()
      
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
        
        emptyMessage.text = "Ended Watch List is Empty"
        if hideYesNo == false {
            collView.isHidden = false
            
            fidgetImageView.isHidden = false
            emptyMessage.isHidden = true
            errorimg.isHidden = true
        }
        else  {
            fidgetImageView.isHidden = true
            collView.isHidden = true
            
            emptyMessage.isHidden = false
            errorimg.isHidden = false
        }
    }
  
  
  func myEndedListData(){
    dbRef = Database.database().reference()
    guard let userId = Auth.auth().currentUser?.uid else {return}
    fidgetImageView.isHidden = false
    dbRef.child("users").child(userId).observeSingleEvent(of: .value) { (dataSnapShot) in
      
      self.endedListArray.removeAll()
      guard let userDict = dataSnapShot.value as? NSDictionary else {
        print("ERROR: while geting dataSnapshot")
        return
      }
      guard let products = userDict.value(forKey: "products")else  {
        self.hideCollectionView(hideYesNo: true)
        print("ERROR: while getting users/Products")
        return
      }
      //self.hideCollectionView(hideYesNo: false)
      guard let productsDict  = products as? NSDictionary else {
        print("ERROR: while geting User Products lis")
        return
      }
      guard let watching = productsDict.value(forKey: "watching") as? NSDictionary else {
        self.hideCollectionView(hideYesNo: true)
        print("ERROR: while geting watching keys")
        return
      }
      for (productkey,watchList) in watching {
        guard let watchDict = watchList as? [String:AnyObject] else {
          print("ERROR: while geting watch DICT")
          return
        }
        guard let categoryName = watchDict["category"] as? String else{return}
        guard let auctionType = watchDict["auction"] as? String else{return}
        guard let state = watchDict["state"] as? String else {return}
        self.dbRef.child("products").child(categoryName).child(auctionType).child(state).child(productkey as! String).observeSingleEvent(of: .value, with: { (productsnapshot) in
          guard let productDict = productsnapshot .value as? [String:AnyObject] else {
            print("ERROR: while geting product Dict")
            return
          }
          let product = ProductModel(categoryName: categoryName, auctionType: auctionType, prodKey: productkey as! String, productDict: productDict)
          guard let endTime = product.endTime else {return}
          let currentTime = Date().millisecondsSince1970
           if endTime < currentTime && endTime != -1{
            self.endedListArray.append(product)
          }
          DispatchQueue.main.async {
            self.fidgetImageView.isHidden = true
            self.collView.reloadData()
            
          }
        })
      }
    }
  }
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo.init(title: "Ended.")
  }

}


extension EndedWatchListVc: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return endedListArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WatchlistEndedCell
        cell.layer.cornerRadius = 3.0
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowOpacity = 0.6
        
        let baseView = cell.ViewSell
        baseView!.layer.cornerRadius = 8
        baseView!.clipsToBounds = true
        baseView!.addShadowView()
        let product = endedListArray[indexPath.row]
        cell.ImageItem.addShadowView()
        //cell.ImageItem.addShadowAndRound()
       
      if let imageUrl = product.imageUrl0 {
        cell.ImageItem.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "emptyImage"))
          }
        cell.itemLabel.text = product.title
     
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = endedListArray[indexPath.row]
        
        let prodDetailsSB = getStoryBoardByName(storyBoardNames.prodDetails)
        let controller = prodDetailsSB.instantiateViewController(withIdentifier: "ProductDetailVc") as! ProductDetailVc
        controller.productDetail = selectedProduct
        nav?.pushViewController(controller, animated: true)
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 33, width: 50, height: 40)
        //  self.mainNavigationController?.pushViewController(controller, animated: true)
        // nav?.pushViewController(controller, animated: true)
        //        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}

    

   

