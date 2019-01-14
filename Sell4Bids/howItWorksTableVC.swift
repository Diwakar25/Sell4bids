//
//  howItWorksTableVC.swift
//  Sell4Bids
//
//  Created by admin on 4/14/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class howItWorksTableVC: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addDoneTabBarButtonToNav()
    
  }
  
  func addDoneTabBarButtonToNav() {
    
    let barbutton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.barBtnInNavTapped))
    self.navigationItem.setLeftBarButton(barbutton, animated: true)
  }
  
  
  @objc func barBtnInNavTapped() {
    self.dismiss(animated: true, completion: nil)
  }
  
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return 12
    
  }
  
  
  
}
