/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import AVFoundation
import Alamofire
import SDWebImage

typealias Completion = (Bool) -> ()

class SearchResultsVC: UIViewController {
  
  @IBOutlet weak var noResultsView: NoResultsView!
  @IBOutlet weak var fidget: UIImageView!
  
  @IBOutlet weak var collectionView: UICollectionView!
  var products : [ProductModel]?
  var searchText : String?
  override var preferredStatusBarStyle : UIStatusBarStyle {
    return UIStatusBarStyle.lightContent
  }
  @IBOutlet weak var viewDim: UIView!
  
  var flagShowFidget = true
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    addLogoWithLeftBarButton()
    setupViews()
    showFidgetAfter2Seconds()
    downloadAndShowData()
    setupButtonsOfNoResultsView()
  
  }
  
  func showFidgetAfter2Seconds(){
    
    if #available(iOS 10.0, *) {
      Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] (timer) in
        guard let this = self else { return }
        DispatchQueue.main.async {
          this.fidget.isHidden = !this.flagShowFidget
        }
      }
    } else {
      // Fallback on earlier versions
    }
  }
  
  func setupViews() {
    if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
      layout.flagKeepHeaderHeightForHomeLayout = false
      layout.delegate = self
    }
    view.backgroundColor = UIColor.white
    self.title = self.searchText
    collectionView?.backgroundColor = UIColor.white
    collectionView?.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    view.backgroundColor = UIColor.white
    noResultsView.btnRight.addShadowAndRound()
    noResultsView.btnleft.addShadowAndRound()
    fidget.toggleRotateAndDisplayGif()
    showFidget(flag: false)
  }
  
  private func setupButtonsOfNoResultsView() {
    noResultsView.btnleft.setTitle("Home", for: .normal)
    noResultsView.btnRight.setTitle("Change", for: .normal)
    noResultsView.btnleft.addTarget(self, action: #selector(btnLeftNoResultsTapped), for: .touchUpInside)
    noResultsView.btnRight.addTarget(self, action: #selector(btnRightNoResultsTapped), for: .touchUpInside)
  }
  
  @objc private func btnLeftNoResultsTapped() {
    self.navigationController?.popToRootViewController(animated: true)
  }
  
  @objc private func btnRightNoResultsTapped() {
    self.navigationController?.popViewController(animated: true)
  }
  
  func downloadAndShowData() {
    toggleHideNoResults(flag: true)
    let searchVC = SearchVc()
    guard let text = searchText?.lowercased() else {
      return
    }
    dimBack(flag: true)
    searchVC.isResultAvailableForThisQuery(queryString: text) { (success) in
      if success {
        searchVC.observeResultAndReturnProductArray(queryString: text, completion: { [weak self] (success, productArray) in
          
          guard let this = self else { return }
          this.flagShowFidget = false
          this.dimBack(flag: false)
          this.showFidget(flag: false)
          guard success , let array = productArray, array.count > 0  else {
            this.toggleHideNoResults(flag: false)
            return
          }
          
          this.products = array
           
            this.downloadAndSaveImages(completion: { (success) in
                if success {
                    this.reloadColView()
                }
                
                
            })
        })
      
        
        
        
      }else {
        //result was not available
        let textEncoded = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let urlStr = "https://us-central1-sell4bids-4affe.cloudfunctions.net/searchResult?key=qwerty&queryString=\(textEncoded)"
        
        searchVC.callApiToGenerateResult(urlStr: urlStr, completion: { (success) in
          searchVC.observeResultAndReturnProductArray(queryString: text, completion: { [weak self] (success,productArray) in
            
            guard let this = self else { return }
            this.flagShowFidget = false
            this.dimBack(flag: false)
            this.showFidget(flag: false)
            guard success , let array = productArray, array.count > 0 else {
              this.noResultsView.layoutIfNeeded()
              this.toggleHideNoResults(flag: false)
              return
            }
            
            guard array.count > 0 else {
              this.toggleHideNoResults(flag: false)
              return
            }
            this.products = array
            
          })
        })
    
       
        
        
      }
        self.downloadAndSaveImages(completion: { (success) in
            if success {
                self.reloadColView()
            }
            
            
        })
    }
   
   
    
  }
  
  func toggleHideNoResults(flag: Bool) {
    DispatchQueue.main.async {
      self.noResultsView.isHidden = flag
    }
  }
  
  func downloadAndSaveImages( completion: @escaping Completion ) {
    //var i = 0
    print("product == \(self.products)")
    if self.products != nil {
    
  
    for product in self.products! {
        
      let photoIndex = self.products?.index(where: { (aProduct:ProductModel) -> Bool in
        return aProduct.imageUrl1 == product.imageUrl1
      })
      if let urlStr = product.imageUrl0 , let url = URL.init(string: urlStr) {
        let downloader = SDWebImageDownloader(sessionConfiguration: URLSessionConfiguration.ephemeral)
        downloader.downloadImage(with: url, options: SDWebImageDownloaderOptions.allowInvalidSSLCertificates, progress: nil) { (image_, data, error, success) in
          if let image = image_ {
            
            var array = [UIImage]()
            let cellSpacing :CGFloat = 8
            let numOfColumns :CGFloat = 3
            let scaledWidth = (self.view.frame.width / numOfColumns) - ( cellSpacing * numOfColumns )
            //scaling because images have large heights. e.g 720 x 1024 etc
            let scaledImage = imageWithImage(sourceImage: image, scaledToWidth:scaledWidth )
            array.append(scaledImage)
            self.products![photoIndex!].imagesArray = array
            
           
          completion(true)
            
          }else {
            self.products![photoIndex!].imagesArray?.insert(#imageLiteral(resourceName: "emptyImage"), at: 0 )
            completion(false)
          }
          
        }
        
      }else {
        completion(false)
        self.products![photoIndex!].imagesArray?.append(#imageLiteral(resourceName: "emptyImage"))
      }
    }
    }
  }
  
  func reloadColView() {
    let layout = self.collectionView?.collectionViewLayout as? PinterestLayout
    layout?.cache.removeAll()
    self.collectionView?.reloadData()
    layout?.finalizeLayoutTransition()
  }
  //helpers
  func dimBack(flag: Bool) {
    DispatchQueue.main.async {
      UIView.animate(withDuration: 0.3, animations: {
        //self.viewDim.alpha = flag ? 0.3 : 0
        
      })
    }
  }

  func showFidget(flag : Bool) {
    DispatchQueue.main.async {
      self.fidget.isHidden = !flag
    }
  }
  
}

//MARK:- UICollectionViewDataSource, UICollectionViewDelegate
extension SearchResultsVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
  
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let products = products else {
      return 0
    }
    return products.count
  }
  
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedPhotoCell", for: indexPath)
    guard var products = products  else {
      return cell
    }
    
    cell.layer.cornerRadius = 5
    cell.layer.masksToBounds = false
    cell.layer.shadowColor = UIColor.black.cgColor
    cell.layer.shadowOffset = CGSize(width: 1, height: 1)
    cell.layer.shadowOpacity = 0.6
    
    let product = products[indexPath.row]
    if let annotateCell = cell as? AnnotatedPhotoCell {
      
      annotateCell.mainContainerView.layer.cornerRadius = 5
      annotateCell.mainContainerView.clipsToBounds = true
      annotateCell.mainBidNowBtn.addShadowAndRound()
      
      if let imagesArray = product.imagesArray, imagesArray.count > 0 {
        annotateCell.mainImageView.image = imagesArray[0]
      }else {
        annotateCell.mainImageView.image = #imageLiteral(resourceName: "emptyImage")
      }
      //set label
      if let title = product.title {
        annotateCell.titleLabel.text = title
      }
      
      //setting price
      if let price = product.startPrice {
        
        if let auctionType = product.auctionType {
          if auctionType.lowercased().contains("buy") {
            annotateCell.mainBidNowBtn.setTitle("Buy at \(product.currency_symbol ?? "$")\(price)", for: .normal)
          }else {
            annotateCell.mainBidNowBtn.setTitle("Bid at \(product.currency_symbol ?? "$")\(price)", for: .normal)
          }
        }
        
      }
      
      annotateCell.mainBidNowBtn.backgroundColor = returnButtonColor(forProduct: product)
      annotateCell.mainBidNowBtn.tag = indexPath.item
      annotateCell.mainBidNowBtn.addTarget(self, action: #selector(self.bidNowBuyNowBtnTapped(_:)), for: .touchUpInside)
      
      
    }
    
    
    return cell
  }
  
  @objc func bidNowBuyNowBtnTapped( _ sender : UIButton ) {
    
    let indexPath = IndexPath.init(row: sender.tag, section: 0)
    guard let delegate = collectionView.delegate else { return  }
    delegate.collectionView!(collectionView, didSelectItemAt: indexPath)
    
  }
  
  func returnButtonColor(forProduct: ProductModel) -> UIColor {
    let colorRed = UIColor(red:255/255, green:27/255, blue:34/255, alpha:0.8)
    guard let timeRemaining = forProduct.timeRemaining , let endTime = forProduct.timeRemaining else {
      return colorRed
    }
    if timeRemaining < 0  && endTime != -1 {
      return UIColor(red:184/255, green:184/255, blue:184/255, alpha:1)
    }
    else {
      return  colorRed
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    guard let products = products else {
      
      return
    }
    let prodDetailsSB = getStoryBoardByName(storyBoardNames.prodDetails)
    let selectedProduct = products[indexPath.row]
    let controller = prodDetailsSB.instantiateViewController(withIdentifier: "ProductDetailVc") as! ProductDetailVc
    controller.productDetail = selectedProduct
    clearBackButtonText()
    navigationController?.pushViewController(controller, animated: true)
    
  }
}

//MARK: - PINTEREST LAYOUT DELEGATE
extension SearchResultsVC : PinterestLayoutDelegate {
  
  // 1. Returns the photo height
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
    
    guard let products = products else {
      return 250
    }
    guard let array = products[indexPath.item].imagesArray, array.count > 0 else {
      return 250
    }
    let photo = array[0]
    if photo.size.height == 0 {
      return 250
    }
    
    let height = photo.size.height
    //if height > 400 && height <= 600  { height = height * 0.5 }
    let lblNameHeight: CGFloat = 30
    let btnHeight : CGFloat = 40
    return height + lblNameHeight + btnHeight
    
  }
  
}

