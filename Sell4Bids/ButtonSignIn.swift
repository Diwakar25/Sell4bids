//
//  ButtonSignIn.swift
//  Sell4Bids
//
//  Created by admin on 8/20/18.
//  Copyright © 2018 admin. All rights reserved.
//


class ButtonSignIn: UIButton {
  
  override func awakeFromNib() {
    setupButton()
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    //setupButton()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupButton()
  }
  
  
  func setupButton() {
    
    //for 4 - 5 " screens
    var fontSize : CGFloat = 24
    if Env.isIpad { fontSize = 35 }
    else if UIDevice.isSmall { fontSize = 20 }

    titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
    
  }
  
}


class ButtonXLarge: UIButton {
  
  override func awakeFromNib() {
    setupButton()
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    //setupButton()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupButton()
  }
  
  
  func setupButton() {
    
    //for 4 - 5 " screens
    var fontSize : CGFloat = 27
    if Env.isIpad { fontSize = 31 }
    else if UIDevice.isSmall { fontSize = 25 }
    
    titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .heavy)
  }
  
}

class ButtonLarge: UIButton {
  
  override func awakeFromNib() {
    setupButton()
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    //setupButton()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupButton()
  }
  
  
  func setupButton() {
    
    //for 4 - 5 " screens
    var fontSize : CGFloat = 25
    if Env.isIpad { fontSize = 28 }
    else if UIDevice.isSmall { fontSize = 22 }
    
    titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .heavy)
  }
  
}


class ButtonNormal: UIButton {
  
  override func awakeFromNib() {
    setupButton()
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    //setupButton()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupButton()
  }
  
  
  func setupButton() {
    
    //for 4 - 5 " screens
    var fontSize : CGFloat = 18
    if Env.isIphoneMedium { fontSize = 15 }
    else if Env.isIpad { fontSize = 20 }
    
    titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight(rawValue: 4))
    
  }
  
}

class ButtonSmallText: UIButton {
  
  override func awakeFromNib() {
    setupButton()
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    //setupButton()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupButton()
  }
  
  
  func setupButton() {
    
    //for 4 - 5 " screens
    var fontSize : CGFloat = 14
    if UIDevice.isSmall { fontSize = 15 }
    else if UIDevice.isMedium { fontSize = 17 }
    else if UIDevice.isPad { fontSize = 24 }
    
    titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight(rawValue: 6))
    
    
  }
  
}


