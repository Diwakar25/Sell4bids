//
//  fidgetVC.swift
//  ShopNRoar
//
//  Created by admin on 10/10/17.
//  Copyright © 2017 BrainPlow. All rights reserved.
//

import UIKit

class fidget {
    
    public static func toggleRotateAndDisplayView (fidgetView: UIImageView , downloadcompleted : Bool)
    {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            fidgetView.isHidden = false
            if downloadcompleted == true {
                fidgetView.image = nil
                fidgetView.isHidden = true
            }
            
        
        })
            
        _ = arc4random_uniform(2) + 1
        let nextGifName : String
        if UIDevice.modelName.contains("iPhone 5s") {
             nextGifName = gifNames[0]
        }else {
             nextGifName = gifNames[0]
        }
        
       
        
        fidgetView.loadGif(name: nextGifName)
    
    }
    
    public static func toggleRotateAndDisplayItems (fidgetView: UIImageView , downloadcompleted : Bool)
    {
        
      
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            fidgetView.isHidden = false
            if downloadcompleted == true {
                fidgetView.image = nil
                fidgetView.isHidden = true
            }
            
            
        })
            
            
        
        let randNumber = arc4random_uniform(2) + 1
        let nextGifName : String
        if UIDevice.modelName.contains("iPhone 5s") {
            nextGifName = gifNames[0]
        }else {
            nextGifName = gifNames[0]
        }
        
        
        
        fidgetView.loadGif(name: nextGifName)
        
    }
    
    
    public static func stopfiget(fidgetView : UIImageView) {
        fidgetView.isHidden = true
        fidgetView.image = nil
    
    }
}




