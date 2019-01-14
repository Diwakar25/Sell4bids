//
//  AboutSell4BidsTableVC.swift
//  Sell4Bids
//
//  Created by admin on 4/14/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class AboutSell4BidsTableVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
      addDoneTabBarButtonToNav()
    }
  
  
  func addDoneTabBarButtonToNav() {
    let barbutton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.barBtnInNavTapped))
    self.navigationItem.setLeftBarButton(barbutton, animated: true)
  }
  
  
  @objc func barBtnInNavTapped() {
    self.dismiss(animated: true, completion: nil)
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

  
}
