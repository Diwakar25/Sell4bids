//
//  NoResultsView.swift
//  Sell4Bids
//
//  Created by admin on 5/9/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class NoResultsView: UIView {

  
  @IBOutlet weak var whiteView: UIView!
  @IBOutlet var mainView: UIView!
  @IBOutlet weak var imgViewNoProduct: UIImageView!
  @IBOutlet weak var lblOopsNoResults: UILabel!
  @IBOutlet weak var lblTryChangingKeyWords: UILabel!
  
  @IBOutlet weak var btnleft: UIButton!
  @IBOutlet weak var btnRight: UIButton!
  
  override init(frame: CGRect) { //for using custom view in code
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) { //for using custom view in IB
    super.init(coder: aDecoder)
    commonInit()
  }
  
  private func commonInit() {
    Bundle.main.loadNibNamed("NoResultsView", owner: self, options: nil)
    addSubview(mainView)
    mainView.frame = self.bounds
    mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    whiteView.addShadowAndRound()
  }
}
