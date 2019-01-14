//
//  Products.swift
//  Sell4Bids
//
//  Created by admin on 9/5/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import FirebaseDatabase
class ProductModel: Hashable {
  var hashValue: Int
  
  static func ==(lhs: ProductModel, rhs: ProductModel) -> Bool {
    guard let lhsKey = lhs.productKey else {
      return false
    }
    guard let rhsKey = rhs.productKey else {
      return false
    }
    
    return lhsKey == rhsKey
  }
  
  //MARK:- Initializatio
  var city:String?
  var condition:String?
  var description:String?
  var imageUrl0small : String?
  var imageUrl0:String?
  var imageUrl1:String?
  var imageUrl2:String?
  var imageUrl3:String?
  var imageUrl4:String?
  var title:String?
  var categoryName:String?
  var userId:String?
  var auctionType:String?
  var productKey:String?
  var isUserAcceptingOffers:String?
  var state:String?
  var benefits:String?
  var companyDesc:String?
  var employmentType:String?
  var jobCategory:String?
  var payPeriod:String?
  var companyName:String?
  var Visibility:String?
  var chargeTime:Int64?
  var quantity:Int?
  var endTime:Int64?
  var startTime:Int64?
  var startPrice:Int?
  var timeRemaining:Int64?
  var ordersCount : Int?
  var imagesArray : [UIImage]?
  //query factor add on 11/22/2018
    var category_state_time : String?
    var category_time : String?
    var category_zipcode_time : String?
    var state_time : String?
    var zipcode_time : String?
    var city_time: String?
    var height_ratio : Float?
    var height : Float?
    var country : String?
    var currency_string : String?
    var currency_symbol : String?
    var zipcode : String?
    

  //MARK:- Initialization
  
  
    init(city:String?="", condition:String?="",description:String?="",imageUrl1:String?="",imageUrl2:String?="",imageUrl3:String?="",imageUrl4:String?="",imageUrl5:String?="",startPrice:Int? = -7,title:String?="", categoryName:String?="",endTime:Int64? = -7 ,startTime:Int64? = -7,timeRemaining:Int64? = -7,userId:String? = "" ,auctionType:String?="",productKey:String?="",acceptOffers:String?="",state:String? = "", quantity:Int? = -7,benefits:String?="",companyDesc:String? = "",employmentType:String?="",jobCategory:String?="" ,payPeriod:String?="",companyName:String?="",chargeTime:Int64 = -7,Visibility:String?="" ) {
    // Initialize stored properties.
    self.city = city
    self.condition = condition
    self.description = description
    self.imageUrl0 = imageUrl1
    self.imageUrl1 = imageUrl2
    self.imageUrl2 = imageUrl3
    self.imageUrl3 = imageUrl4
    self.imageUrl4 = imageUrl5
    self.startPrice = startPrice
    self.title = title
    self.categoryName = categoryName
    self.endTime = endTime
    self.startTime = startTime
    self.userId = userId
    self.auctionType = auctionType
    self.productKey = productKey
    self.isUserAcceptingOffers = acceptOffers
    self.state = state
    self.quantity = quantity
    self.benefits = benefits
    self.companyDesc = companyDesc
    self.employmentType = employmentType
    self.jobCategory = jobCategory
    self.payPeriod = payPeriod
    self.companyName    = companyName
    self.chargeTime = chargeTime
    self.Visibility = Visibility
   
    self.timeRemaining = timeRemaining
    guard let key = productKey else {
      hashValue = -1
      return
    }
    self.hashValue = Int(key) ?? -1
  }
  
