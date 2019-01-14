/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Firebase
import MessageKit


struct Message: MessageType {
  var kind: MessageKind
  
  var id: String?
  let content: String
  let sentDate: Date
  let sender: Sender
  var timeStamp : Int64?
  
  var data: MessageKind {
    return .text(content)
    
//    if let image = image {
//      return .photo(image)
//    } else {
//      return .text(content)
//    }
  }
  
  var messageId: String {
    return "\(id as Any )" 
  }
  
  var image: UIImage? = nil
  var downloadURL: URL? = nil
  
  
  init(id: String,  senderID : String, displayName : String, msgContent: String, timeStamp: Int64 ) {
    sender = Sender(id: senderID, displayName: displayName)
    content = msgContent
    sentDate = Date()
    self.id = id
    self.timeStamp = timeStamp
    kind = .text(content)
  }
  
  init(user: User, content: String) {
    sender = Sender(id: user.uid, displayName: "AppSettings.displayName")
    self.content = content
    sentDate = Date()
    id = nil
    kind = .text(content)
  }
  
  
  
  //for sending image msg
//  init(user: User, image: UIImage) {
//    sender = Sender(id: user.uid, displayName: "AppSettings.displayName")
//    self.image = image
//    content = ""
//    sentDate = Date()
//    id = nil
//    kind = MessageKind.text(content)
//  }
  
}

private struct MockMediaItem: MediaItem {
    
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init(image: UIImage ) {
        self.image = image
        self.size = CGSize(width: 100, height: 100)
        self.placeholderImage = UIImage()
       
    }
    
}

struct Messagewithseller: MessageType {
    var kind: MessageKind

    var id: String?
    let content: String
    let sentDate: Date
    let sender: Sender
    var timeStamp : Int64?
     var itemimage : MediaItem?
    var data: MessageKind {
        return .text(content)
        
        
            if let image = itemimage {
              return .photo(image)
            } else {
              return .text(content)
            }
    }
    
    var messageId: String {
        return "\(id as Any )"
    }
    
   
    var downloadURL: URL? = nil
    
    
    init?(id: String,  senderID : String, displayName : String, msgContent: String, timeStamp: Int64 , itemimage : UIImage ) {
        sender = Sender(id: senderID, displayName: displayName)
        content = msgContent
        sentDate = Date()
        self.id = id
        let item =  MockMediaItem.init(image: itemimage)
        
      
        
        kind = .photo(item)
        

        

        
    }
    
    init(user: User, content: String) {
        sender = Sender(id: user.uid, displayName: "AppSettings.displayName")
        self.content = content
        sentDate = Date()
        id = nil
        kind = .text(content)
        
    }
    
    
    
    //for sending image msg
    //  init(user: User, image: UIImage) {
    //    sender = Sender(id: user.uid, displayName: "AppSettings.displayName")
    //    self.image = image
    //    content = ""
    //    sentDate = Date()
    //    id = nil
    //    kind = MessageKind.text(content)
    //  }
    
}
extension Messagewithseller: Comparable {
  
  static func == (lhs: Messagewithseller, rhs: Messagewithseller) -> Bool {
    return lhs.id == rhs.id
  }
  
  static func < (lhs: Messagewithseller, rhs: Messagewithseller) -> Bool {
    return lhs.sentDate < rhs.sentDate
  }
  
}


extension Message: Comparable {
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
    
}

extension Message : DatabaseRepresentation {
    
    var representation: [String : Any] {
        var rep: [String : Any] = [
            "created": sentDate,
            "senderID": sender.id,
            "senderName": sender.displayName
        ]
        
        if let url = downloadURL {
            rep["url"] = url.absoluteString
        } else {
            rep["content"] = content
        }
        
        return rep
    }
    
}

//  init?(document: QueryDocumentSnapshot) {
//    let data = document.data()
//
//    guard let sentDate = data["created"] as? Date else {
//      return nil
//    }
//    guard let senderID = data["senderID"] as? String else {
//      return nil
//    }
//    guard let senderName = data["senderName"] as? String else {
//      return nil
//    }
//
//    id = document.documentID
//
//    self.sentDate = sentDate
//    sender = Sender(id: senderID, displayName: senderName)
//
//    if let content = data["content"] as? String {
//      self.content = content
//      downloadURL = nil
//    } else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
//      downloadURL = url
//      content = ""
//    } else {
//      return nil
//    }
//  }
  


extension Messagewithseller: DatabaseRepresentation {

  var representation: [String : Any] {
    var rep: [String : Any] = [
      "created": sentDate,
      "senderID": sender.id,
      "senderName": sender.displayName
    ]

    if let url = downloadURL {
      rep["url"] = url.absoluteString
    } else {
      rep["content"] = content
    }

    return rep
  }

}



