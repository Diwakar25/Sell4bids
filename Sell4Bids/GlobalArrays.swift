//
//  Products.swift
//  Sell4Bids
//
//  Created by admin on 8/29/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

struct DB_Names {
  static let products = "products"
  static let buyItNow = "buy-it-now"
  static let reserve = "reserve"
  static let nonReserve = "non-reserve"
    static var state = "State"
  static let auctionTypes : [String] = ["buy-it-now","reserve", "non-reserve"]
  static let statesAbbrevArray : [String] = ["NY"]
}

struct storyBoardNames {
  static var myWatchList = "myWatchList"
  static var main = "Main"
  static var loginSignupSB = "loginSignupSB"
  static var prodDetails = "productDetail"
  static var myProfileSB = "myProfileSB"
  static var myWatchListSB = "myWatchList"
  static var whatIsSell4bids_HowWorks_Contact = "whatIsSell4bids_HowWorks_Contact"
  static var searchVC = "searchVC"
  static var chat = "chat"
  struct tabs {
    
    static var homeTab = "homeTab"
    static var mySell4BidsTab = "mySell4BidsTab"
    static var sellTab = "sellTab"
    static var categoriesTab = "categoriesTab"
    static var notificationsTab = "notificationsTab"
  }
  static let EditListingVC = "EditListingVC"
  
}
func toggleEnableIQKeyBoard(flag : Bool) {
  
  IQKeyboardManager.shared.enableAutoToolbar = flag
  IQKeyboardManager.shared.enable = flag
}
let googleZipcodeApiKey = "AIzaSyAWZYqghSlhhow9cLhRAGh5WQ0DBgBbWmA"

let str_Products_Node_Main = "products"
let shareString : String = "Hi, I invite you to join me on Sell4Bids, A Super-Cool Auction App to Buy, Sell or Bid On items\n"
let urlAppStore = URL.init(string: "https://itunes.apple.com/us/app/sell4bids/id1304176306?mt=8")!

var buyOptionArray:[String] = ["Buy Now","Bidding"]
var countryList:[String] = ["USA", "IN"]
var stateNamesArray:[String] = [ "Alabama, AL","Alaska, AK","Arizona, AZ","Arkansas, AR","California, CA","Colorado, CO","Connecticut, CT","Delaware, DE","Florida, FL","Georgia, GA","Hawaii, HI","Idaho,ID","Illinois, IL","Indiana, IN","Iowa, IA","Kansas, KS",
                           "Kentucky, KY",
                           "Louisiana, LA",
                           "Maine, ME",
                           "Maryland, MD",
                           "Massachusetts, MA","Michigan, MI",
                           "Minnesota, MN",
                           "Mississippi, MS",
                           "Missouri, MO",
                           "Montana, MT",
                           "Nebraska, NE",
                           "Nevada, NV","New Hampshire, NH",
    "New Jersey, NJ",
    "New Mexico, NM",
    "New York, NY",
    "North Carolina, NC",
    "North Dakota, ND",
    "Ohio, OH",
    
    "Oklahoma, OK",
    "Oregon, OR",
    "Pennsylvania, PA",
    "Rhode Island, RI",
    "South Carolina, SC",
    "South Dakota, SD",
    "Tennessee, TN",
    
    "Texas, TX",
    "Utah, UT",
    "Vermont, VT",
    "Virginia, VA",
    "Washington , WA",
    "Washington DC, DC",
    "West Virginia, WV",
    "Wisconsin, WI",
    
    "Wyoming, WY",
    "Andaman and Nicobar Islands, IN-AN",
    "Andhra Pradesh, IN-AP",
    "Arunachal Pradesh, IN-AR",
    "Assam, IN-AS",
    "Bihar, IN-BR",
    "Chandigarh, IN-CH,CHD",
    "Chhattisgarh, IN-CT, CG",
    "Dadra and Nagar Haveli, IN-DN,DNH",
    "Daman and Diu, IN-DD",
    "Delhi, IN-DL,DEL",
    "Goa, IN-GA",
    "Gujarat, IN-GJ,GUJ",
    "Haryana, IN-HR",
    "Himachal Pradesh, IN-HP",
    "Jammu and Kashmir, IN-JK",
    "Jharkhand, IN-JH",
    "Karnataka, IN-KA,KRN",
    "Kerala, IN-KL,KER",
    "Lakshadweep, IN-LD,LKP",
    "Madhya Pradesh, IN-MP",
    "Maharashtra, IN-MH,MAH",
    "Manipur, IN-MN,MNP",
    "Meghalaya, IN-ML,MEG",
    "Mizoram, IN-MZ,MIZ",
    "Nagaland, IN-NL,NLD",
    "Odisha, Orissa, IN-OR,OD",
    "Puducherry, IN-PY,PDY",
    "Punjab, IN-PB",
    "Rajasthan, IN-RJ,RAJ",
    "Sikkim, IN-SK,SKM",
    "Tamil Nadu, IN-TN",
    "Telangana, IN-TG,TS",
    "Tripura, IN-TR,TRP",
    "Uttar Pradesh, IN-UP",
    "Uttarakhand,Uttaranchal, IN-UT,UK,UA",
    "West Bengal, IN-WB"]
