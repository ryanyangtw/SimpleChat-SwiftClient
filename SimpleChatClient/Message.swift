//
//  Message.swift
//  FireChat-Swift
//
//  Created by Katherine Fang on 8/20/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

import Foundation
import JSQMessagesViewController

final class Message : NSObject, JSQMessageData, ResponseCollectionSerializable  {
  
  var senderId_ : String!
  var senderDisplayName_ : String!
  var date_ : NSDate
  var isMediaMessage_ : Bool
  var hash_ : Int = 0
  var text_ : String
  
  convenience init(senderId: String, text: String) {
    self.init(senderId: senderId, senderDisplayName: "No Name", isMediaMessage: false, hash: 1, text: text)
  }
  
  init(senderId: String, senderDisplayName: String?, isMediaMessage: Bool, hash: Int, text: String) {
    self.senderId_ = senderId
    self.senderDisplayName_ = senderDisplayName
    self.date_ = NSDate()
    self.isMediaMessage_ = isMediaMessage
    self.hash_ = hash
    self.text_ = text
  }
  
  func senderId() -> String? {
    return senderId_;
  }
  
  func senderDisplayName() -> String! {
    return senderDisplayName_;
  }
  
  func date() -> NSDate! {
    return date_;
  }
  
  func isMediaMessage() -> Bool {
    return isMediaMessage_;
  }
  
  func messageHash() -> UInt {
    return UInt(hash_);
  }
  
  func text() -> String! {
    return text_;
  }
  
  
  
  
  // This makes Commetn conform to ResponseCollectionSerializable
  @objc static func collection(#response: NSHTTPURLResponse, representation: AnyObject) -> [Message] {
    
    println("representation: \(representation)")
    var messages = [Message]()

    for message in representation.valueForKeyPath("messages") as! [[String: AnyObject]] {
      messages.append(Message(JSON: message))
    }
    return messages
  }
  
  
  init(JSON: AnyObject) {
    
    let senderId = JSON.valueForKeyPath("sender.id") as! Int
    senderId_ = "\(senderId)"
    senderDisplayName_ = JSON.valueForKeyPath("sender.name") as! String
    date_ = NSDate()
    isMediaMessage_ = false
    hash_ = JSON.valueForKeyPath("id") as! Int
    text_ = JSON.valueForKeyPath("content") as! String

  }


}


