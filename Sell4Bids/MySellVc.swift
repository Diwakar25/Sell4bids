//
// MySellVc.swift
//  Sell4Bids
//
//  Created by admin on 10/9/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase

class SellingVC: UIViewController {
    //MARK: - Properties
    
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var fidgetImageView: UIImageView!
    @IBOutlet weak var imgeView: UIImageView!
    @IBOutlet weak var emptyProductMessage: UILabel!
    var numberOfColumns : CGFloat = {
        if UIDevice.current.userInterfaceIdiom == .pad { return 3 }
        else { return 2}
        
    }()
    
    
    //MARK: - variables
    var mySellArray = [ProductModel]()
    var dbRef: DatabaseReference!
    private let leftAndRightPaddings: CGFloat = 6.0
    private let numberOfItemsPerRow: CGFloat = 2.0
    private let heightAdjustment: CGFloat = 30.0
    var nav:UINavigationController?
    override func viewDidLoad() {
        super.viewDidLoad()
        //passing data to of Selling Products to SellingViewController
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
        fidgetImageView.loadGif(name: "fidget")
        cutomizeCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserSellingData()
    }
    
    func hideCollectionView(hideYesNo : Bool) {
        
        emptyProductMessage.text = "Item you list for sale, appear here."
        if hideYesNo == false {
            collView.isHidden = false
            imgeView.isHidden = true
            fidgetImageView.isHidden = false
            emptyProductMessage.isHidden = true
        }
        else  {
            fidgetImageView.isHidden = true
            collView.isHidden = true
            imgeView.isHidden = false
            emptyProductMessage.isHidden = false
        }
    }
    
    func cutomizeCollectionView(){
        //custom collectionView Cell size
        let bounds = UIScreen.main.bounds
        let width = (bounds.size.width / numberOfColumns ) - (leftAndRightPaddings * 2)
        let layout = collView.collectionViewLayout as! UICollectionViewFlowLayout
        //layout.itemSize = CGSize(width, width + heightAdjustment)
        layout.itemSize = CGSize(width: width, height: width + heightAdjustment)
    }
    
    func getUserSellingData(){
        //  fidgetImageView.isHidden = false
        dbRef = Database.database().reference()
        guard let userId = Auth.auth().currentUser?.uid else {
            self.hideCollectionView(hideYesNo: true)
            print("ERROR : user id ie nil in MySellVC")
            fatalError()
        }
        dbRef.child("users").child(userId).child("products").observeSingleEvent(of: .value) { (productsSnapshot) in
            self.mySellArray.removeAll()
            guard let userProducts = productsSnapshot.value as? [String:AnyObject] else {
                self.fidgetImageView.isHidden = true
                self.hideCollectionView(hideYesNo: true)
                return
            }
            guard let sellingProduct = userProducts["selling"] as? [String:AnyObject] else {
                self.hideCollectionView(hideYesNo: true)
                print("ERROR : while getting user selling data")
                self.fidgetImageView.isHidden = true
                self.hideCollectionView(hideYesNo: true)
                return
            }
            for products in sellingProduct {
                let productkey = products.key
                guard let prodDict = products.value as? [String:AnyObject] else {
                    print("ERROR : while getting user selling data")
                    
                    return
                }
                guard let categoryName = prodDict["category"] as? String else {
                    print("ERROR: while geting CategoryName")
                    return
                }
                guard let auctionType = prodDict["auctionType"] as? String  else {
                    print("ERROR: while geting auctionType")
                    return
                }
                guard let stateName = prodDict["state"] as? String  else {
                    print("ERROR: while geting stateName")
                    return
                }
                self.dbRef.child("products").child(categoryName ).child(auctionType).child(stateName ).child(productkey).observeSingleEvent(of: .value, with: { (productSnapshot) in
                    if productSnapshot.childrenCount > 0 {
                        guard let productDict = productSnapshot.value as? [String:AnyObject] else {
                            print("ERROR: while fetchinh products Dicts")
                            return
                        }
                        let product = ProductModel(categoryName: categoryName, auctionType: auctionType, prodKey: productkey, productDict: productDict)
                        if product.categoryName != nil && product.auctionType != nil && product.state != nil{
                            self.mySellArray.append(product)
                            
                        }
                        
                        
                        DispatchQueue.main.async {
                            self.hideCollectionView(hideYesNo: false)
                            self.fidgetImageView.isHidden = true
                            self.collView.reloadData()
                            
                        }
                    }
                })
                
            }
        }
        
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
        cell.makeCornersRound()
        cell.addDropShadow1()
        
        let product = mySellArray[indexPath.row]
        
        if let imageUrl = product.imageUrl0 {
            cell.sellImagevView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "emptyImage"))
        }
        DispatchQueue.main.async {
            cell.titleCellLabel.text = product.title
            if let price = product.startPrice {
                cell.lblPriceProduct.text = "\(price)"
            }
        
        }
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = mySellArray[indexPath.row]
        let controller = storyboard?.instantiateViewController(withIdentifier: "ProductDetailVc") as! ProductDetailVc
        controller.productDetail = selectedProduct
        nav?.pushViewController(controller, animated: true)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == collView {
//            var width = ( collectionView.bounds.size.width / numberOfColumns ) - 20
//            //width = width - (collectionView.contentInset.left + collectionView.contentInset.right) * numberOfColumns
//
//            //print(collectionView.bounds)
//            let height = collectionView.bounds.size.height / 2.5
//            return CGSize(width: width, height: height)
//        }
//        return CGSize(width: 0, height: 0)
//
//    }
    
}



