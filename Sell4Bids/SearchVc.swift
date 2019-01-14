 //
//  SearchVc.swift
//  Sell4Bids
//
//  Created by admin on 12/8/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase
import Speech
import Alamofire
 @available(iOS 10.0, *)
 class SearchVc: UIViewController {
  //MARK:- Properties
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var emptyProductMessage: UILabel!
  @IBOutlet weak var imgVIew: UIImageView!
  @IBOutlet weak var fidgetImageView: UIImageView!
  @IBOutlet weak var tableView : UITableView!
  //@IBOutlet weak var searchBar: UISearchBar!
    var searchBar = UISearchBar()
  //MARK:- Variables
    
    
    //new Search bar implementation Ahmed Baloch 11/1/2019
    
    //Mic btn
    @objc func mikeTapped() {
        let searchSB = getStoryBoardByName(storyBoardNames.searchVC)
        let searchVC = searchSB.instantiateViewController(withIdentifier: "SearchVC") as! SearchVc
        searchVC.flagShowSpeechRecBox = true
        self.navigationController?.pushViewController(searchVC, animated: false)
    }
    

    //Filter Btn Ahmed Baloch 11/1/2019
    @objc func filterbtnaction() {
      
    }

    
    //invite btn Ahmed baloch 11/1/2019
    
    @objc func invitebtnaction(_ sender : AnyObject) {
        let items =  [shareString, urlAppStore] as [ Any ]
        let activityVC = UIActivityViewController(activityItems: items , applicationActivities: [])
        activityVC.popoverPresentationController?.sourceView = sender as! UIView
        if let popoverController = activityVC.popoverPresentationController{
            popoverController.barButtonItem = sender as? UIBarButtonItem
            popoverController.permittedArrowDirections = .up
        }
        self.present(activityVC, animated:false , completion: nil)
    }

    
    
    
    
    
    
    
    
  
  @IBOutlet weak var viewVoiceSearch: UIView!
  var dbRef: DatabaseReference!
  var databaseHandle:DatabaseHandle?
  var searchString:String!
  lazy var suggestionProductArray = [ProductModel]()
  var flagShowSpeechRecBox = false
  var flagSpeechRecBoxShowing = false
  var titleview = Bundle.main.loadNibNamed("SearchbarCustomView", owner: self, options: nil)?.first as! CustomSearchView
  //Constraints4
  ///0, 2000 for showing/hiding
  @IBOutlet weak var CenterViewSpeechRecBox: NSLayoutConstraint!
  
  @IBOutlet weak var viewDim: UIView!
 
  @IBOutlet weak var lblTapToGetStarted: UILabel!
  @IBOutlet weak var imgMicrophone: UIImageView!
  @IBOutlet weak var imgFidget: UIImageView!
  var mikeImgForSpeechRec = UIImageView(frame: CGRect(x: 20, y: 0, width: 50, height: 50))
    
    

   
    override func viewLayoutMarginsDidChange() {
       navigationItem.titleView?.frame = CGRect(x: 3, y: 0, width: UIScreen.main.bounds.width, height: 40)
    }
    
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    
 navigationItem.hidesBackButton = true

    searchBar = titleview.SearchBar
    searchBar.delegate = self
    
  
   //Implemented Btn function in Top Bar Ahmed Baloch 11/1/2019
    
   // titleview.filterbtn.addTarget(self, action: #selector(filterbtnaction), for: .touchUpInside)
    titleview.invitebtn.addTarget(self, action:  #selector(self.inviteBarBtnTapped), for: .touchUpInside)
    
    titleview.micbtn.addTarget(self, action:  #selector(mikeTapped), for: .touchUpInside)
   
    
    
    
    
    
    searchBar.backgroundColor = UIColor.clear
    navigationItem.titleView = titleview

    //addLogoWithLeftBarButton()
    dbRef = FirebaseDB.shared.dbRef
    
    collectionView.backgroundColor = .clear
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    addGestureToMike()
    setupViews()
    if flagShowSpeechRecBox {
      toggleShowBoxSpeechRec(flag : true)
      startSpeechRecognition()
    }else {
      searchBar.becomeFirstResponder()
      toggleShowBoxSpeechRec(flag: false)
    }
    DispatchQueue.main.async {
      self.title = "Search Anything!"
    }
    
    //Side Menu Properties
    if (self.revealViewController()?.delegate = self as? SWRevealViewControllerDelegate) != nil {
        self.revealViewController().delegate = self as? SWRevealViewControllerDelegate
        
        
        self.titleview.menubtn.addTarget( revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        //  titleview.menuBtn.target = revealViewController()
        //    titleview.menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
    }
    
  }
  
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        mikeTapped()
    }
  override func viewWillAppear(_ animated: Bool) {
    
    enableIQKeyBoardManager(flag: false)
  }
  
  
  override func viewWillDisappear(_ animated: Bool) {
    enableIQKeyBoardManager()
    timer.invalidate()
    
  }
  private func setupViews() {
    fidgetImageView.toggleRotateAndDisplayGif()
    DispatchQueue.main.async {
      self.fidgetImageView.isHidden = true
    }
    viewVoiceSearch.addShadowAndRound()
    navigationItem.title  = searchString
    
    // Do any additional setup after loading the view.
  
    
    //searchBar.setImage(UIImage(), for: .clear, state: .normal)
    
    
    //CenterViewSpeechRecBox.constant = 2000
  }
  
  private func addGestureToMike() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(mikeTapped))
    mikeImgForSpeechRec.addGestureRecognizer(tap)
  }


  
  private func startSpeechRecognition() {
    requestVoicePermission(completion: { (granted) in
      if granted {
        if !self.flagSpeechRecBoxShowing { self.toggleShowBoxSpeechRec(flag: true) }
        
        self.recordAndRecognizeSpeec()
        self.lblTapToGetStarted.text = "Listening ...."
        
        //searchBar.isUserInteractionEnabled = false
        self.tableView.isUserInteractionEnabled = false
        self.toggleDimBack(flag: true)
        
      }
    })
  }

  private func toggleDimBack(flag : Bool) {
    if flag {
      DispatchQueue.main.async {
        self.viewDim.alpha = 0.3
      }
    }else {
      DispatchQueue.main.async {
        self.viewDim.alpha = 0
      }
    }
  }
  
  private func toggleShowBoxSpeechRec(flag : Bool) {
    if flag {
      //show
      CenterViewSpeechRecBox.constant = 0
      DispatchQueue.main.async {
        self.searchBar.resignFirstResponder()
        self.view.endEditing(true)
      }
      flagSpeechRecBoxShowing = true
      toggleDimBack(flag: true)
      self.tableView.isUserInteractionEnabled = false
      
    }else {
      flagSpeechRecBoxShowing = false
      CenterViewSpeechRecBox.constant = 2000
      toggleDimBack(flag: false)
      tableView.isUserInteractionEnabled = true
    }
    UIView.animate(withDuration: 0.3) {
      //DispatchQueue.main.async {
      self.view.layoutIfNeeded()
      //}
    }
  }
  
  func emptyProMessage() {
    
    emptyProductMessage.text = "No Product Found"
    
    if suggestionProductArray.count > 0{
      collectionView.isHidden = false
      imgVIew.isHidden = true
      emptyProductMessage.isHidden = true
    }
    else {
      collectionView.isHidden = true
      imgVIew.isHidden = false
      emptyProductMessage.isHidden = false
    }
  }
  
  @objc func bidNowBtnnTapped(_ sender: UIButton) {
    
    let indexPathRow = sender.tag
    let selectedProduct = suggestionProductArray[indexPathRow]
    let controller = storyboard?.instantiateViewController(withIdentifier: "ProductDetailVc") as! ProductDetailVc
    
    controller.productDetail = selectedProduct
    navigationController?.pushViewController(controller, animated: true)
  }
  
  //MARK:- Touches
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first
    if flagSpeechRecBoxShowing {
      if touch?.view == imgMicrophone {
        imgMicrophone.alpha = 1
        recordAndRecognizeSpeec()
        lblTapToGetStarted.text = "Listening"
      }else if touch?.view != viewVoiceSearch && flagSpeechRecBoxShowing {
        toggleShowBoxSpeechRec(flag: false)
      }
    }
    
  }
 
  private func toggleShowTVSearchSugg (flag : Bool) {
    if flag {
      DispatchQueue.main.async {
        
      }
    }
  }
  //////////      Speech Recognition Code      /////////
  /////////////////////////////////////////////////////
  var speechRecognized = false
  //First, an instance of the AVAudioEngine class.
  // This will process the audio stream. It will give updates when the mic is receiving audio.
  var audioEngine = AVAudioEngine()
  //second, an instance of the speech recognizer. This will do the actual speech recognition. It can fail to recognize speech and return nil, so it’s best to make it an optional
  var speechReocognizer : SFSpeechRecognizer? = SFSpeechRecognizer()
  // By default, the speech recognizer will detect the devices locale and in response recognize the language appropriate to that geographical location
  // The default language can also be set by passing in a locale argument and identifier. Like this: let speechRecognizer: SFSpeechRecognizer(locale: Locale.init(identifier: "en-US")) .
  
  //Third, recognition request as SFSpeechAudioBufferRecognitionRequest. This allocates speech as the user speaks in real-time and controls the buffering. If the audio was pre-recorded and stored in memory you would use a SFSpeechURLRecognitionRequest instead.
  
  var request = SFSpeechAudioBufferRecognitionRequest()
  //Fourth, an instance of recognition task. This will be used to manage, cancel, or stop the current recognition task.
  var recognitionTask: SFSpeechRecognitionTask?
  
  //5. will perform the speech recognition. It will record and process the speech as it comes in.
  
  //audio engine uses what are called nodes to process bits of audio. Here .inputNode creates a singleton for the incoming audio. by apple "Nodes have input and output busses, which can be thought of as connection points"
  var recognizedTest = ""
  //MARK: Speech Recognition
  private func requestVoicePermission( completion: @escaping (Bool) -> () )  {
    
    //imgMicrophone.isUserInteractionEnabled = false
    //    if !AVAudioSession.sharedInstance().recor>dPermission() == AVAudioSessionRecordPermission.granted {
    let recordingSession = AVAudioSession()
    do {
      
      try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
      switch recordingSession.recordPermission() {
      case AVAudioSessionRecordPermission.granted:
        print("Permission granted")
        SFSpeechRecognizer.requestAuthorization({ (authStatus) in
          OperationQueue.main.addOperation {
            switch authStatus {
            case .authorized:
              //self.recordButton.isEnabled = true
              completion(true)
            case .denied:
              completion(false)
              self.showToast(message: "Speech Recognition Permission not granted.")
            case .restricted:
              self.showToast(message: "Speech Recognition Permission Restricted.")
              completion(false)
            case .notDetermined:
              self.showToast(message: "Speech Recognition Permission not Determined.")
              completion(false)
            }
          }
        })
        
      //recordAndRecognizeSpeec()
      case AVAudioSessionRecordPermission.denied:
        
        print("user had denied Pemission earlier")
        let title = "Microphone permission not found"
        let mess = "Go to Settings -> Privacy -> Microphone, find Sell4Bids and tap on the switch to allow microphone to process your voice."
        let alert = UIAlertController(title: title, message: mess, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
          alert.dismiss(animated: true, completion: nil)
          completion(false)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
      case AVAudioSessionRecordPermission.undetermined:
        
        print("Request permission here")
        
        // Handle granted
        recordingSession.requestRecordPermission(){ (allowed) in
          if allowed {
            SFSpeechRecognizer.requestAuthorization({ (authStatus) in
              OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                  //self.recordButton.isEnabled = true
                  completion(true)
                case .denied:
                  completion(false)
                  self.showToast(message: "Speech Recognition Permission not granted.")
                case .restricted:
                  self.showToast(message: "Speech Recognition Permission Restricted.")
                  completion(false)
                case .notDetermined:
                  self.showToast(message: "Speech Recognition Permission not Determined.")
                  completion(false)
                }
              }
            })
            //print("Granted")
            //completion(true)
            
          } else {
            print("Denied")
            self.showToast(message: "Permission Denied.")
            
            //let alert = UIAlertController(title: "We need your permission to process your Speech", message: "Go to Settings -> Privacy -> Microphone, find SHOPnROAR and tap on the switch to allow speech recognition.", preferredStyle: .alert)
            //            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            //              alert.dismiss(animated: true, completion: nil)
            //              completion(false)
            //            }))
            //            self.present(alert, animated: true, completion: nil)
          }
          
        }
        
      }
    } catch {
      print("try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord) failed")
    }
    
    //}
    
    
  }
  var timer = Timer()
  private func recordAndRecognizeSpeec() {
    
    audioEngine = AVAudioEngine()
    speechReocognizer = SFSpeechRecognizer()
    request = SFSpeechAudioBufferRecognitionRequest()
    recognitionTask = SFSpeechRecognitionTask()
    let node = audioEngine.inputNode
    let recordingFormat = node.outputFormat(forBus: 0)
    //InstallTap configures the node and sets up the request instance with the proper buffer on the proper bus.
    node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
      self.request.append(buffer)
    }
    
    
    toggleDimBack(flag: true)
    //When user did not speak for for seconds
    timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { (timer) in
      //utilityFunctions.hide(view: self.imgFidget)
      print("4 seconds have been passed and you did not speak")
      self.lblTapToGetStarted.text = "Sorry, we did'nt get that. Tap on the microphone to try Again."
      self.imgMicrophone.alpha = 0.3
      self.imgMicrophone.isUserInteractionEnabled = true
      //self.lblTapToGetStarted.text = ""
      //self.recognitionTask?.finish()
      self.audioEngine.stop()
//      self.recognitionTask?.cancel()
      let node = self.audioEngine.inputNode
      node.removeTap(onBus: 0)

    }
    
    audioEngine.prepare()
    do{
      
      try audioEngine.start()
      //Then, make a few more checks to make sure the recognizer is available for the device and for the locale, since it will take into account location to get language
      guard  let myRecognizer = SFSpeechRecognizer() else {
        
        return
      }
      if !myRecognizer.isAvailable{
        //recognier not available right now
        print("recognizer not available")
        return
        
      }
      
      //Next, call the recognitionTask method on the recognizer. This is where the recognition happens.
      var timerDidFinishTalk = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (timer) in
        
      })
      
      recognitionTask = speechReocognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
        guard let result = result else {
          print("There was an error: \(error!)")
          return
        }
        //user spoke before 4 seconds of silence
        //print("inside recognition task handler with result : \(result.bestTranscription.formattedString)")
        if self.timer.isValid { self.timer.invalidate() }
        
        timerDidFinishTalk.invalidate()
        
        timerDidFinishTalk = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
          
         // showSwiftMessageWithParams(theme: .success, title: "Speech Recognized", body: "Successfully Recognized your speech")
          self.imgFidget.hide()
          self.toggleShowBoxSpeechRec(flag: false)
          let searchText = result.bestTranscription.formattedString
          DispatchQueue.main.async {
            self.lblTapToGetStarted.text = "Successfully recognized your speech."
            self.searchBar.text = searchText
            self.searchBar(self.searchBar, textDidChange: searchText)
            
          }
          self.toggleShowTVSearchSugg(flag: true)
          
          self.speechRecognized = true
          self.recognitionTask?.finish()
          node.removeTap(onBus: 0)
          self.request.endAudio()
          //self.request = nil
          self.recognitionTask = nil
          self.audioEngine.stop()
          
        })
        
        
      
          
          
        
        
      })
    }catch{
      print("let result = result failed")
      return print(error)
    }
  }
  
  private func stopSpeechRecognition(){
    self.lblTapToGetStarted.text = "Stopping Speech Recognition"
    self.request.endAudio()
    self.audioEngine.stop()
    
    let node = audioEngine.inputNode
    node.removeTap(onBus: 0)
    
    
  }
  
}
 
