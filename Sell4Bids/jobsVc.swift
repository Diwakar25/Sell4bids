//
//  jobsVc.swift
//  Sell4Bids
//
//  Created by admin on 11/7/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase

class jobsVc: UIViewController,UISearchBarDelegate {
  //MARK:- Properties
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var imgeView: UIImageView!
  @IBOutlet weak var emptyProductMessage: UILabel!
  @IBOutlet weak var fidgetImageView: UIImageView!
  var databaseHandle:DatabaseHandle?
  var categoryName : String!
  var blockedUserIdArray = [String]()
  var endAtChargeTimes = [String:CLongLong]()
  private var jobsDataSource = [ProductModel]()
  var filterJobsDataSource = [ProductModel]()
  var endAtChargeTime : CLongLong = -999
  
    @IBOutlet weak var searchTabBar: UISearchBar!
    var flagWasPushed = false
  //MARK:- Life Cycle
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterJobsDataSource = jobsDataSource.filter({( candy : ProductModel) -> Bool in
            
            if candy.title!.lowercased().contains(searchText.lowercased()) {
                return candy.title!.lowercased().contains(searchText.lowercased())
            }
            self.tableView.reloadData()
            
            return false
        })
        
    }
    func isFiltering() -> Bool {
        return !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        
        return searchTabBar.text?.isEmpty ?? true
    }
    
    override func viewDidLayoutSubviews() {
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 40)
    }
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    
   // navigationItem.titleView = searchTabBar
    
    if !flagWasPushed {
      let barBtnDone = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(backBtnTap))
      navigationItem.leftBarButtonItem = barBtnDone
    }
    
    downloadAndShowJobs()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
  }
  
  func downloadAndShowJobs(){
    //check internet is available
    if InternetAvailability.isConnectedToNetwork() == true {
      getCurrentUserData{ [weak self] (complete) in
        guard let this = self else { return }
        this.fetchAndDisplayDataOptimized(flagFirstTime: true)
      }
    }
    else {
      self.alert(message: "Make sure your Device is connected to Internet", title: "No Internet Connection")
      //activityIndicator.isHidden = true
      fidgetImageView.isHidden = true
      
    }
  }
  
  func hideCollectionView(hideYesNo : Bool) {
    emptyProductMessage.text = "No job found"
    if hideYesNo == false {
      tableView.isHidden = false
      imgeView.isHidden = true
      fidgetImageView.isHidden = false
      emptyProductMessage.isHidden = true
    }
    else  {
      fidgetImageView.isHidden = true
      tableView.isHidden = true
      imgeView.isHidden = false
      emptyProductMessage.isHidden = false
    }
  }
  
  
  @objc func backBtnTap() {
    if flagWasPushed {
       self.navigationController?.popViewController(animated: true)
    }else {
      dismiss(animated: true, completion: nil)
    }
    
    
  }
  
  func getCurrentUserData(completion : @escaping (Bool) -> ()) {
    
    if let userId = Auth.auth().currentUser?.uid {
      FirebaseDB.shared.dbRef.child("users").child(userId).observe(.value, with: { [weak self] (snapshot) in
        guard let this = self else { return }
        this.blockedUserIdArray.removeAll()
        if let dictObj = snapshot.value as? NSDictionary {
          if   let blockedPerson = dictObj.value(forKeyPath: "blockedPersons") as? NSDictionary {
            for value in blockedPerson {
              let blockedPerson = value.key as! String
              this.blockedUserIdArray.append(blockedPerson)
              
            }
          }
        }
        completion(true)
      })
    }
    
  }

  let queryBuyItNow :DatabaseQuery = {
    return FirebaseDB.shared.dbRef.child("products").child("Jobs").child("buy-it-now")
  }()
  
  private func fetchAndDisplayDataOptimized(flagFirstTime:Bool) {
    var numOfStatesProcessed = 0
    //let totalStatesToProcess = DB_Names.statesAbbrevArray.count
    //print("query : \(query)")
    for stateName in DB_Names.statesAbbrevArray {
      numOfStatesProcessed += 1
      let query = queryBuyItNow.ref.child(stateName)
      var arrCurrentFetchedProducts = [ProductModel]()
      print("query = \(query)")
      var queryForEachState :DatabaseQuery!
      if flagFirstTime {
        queryForEachState = query.queryOrdered(byChild: "chargeTime").queryLimited(toLast: 5)
      }else {
        
        queryForEachState = query.queryOrdered(byChild: "chargeTime").queryEnding(atValue: endAtChargeTimes[stateName]).queryLimited(toLast: 6)
      }
      
      
      queryForEachState.observeSingleEvent(of: .value, with: { [weak self] (StateDataSnapShot) in
        guard let thisInner = self else { return }
        if StateDataSnapShot.childrenCount > 0
        {
          print("Working for state : \(stateName)")
          for stateSnap in StateDataSnapShot.children.allObjects as! [DataSnapshot]
          {
            guard let prodDict = stateSnap.value as? [String:AnyObject] else {
              //fatalError("guard let item = s.value as? [String:AnyObject] failed in \(self)")
              continue
            }
            //avoid duplication here
            let key = stateSnap.key
            if flagFirstTime {
              //just add to data source. no need to check for avoiding duplication
              let productObj = ProductModel(categoryName: "Jobs", auctionType: "buy-it-now", prodKey: key, productDict: prodDict)
              //print("Adding first time : \(String(describing: productObj.title))")
              guard let prodUserId = productObj.userId  else {
                continue
              }
              if (!thisInner.blockedUserIdArray.contains(prodUserId)){
                arrCurrentFetchedProducts.append(productObj)
              }
              
            }else {
              // !flagFirstTime
              guard thisInner.endAtChargeTimes.count > 0 else {
                print ("guard endAtChargeTimes.count >0 failed in \(thisInner)")
                return
              }
              let thisStatesEndAt = thisInner.endAtChargeTimes[stateName]
              //to avoid duplication
              let productModel = ProductModel(categoryName: "Jobs", auctionType: "buy-it-now", prodKey: key, productDict: prodDict)
              if productModel.chargeTime != thisStatesEndAt {
                guard let id = productModel.userId else {
                  print("No user id found in job. Going to return ")
                  continue
                }
                if (!thisInner.blockedUserIdArray.contains(id)){
                  arrCurrentFetchedProducts.append(productModel)
                }
              }else {
                print("Detected Duplication")
              }
            }
            
          }
          
          let firstsChargeTime = arrCurrentFetchedProducts[0].chargeTime
          //print("Going to store charge time of state \(stateName). : Charge Time :\(firstsChargeTime!)")
          
          thisInner.endAtChargeTimes[stateName] = firstsChargeTime
          DispatchQueue.main.async {
            //arrCurrentFetchedProducts = arrCurrentFetchedProducts.reversed()
            thisInner.jobsDataSource.append(contentsOf: arrCurrentFetchedProducts)
            thisInner.tableView.reloadData()
            thisInner.imgeView.isHidden = thisInner.jobsDataSource.count > 0
          }
        }else {
          numOfStatesProcessed += 1
        }
        
      })
      
    }
  }
  
  private func fetchAndDisplayData(flagFirstTime:Bool) {
    let query :DatabaseQuery = queryBuyItNow
    print("query : \(query)")
    
    
    query.observeSingleEvent(of: .value) { [weak self] (dataSnapShot:DataSnapshot) in
      guard let this = self else { return }
      DispatchQueue.main.async { this.fidgetImageView.isHidden = true    }
      
      if dataSnapShot.childrenCount > 0 {
        guard let snapShotDict = dataSnapShot.value as? [String:AnyObject] else {
          print("guard let snapShotDict = dataSnapShot as? [String:AnyObject] failed in \(this)")
          return
        }
        //iterating through states
        for (stateName, _ ) in snapShotDict {
          var arrCurrentFetchedProducts = [ProductModel]()
          print("\nCurrent state name : " + "\(stateName)")
          //print(StateProducts)
          if stateName == "CA" {
            print("CA state Name")
          }
          //get first element's charge time
          var queryForEachState :DatabaseQuery!
          if flagFirstTime {
            queryForEachState = FirebaseDB.shared.dbRef.child("products").child("Jobs").child("buy-it-now").child(stateName).queryOrdered(byChild: "chargeTime").queryLimited(toLast: 5)
          }else {
            
            queryForEachState = FirebaseDB.shared.dbRef.child("products").child("Jobs").child("buy-it-now").child(stateName).queryOrdered(byChild: "chargeTime").queryEnding(atValue: this.endAtChargeTimes[stateName]).queryLimited(toLast: 6)
          }
          
          
          queryForEachState.observeSingleEvent(of: .value, with: { [weak self] (StateDataSnapShot) in
            guard let thisInner = self else { return }
            if StateDataSnapShot.childrenCount > 0
            {
              print("Working for state : \(stateName)")
              for stateSnap in StateDataSnapShot.children.allObjects as! [DataSnapshot]
              {
                guard let prodDict = stateSnap.value as? [String:AnyObject] else {
                  //fatalError("guard let item = s.value as? [String:AnyObject] failed in \(self)")
                  return
                }
                //avoid duplication here
                let key = stateSnap.key
                if flagFirstTime {
                  //just add to data source. no need to check for avoiding duplication
                  let productObj = ProductModel(categoryName: "Jobs", auctionType: "buy-it-now", prodKey: key, productDict: prodDict)
                  print("Adding first time : \(String(describing: productObj.title))")
                  guard let prodUserId = productObj.userId  else {return}
                  if (!thisInner.blockedUserIdArray.contains(prodUserId)){
                    arrCurrentFetchedProducts.append(productObj)
                  }
                  
                }else {
                  // !flagFirstTime
                  guard thisInner.endAtChargeTimes.count > 0 else {
                    print ("guard endAtChargeTimes.count >0 failed in \(thisInner)")
                    return
                  }
                  let thisStatesEndAt = thisInner.endAtChargeTimes[stateName]
                  //to avoid duplication
                  let productModel = ProductModel(categoryName: "Jobs", auctionType: "buy-it-now", prodKey: key, productDict: prodDict)
                  if productModel.chargeTime != thisStatesEndAt {
                    guard let id = productModel.userId else {
                      print("No user id found in job. Going to return ")
                      return
                    }
                    if (!thisInner.blockedUserIdArray.contains(id)){
                      arrCurrentFetchedProducts.append(productModel)
                    }
                  }else {
                    print("Detected Duplication")
                  }
                }
                
              }
              guard arrCurrentFetchedProducts.count > 0 else {
                print("guard let arrCurrentFetchedProducts.count > 0 failed in \(thisInner)")
                return
              }
              let firstsChargeTime = arrCurrentFetchedProducts[0].chargeTime
              print("Going to store charge time of state \(stateName). : Charge Time :\(firstsChargeTime!)")
              thisInner.endAtChargeTimes[stateName] = firstsChargeTime
              DispatchQueue.main.async {
                //arrCurrentFetchedProducts = arrCurrentFetchedProducts.reversed()
                thisInner.jobsDataSource.append(contentsOf: arrCurrentFetchedProducts)
                thisInner.tableView.reloadData()
              }
            }//end if StateDataSnapShot.childrenCount > 0
            
          })
          
        }
        // end if let firstSnapValue = first.value as? [String:AnyObject]
      }//end if snap.childrenCount > 0
    }
  }
}//end of class

