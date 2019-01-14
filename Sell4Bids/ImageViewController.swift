//
//  ImageViewController.swift
//  Sell4Bids
//
//  Created by admin on 11/10/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
var userData:UserModel?
    
    @IBOutlet weak var userImg: UIImageView!
    
  
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        print("asdfasdfasdf")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
        
        guard let userData = self.userData else { return }
       
       
        self.userImg.sd_setImage(with: URL(string: userData.image ?? ""), placeholderImage: UIImage(named: "emptyImage" ))

        print("Image == \(String(describing: userData.image))")
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
