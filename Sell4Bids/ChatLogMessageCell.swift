//
//  ChatLogMessageCell.swift
//  Sell4Bids
//
//  Created by admin on 5/1/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit


class ChatLogMessageCell: BaseCell {
  
  let messageTextView: UITextView = {
    let textView = UITextView()
    textView.isScrollEnabled = false
    textView.isUserInteractionEnabled = false
    textView.isEditable = false
    textView.font = UIFont.boldSystemFont(ofSize: 18)
    textView.text = "Sample message"
    
    
    
    return textView
  }()
  
  let textBubbleView: UIView = {
    let view = UIView()
    view.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
    //view.layer.cornerRadius = 10
    
    view.clipsToBounds = true
    return view
  }()
  
  let profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    let cornerRadius :CGFloat = Env.isIpad ? 25 : 20 
    imageView.layer.cornerRadius = cornerRadius
    imageView.layer.masksToBounds = true
    return imageView
  }()
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        let cornerRadius :CGFloat = Env.isIpad ? 25 : 20
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.masksToBounds = true
        return imageView
    }()
  
  static let grayBubbleImage = #imageLiteral(resourceName: "chat_bubble_received").resizableImage(withCapInsets: UIEdgeInsetsMake(22, 26, 22, 26)).withRenderingMode(.alwaysTemplate)
  static let blueBubbleImage = #imageLiteral(resourceName: "chat_bubble_sent").resizableImage(withCapInsets: UIEdgeInsetsMake(22, 26, 22, 26)).withRenderingMode(.alwaysTemplate)
  
  let bubbleImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = ChatLogMessageCell.grayBubbleImage
    imageView.tintColor = UIColor(white: 0.90, alpha: 1)
    
    return imageView
  }()
  
  let dateLabel : UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 10)
    label.textColor = UIColor.darkGray
    return label
  }()
  override func setupViews() {
    super.setupViews()
    
    addSubview(textBubbleView)
    addSubview(messageTextView)
    addSubview(profileImageView)
    
    addSubview(dateLabel)
    
    let widthHeigh = Env.isIpad ? "50" : "40"
    addConstraintsWithFormat(format: "H:|-8-[v0(\(widthHeigh))]", views: profileImageView)
    addConstraintsWithFormat(format: "V:|[v0(\(widthHeigh))]|", views: profileImageView)
    

    
  }
  
}

class BaseCell: UICollectionViewCell {
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupViews() {
  }
}

extension UIView {
  
  func addConstraintsWithFormat(format: String, views: UIView...) {
    
    var viewsDictionary = [String: UIView]()
    for (index, view) in views.enumerated() {
      let key = "v\(index)"
      viewsDictionary[key] = view
      view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
  }
  
}
