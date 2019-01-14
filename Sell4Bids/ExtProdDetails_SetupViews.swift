//
//  ExtProdDetails_SetupViews.swift
//  Sell4Bids
//
//  Created by Awais Fayyaz on 24/07/2018.
//  Copyright © 2018 admin. All rights reserved.
//
import Firebase
import GoogleMaps
//MARK:- Setup Views

extension ProductDetailTableVc {
  
   func setupViews() {
    
    viewBackGround = UIView(frame: tableViewProdDetails.frame)
    viewBackGround.backgroundColor = tableViewProdDetails.backgroundColor
    viewBackGround.autoresizingMask = tableViewProdDetails.autoresizingMask
    viewBackGround.addSubview(tableViewProdDetails)
    loadMap()
    
    //setup rate seller btn actions
    //btnViewOfferHistory.addShadowAndRound()
    btnRateNowSeller.addShadowAndRound()
    btnMarkPaid.addShadowAndRound()
    DispatchQueue.main.async {
      if self.isJob{
        self.lblOfferWillBeAccepted.text = "Your offer has been sent to the Employer. Waiting for the Employer to respond. You can also send a Chat Message directly to the Employer"
      }else {
        self.lblOfferWillBeAccepted.text = "Your offer has been sent to the Seller. Waiting for the Seller to respond. You can also send a Chat Message directly to the Seller"
      }
    }
    viewYouMarkedPaid.addShadowAndRound()
    viewSellerMarkedPaid.addShadowAndRound()
    acceptOffersBtn.addShadowAndRound()
    newOrderBtn.addShadowAndRound()
    stockBtn.addShadowAndRound()
    productVisibilityBTn.addShadowAndRound()
    relistBtn.addShadowAndRound()
    turboChargeBtn.addShadowAndRound()
    //viewCounterOfferContainer.makeCornersRound()
    btnViewCounterOffer.addShadowAndRound()
    viewCounterOfferContainer.addShadowAndRound()
    btnEndListing.makeRedAndRound()
    
    
    //for longer product labels, looks weird
    btnEditListing.addShadowAndRound()
  }
  
  
  
  
  //New function
  func setButtons(){
    btnSetSeconds.isHidden = true
    if productData.userId == SessionManager.shared.userId {
      let ref = FirebaseDB.shared.dbRef
      let dic = ["temporaryTimeStamp":ServerValue.timestamp()]
      ref.updateChildValues(dic)
      
      ref.child("temporaryTimeStamp").observe(DataEventType.value, with: { [weak self] (snap) in
        guard let this = self else { return }
        if let currentTime = snap.value as? Int64{
          let re = FirebaseDB.shared.dbRef.child("products").child(this.productData.categoryName!).child(this.productData.auctionType!).child(this.productData.state!).child(this.productData.productKey!)
          re.observe( .value, with: { [weak self ](snapshot) in
            guard let thisInner = self else { return }
            print(snapshot)
            if snapshot.hasChildren(){
              
              if let data = snapshot.value as? [String:Any]{
                
                
                if thisInner.productData.auctionType != "buy-it-now"{
                  
                  thisInner.acceptOffersBtn.isHidden = true
                  thisInner.newOrderBtn.isHidden = true
                  thisInner.productVisibilityBTn.isHidden = true
                  // self.productVisibilityBTn.isEnabled = false
                }
                  
                else{
                  thisInner.acceptOffersBtn.isHidden = false
                  thisInner.newOrderBtn.isHidden = false
                  
                  
                  if let acceptOffer = data["acceptOffers"] as? String{
                    
                    
                    //acceptOffer portion start
                    if acceptOffer == "yes"{
                      thisInner.acceptOffer = acceptOffer
                      thisInner.acceptOffersBtn.setTitle(
                        "Stop Accepting Offers", for: .normal)
                      thisInner.acceptOffersBtn.backgroundColor = UIColor.white
                      thisInner.acceptOffersBtn.setTitleColor(UIColor.darkGray, for: .normal)
                      thisInner.acceptOffersBtn.layer.borderColor = UIColor.darkGray.cgColor
                      thisInner.acceptOffersBtn.layer.cornerRadius = 5
                      thisInner.acceptOffersBtn.layer.borderWidth = 1
                      
                    }
                    else if acceptOffer == "no"{
                      thisInner.acceptOffer = acceptOffer
                      thisInner.acceptOffersBtn.setTitle("Accept Offers", for: .normal)
                      thisInner.acceptOffersBtn.backgroundColor = UIColor.darkGray
                      thisInner.acceptOffersBtn.setTitleColor(UIColor.white, for: .normal)
                      
                    }
                  }
                  else{
                    thisInner.acceptOffersBtn.setTitle("Accept Offers", for: .normal)
                  }
                  
                  
                  if let ordering = data["ordering"] as? String{
                    
                    if ordering == "stopped"{
                      
                      thisInner.newOrderBtn.setTitle("Get New Orders", for: .normal)
                      thisInner.newOrderBtn.backgroundColor = UIColor.darkGray
                      thisInner.newOrderBtn.setTitleColor(UIColor.white, for: .normal)
                      //                                            self.acceptOffersBtn.layer.cornerRadius = 5
                      //                                            self.acceptOffersBtn.layer.borderWidth = 1
                    }
                    else if ordering == "yes"{
                      
                      thisInner.newOrderBtn.setTitle("Stop New Orders", for: .normal)
                      thisInner.newOrderBtn.backgroundColor = UIColor.white
                      thisInner.newOrderBtn.setTitleColor(UIColor.darkGray, for: .normal)
                      thisInner.newOrderBtn.layer.borderColor = UIColor.darkGray.cgColor
                      thisInner.newOrderBtn.layer.cornerRadius = 5
                      thisInner.newOrderBtn.layer.borderWidth = 1
                    }
                    
                  }
                  else{
                    
                    thisInner.newOrderBtn.setTitle("Stop New Orders", for: .normal)
                    thisInner.newOrderBtn.backgroundColor = UIColor.white
                    thisInner.newOrderBtn.setTitleColor(UIColor.darkGray, for: .normal)
                    thisInner.newOrderBtn.layer.borderColor = UIColor.darkGray.cgColor
                    thisInner.newOrderBtn.layer.cornerRadius = 5
                    thisInner.newOrderBtn.layer.borderWidth = 1
                  }
                  
                  
                  
                  
                  
                  //orderign portion end
                  
                  
                  
                  //visibility portion start
                  if let visibility = data["visibility"] as? String{
                    
                    
                    if visibility == "hidden"{
                      thisInner.productVisibilityBTn.setTitle("Show Item", for: .normal)
                      thisInner.productVisibilityBTn.backgroundColor = UIColor.darkGray
                      thisInner.productVisibilityBTn.setTitleColor(UIColor.white, for: .normal)
                      
                    }
                    else if visibility == "shown"{
                      thisInner.productVisibilityBTn.setTitle("Hide Item", for: .normal)
                      thisInner.productVisibilityBTn.backgroundColor = UIColor.white
                      thisInner.productVisibilityBTn.setTitleColor(UIColor.darkGray, for: .normal)
                      thisInner.productVisibilityBTn.layer.borderColor = UIColor.darkGray.cgColor
                      thisInner.productVisibilityBTn.layer.cornerRadius = 5
                      thisInner.productVisibilityBTn.layer.borderWidth = 1                             }
                  }
                  else{
                    
                    thisInner.productVisibilityBTn.setTitle("Hide Item", for: .normal)
                    thisInner.productVisibilityBTn.backgroundColor = UIColor.white
                    thisInner.productVisibilityBTn.setTitleColor(UIColor.darkGray, for: .normal)
                    thisInner.productVisibilityBTn.layer.borderColor = UIColor.darkGray.cgColor
                    thisInner.productVisibilityBTn.layer.cornerRadius = 5
                    thisInner.productVisibilityBTn.layer.borderWidth = 1
                  }
                  //end Visibility portion
                  
                  
                  
                  
                }
                
                
                //start Re-list portion
                
                if let endTime = data["endTime"] as? Int64{
                    
                  let dif = currentTime - endTime
                    print("currentTime = \(currentTime)")
                    print("dif = \(dif)")
                  if dif <= 0 || endTime == -1 {
                    
                    thisInner.relistBtn.isEnabled = false
                    thisInner.btnEndListing.isHidden = false
                    thisInner.relistBtn.setTitle("Item is listed", for: .normal)
                  }
                  else{
                    print("Called relistBtn")
                    thisInner.relistBtn.isEnabled = true
                    thisInner.btnEndListing.isHidden = true
                    thisInner.relistBtn.setTitle("Relist the Item", for: .normal)
                    
                  }
                  
                }
                else{
                  thisInner.relistBtn.isEnabled = false
                }
                
              
                //end Re-list portion
                
              }
              else{
                print("No data found")
                
              }
              
              
            }
            
          })//end lisnter of product
        }
      })//end listner of timeStamp
    }
  }
  
