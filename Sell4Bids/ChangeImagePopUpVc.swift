//
//  ChangeImagePopUpVc.swift
//  Sell4Bids
//
//  Created by admin on 12/4/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
protocol ImageUrlDelegate {
    func dataChanged(UserImage: UIImage)
}

class ChangeImagePopUpVc: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
  //MARK:- Properties
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var takePhotoBtn: UIButton!
    @IBOutlet weak var selectPhotoBtn: UIButton!
    
  //MARK:- Vatiables
    var imagePicker = UIImagePickerController()
    var picker2 = UIImagePickerController()
    var selectedImageFromPicker: UIImage?
    var dbRef:DatabaseReference!
    var delegate: ImageUrlDelegate?
  //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       imagePicker.delegate = self
        popUpView.layer.cornerRadius  = 10
        popUpView.layer.masksToBounds = true
       // popUpView.layer.cornerRadius = 5.0
        popUpView.layer.borderColor = UIColor.red.cgColor
        popUpView.layer.borderWidth = 2.0
        //popUpView.layer.borderWidth = 2.0
        takePhotoBtn.layer.cornerRadius = 10
        takePhotoBtn.layer.masksToBounds = true
        selectPhotoBtn.layer.cornerRadius = 10
        selectPhotoBtn.layer.masksToBounds = true
        takePhotoBtn.layer.shadowOpacity = 0.5
        takePhotoBtn.layer.shadowRadius = 5
        takePhotoBtn.layer.masksToBounds = false
        selectPhotoBtn.layer.shadowOpacity = 0.5
        selectPhotoBtn.layer.shadowRadius = 5
        selectPhotoBtn.layer.masksToBounds = false
       
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
    func checkPermissionOfCamera(){
        
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized{
            
        }
        else{
            
            getPermission(type: "camera")
      
        }
        
        
    }
    func getPermission(type: String){
        let alert = UIAlertController(title: "\"Sell4Bids\" Would Like to Access the Camera", message: "This app requires access to camera.", preferredStyle: .alert)
        
        let dontAllow = UIAlertAction(title: "Don\'t Allow", style: .default, handler: nil)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            if type == "camera"{
                UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
            }
        }
        
        alert.addAction(dontAllow)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func takePhotoButtonTapped(_ sender: UIButton) {
        print("take Photo")
        
        var i = UserDefaults.standard.object(forKey: "isFirstCameraAccess") as? Bool
        
        if AVCaptureDevice.authorizationStatus(for: .video) != .authorized{
            if i != nil{
                // not first
                
                checkPermissionOfCamera()
            }
            else{
                //first
                
                
                if UIImagePickerController.isSourceTypeAvailable(.camera){
                    
                    imagePicker.sourceType = .camera
                    
                    // isFirst = false
                    UserDefaults.standard.set(false, forKey: "isFirstCameraAccess")
                    self.present(imagePicker, animated: true, completion: nil)
                    
                }
                else{
                    self.alert(message: "No camera availabe", title: "ERROR")
                }
                
                
            }
        }else{
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                
                imagePicker.sourceType = .camera
                
                //isFirst = false
                UserDefaults.standard.set(false, forKey: "isFirstCameraAccess")
                self.present(imagePicker, animated: true, completion: nil)
                
            }
            else{
                self.alert(message: "No camera availabe", title: "ERROR")
            }
        }
    }

    @IBAction func selectPhotoButtonTapped(_ sender: UIButton) {
        print("Select Photo")
     
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            self.imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            self.alert(message: "No photo library available", title: "ERROR")
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let editedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
         
            delegate?.dataChanged(UserImage: editedImage)
            uploadImage(profileImage: editedImage)
            
            
        }
      
        
        
    }
    func uploadImage(profileImage:UIImage){
     
        if  let currentUserid = Auth.auth().currentUser?.uid {
            dbRef = FirebaseDB.shared.dbRef.child("users").child(currentUserid)
            
        }
        let storageRef = Storage.storage().reference().child("image.jpg")
          let uploadImage = resizeImage(image: profileImage)
              //  UIImagePNGRepresentation(profileImage)
        
                print(profileImage.size)
            storageRef.putData(uploadImage, metadata: nil, completion: { (metadata, error) in
              guard error == nil else {
                self.alert(message: "Database error occured", title: "Image Could not be updated")
                return
              }
                  //print(metadata?.downloadURL())
              storageRef.downloadURL(completion: { (url, error) in
                
                if let imageUrl = url {
                  self.dbRef.child("image").setValue("\(imageUrl)")
                  self.alert(message: "Succuessfully Uploaded", title: "Edit profile")
                  
                }
              })
              
              
            })
            self.dismiss(animated: true, completion: nil)

                //dbRef.child("image").setValue(metadata.downloadUrl())
        

    }
    func resizeImage(image: UIImage) -> Data{
        var actualHeight:Float = Float(image.size.height)
        var actualWidth:Float = Float(image.size.width)
        var newHeight:Float = 0.0
        var newWidth:Float = 1000.0
        var compressionQuality:Float = 0.5;//50 percent compression
        var aspectRatio:Float = actualWidth/actualHeight
        newHeight = newWidth/aspectRatio
        var maxRatio:Float = newWidth/newHeight;
        
        if (actualHeight > newHeight || actualWidth > newWidth)
        {
            if(aspectRatio < maxRatio)
            {
                //adjust width according to maxHeight
                aspectRatio = newHeight / actualHeight;
                actualWidth = aspectRatio * actualWidth;
                actualHeight = newHeight;
            }
            else if(aspectRatio > maxRatio)
            {
                //adjust height according to maxWidth
                aspectRatio = newWidth / actualWidth;
                actualHeight = aspectRatio * actualHeight;
                actualWidth = newWidth;
            }
            else
            {
                actualHeight = newHeight;
                actualWidth = newWidth;
            }
        }
        
        var height = Double(actualHeight)
        var width = Double(actualWidth)
        
        
        var rect = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        var img = UIGraphicsGetImageFromCurrentImageContext()
        var imageData = UIImagePNGRepresentation(img!)
        UIGraphicsEndImageContext()
        return imageData!//UIImage(data: imageData ?? Data())!
        
        
        
        
        
    }
    
    
}
