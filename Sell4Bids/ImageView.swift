//
//  ImageView.swift
//  Sell4Bids
//
//  Created by admin on 11/10/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class ImageView: UIViewController{
    
    var image =  String()
    var userName = String()
    fileprivate func addDoneLeftBarBtn() {
        
        
        addLogoWithLeftBarButton()
        let doneBarBtn = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(backBtnTap))
        
        let button = UIButton.init(type: .custom)
        button.setImage( #imageLiteral(resourceName: "hammer_white")  , for: UIControlState.normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItems = [doneBarBtn , barButton ]
    }
    
   
    @IBOutlet weak var userImg: UIImageView!
    
    @objc func backBtnTap() {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        addInviteBarButtonToTop()
        if defaults.value(forKey: "UserImage") != nil {
            image = (defaults.value(forKey: "UserImage") as? String)!
            
        }
        
        if defaults.value(forKey: "UserName") != nil {
            userName = (defaults.value(forKey: "UserName") as? String)!
            
        }
        
        self.navigationItem.title = userName
        self.userImg.sd_setImage(with: URL(string: image ), placeholderImage: UIImage(named: "emptyImage" ))
        
       addDoneLeftBarBtn()
       
      
        // Do any additional setup after loading the view.
    }
    
  
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
