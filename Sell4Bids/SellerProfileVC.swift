//
//  UserProfileVc.swift
//  Sell4Bids
//
//  Created by admin on 10/17/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import Cosmos
import XLPagerTabStrip

class SellerProfileVC: UIViewController, IndicatorInfoProvider {
  
  //MARK:- Properties
  @IBOutlet weak var collView: UICollectionView!
  @IBOutlet weak var emptyProductMessage: UILabel!
  @IBOutlet weak var imgeView: UIImageView!
  @IBOutlet weak var fidgetImageView: UIImageView!
  weak var delegate : sellerProfileVCDelegate?
  //MARK:- Variables
  var userData:UserModel!
  var userProductArray = [ProductModel]()
  var dbRef: DatabaseReference!
  private let leftAndRightPaddings: CGFloat = 32.0
  private let numberOfItemsPerRow: CGFloat = 2.0
  private let heightAdjustment: CGFloat = 30.0
  var nav:UINavigationController?
  var productsCount:Int = 0
  var followersCount:Int = 0
  var followingCount:Int = 0
  var isfollowing:Bool = false
  let currentUserId = Auth.auth().currentUser?.uid
  var userIdToDisplayData : String?
  var sellerProfileImage : UIImage? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Seller Profile"
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = UIColor.white
    
    dbRef = FirebaseDB.shared.dbRef
    getUserProducts()
    // Do any additional setup after loading the view.
    
    //userName.text = userData.name
    self.navigationController?.navigationBar.topItem?.title = "";
    
    cutomizeCollectionView()
    guard let data = userData , let id = data.userId else { return }
    if (currentUserId == id) {
      
      let cancel = UIBarButtonItem.init(image:UIImage(named: "stepBack") , style:.plain, target: self, action: #selector(backBtnTap))
      navigationItem.leftBarButtonItem = cancel
      navigationItem.title = userData.name
    }
    
  }
  
  @objc func backBtnTap(){
    self.navigationController?.popViewController(animated: true)
  }
  
  func cutomizeCollectionView(){
    //custom collectionView Cell size
    
    let bounds = UIScreen.main.bounds
    let width = (bounds.size.width - leftAndRightPaddings) / numberOfItemsPerRow
    let layout = collView.collectionViewLayout as! UICollectionViewFlowLayout
    //layout.itemSize = CGSize(width, width + heightAdjustment)
    layout.itemSize = CGSize(width: width, height: width + heightAdjustment)
  }
  
  var downloadCompleted = false
  
