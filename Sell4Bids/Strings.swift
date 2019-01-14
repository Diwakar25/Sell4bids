//
//  Strings.swift
//  Sell4Bids
//
//  Created by admin on 2/2/18.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
extension String {
  static let strKeyUserDefaultsisUserLogged = "isUserLoggedIn"
  static let strKeyUserDefaultsuserID = "uid"
  static let strKeyUserDefaultsuserEmail = "email"
  static let strKeyUserDefaultsName = "name"
  static let strKeyUserLoggindInThrough = "loggedInThrough"
  static let strKeyUserDefaultsFCMToken = "fcmToken"
  static let strInternalErrorOccured = "Sorry, An internal error occured. Please try Later."
  static let str_AccountActivation = "Account Activation"
  static let str_VerEmailSent = "A verification email has been sent to your account. Please check your inbox for Account Activation Instructions "
  static let str_chckInboxForAccVer = "Plase check your Inbox for Account Verification Code. Enter that Code below to continue"
  static let str_VerEmailNotSent = "Sorry, We could not send you account activation email. Try Later."

}

struct FBKeys {
  static var products = "products"
  static var offerHistory = "offer_history"
}

let strMarkasUnPaid = "Mark as UnPaid"
let strQuesYouWantToMarkUnPaid = "This item is Marked as Paid. Do you want to Mark this item as UnPaid ? "
class PromptMessages {
  static var title_ListingEnded = "Listing Ended"
  static var title_AuctionEnded = "Auction Ended"
  static var title_We_cantShare = "Sorry, We can't share this product"
  static var msgIncompleteProductData = "Incomplete Product Data"
  static var sorryYouMissedTime = "Sorry, You missed out on this item"
  static var acceptOffersInfo = "Buyers will be able to send you offers on different prices instead of mentioned price"
  static var listIndefinitelyDescription = "Listing time of item will not end. Buyers can send offers any time. However you can end listing any time you want from item detail page after listing the item. "
}

struct PromptTitles {
  static var acceptOffers = "Accept Offers"
  static var listIndefinite = "List Indefinitely"
  
}