  init(categoryName:String,auctionType:String,prodKey: String, productDict: [String:Any]) {
    if let state = productDict["state"] as? String{
      self.state = state
    }
    if let city = productDict["city"] as? String{
      self.city = city
    }
    
    if let zipcode = productDict["zipcode"] as? String
    {
        self.zipcode = zipcode
    }
    if let condition = productDict["condition"] as? String{
      self.condition = condition
    }
    if let description = productDict["description"] as? String{
      self.description = description
    }
    
    if let title = productDict["title"] as? String {
      self.title = title
    }
    if let category_state_time = productDict["category_state_time"] as? String {
        self.category_state_time = category_state_time
    }
    if let category_time = productDict["category_time"] as? String {
        self.category_time = category_time
    }
    if let category_zipcode_time = productDict["category_zipcode_time"] as? String {
        self.category_zipcode_time = category_zipcode_time
    }
    if let state_time = productDict["state_time"] as? String {
        self.state_time = state_time
    }
    if let zipcode_time = productDict["zipcode_time"] as? String {
        self.zipcode_time = zipcode_time
    }
    if let city_time = productDict["city_time"] as? String {
        self.city_time = city_time
    }
   
    
    
    
    if let image0small = productDict["image1"] as? String{
        self.imageUrl0 = image0small
    }
    
    if (self.imageUrl0 == nil) {
        if let image0 = productDict["image0"] as? String{
            self.imageUrl0 = image0
        }
    }
    if let image1 = productDict["image1"] as? String {
      self.imageUrl1 = image1
    }
    if let image2 = productDict["image2"] as? String{
      self.imageUrl2 = image2
    }
    if let image3 = productDict["image3"] as? String{
      self.imageUrl3 = image3
    }
    if let image4 = productDict["image4"] as? String{
      self.imageUrl4 = image4
    }
    
 
    if let userId = productDict["uid"] as? String
    { self.userId = userId
    }
    if let isUserAcceptingOffers = productDict["acceptOffers"] as? String
    {
      self.isUserAcceptingOffers = isUserAcceptingOffers
    }
    // Geting Jobs data
    if let companyDesc = productDict["companyDescription"] as? String
    {
      self.companyDesc = companyDesc
      
    }
    if let benefits = productDict["benefits"] as? String
    {
      self.benefits = benefits
      
    }
    if let employmentType = productDict["employmentType"] as? String{
      self.employmentType = employmentType
    }
    if let jobCategory = productDict["jobCategory"] as? String{
      self.jobCategory = jobCategory
    }
    if let payPeriod = productDict["payPeriod"] as? String{
      self.payPeriod = payPeriod
    }
    if let companyName = productDict["companyName"] as? String{
      self.companyName = companyName
    }
    if let visibility = productDict["visibility"] as? String {
      self.Visibility = visibility
    }else {
      self.Visibility = "shown"
    }
    if let chargeTime = productDict["chargeTime"] as? Int64{
      self.chargeTime = chargeTime
    }else {
      self.chargeTime = -1
    }
    if let quantity = productDict["quantity"] as? String{
      self.quantity = Int(quantity)
    }
    else if let quantity = productDict["quantity"] as? Int {
      self.quantity = quantity
    }else {
      quantity = -1
    }
    if let endTime = productDict["endTime"] as? Int64{
      self.endTime = endTime
    }else {
      self.endTime = 86573726
    }
    if let startTime = productDict["startTime"] as? Int64 {
      self.startTime = startTime
    }else {
      self.startTime = -1
    }
    if let startPrice = productDict["startPrice"] as? String{
      self.startPrice = Int(startPrice)
    }else if let startPrice = productDict["startPrice"] as? Int {
      self.startPrice = startPrice
    }else {
      startPrice = -1
    }
    if let timeRemaining = productDict["timeRemaining"] as? Int64 {
      self.timeRemaining = timeRemaining
    }else {
      ///no node time remaining present
      self.timeRemaining = nil
    }
    
    if let country = productDict["country"] as? String {
        self.country = country
    }
    
    if let currency_string = productDict["currency_string"] as? String {
        self.currency_string = currency_string
    }
    
    
    if let currency_symbol = productDict["currency_symbol"] as? String {
        self.currency_symbol = currency_symbol
    }
    
    
    //get number of orders placed and store in
    if let ordersDict = productDict["orders"] as? [String:Any] {
      self.ordersCount = ordersDict.keys.count
    }
    
    
        if let ordersDict = productDict["images_info_small"] as? NSArray {
            
            
            
            if ordersDict.count == 1{
                let item = ordersDict[0] as? NSDictionary
                let itemratio = item!["ratio"] as? Float
                let itemheight = item!["height"] as? Float
                
                print("item == \(item!["ratio"])")
                print("item height == \(itemheight)")
                
                self.height_ratio = itemratio
                self.height = itemheight
            }
            
            
            
        }
   
    
   
    
   
   
    self.productKey = prodKey
    self.categoryName = categoryName
    self.auctionType = auctionType
    
    
    hashValue = Int(prodKey) ?? -1
    
  }
    
  
}

