//
//  CustomLabels.swift
//  Sell4Bids
//
//  Created by admin on 8/25/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

class smallBold: UILabel {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLabel()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupLabel()
  }
  
  
  private func setupLabel() {
    font = UIDevice.isPad ? Fonts.ipadSmallBold : Fonts.iphoneSmallBold
    
  }
  
}

class small: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLabel()
    }
    
    
    private func setupLabel() {
        font = UIDevice.isPad ? Fonts.ipadSmallBold : Fonts.iphoneSmallBold
        
    }
    
}


class MediumBold: UILabel {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLabel()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupLabel()
  }
  
  
  private func setupLabel() {
    if UIDevice.isSmall  { font = Fonts.ipadSmallBold }else if UIDevice.isMedium {
        font = Fonts.iphoneMediumBold
    }
    else if UIDevice.isPad { font = Fonts.ipadMediumBold }
    
  }
  
}

class LargeBold: UILabel {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLabel()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupLabel()
  }
  
  
  private func setupLabel() {
    
    if UIDevice.isSmall { font = Fonts.iphoneLargeBold }
    else if UIDevice.isMedium { font = Fonts.iphoneMediumBold }
    else if UIDevice.isPad { font = Fonts.ipadLargeBold}
    
  }
  
}

class xLargeBold: UILabel {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLabel()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupLabel()
  }
  
  
  private func setupLabel() {
    
    if UIDevice.isSmall { self.font = Fonts.iphoneSmallBold}
    else if UIDevice.isMedium { self.font = Fonts.iphoneMediumBold }
    else if UIDevice.isPad { self.font = Fonts.ipadLargeBold}
    self.setNeedsDisplay()
  }
  
}

