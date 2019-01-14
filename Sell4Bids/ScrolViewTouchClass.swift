//
//  ScrolViewTouchClass.swift
//  socialLogins
//
//  Created by Irfan on 10/6/17.
//  Copyright © 2017 Admin. All rights reserved.
//

//import Foundation
import UIKit

protocol PassTouchesScrollViewDelegate {
    func touchBegan()
    func touchMoved()
}


class PassTouchesScrollView: UIScrollView {
    
    var delegatePass : PassTouchesScrollViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
     func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        // Notify it's delegate about touched
        self.delegatePass?.touchBegan()
        
        if self.isDragging == true {
            self.next?.touchesBegan(touches as! Set<UITouch>, with: event)
        } else {
            super.touchesBegan(touches as! Set<UITouch>, with: event)
        }
        
    }
    
    func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent)  {
        
        // Notify it's delegate about touched
        self.delegatePass?.touchMoved()
        
        if self.isDragging == true {
            self.next?.touchesMoved(touches as! Set<UITouch>, with: event)
        } else {
            super.touchesMoved(touches as! Set<UITouch>, with: event)
        }
    }
}
