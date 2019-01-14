//
//  Message.swift
//  chatPractice
//
//  Created by Admin on 9/17/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
class MessageOld: Hashable, Equatable{
    
    var hashValue: Int{ get { return timeStamp!.hashValue } }
    
    static func ==(lhs: MessageOld, rhs: MessageOld) -> Bool {
        return lhs.timeStamp==rhs.timeStamp
    }
    
    
    var timeStamp : String?
    var receiver : String?
    var sender : String?
    var message : String?
    var itemimg : String?
    var itemtitle : String?
    
}



class AllMessages{
    
    
    var key : String!
    var listOfMessages = [MessageOld]()
}
