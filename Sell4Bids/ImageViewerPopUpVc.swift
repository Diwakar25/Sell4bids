//
//  ImageViewerPopUpVc.swift
//  Sell4Bids
//
//  Created by admin on 12/20/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class ImageViewerPopUpVc: UIViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  //MARK:- Variables
  
  @IBOutlet weak var pageControl: UIPageControl!
  var imagesArray = [String]()
  var selectedIndex:IndexPath!
  
  @IBOutlet weak var btnDoneImageViewer: UIButton!
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    //print("number of pages : \(self.imagesArray.count)")
    print("selected index row : \(selectedIndex.row )")
    print("selected index section : \(selectedIndex.section )")
    
    
    //self.pageControl.numberOfPages = 4
    
  
    btnDoneImageViewer.layer.cornerRadius = 0.5 * btnDoneImageViewer.bounds.size.width
    btnDoneImageViewer.clipsToBounds = true
    btnDoneImageViewer.layer.borderColor = UIColor.white.cgColor
    btnDoneImageViewer.layer.borderWidth = 2
    
  }
  
  override func viewDidLayoutSubviews() {
    
    
    if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
        var itemHeight = CGFloat()
        let itemWidth = view.bounds.width
        if UIDevice.current.model.contains("iPhone") {
            itemHeight = view.bounds.height/45 * 100
        }else if UIDevice.current.model.contains("iPad") {
            itemHeight = view.bounds.height/50 * 100
        }
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.invalidateLayout()
    }
    
    if let index = selectedIndex {
      let indexPath = IndexPath.init(item: index.row, section: 0)
      if indexPath.row > 0 {
        self.collectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally],
                                         animated: true)
        
        print("current page : \(self.selectedIndex.row)")
       
       
      }
      
      
      
      
      
      
      
    }
  }
  
  @IBAction func cancelButtonTapped(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
  }
  
}
//MARK:- UICollectionViewDataSource, UICollectionViewDataSource
extension ImageViewerPopUpVc: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    pageControl.numberOfPages = imagesArray.count
    return imagesArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    let  imageView = cell.viewWithTag(1) as! UIImageView
    imageView.sd_setImage(with: URL(string: self.imagesArray[indexPath.row]), placeholderImage: UIImage(named: "emptyImage"))
   // self.pageControl.currentPage = indexPath.row
    return cell
  }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }

  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return collectionView.bounds.size
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
 }
}