  func handlingBiddingAndOffersList(){
    guard let categoryName = productData.categoryName, let auctionType = productData.auctionType, let stateName = productData.state,let productKey = productData.productKey else {return}
    if self.currentuserId == productData.userId {
      self.ischeckReport = false
      self.isOrder = false
      self.isBid  = false
      
    }
    else {
      print("cat name : \(categoryName) auctionType \(auctionType)")
      print("stateName : \(stateName) productKey \(productKey)")
      
      let ref = dbRef.child("products").child(categoryName).child(auctionType)
      ref.child(stateName).child(productKey).child("ratings").observe(.value, with: { [weak self] (snapshot)  in
        guard self != nil else { return }
        let dictObj = snapshot.value as? NSDictionary
        
        if let valueDict = dictObj?.value(forKey: (self?.currentUserId)!) as? NSDictionary {
          if let rating = valueDict.value(forKey: "rating") as? String {
            let ratingInt = (rating as NSString).integerValue
            
            self?.cosmosRatingView.rating = Double(ratingInt)
            
            self?.cosmosRatingView.settings.updateOnTouch = false
            
            if rating == "0" || rating == " "{
              self?.flagShowBtnMarkPaid = true
              self?.flagGiveOptionToRate = true
              self?.buyerHasRatedThisProduct = false
              
            }
            else if ( rating == "1" || rating == "2"||rating == "3" || rating == "4" || rating == "5")
            {
              self?.flagShowBtnMarkPaid = true
              self?.flagGiveOptionToRate = false
              self?.buyerHasRatedThisProduct = true
              
            }
          }else {
            self?.flagGiveOptionToRate = true
            self?.buyerHasRatedThisProduct = false
          }
          
          func showToastYouWonThisItem() {
            guard let this = self else { return }
            if this.flagGiveOptionToRate || this.buyerHasRatedThisProduct {
                this.lblWonItem.isHidden = false
                this.flagWonItem = true
                
            }else{
                this.flagWonItem = false
            }
          }
          
        } else {
          self?.flagGiveOptionToRate = false
          self?.buyerHasRatedThisProduct = false
        }
        
        
      })
      if productData.auctionType == "buy-it-now" {
        //check order
        self.dbRef.child("products").child(categoryName).child(auctionType).child(stateName).child(productKey).child("orders").observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
          guard self != nil  else { return }
          if snapshot.hasChild(self!.currentUserId){
            if snapshot.childSnapshot(forPath: self!.currentUserId).childSnapshot(forPath: "rating").exists() {
              self!.isOrder = false
            }
            else {
              
              self!.isOrder = true
              
            }
            self!.isOrder = true
          }
          else {
            self!.isOrder = false
          }
          
        })
      }
      else {
        //checking bid
        self.dbRef.child("products").child(categoryName).child(auctionType).child(stateName).child(productKey).child("bids").observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
          guard self != nil else { return }
          if snapshot.hasChild(self!.currentUserId){
            self!.isBid = true
          }
          else {
            self!.isBid = false
          }
        })
        
        
      }
      dbRef.child("productsReports").observe(.value, with: { [weak self] (snapshot) in
        guard self != nil else { return }
        if snapshot.hasChild(self!.productData.productKey!){
          self!.reportItemLabel.text = "Unreport"
          self!.reportImageView.image = #imageLiteral(resourceName: "flag_red")
          self!.isReport = true
          self!.ischeckReport = true
          
          
          
        }else {
          
          self!.reportItemLabel.text = "Report item"
          self!.reportImageView.image = #imageLiteral(resourceName: "flag_black")
          self!.isReport = false
          self!.ischeckReport = true
          
          
        }
      })
      
    }
  }
  
  func displayProducDetail() {
    //userImageView.layer.borderWidth = 1
    //userImageView.layer.borderColor = UIColor.red.cgColor
    userImageView.layer.masksToBounds = false
    userImageView.layer.cornerRadius = userImageView.frame.height/2
    userImageView.clipsToBounds = true
    userImageView.image = #imageLiteral(resourceName: "user_icon_512")
    if productData.categoryName == "Jobs"  {
      
      if let title = productData.title {
        titleLabel.text = title
      }
      
      if let category = productData.categoryName {
        categoryNamelabel.text = "\(category), \(productData.jobCategory ?? " ") at \(productData.companyName ?? " ")"
      }
      
      companyNameLabel.text = "Company : \(productData.companyName ?? "Not Available")"
      
      
      if let companyDesc = productData.companyDesc {
        companyDescriptionLabel.text = companyDesc
      }
      
      if let benefits = productData.benefits {
        benefitsLabel.text = benefits
      }
      if let employmentType = productData.employmentType {
        employementType.text = employmentType
      }
      
      if let payPeriod = productData.payPeriod {
        payPeriodLabel.text = payPeriod
      }
      
      if let desc = productData.description {
        descriptionLabel.text = desc
      }
      if let condition = productData.condition {
        conditionLabel.text = condition
      }
      
        if let cityname = productData.city {
            cityLabel.text = "\(productData.city ?? city), \(productData.state ?? stateName) \(productData.zipcode ?? zipCode)"
        }else {
             cityLabel.text = "\(city), \(stateName) \(zipCode)"
            print("Match Not Found")
        }
      ConditionJobLabel.text = "Job Condition"
      self.isJob = true
      
    }
    else {
      //displaying product data into label
      if let title = productData.title {
        //photoTitleLabel.text = title
        titleLabel.text = title
        
      }
      
      
      //  if let city =
      if let city = productData.city {
         cityLabel.text = "\(productData.city ?? city), \(productData.state ?? stateName) \(productData.zipcode ?? zipCode)"
      }else {
        cityLabel.text = "\(city), \(stateName) \(zipCode)"
      print("Match Not Found")
        }
      if let desc = productData.description {
        descriptionLabel.text = desc
      }
      if let condition = productData.condition {
        conditionLabel.text = condition
      }
      if let category = productData.categoryName {
        categoryNamelabel.text = category
      }
      
      if let category = productData.categoryName {
        categoryNamelabel.text = category
      }
      
      
      ConditionJobLabel.text = "Condition"
      if let productquantity = productData.quantity {
        if productquantity <= 0 {
          if self.isJob {
            quantityLabel.text = "This Job posting is no longer available!"
          }else {
            quantityLabel.text = "Out of stock"
          }
          
          quantityLabel.textColor = colorRedPrimay
          
        }else {
          quantityLabel.text = "Quantity in stock : \(productquantity) items"
        }
        
      }
      self.isJob = false
    }
    
  }
  
  func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
    // Update View
    
    //activityIndicatorView.stopAnimating()
    
    if let error = error {
      print("Unable to Forward Geocode Address (\(error))")
      
      
    } else {
      
      
      if let placemarks = placemarks, placemarks.count > 0 {
        location = placemarks.first?.location
      }
      
      if let location = location {
        let coordinate = location.coordinate
        lat = coordinate.latitude
        long = coordinate.longitude
        
        loadMap()
        
        
      } else {
        print("No Matching Location Found")
      }
    }
  }
  
  func loadMap() {
    
    let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 14, bearing: 0, viewingAngle: 0)
   
    mapView.camera = camera
    let circle = GMSCircle()
    
    circle.position = camera.target
    circle.radius = 700
    circle.strokeWidth = 1
    circle.strokeColor = UIColor.blue
    circle.fillColor = UIColor(red: 0, green: 0, blue: 0.35, alpha: 0.05)
    circle.map = mapView
    mapView.settings.setAllGesturesEnabled(false)
  }
  
  func computeAndSetPostedTimeLabel(){
    //Server Current Time
    //        let serverTime:TimeInterval = Double(currentTime)
    //        //converting to Date and time
    //        let servermilliToDate = Date(timeIntervalSince1970: serverTime/1000)
    //        //StartTime of Product or Posting time of product
    if let productTime = productData.startTime {
      let startTime:TimeInterval = TimeInterval(productTime)
      //converting milli to Date and time
      let ProductmilliToDate = Date(timeIntervalSince1970: startTime/1000)
      //Difference Between Server Time and Product Start Time
      let calender = NSCalendar.current as NSCalendar
      let unitflags = NSCalendar.Unit([.day,.hour,.minute,.second])
      var diffDate = calender.components(unitflags, from:ProductmilliToDate, to: Date())
      if let days = diffDate.day, let hours = diffDate.hour, let minutes = diffDate.minute, let seconds = diffDate.second {
        if days >= 1{
          let dayString = days > 1 ? "days" : "day"
          postedTimeLabel.text = "Posted \(days) " + dayString + " ago"
        }
        else if  hours < 24 && hours > 1{
          let hourString = hours > 1 ? "hours" : "hours"
          postedTimeLabel.text = "Posted \(hours) \(hourString) ago."
        }
        else if minutes < 60 && minutes > 1 {
          let minString = minutes > 1 ? "minutes" : "minute"
          postedTimeLabel.text = "Posted \(minutes) \(minString) ago."
        }
        else if seconds < 60 && seconds > 1{
          
          postedTimeLabel.text = "Posted \(seconds) seconds ago."
        }
        
      }
    }
  }
  
  static var flagCellListingEndedisHidden = true
  
 @objc func updateTimer(currentTime: NSNumber?){
    var timer = Int64()
    var dif = Int64()
    var ref = Database.database().reference()
    ref = ref.child("items").child((self.productData?.productKey!)!)
   
         ref.observeSingleEvent(of: .value) { (snapshot) in

        if let  currentTime = snapshot.childSnapshot(forPath: "endTime").value as? Int64{
           
            timer = currentTime
      
    DispatchQueue.main.async {
       
      //Convert EndTime Milliseconds to DateFormat
        
        if (self.productData!.endTime != nil) {
        
        
        //list indefinitely
       
            dif =  timer
       
   
      
    
        if  dif <= 0 || dif == -1 {
            print("Time ended = \(dif)")
      
            
          //previously we were showing
          let needsReload = self.flagShowCellLisingEnded == true
          self.flagShowCellLisingEnded = false
          
          
            
            if needsReload {
                self.tableView.reloadUsingDispatch()
            }
            
            
          
        }else {
         
            self.lblTimeEnded.alpha = 0
            self.timeStackView.isHidden = false
            
          
            let endTimeInterval:TimeInterval = TimeInterval(timer)
          //Convert to Date
          let endDate = Date(timeIntervalSince1970: endTimeInterval/1000)
          
          //Difference between servertime and endtime
          let calendar = NSCalendar.current as NSCalendar
          let unitFlags = NSCalendar.Unit([.day,.hour,.minute,.second])
          var components = calendar.components(unitFlags, from: Date(), to: endDate )
          //print("calender components: \(components)")
          if let days = components.day, let hours = components.hour, let minutes = components.minute, let secs = components.second {
            if days <= 0 && hours <= 0 && minutes <= 0 && secs <= 0 {
              //no time left to show
              
                self.lblTimeEnded.alpha = 1
                self.timeStackView.isHidden = true
                if let auctionType = self.productData.auctionType {
                    if auctionType.lowercased().contains("buy"){
                        self.lblTimeEnded.text = PromptMessages.title_ListingEnded
                    }else {
                        self.lblTimeEnded.text = PromptMessages.title_AuctionEnded
                    }
                }
                
            
            }else {
              //some time left to show
              if days > 0 {
                self.daysLabel.text = String(format: "%2i",days)
              }
              //for not showing 00 hours
              self.daysLabel.isHidden = days <= 0
              self.lblDaysTimerStatic.isHidden = days <= 0
              
              if hours > 0{
                self.hoursLabel.text = String(format: "%2i",hours)
              }
              self.hoursLabel.isHidden = hours <= 0
              self.lblHoursTimerStatic.isHidden = hours <= 0
              
              if minutes > 0 {
                self.minsLabel.text =  String(format: "%2i",minutes)
              }
              self.minsLabel.isHidden = minutes <= 0
              self.lblMinsTimerStatic.isHidden = minutes <= 0
              
              if secs > 0 {
                self.secondsLabel.text = String(format: "%2i",secs)
                
              }
              self.secondsLabel.isHidden = secs <= 0
              self.lblSecsTimerStatic.isHidden = secs <= 0
              
              
              
              //handle 1 hour instead of 1 hours, i day instead of 1 D
              self.lblDaysTimerStatic.text = days > 1  ? "Days" : "Day"
              self.lblHoursTimerStatic.text = hours > 1  ? "Hours" : "Hour"
              self.lblMinsTimerStatic.text = minutes > 1  ? "Mins" : "Min"
              self.lblSecsTimerStatic.text = secs > 1  ? "Secs" : "Sec"
            }
            
          }
        }
        
      }
    }
  }
    }
    }
 
  func checkWatchList() {
    dbRef.child("users").child(self.currentUserId).child("products").child("watching").observe(.value, with: { [weak self ] (snapshot) in
      guard let this = self else { return }
      
      if snapshot.hasChild(this.productData.productKey!){
        this.watchListLabel.text = "Remove from My WatchList"
        this.watchListImageView.image = #imageLiteral(resourceName: "ic_eye_red")
        
        this.isWatchList = true
        
      }else {
        this.watchListLabel.text = "Add to MySell4Bids Watch List"
        this.watchListImageView.image = #imageLiteral(resourceName: "ic_eye_black")
        this.isWatchList = false
      }
      
    })
  }
  
  @objc func updateSellerRatings(){
    cosmosSetRating.settings.updateOnTouch = true
    let rating = Int(cosmosSetRating.rating)
    
    //Set rating to Products Node "Ratings" and setting values
    var ref = dbRef.child("products").child(productData.categoryName!)
    ref = ref.child(productData.auctionType!).child(productData.state!)
    ref = ref.child(productData.productKey!).child("ratings")
    ref.child(currentUserId).child("rating").setValue("\(rating)")
    
    let sellersId = productData.userId
    guard let productData = productData else {
      alert(message: "Could not rate the user")
      return
    }
    
    ref = dbRef.child("products").child(productData.categoryName!)
    ref = ref.child(productData.auctionType!).child(productData.state!)
    ref = ref.child(productData.productKey!).child("ratings")
    ref.child(currentUserId).child("sellerid").setValue(sellersId)
    
    //converting the all ratings value into Average rating and then set it to User table as Average rating
    
    let UserAverageRating = Float(UserArray[0].averageRating ?? 0 )
    var userTotalRating =  Float(UserArray[0].totalRating ?? 0 )
    let currentRating = Float(rating)
    
    //Average Formula
    
    let getAverageRating = ((UserAverageRating * userTotalRating) + currentRating) / (userTotalRating + 1)
    
    //Adding count to total rating
    userTotalRating += 1
    let IntCount = Int(userTotalRating)
    
    
    //Seting values to users table, who upload the product
    dbRef.child("users").child(UserArray[0].userId!).child("averagerating").setValue("\(getAverageRating)")
    dbRef.child("users").child(UserArray[0].userId!).child("totalratings").setValue("\(IntCount)")
    
    cosmosRatingView.rating = cosmosSetRating.rating
    flagGiveOptionToRate = false
    buyerHasRatedThisProduct = true
    self.tableView.reloadUsingDispatch()
    alert(message: "Seller rating has been Updated", title: "You rated the Seller")
    
  }
  
  func dataChange(checkRelist: Bool) {
    
    if checkRelist == true {
      DispatchQueue.main.async {
        self.relistBtn.isEnabled = false
        self.relistBtn.setTitle("Item is listed", for: .normal)
      }
      
    }
    
  }
  
}
