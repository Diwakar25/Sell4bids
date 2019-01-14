//  ButtonBarExampleViewController.swift
//  XLPagerTabStrip ( https://github.com/xmartlabs/XLPagerTabStrip )
//
//  Copyright (c) 2017 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import XLPagerTabStrip

class mySell4BidsVC_XlPager: ButtonBarPagerTabStripViewController , UITabBarControllerDelegate , SWRevealViewControllerDelegate {
    
  
    var titleview = Bundle.main.loadNibNamed("NavigationBarMainView", owner: self, options: nil)?.first as! NavigationBarMainView
    

  
//    override func viewLayoutMarginsDidChange() {
//        navigationItem.titleView?.frame = CGRect(x: 2, y: 0, width: UIScreen.main.bounds.width, height: 40)
//    }
  
   
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
    
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    
    
    
    
    
    fileprivate func addDoneLeftBarBtn() {
        
        
        addLogoWithLeftBarButton()
        let button = UIButton.init(type: .custom)
        button.setImage( #imageLiteral(resourceName: "hammer_white")  , for: UIControlState.normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItems = [btnMenuButton, barButton ]
    }
    
    
    
    
     @IBOutlet weak var searchBarTop: UISearchBar!
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
    
  var isReload = false
  var controllers : [UIViewController] = [UIViewController]()
    lazy var mikeImgForSpeechRec = UIImageView(frame: CGRect(x: 0, y: 0, width: 0,height: 0))
    
    
    @IBAction func filterbtn(_ sender: Any) {
       
    
        
        isfilterclicked = true
        
        tabBarController?.selectedIndex = 0
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        isfilterclicked = false
        print("Disappear")
       
    }
    
 
  override func viewDidLoad() {
    super.viewDidLoad()
   
    
     buttonBarView.move(fromIndex: 0, toIndex: 0, progressPercentage: 1, pagerScroll: .no)
    
    self.buttonBarView.addShadowView()
    self.navigationItem.titleView = titleview
    titleview.citystateZIpcode.text = "\(city), \(stateName) \(zipCode)"
    titleview.searchBarButton.addTarget(self, action: #selector(searchbtnaction), for: .touchUpInside)
    titleview.filterbtn.addTarget(self, action: #selector(filterbtnaction), for: .touchUpInside)
    titleview.inviteBtn.addTarget(self, action:  #selector(self.inviteBarBtnTapped), for: .touchUpInside)
    titleview.micBtn.addTarget(self, action:  #selector(mikeTapped), for: .touchUpInside)
 // addDoneLeftBarBtn()
   // addInviteBarButtonToTop()
    mikeImgForSpeechRec.image = UIImage(named: "mike")
    
    searchBarTop.delegate = self
    searchBarTop.setImage(mikeImgForSpeechRec.image, for: .bookmark, state: .normal)
    
//      addGestureToMike()
    
   
    
    searchBarTop.showsBookmarkButton = true
    
    
//    navigationItem.titleView = searchBarTop
    
    if (self.revealViewController()?.delegate = self) != nil {
        self.revealViewController().delegate = self
    }
    
//    btnMenuButton.target = revealViewController()
//    btnMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))

    
    titleview.menuBtn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside); self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    
    setupMySell4BidsTopBar()
    setupViews()
   
    

  }
    
 
    
  private func setupViews() {
    //addDoneLeftBarBtn()
    //addInviteBarButtonToTop()
    
    clearBackButtonText()
    self.title = "MySell4Bids"
  }
  
 
  @objc func barBtnInNavTapped() {
    self.tabBarController?.selectedIndex = 0
  }
  func setupMySell4BidsTopBar () {
    
    changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
        guard changeCurrentIndex == true else { return }
        
        oldCell?.label.textColor = UIColor.black
        newCell?.label.textColor = UIColor.red
        
        if animated {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            })
        }
        else {
            newCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            oldCell?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
    
   settings.style.buttonBarItemBackgroundColor =  UIColor.white
    settings.style.buttonBarItemTitleColor = UIColor.black
    let size :CGFloat = Env.isIpad ? 20 : 20
    settings.style.buttonBarItemFont = UIFont.boldSystemFont(ofSize: size)
    buttonBarView.selectedBar.backgroundColor = UIColor.red
    
   // buttonBarView.backgroundColor =  UIColor(red:1.00, green:0.90, blue:0.90, alpha:1.0)
  }
  // MARK: - PagerTabStripDataSource
  
   
  override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    
    let chatSB = getStoryBoardByName(storyBoardNames.chat)
    //My Chat
    let controllerChat = chatSB.instantiateViewController(withIdentifier: "MyChatList") as! MyChatListVC
    controllerChat.view.layer.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.width, height: self.containerView.frame.height)
    controllerChat.nav = self.navigationController
    controllerChat.flagUsedInMySell4Bids = true
    controllerChat.title = "My Chat"
    self.controllers.append(controllerChat)
  
    
    
    //My Watch List
    let watchListSB = getStoryBoardByName(storyBoardNames.myWatchListSB)
    let watchListVC = watchListSB.instantiateViewController(withIdentifier: "ActiveWatchListVc") as! ActiveWatchListVc
    watchListVC.nav = self.navigationController
    watchListVC.title = "Watch List"
    self.controllers.append(watchListVC)
    
    
    //Selling
    let controllerSelling = self.storyboard?.instantiateViewController(withIdentifier: "MySellVc") as! SellingVC
    controllerSelling.nav = self.navigationController
    controllerSelling.title = "Selling"
    self.controllers.append(controllerSelling)
    
    
  
    
    
    //Buying and Bids
    let controllerBids = self.storyboard?.instantiateViewController(withIdentifier: "BidsVc") as! BuyingAndBidsVC
    controllerBids.nav = self.navigationController
    controllerBids.title = "Buying & Bids"
    self.controllers.append(controllerBids)

   
    
    //Bought and Wins
    let controllerBoughts = self.storyboard?.instantiateViewController(withIdentifier:"BoughtAndWinsVc") as! BoughtAndWinsVc
    controllerBoughts.nav = self.navigationController
    controllerBoughts.title = "Bought & Wins"
    self.controllers.append(controllerBoughts)

    //Followers
    let controllerFollowers = self.storyboard?.instantiateViewController(withIdentifier: "FollowersVc") as! FollowersVc
    controllerFollowers.nav = self.navigationController
    controllerFollowers.title = "Followers"
    self.controllers.append(controllerFollowers)

    //Following
    let controllerFollowing = self.storyboard?.instantiateViewController(withIdentifier: "FollowingVc") as! FollowingVc
    controllerFollowing.nav = self.navigationController
    controllerFollowing.title = "Following"
    self.controllers.append(controllerFollowing)

    //Block list
    let controllerBlockedUsers = self.storyboard?.instantiateViewController(withIdentifier: "BlockUserVc") as! BlockUserVc
    controllerBlockedUsers.nav = self.navigationController
    controllerBlockedUsers.title = "Block List"
    self.controllers.append(controllerBlockedUsers)
  
    //My profile.
//    let mainSB = getStoryBoardByName(storyBoardNames.main)
//    let myProfileVC = mainSB.instantiateViewController(withIdentifier: "UserProfileVc") as! SellerProfileVC
//    myProfileVC.nav = self.navigationController
//    myProfileVC.title = "My Profile"
//    self.controllers.append(myProfileVC)
    
    
    return self.controllers
  }
  
    
 

  override func reloadPagerTabStripView() {
    isReload = true
   
    if arc4random() % 2 == 0 {
      pagerBehaviour = .progressive(skipIntermediateViewControllers: arc4random() % 2 == 0, elasticIndicatorLimit: arc4random() % 2 == 0 )
    } else {
      pagerBehaviour = .common(skipIntermediateViewControllers: arc4random() % 2 == 0)
    }
    super.reloadPagerTabStripView()
    
  }
   
    
    
}

extension mySell4BidsVC_XlPager: UISearchBarDelegate{
    
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



