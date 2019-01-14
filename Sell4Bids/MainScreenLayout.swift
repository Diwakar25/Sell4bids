//
//  CustomLayout.swift
//  Sell4Bids
//
//  Created by admin on 12/18/17.
//  Copyright © 2017 admin. All rights reserved.
//


import UIKit

protocol CustomLayoutDelegate: class {
  func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat
}
class MainScreenLayout: UICollectionViewLayout {
  weak var delegate: CustomLayoutDelegate!
  
  // 2
  fileprivate var numberOfColumns = 3
  fileprivate var cellPadding: CGFloat = 6
  
  // 3
  fileprivate var cache = [UICollectionViewLayoutAttributes]()
  
  // 4
  fileprivate var contentHeight: CGFloat = 0
  
  fileprivate var contentWidth: CGFloat {
    guard let collectionView = collectionView else {
      return 0
    }
    let insets = collectionView.contentInset
    return collectionView.bounds.width - (insets.left + insets.right)
  }
  
  // 5
  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }
  override func prepare() {
    
    // 1
    guard cache.isEmpty == true, let collectionView = collectionView else {
      return
    }
    // 2
    let columnWidth = contentWidth / CGFloat(numberOfColumns)
    var xOffset = [CGFloat]()
    for column in 0 ..< numberOfColumns {
      xOffset.append(CGFloat(column) * columnWidth)
    }
    var column = 0
    var yOffset =  [CGFloat](repeating: 0, count: numberOfColumns)
    
    // 3
    for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
      
      let indexPath = IndexPath(item: item, section: 0)
      
      // 4
      let photoHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
      let height = (cellPadding * 2 + photoHeight) + 70
      let frame = CGRect(x: xOffset[column], y: yOffset[column] + 120 , width: columnWidth, height: height)
      let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
      
      // 5
      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      attributes.frame = insetFrame
      cache.append(attributes)
      
      // 6
      contentHeight = max(contentHeight, frame.maxY)
      yOffset[column] = yOffset[column] + height
      
      column = column < (numberOfColumns - 1) ? (column + 1) : 0
      
    }
//    
    let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: IndexPath(item: 0, section: 0))
    attributes.frame = CGRect(x: 0, y: 0, width:collectionView.frame.size.width , height: 120)
    cache.append(attributes)
    
  }
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    
    var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
    
    // Loop through the cache and look for items in the rect
    for attributes in cache {
      if attributes.frame.intersects(rect) {
        visibleLayoutAttributes.append(attributes)
      }
    }
    return visibleLayoutAttributes
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cache[indexPath.item]
  }
  override func invalidateLayout() {
    cache.removeAll()
    super.invalidateLayout()
  }
//
  
}
