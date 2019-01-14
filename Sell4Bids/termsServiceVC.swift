//
//  termsServiceVC.swift
//  Sell4Bids
//
//  Created by admin on 4/14/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import WebKit

class termsServiceVC: UIViewController {
  
  var webView: WKWebView!
  var flagShowTerms_or_PrivacyPolicy = 0
  @IBOutlet weak var dimView: UIView!
  var imgFidget = UIImageView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var urlStr = "https://www.sell4bids.com/privacy-policy"
    if flagShowTerms_or_PrivacyPolicy == 0 {
      urlStr = "https://www.sell4bids.com/terms-and-conditions"
    }
    let myURL = URL(string: urlStr)
    let myRequest = URLRequest(url: myURL!)
    webView.load(myRequest)
    webView.navigationDelegate = self
    // Do any additional setup after loading the view.
    addDoneTabBarButtonToNav()
    imgFidget = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    imgFidget.center = CGPoint(x: 200 , y: 300 )
    self.view.addSubview(imgFidget)
    imgFidget.toggleRotateAndDisplayGif()
  }
  override func viewDidAppear(_ animated: Bool) {
    
  }
  
  func addDoneTabBarButtonToNav() {
    let barbutton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.barBtnInNavTapped))
    
    self.navigationItem.setLeftBarButton(barbutton, animated: true)
  }
  
  
  @objc func barBtnInNavTapped() {
    self.dismiss(animated: true, completion: nil)
  }
  
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

extension termsServiceVC: WKUIDelegate , WKNavigationDelegate{
  override func loadView() {
    
    let webConfiguration = WKWebViewConfiguration()
    webView = WKWebView(frame: .zero, configuration: webConfiguration)
    webView.uiDelegate = self
    view = webView
  }
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    DispatchQueue.main.async {
      self.imgFidget.isHidden = true
      
    }
  }
  
}


