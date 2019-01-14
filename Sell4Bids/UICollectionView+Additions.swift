//
//  UICollectionView+Additions.swift
//  Sell4Bids
//
//  Created by admin on 8/13/18.
//  Copyright © 2018 admin. All rights reserved.
//
import UIKit

extension UIScrollView {
  
  var isAtBottom: Bool {
    return contentOffset.y >= verticalOffsetForBottom
  }
  
  var verticalOffsetForBottom: CGFloat {
    let scrollViewHeight = bounds.height
    let scrollContentSizeHeight = contentSize.height
    let bottomInset = contentInset.bottom
    let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
    return scrollViewBottomOffset
  }
  
}
