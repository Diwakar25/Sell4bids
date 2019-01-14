//
//  ChatMessageCell.swift
//  GroupedMessagesLBTA
//
//  Created by Brian Voong on 8/25/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit

class ChatMessageCell: UITableViewCell {
    
    let messageLabel = UILabel()
    let bubbleBackgroundView = UIView()
    let timeLabel = UILabel()
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    var isIncoming = Bool()

    
    
    func Autoset () {
        print("isincoming \(isIncoming)")
        if isIncoming {
            leadingConstraint.isActive = true
            trailingConstraint.isActive = false
        } else {
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
        }
         bubbleBackgroundView.backgroundColor = isIncoming ? UIColor(red: 231/256, green: 229/256, blue: 237/256, alpha: 1.0) : UIColor(red: 75/256, green: 208/256, blue: 97/256, alpha: 1.0)
        messageLabel.textColor = isIncoming ? .black : .white
        timeLabel.textColor = isIncoming ? .black : .white
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        bubbleBackgroundView.backgroundColor = .yellow
        bubbleBackgroundView.layer.cornerRadius = 12
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
       
       
        
        timeLabel.font = timeLabel.font.withSize(12)
        
      
        addSubview(bubbleBackgroundView)
        addSubview(messageLabel)
        addSubview(timeLabel)
        
        
        // lets set up some constraints for our label
        let constraints = [
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            messageLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -12),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 26),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16),
            
            timeLabel.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: -5),
            timeLabel.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -16),
            ]
        NSLayoutConstraint.activate(constraints)
        
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        leadingConstraint.isActive = false
        
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        trailingConstraint.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}