var realGpsCountry = String()

var  categoriesArray: [String] = ["Jobs","Accessories","Antiques", "Arts and Crafts", "Baby and Kids", "Bags",
                          "Boats and Marines","Books","Business Equipment", "Campers and RVs","Cars and Accessories",
                          "CDs and DVDs","Clothing","Collectible Toys","Computers and Accessories","Costumes",
                          "Coupons", "Electronics","Exercise","Fashion", "Free and Donations",
                          "Furniture","Gadgets","Games","Halloween","Hobbies",
                          "Home Decor","Home and Garden","Household Appliances", "Jewelry", "Kids Toys",
                          "Makeup and Beauty","Motorcycles and Accessories","Musical Equipment","Outdoor and Camping","Pet & Animals","Pet Accessories",
                          "Tickets","Tools","Phone and Tablets","Shoes","Sports Equipment",
                          "Video Games","Wallets","Watches","Wedding","Others"]


var categoriesImagesArray :[UIImage] = [#imageLiteral(resourceName: "Jobs"), #imageLiteral(resourceName: "Associries"), #imageLiteral(resourceName: "Antiques"), #imageLiteral(resourceName: "Arts & Crafts"), #imageLiteral(resourceName: "baby&kids"), #imageLiteral(resourceName: "Bags"), #imageLiteral(resourceName: "Boats and Marines"), #imageLiteral(resourceName: "Books"), #imageLiteral(resourceName: "Business Equipment"), #imageLiteral(resourceName: "campare & RVs"), #imageLiteral(resourceName: "cars"), #imageLiteral(resourceName: "CD & DVD"), #imageLiteral(resourceName: "Clothing"), #imageLiteral(resourceName: "Celectible Toys"), #imageLiteral(resourceName: "Computer And Associries"), #imageLiteral(resourceName: "Costumes"), #imageLiteral(resourceName: "Coupons"), #imageLiteral(resourceName: "Electronics"), #imageLiteral(resourceName: "Exercise"), #imageLiteral(resourceName: "Fashion"),
                                        #imageLiteral(resourceName: "free and donate"), #imageLiteral(resourceName: "Furniture"), #imageLiteral(resourceName: "Gadget"), #imageLiteral(resourceName: "games"), #imageLiteral(resourceName: "Haloween"), #imageLiteral(resourceName: "Hobbies"), #imageLiteral(resourceName: "Home and Garden"), #imageLiteral(resourceName: "Home and Garden"), #imageLiteral(resourceName: "House hold Appliances"), #imageLiteral(resourceName: "Jewellery"), #imageLiteral(resourceName: "Kids toys"), #imageLiteral(resourceName: "Make Up and Beauty"), #imageLiteral(resourceName: "Moto Bike"), #imageLiteral(resourceName: "Musical Instrument"), #imageLiteral(resourceName: "Outdoor compaign"), #imageLiteral(resourceName: "Pet & Animals"),#imageLiteral(resourceName: "Pet accossiries"), #imageLiteral(resourceName: "Tickets"), #imageLiteral(resourceName: "Tools"), #imageLiteral(resourceName: "Phone and Tablet"), #imageLiteral(resourceName: "Shoes"), #imageLiteral(resourceName: "Sports accossiries"), #imageLiteral(resourceName: "Video_Games"), #imageLiteral(resourceName: "wallets"), #imageLiteral(resourceName: "watch"), #imageLiteral(resourceName: "Wedding"), #imageLiteral(resourceName: "Others") ]

var sideMenuIconsArray : [UIImage] = [ #imageLiteral(resourceName: "home_top"), #imageLiteral(resourceName: "sell"), #imageLiteral(resourceName: "categories_top"), #imageLiteral(resourceName: "filter"), #imageLiteral(resourceName: "mysell4bids_top"), #imageLiteral(resourceName: "jobs"), #imageLiteral(resourceName: "chat_128"), #imageLiteral(resourceName: "ic_watch"), #imageLiteral(resourceName: "man"), #imageLiteral(resourceName: "notification_top"), #imageLiteral(resourceName: "star"), #imageLiteral(resourceName: "establish contact"), #imageLiteral(resourceName: "icons8-Sign Out-64")]

var selectedchatvalue : Bool? = false
let paginationFirstTimeConstant = 12
let colorRedPrimay = #colorLiteral(red: 0.8705882353, green: 0.05882352941, blue: 0.05098039216, alpha: 1)

struct Constants {
  static let fidgetSpinAfterSeconds = 3
}

let colorRed = UIColor.init(hex: "EE312F")
let colorGreen = UIColor.init(hex: "90BF52")
let colorAqua = UIColor.init(hex: "0F8FAC")
let colorBlue = UIColor.init(hex: "245FC5")
let colorDarkPink = UIColor.init(hex: "B50F52")
let colorDarkGreen = UIColor.init(hex: "0A9383")


func btn_click_Effect(btn : UIButton) {
   if btn.isTouchInside {
        btn.backgroundColor = UIColor.white
        btn.titleLabel?.textColor = UIColor.black
   }else {
    btn.backgroundColor = UIColor.black
    btn.titleLabel?.textColor = UIColor.white
    }
}

var colorsArrayForBackGroundInitials : [UIColor] {
  let array : [UIColor] = [  colorRed, colorGreen, colorAqua, colorBlue, colorDarkPink, colorDarkGreen]
  return array
}

struct Fonts {
  
  static let sizePhone :CGFloat = {
    if UIDevice.isSmall{ return 15 }
    else if UIDevice.isPad { return 20 }
    else { return 16 }
  }()
  
  static let sizePad : CGFloat = 25
  
  //small
  static let iphoneSmallRegular = UIFont.systemFont(ofSize: sizePhone - 2)
  static let ipadSmallRegular = UIFont.systemFont(ofSize: sizePad - 2 )
  
    static let iphoneSmallBold = UIFont.systemFont(ofSize: sizePhone, weight: UIFont.Weight(rawValue: 1))
  static let ipadSmallBold = UIFont.systemFont(ofSize: sizePad - 5)
    
    static let iphoneSmall = UIFont.systemFont(ofSize: sizePhone)
    static let ipadSmall = UIFont.systemFont(ofSize: sizePad - 5)
  
  //medium
  static let iphoneMediumRegular = UIFont.systemFont(ofSize: sizePhone )
  static let ipadMediumRegular = UIFont.systemFont(ofSize: sizePad  )
  
    static let iphoneMediumBold = UIFont.systemFont(ofSize: sizePhone + 4, weight: UIFont.Weight(rawValue: 4))
    static let ipadMediumBold = UIFont.systemFont(ofSize: sizePad - 3 , weight: UIFont.Weight(rawValue: 4))
  
  //large
  static let iphoneLargeRegular = UIFont.systemFont(ofSize: sizePhone + 2)
  static let ipadLargeRegular = UIFont.systemFont(ofSize: sizePad + 3 )
  
    static let iphoneLargeBold = UIFont.systemFont(ofSize: sizePhone, weight: UIFont.Weight(rawValue: 6))
    static let ipadLargeBold = UIFont.systemFont(ofSize: sizePad + 2, weight: UIFont.Weight(rawValue: 6))


  static let iphoneXLargeBold = UIFont.systemFont(ofSize: sizePhone + 7, weight: .heavy)
  static let ipadXLargeBold = UIFont.systemFont(ofSize: sizePad, weight: .heavy)
  
  
  ///boldSystemFont(ofSize: sizePhone )
  
  static let homeCategoryLabelPhone = UIFont.boldSystemFont(ofSize: (Fonts.sizePhone + 3) )
  static let homeCategoryLabelPad = UIFont.boldSystemFont(ofSize: Fonts.sizePad   )
}