@available(iOS 10.0, *)
var timer: Timer?
 
 extension SearchVc: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
  
    timer.invalidate()
    if searchText.isEmpty {
      self.suggestionProductArray.removeAll()
      tableView.reloadUsingDispatch()
      collectionView.reloadUsingDispatch()
    }else {
      if searchText.count > 3 {
        timer  = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
          self.searchSuggestionList(searchText: searchText.lowercased(), flagShowColView: false)
        }
      }
    }
    
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if !(searchBar.text?.isEmpty)! {
      
      let searchResultsVC = storyboard?.instantiateViewController(withIdentifier: "SearchResultsVC") as! SearchResultsVC
      searchResultsVC.searchText = searchBar.text!.lowercased()
      self.navigationController?.pushViewController(searchResultsVC, animated: true)
      
    }
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    
    collectionView.alpha = 1
  }
  
  ///search database for search string and show results
  func searchSuggestionList(searchText: String, flagShowColView: Bool){
    
    toggleDimBack(flag: true)
    DispatchQueue.main.async {
      self.fidgetImageView.isHidden = false
    }
    isResultAvailableForThisQuery(queryString: searchText) { [weak self] (resultExists: Bool) in
      guard let this = self else { return }
      if resultExists {
        //observe the result
        this.observeResultAndReturnProductArray(queryString: searchText, completion: { [weak self] (success, productArray) in
          
          this.toggleDimBack(flag: false)
          DispatchQueue.main.async {
            this.fidgetImageView.isHidden = true
          }
          
          guard success , let productArray = productArray, let thisInner = self else { return }
          thisInner.suggestionProductArray.removeAll()
          thisInner.suggestionProductArray = productArray
          
          DispatchQueue.main.async {
            thisInner.tableView.reloadData()
            thisInner.tableView.isHidden = flagShowColView
            thisInner.collectionView.isHidden = !flagShowColView
            thisInner.collectionView.reloadData()
          }
        })
      }else {
        //call API and then observe the result
        let textEncoded = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let urlStr = "https://us-central1-sell4bids-4affe.cloudfunctions.net/searchResult?key=qwerty&queryString=\(textEncoded)"
        //call the api, upon completion, call
        this.callApiToGenerateResult(urlStr: urlStr, completion: { (success) in
          if success {
            //print("SUCCESS. Api call to generate results succeeded")
            
            this.observeResultAndReturnProductArray(queryString: searchText, completion: { [weak self] (success, productArray) in
              
              guard let this = self else { return }
              
              this.toggleDimBack(flag: false)
              DispatchQueue.main.async {
                this.fidgetImageView.isHidden = true
              }
              guard success, let array = productArray else {
                showSwiftMessageWithParams(theme: .info, title: "Search Results", body: "No Suggestions Found. Try Changing keywords")
                return
              }
              
              this.suggestionProductArray.removeAll()
              this.suggestionProductArray = array
              
              DispatchQueue.main.async {
                this.tableView.reloadData()
              }
            })
          }else{
           //api to generate result failed
            print("ERROR: API To Generate result Failed ")
            DispatchQueue.main.async {
              this.fidgetImageView.isHidden = true
            }
            this.toggleDimBack(flag: false)
            
          }
        })
        
      }
    }
    

  }
  func callApiToGenerateResult(urlStr: String, completion: @escaping (Bool) -> () ) {
    guard let url = URL.init(string: urlStr) else { return }
    let request = Alamofire.request(url)
    request.responseString { (dataResponse) in
      //print(dataResponse.result)
      let statusCode = dataResponse.response?.statusCode
      if statusCode == 200 {
        completion(true)
      }else {
        completion(false)
      }
      //print(dataResponse.response?.statusCode as Any)
      
    }
  }
  
  
  func observeResultAndReturnProductArray(queryString: String, completion: @escaping (Bool,[ProductModel]? ) ->() ) {
    
    let ref = FirebaseDB.shared.dbRef.child("result").child(queryString)
    
    var resultsProductArray : [ProductModel]?
    ref.observeSingleEvent(of: DataEventType.value) { (snapshot) in
      
      if snapshot.hasChildren(){
        resultsProductArray = [ProductModel]()
        guard let productsDictForQuery = snapshot.value as? [String:Any] else {
          print("Invalid Products Data for query sent by server")
          return
        }
        
        
        for (productKey, productValueDict) in productsDictForQuery {
          guard let productDict = productValueDict as? [String:Any] else {
            print("Invalid product Data sent")
            return
          }
          guard let category = productDict["category"] as? String,
            let auctionType = productDict["auctionType"] as? String else {
              print("Could not get auction type and category from product data")
              return
          }
          let product = ProductModel(categoryName: category, auctionType: auctionType, prodKey: productKey, productDict: productDict)
          if let imageUrl = product.imageUrl0, !imageUrl.isEmpty {
            resultsProductArray?.append(product)
          }
        
        }
        
        completion(true, resultsProductArray!)
      }// end if snapshot.hasChildren()
      else{
        //no results found
        completion(false, nil)
      }
    }
  }
  
  ///checks if the result is already available for this query string by going into db -> result -> queryString
  func isResultAvailableForThisQuery(queryString: String, completion: @escaping (Bool) ->() ) {
    
    let ref = FirebaseDB.shared.dbRef.child("result").child(queryString)
    ref.observeSingleEvent(of: DataEventType.value) { (snapshot) in
      if snapshot.hasChildren() {
        completion(true)
      }
      else {
        completion(false)
      }
    }
  }
  
}


