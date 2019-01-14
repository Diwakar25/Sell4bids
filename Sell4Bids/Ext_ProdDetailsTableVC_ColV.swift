//
//  Ext_ProdDetailsTableVC_ColV.swift
//  Sell4Bids
//
//  Created by MAC on 24/07/2018.
//  Copyright © 2018 admin. All rights reserved.
//


//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ProductDetailTableVc : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return imageUrlStringsForProduct.count
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView == self.sliderCollView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
      
      if  imageUrlStringsForProduct.count != 0  {
        cell.productImageView.sd_setImage(with: URL(string: imageUrlStringsForProduct[indexPath.row]), placeholderImage: UIImage(named: "emptyImage"))
      }else {
        cell.productImageView.image = UIImage(named: "emptyImage")
      }
      return cell
    }
    else if collectionView == self.colViewProductImagesPopup{
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
      cell.makeCornersRound()
      let imageView = cell.viewWithTag(1) as! UIImageView
      if imageUrlStringsForProduct.count != 0 {
        imageView.sd_setImage(with: URL(string:  imageUrlStringsForProduct[indexPath.row]), placeholderImage: UIImage(named: "emptyImage"))
      }else {
        
        imageView.image = UIImage(named: "emptyImage")
      }
      return cell
    }
      
    else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
      
      cell.makeCornersRound()
      cell.imageViewProduct.sd_setImage(with: URL(string: imageUrlStringsForProduct[indexPath.row]), placeholderImage: UIImage(named: "emptyImage"))
      cell.imageViewProduct.layer.cornerRadius = 8
      cell.imageViewProduct.clipsToBounds = true
      return cell
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
  
    if collectionView == self.sliderCollView {
      return collectionView.bounds.size
    }
    else  if collectionView == self.colViewProductImagesPopup {
      let width = self.view.frame.width
      let height = self.view.frame.height + 40
      let size = CGSize.init(width: width, height: height)
      return size
    }
      
    else  {
      let width = CGFloat(100)
      let height = collectionView.bounds.height
      return CGSize(width: 50, height: 50)
    }
  }
  
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if collectionView == self.sliderCollView {
      let num = indexPath.row
      self.pageController.currentPage = num
      
    }
    
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // let images = dataArray[indexPath.row]
    if collectionView == self.selectorCollView {
      self.sliderCollView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
    }else {
      
      let controller = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewerPopUpVc")  as! ImageViewerPopUpVc
      //let  selectedImage = dataArray[indexPath.row]
      controller.selectedIndex = indexPath
      print("controller.selectedIndex : \(controller.selectedIndex)")
      controller.view.backgroundColor = UIColor.white
      controller.imagesArray = imageUrlStringsForProduct
      
      
      controller.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
      controller.modalTransitionStyle = .coverVertical
      self.present(controller, animated: true, completion: nil)
      
      //indexPath.row
      
    }
    
  }
  
}
