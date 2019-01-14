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
  var flagFilteringResults = false
  var filteredCategories :[String] = []
  var filteredJobs :[String] = []
  weak var delegate : SelectACategoryVCDelegate?
  @IBOutlet weak var searchBarFilterCategories: UISearchBar!
  
  var jobCategory = ["Select Job Category","Accounting and Finance","Admin", "Automotive", "Business", "Construction", "Creative", "Customer Services", "Education", "Engineering",
                     "Food and Restaurants", "Healthcare", "Hotel and Hospitality", "Human Resources", "Labor", "Manufacturing", "Marketing", "Personal Care", "Real Estate",
                     "Retail and Wholesale", "Sales", "Salon, Spa and Fitness", "Security", "Skilled Trade and Craft", "Technical Support", "Transportation",
                     "TV, Film and Video", "Web and Info Design", "Writing and Editing", "Other", "Maintenance and Installation", "Office"]
  
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
    if isJob {
      if flagFilteringResults {
        return filteredJobs.count
      }else {
        return jobCategory.count
      }
      
    }
    else{
      if flagFilteringResults {
        return filteredCategories.count
      }
      return categoriesArray.count
    }
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "test", for: indexPath) //as! TableViewCell
    
    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    cell.textLabel?.textColor = UIColor.darkGray
    if isJob {
      if flagFilteringResults {
        cell.textLabel?.text = filteredJobs[indexPath.row]
      }else {
        cell.textLabel?.text = jobCategory[indexPath.row]
      }
      
    }
    else{
      //!isJob
      var text = ""
      if flagFilteringResults { text = filteredCategories[indexPath.row] } else {
        text = categoriesArray[indexPath.row]
      }
      cell.textLabel?.text = text
    }
    return cell
  }
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if isJob {
      var jobType = ""
      if flagFilteringResults {
        jobType = filteredJobs[indexPath.row]
      }else {
        jobType = jobCategory[indexPath.row]
      }
      delegate?.categorySelected(catName: jobType)
      
    }
      
    else {
      var catName = ""
      if flagFilteringResults {
        catName = filteredCategories[indexPath.row]
      }else { catName = categoriesArray[indexPath.row ]}
      delegate?.categorySelected(catName: catName)
      
    }
    self.navigationController?.popViewController(animated: false)
    
  }
}

protocol SelectACategoryVCDelegate : class {
  func categorySelected(catName: String)
}
extension SelectACategory : UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty {
      flagFilteringResults = false
      
    }else {
      if !flagFilteringResults { flagFilteringResults = true }
      if isJob {
        filteredJobs = jobCategory.filter({ (aJob) -> Bool in
          return aJob.lowercased().contains(searchText.lowercased())
        })
      }else {
        filteredCategories = categoriesArray.filter({ (aCategory) -> Bool in
          return aCategory.lowercased().contains(searchText.lowercased())
        })
      }
    }
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
}