//MARK: - UITableViewDelegate, UITableViewDataSource

 @available(iOS 10.0, *)
 extension SearchVc: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return suggestionProductArray.count
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
    
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard suggestionProductArray.count > 0 else {
      print("could not refresh table view. suggestion array has 0 count. so going to return")
      return UITableViewCell()
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
    let titleLabel = cell?.viewWithTag(1) as? UILabel
    let categorNameLabe = cell?.viewWithTag(2) as? UILabel
    
    let product = suggestionProductArray[indexPath.section]
    
    let imageView = cell?.viewWithTag(7) as! UIImageView
    imageView.image = #imageLiteral(resourceName: "placeholder")
    if let imageUrlStr =  product.imageUrl0,
      let imageUrl = URL.init(string: imageUrlStr) {
        imageView.sd_setImage(with: imageUrl)
      }
    
    titleLabel?.text = product.title
    categorNameLabe?.text = product.categoryName
    if let containerView = cell?.viewWithTag(6) as? UIView {
      containerView.makeCornersRound()
    }
    
    
    cell?.selectionStyle = UITableViewCellSelectionStyle.none
    return cell!
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard suggestionProductArray.count > 0 else {
      print("guard suggestionProductArray.count > 0 failed in \(self)")
      return
    }
    let prodDetailsSB = getStoryBoardByName(storyBoardNames.prodDetails)
    let selectedProduct = suggestionProductArray[indexPath.section]
    let controller = prodDetailsSB.instantiateViewController(withIdentifier: "ProductDetailVc") as? ProductDetailVc
    controller?.productDetail = selectedProduct
    navigationController?.pushViewController(controller!, animated: true)
    //self.tableView.isHidden = true
    
    //searchController.isActive = false
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    return 70
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //cell spacing
    return 5
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = UIColor.clear
    return headerView
  }
}