//Mark: - UITableViewDataSource,UITableViewDelegate

extension jobsVc: UITableViewDataSource,UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isFiltering() {
        return filterJobsDataSource.count
    }else {
         return jobsDataSource.count
    }
   
    //return jobsDataArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if isFiltering() {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let product = filterJobsDataSource[indexPath.row]
        //let product = jobsDataArray[indexPath.row]
        cell.titleLabel.text = product.title
        cell.payPeriodLabel.text = product.payPeriod
        cell.jobCategoryLabel.text = product.jobCategory
        if let price = product.startPrice     { cell.startPriceLabel.text = "\(price)$" }
        cell.descriptionLabel.text = product.description
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.updateUIForJobs()
         return cell
    }else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let product = jobsDataSource[indexPath.row]
        //let product = jobsDataArray[indexPath.row]
        cell.titleLabel.text = product.title
        cell.payPeriodLabel.text = product.payPeriod
        cell.jobCategoryLabel.text = product.jobCategory
        if let price = product.startPrice     { cell.startPriceLabel.text = "\(price)$" }
        cell.descriptionLabel.text = product.description
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.updateUIForJobs()
        return cell
    }
    
   
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedProduct = jobsDataSource[indexPath.row]
    let productDetailSB = getStoryBoardByName(storyBoardNames.prodDetails)
    let controller = productDetailSB.instantiateViewController(withIdentifier: "ProductDetailVc") as! ProductDetailVc
    controller.productDetail = selectedProduct
    navigationController?.pushViewController(controller, animated: true)
    
    
  }
  
  
  
  
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableView.estimatedRowHeight
    
  }
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    let currentOffset = scrollView.contentOffset.y
    let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
    
    if maxOffset - currentOffset <= 40{
      //getDataOfJobs()
      fetchAndDisplayData(flagFirstTime: false)
    }
  }
  
}
