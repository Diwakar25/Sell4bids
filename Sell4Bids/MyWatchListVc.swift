//
//  MyWatchListVc.swift
//  Sell4Bids
//
//  Created by admin on 11/7/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

import XLPagerTabStrip

class MyWatchListVc: ButtonBarPagerTabStripViewController, IndicatorInfoProvider {
  
  //MARK: - Variables
  var controllers:[UIViewController] = Array<UIViewController>()
  //var pageMenu : CAPSPageMenu?
  var nav:UINavigationController?
  

  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupMySell4BidsTopBar()
    
  }
  
  fileprivate func setupViews() {
    navigationItem.title = "Watching"
    // Do any additional setup after loading the view.
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = UIColor.white
    
    let barBtnDone = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(backBtnTap))
    
    navigationItem.leftBarButtonItem = barBtnDone
  }
  
  func setupMySell4BidsTopBar () {
    
    settings.style.buttonBarItemBackgroundColor = UIColor.white
    settings.style.buttonBarItemTitleColor = UIColor.black
    let size :CGFloat = Env.isIpad ? 15 : 20
    settings.style.buttonBarItemFont = UIFont.boldSystemFont(ofSize: size)
    buttonBarView.selectedBar.backgroundColor = UIColor.red
    buttonBarView.backgroundColor =  UIColor.white
  }
  
  override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    
    let controller1 = self.storyboard?.instantiateViewController(withIdentifier: "ActiveWatchListVc")   as! ActiveWatchListVc
    controller1.nav = self.nav
    controller1.title = "Active"
    self.controllers.append(controller1)
    
    let controller2 = self.storyboard?.instantiateViewController(withIdentifier: "EndedWatchListVc") as! EndedWatchListVc
    controller2.nav = self.nav
    controller2.title = "Ended"
    self.controllers.append(controller2)
    
    
    return self.controllers
  }
  
  @objc func backBtnTap() {
    // self.navigationController?.popViewController(animated: true)
    dismiss(animated: true, completion: nil)
  }
  
  func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
    return IndicatorInfo.init(title: "Watch List")
  }
  
}
