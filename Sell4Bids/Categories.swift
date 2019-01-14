//
//  Categories.swift
//  socialLogins
//
//  Created by H.M.Ali on 10/5/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class SelectACategory: UITableViewController {
  
  var isJob = false
  
  @IBOutlet weak var searchBarFilterCategories: UISearchBar!
  
  var categories = ["Accessories","Antiques", "Arts & Crafts", "Baby & Kids", "Bags",
                    "Boats & Marines","Books","Business Equipments", "Campers & RVs","Cars & Accessories",
                    "CDs and DVDs","Clothing","Collectible Toys","Computers & Accessories","Costumes",
                    "Coupons", "Electronics","Exercise","Fashion", "Free & Donations",
                    "Furniture","Gadgets","Games","Halloween","Hobbies",
                    "Home Decor","Home & Garden","Household Appliances","Kids Toys", "Jewelry",
                    "Makeup & Beauty","Motorcycles & Accessories","Musical Equipments","Outdoor & Camping","Pet Accessories",
                    "Tickets","Tools","Phone & Tablets","Shoes","Sports Equipment",
                    "Video Games","Wallets","Watches","Wedding"]
  
  
  var jobCategory = ["Select Job Category","Accounting & Finance","Admin", "Automotive", "Business", "Construction", "Creative", "Customer Services", "Education", "Engineering",
                     "Food & Restaurants", "Healthcare", "Hotel & Hospitality", "Human Resources", "Labor", "Manufacturing", "Marketing", "Personal Care", "Real Estate",
                     "Retail & Wholesale", "Sales", "Salon, Spa & Fitness", "Security", "Skilled Trade & Craft", "Technical Support", "Transportation",
                     "TV, Film & Video", "Web & Info Design", "Writing & Editing", "Other", "Maintenance & Installation", "Office"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
    if isJob == true{
      return jobCategory.count
    }
    else{
      return categories.count
    }
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "test", for: indexPath) //as! TableViewCell
    
    
    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    cell.textLabel?.textColor = UIColor.darkGray
    if isJob == true{
      cell.textLabel?.text = jobCategory[indexPath.row]
    }
    else{
      cell.textLabel?.text = categories[indexPath.row]
    }
    return cell
  }
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    var sendData = ""
    if isJob == true{
      sendData = jobCategory[indexPath.row]
    }
    else{
      sendData = categories[indexPath.row]
    }
    
    NotificationCenter.default.post(name: Notification.Name("ValueSelected"), object: sendData)
    
    self.navigationController?.popViewController(animated: false)
    
    
    
  }
  
  
}
extension SelectACategory : UISearchBarDelegate {
  
}