  func getUserProducts() {
    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] (_) in
      guard let this = self else { return }
      if !this.downloadCompleted {
        this.fidgetImageView.toggleRotateAndDisplayGif()
      }
      
    }
    var userIdToUse = ""
    if let userId = self.userIdToDisplayData {
      userIdToUse = userId
    }
    else {
      guard let data = userData,  let userID = data.userId else {
        print("ERROR: while geting user Id")
        return
      }
      userIdToUse = userID
    }
    
    
    self.dbRef.child("users").child(userIdToUse).observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
      guard let this = self else { return }
      this.downloadCompleted = true
      if let dictObj = snapshot.value as? NSDictionary {
        if let followers = dictObj.value(forKey: "followers") as? NSDictionary {
          this.followersCount = followers.count
        } else {
          this.followersCount = 0
        }
        if let following = dictObj.value(forKey: "followings") as? NSDictionary {
          this.followingCount = following.count
        } else {
          this.followingCount = 0
        }
        if let products = dictObj.value(forKey: "products") {
          let selling  = products as! NSDictionary
          if let productsValues = selling.value(forKey: "selling") as? NSDictionary {
            //  self.productsCount    = productsValues.count
            for sellval in productsValues {
              guard let prodkey = sellval.key as? String else {return}
              guard let dictt = sellval.value as? NSDictionary else {
                return
                
              }
              
              if let categoryName = dictt.value(forKey: "category") as? String {
                
                if let auctionType = dictt.value(forKey: "auctionType") as? String {
                  
                  if let state = dictt.value(forKey: "state") as? String {
                    
                    this.dbRef.child("products").child(categoryName ).child(auctionType).child(state).child(prodkey).observeSingleEvent(of: .value, with: { [weak self](productSnapshot) in
                      guard let thisInner = self else { return }
                      guard let productDict = productSnapshot.value as? [String: AnyObject]  else {
                        print("ERROR : while geting productDict")
                        return
                        
                      }
                      
                      let product = ProductModel(categoryName: categoryName, auctionType: auctionType, prodKey: prodkey, productDict: productDict)
                      if thisInner.productsCount == 0 {
                        thisInner.productsCount = productDict.count
                      }
                      thisInner.userProductArray.append(product)
                      
                      DispatchQueue.main.async {
                        thisInner.fidgetImageView.isHidden = true
                        thisInner.fidgetImageView.image = nil
                        thisInner.collView.reloadData()
                      }
                      
                    })
                  }
                }
              }
            }
            
            
          }else {
            this.fidgetImageView.isHidden = true
            this.fidgetImageView.image = nil
          }
        }else {
          this.fidgetImageView.isHidden = true
            this.fidgetImageView.image = nil
        }
      }
    })
    { (error) in
      print(error.localizedDescription)
      
    }
  }
  
  @objc func followButtontapped() {
    print("pressed")
    
    if (!isfollowing) {
      //setting following for current user
      dbRef.child("users").child(currentUserId!).child("followings").child(userData.userId!).setValue("1")
      //adding count to FollowingCount
      increaseDecreaseNodeCountBy(userId: currentUserId!, toIncreaseTrueOrDecreaseFalse: true ,nodeName: "followingsCount")
      
      //setting followers for profile user
      dbRef.child("users").child(userData.userId!).child("followers").child(currentUserId!).setValue("1")
      increaseDecreaseNodeCountBy(userId: userData.userId!, toIncreaseTrueOrDecreaseFalse: true ,nodeName: "followersCount")
      
      DispatchQueue.main.async {
        self.followersCount += 1
        self.collView.reloadData()
      }
      
      self.alert(message: "You have successfully added seller to your following list. We will notify you about seller's each new listing", title: "Followings")
    } else {
      //Unfollow
      dbRef.child("users").child(currentUserId!).child("followings").child(userData.userId!).removeValue()
      increaseDecreaseNodeCountBy(userId: currentUserId!, toIncreaseTrueOrDecreaseFalse: false ,nodeName: "followingsCount")
      
      dbRef.child("users").child(userData.userId!).child("followers").child(currentUserId!).removeValue()
      increaseDecreaseNodeCountBy(userId: userData.userId!, toIncreaseTrueOrDecreaseFalse: false ,nodeName: "followersCount")
      
      DispatchQueue.main.async {
        self.followersCount -= 1
        self.collView.reloadData()
      }
      
      self.alert(message: "You have un-followed the seller, you can follow again any time", title: "Followings")
      
    }
  }
  
  @objc func blockedButtontapped(){
    
    let alert = UIAlertController(title: "Block Person", message: "Are you sure you want to block this person? You both won't be able to see items from each other.", preferredStyle: .alert)
    let actionBlock = UIAlertAction(title: "Block", style: .default) { (action) in
      handleBlockAction()
    }
    let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
    
    alert.addAction(actionBlock)
    alert.addAction(actionCancel)
    self.present(alert, animated: true)
    
    func handleBlockAction() {
      if let sellerID = userData.userId {
        //blocked the person
        dbRef.child("users").child(currentUserId!).child("blockedPersons").child(sellerID).setValue("1")
        //Blocked by
        dbRef.child("users").child(sellerID).child("blockedBy").child(currentUserId!).setValue("1")
        //remove from following
        dbRef.child("users").child(currentUserId!).child("followings").child(sellerID).removeValue()
        
        increaseDecreaseNodeCountBy(userId: currentUserId!, toIncreaseTrueOrDecreaseFalse: false ,nodeName: "followingsCount")
        //remove from followers
        dbRef.child("users").child(currentUserId!).child("followers").child(sellerID).removeValue()
        // increaseDecreaseNodeCountBy(userId: currentUserId!, toIncreaseTrueOrDecreaseFalse: false ,nodeName: "followersCount")
        //Remove from seller
        dbRef.child("users").child(sellerID).child("followings").child(currentUserId!).removeValue()
        dbRef.child("users").child(sellerID).child("followers").child(currentUserId!).removeValue()
        navigationController?.popToRootViewController(animated: true )
        
        showSwiftMessageWithParams(theme: .success, title: "User Blocked Successfully", body: "Sorry for the inconvenience. You won't be shown any items listed by this user.")
        
      }
    }
    
  }
  
  func increaseDecreaseNodeCountBy(userId:String,toIncreaseTrueOrDecreaseFalse: Bool, nodeName: String){
    dbRef.child("users").child(userId).observeSingleEvent(of: .value) { (snapshot) in
      
      if let dictObj = snapshot.value as? NSDictionary {
        
        guard let currentCounter = dictObj.value(forKey: nodeName) else {return}
        var counter:Int =  0
        if(toIncreaseTrueOrDecreaseFalse) {
          
          counter = (currentCounter as! NSString).integerValue
          if (counter < 0)
          {
            counter = 0
          }
          counter = counter + 1
          print(counter)
          
        }
        else {
          counter = ((currentCounter as? NSString)?.integerValue)!
          counter = counter - 1
          print(counter)
          
          if (counter < 0)
          {
            counter = 0
          }
        }
        self.dbRef.child("users").child(userId).child(nodeName).setValue("\(counter)")
      }
      
      
    }
  }
  
  //MARK:- Actions
  @objc func userImageTapped() {
    guard let image = self.sellerProfileImage else {
      return
    }
    let sellerImageVC = storyboard?.instantiateViewController(withIdentifier: "SellerImageVC") as! SellerImageVC
    sellerImageVC.userImage = image
    self.present(sellerImageVC, animated: true)
  }
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension SellerProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return userProductArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedPhotoCell", for: indexPath) as! AnnotatedPhotoCell
    let product = userProductArray[indexPath.row]
    cell.setupWith(product: product)
    
    cell.categoryBidNowBtn.tag = indexPath.row
    cell.categoryBidNowBtn.addTarget(self, action: #selector(bidNowBtnTapped), for: .touchUpInside)
    
    
    return cell
    
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let selectedProduct = userProductArray[indexPath.row]
    let storyBoard_ = UIStoryboard.init(name: storyBoardNames.prodDetails , bundle: nil)
    let controller = storyBoard_.instantiateViewController(withIdentifier: "ProductDetailVc") as! ProductDetailVc
    controller.productDetail = selectedProduct
    controller.flagWasPushedFromSellerProfile = true
    
    navigationController?.pushViewController(controller, animated: true)
    
//    self.navigationController?.popViewController(animated: true)
//    delegate?.productTapped(selectedProduct)
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
    var header = UICollectionReusableView()
    
    if kind == UICollectionElementKindSectionHeader {
      
      header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
      guard let _ = userData else {
        print("guard let data = userData failed in \(self)")
        return UICollectionReusableView.init()
        
      }
      if let labelUserName = header.viewWithTag(9) as? UILabel {
        labelUserName.text = userData.name ?? "Sell4bids User"
      }
      
      
      let sellerImageView = header.viewWithTag(4) as! UIImageView
      //image.layer.borderWidth = 2
      //image.layer.borderColor = UIColor.red.cgColor
      sellerImageView.layer.cornerRadius = sellerImageView.frame.width/2
      let tapOnImage = UITapGestureRecognizer.init(target: self, action: #selector(userImageTapped))
      
      sellerImageView.addGestureRecognizer(tapOnImage)
      
      sellerImageView.layer.masksToBounds = false
      sellerImageView.clipsToBounds = true
      let productsLabel = header.viewWithTag(1) as! UILabel
      let followersLabel = header.viewWithTag(2) as! UILabel
      let followingLabel = header.viewWithTag(3) as! UILabel
      let cosmosRating = header.viewWithTag(5) as! CosmosView
      let followButton = header.viewWithTag(6) as! UIButton
      let blockButton = header.viewWithTag(7) as! UIButton
      let totalRating = header.viewWithTag(8) as! UILabel
      
      if let imageUrl = self.userData.image{
        let downloader = SDWebImageDownloader.init()
        downloader.downloadImage(with: URL.init(string: imageUrl), options: .highPriority, progress: nil) { (image_, data, error, success) in
          if let imagedownloded = image_ {
            sellerImageView.image = imagedownloded
            sellerImageView.isUserInteractionEnabled = true
            self.sellerProfileImage = imagedownloded
          }
        }
        
        
      }
      productsLabel.text = "\(productsCount)"
      followersLabel.text = "\(followersCount)"
      followingLabel.text = "\(followingCount)"
      cosmosRating.settings.updateOnTouch = false
      
      
      if userData.averageRating != 0 {
        if let Rating = userData.averageRating {
          print(Rating)
          cosmosRating.rating = Double(Rating)
          
        }
        if let totalrating = userData.totalRating {
          totalRating.text = "( Total ratings- \(totalrating)  )"
        }
      }
      else {
        cosmosRating.rating = 0
        totalRating.text = "Not rated yet"
      }
      
      
      
      followButton.addTarget(self, action: #selector(SellerProfileVC.followButtontapped), for: .touchUpInside)
      blockButton.addTarget(self, action: #selector(SellerProfileVC.blockedButtontapped), for: .touchUpInside)
      if (!(currentUserId == userData.userId)) {
        self.dbRef.child("users").child(currentUserId!).child("followings").observeSingleEvent(of: .value, with: { (snapshot) in
          
          if snapshot.hasChild(self.userData.userId!) {
            DispatchQueue.main.async {
              followButton.setTitle("Un-Follow", for: .normal)
              self.isfollowing = true
              
              
            }
          }else {
            DispatchQueue.main.async {
              followButton.setTitle("Follow", for: .normal)
              self.isfollowing = false
              
            }
          }
          
        }){(error) in
          print(error.localizedDescription)
          
        }
      }
      else {
        followButton.isHidden = true
        blockButton.isHidden = true
      }
      
    }
    
    return header
    
  }
  
  @objc func bidNowBtnTapped( _ sender : UIButton) {
    let tag = sender.tag
    let selectedProduct = userProductArray[tag]
    let storyBoard_ = UIStoryboard.init(name: storyBoardNames.prodDetails , bundle: nil)
    let controller = storyBoard_.instantiateViewController(withIdentifier: "ProductDetailVc") as! ProductDetailVc
    controller.productDetail = selectedProduct
    controller.flagWasPushedFromSellerProfile = true
    
    navigationController?.pushViewController(controller, animated: true)
    
  }
  
}

protocol sellerProfileVCDelegate: class {
  func productTapped(_ product : ProductModel )
}

extension SellerProfileVC {
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo.init(title: "My Profile")
  }
}

