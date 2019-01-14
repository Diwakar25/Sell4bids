
//
//  HomeTabBarController.swift
//  Sell4Bids
//
//  Created by MAC on 26/06/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class HomeTabBarController: UITabBarController, UITabBarControllerDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    
  }
  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    
    guard let fromView = selectedViewController?.view, let toView = viewController.view else {
      return false
    }
    
    UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)

   return true
  }
  
}
