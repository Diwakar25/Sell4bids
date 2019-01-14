//
//  CategoryListViewController.swift
//  Sell4Bids
//
//  Created by admin on 9/9/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class CategoriesListVc: UIViewController,SWRevealViewControllerDelegate {
  
  //MARK: - Properties
  var flagFilterApplied = false
  @IBOutlet weak var tableView: UITableView!
  
  var categoryImageDict : Dictionary<String, UIImage>!
  //MARK: - Variables
  var categoriesData : [String:[ProductModel]] = [:]
    
    @IBOutlet weak var searchBarTab: UISearchBar!
     lazy var mikeImgForSpeechRec = UIImageView(frame: CGRect(x: 0, y: 0, width: 0,height: 0))
    
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    
    @IBAction func Fiterbtn(_ sender: Any) {
        isfilterclicked = true
        
        tabBarController?.selectedIndex = 0
        
    }
    
    
    @IBAction func InviteBtn(_ sender: Any) {
        let items =  [shareString, urlAppStore] as [ Any ]
        let activityVC = UIActivityViewController(activityItems: items , applicationActivities: [])
        //activityVC.popoverPresentationController?.sourceView = sender
        if let popoverController = activityVC.popoverPresentationController{
            popoverController.barButtonItem = sender as! UIBarButtonItem
            popoverController.permittedArrowDirections = .up
        }
        self.present(activityVC, animated:true , completion: nil)
        
        
    }
    fileprivate func addDoneLeftBarBtn() {
        
        
        addLogoWithLeftBarButton()
        let button = UIButton.init(type: .custom)
        button.setImage( #imageLiteral(resourceName: "hammer_white")  , for: UIControlState.normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItems = [btnMenuButton, barButton ]
    }
    @objc func mikeTapped() {
        print("ahmed---090")
        let searchSB = getStoryBoardByName(storyBoardNames.searchVC)
        let searchVC = searchSB.instantiateViewController(withIdentifier: "SearchVC") as! SearchVc
        searchVC.flagShowSpeechRecBox = true
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    private func addGestureToMike() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(mikeTapped))
        mikeImgForSpeechRec.addGestureRecognizer(tap)
    }
    
    @objc func searchbtnaction() {
        let searchVCStoryBoard = getStoryBoardByName(storyBoardNames.searchVC)
        let searchVC = searchVCStoryBoard.instantiateViewController(withIdentifier: "SearchVC")
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.pushViewController(searchVC, animated: true)
        
    }
    
    @objc func filterbtnaction() {
        
        isfilterclicked = true
        
        tabBarController?.selectedIndex = 0
        
    }

    
    
    var titleview = Bundle.main.loadNibNamed("NavigationBarMainView", owner: self, options: nil)?.first as! NavigationBarMainView
    
  
    
    override func viewLayoutMarginsDidChange() {
        navigationItem.titleView?.frame = CGRect(x: 2, y: 0, width: UIScreen.main.bounds.width, height: 40)
    }
    
    

    
  override func viewDidLoad() {
    
    super.viewDidLoad()
//    addGestureToMike()
//    addDoneLeftBarBtn()
    
   
    self.navigationItem.titleView = titleview
    titleview.citystateZIpcode.text = "\(city), \(stateName) \(zipCode)"
    titleview.searchBarButton.addTarget(self, action: #selector(searchbtnaction), for: .touchUpInside)
    titleview.filterbtn.addTarget(self, action: #selector(filterbtnaction), for: .touchUpInside)
    titleview.inviteBtn.addTarget(self, action:  #selector(self.inviteBarBtnTapped), for: .touchUpInside)
    titleview.micBtn.addTarget(self, action: #selector(mikeTapped), for: .touchUpInside)
    
    print("Sorted Categories == \(categoriesArray)")
    mikeImgForSpeechRec.image = UIImage(named: "mike")
    
//    searchBarTab.setImage(mikeImgForSpeechRec.image, for: .bookmark, state: .normal)
//    
//    
//   searchBarTab.showsBookmarkButton = true
//    
//    
//    searchBarTab.setImage(mikeImgForSpeechRec.image, for: .bookmark, state: .normal)
//    
//    
//    navigationItem.titleView = searchBarTab
    
    if (self.revealViewController()?.delegate = self) != nil {
        self.revealViewController().delegate = self
    }
    
    titleview.menuBtn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)) , for: .touchUpInside)
   
//    btnMenuButton.target = revealViewController()
//    btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
    self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
   // addInviteBarButtonToTop()
    
    tableView.estimatedRowHeight = 70
    //we need to filter the categories. Names of categories are filtered using available function filter. but need to filter images also, so make a dictionary with key category name and value its images
    categoryImageDict = Dictionary()
    for (index , catName) in categoriesArray.enumerated(){
        print("Image INdex == \(index)")
        print("CatName == \(catName)")
      categoryImageDict[catName] = categoriesImagesArray[index]
    }
    
    //removing back text and changing the color of black icon
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem?.tintColor = UIColor.white
   // addDoneTabBarButtonToNav()
  }
  
  func addDoneTabBarButtonToNav() {
    
    let barbuttonHome = UIBarButtonItem(title: "Home", style: .done, target: self, action: #selector(self.barBtnInNavTapped))
    barbuttonHome.tintColor = UIColor.white
    
    let button = UIButton.init(type: .custom)
    button.setImage( #imageLiteral(resourceName: "hammer_white")  , for: UIControlState.normal)
    button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20) //CGRectMake(0, 0, 30, 30)
    let barButton = UIBarButtonItem.init(customView: button)
    
    self.navigationItem.leftBarButtonItems = [barbuttonHome, barButton]
  }
  
  
  @objc func barBtnInNavTapped() {
    tabBarController?.selectedIndex = 0
  }
  
  
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension  CategoriesListVc: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
        return categoriesArray.count
  
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell
    
    let currentCategory = categoriesArray[indexPath.row]
    print("Image Name == \(currentCategory)")
    cell.lblText.text = currentCategory
    cell.tableViewImage.image = categoryImageDict[currentCategory]
    print("Category Name == \(String(describing: categoryImageDict[currentCategory]))")
    cell.tableViewImage.contentMode = .scaleAspectFit
    cell.selectionStyle = UITableViewCellSelectionStyle.none
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let selectedCat = categoriesArray[indexPath.row]
    if  selectedCat == "Jobs" {
      
      let controller = storyboard?.instantiateViewController(withIdentifier: "jobsVc") as! jobsVc
      controller.categoryName = selectedCat
      controller.flagWasPushed = true
      navigationController?.pushViewController(controller, animated: true)
    }
    else  {
      let controller = storyboard?.instantiateViewController(withIdentifier: "CategoryDetailVC") as! CategoryDetailVC
      controller.categoryName = selectedCat
      navigationController?.pushViewController(controller, animated: true)
    }
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if Env.isIphoneSmall { return 60 }
    else if Env.isIphoneMedium { return 65 }
    return 70
  }
  
  
}

extension CategoriesListVc : UISearchBarDelegate {
   
        
        func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
            let searchVCStoryBoard = getStoryBoardByName(storyBoardNames.searchVC)
            let searchVC = searchVCStoryBoard.instantiateViewController(withIdentifier: "SearchVC")
            self.navigationController?.view.backgroundColor = UIColor.clear
            self.navigationController?.pushViewController(searchVC, animated: true)
            
            return false
        }
        
        func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
            mikeTapped()
        }
    }

