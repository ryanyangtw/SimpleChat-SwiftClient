//
//  RoomModel.swift
//  SimpleChatClient
//
//  Created by Ryan on 2015/5/8.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import Foundation
import UIKit


final class ChatroomModel:  NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {
  
  // This makes UserModel conform to ResponseCollectionSerializable
  @objc static func collection(#response: NSHTTPURLResponse, representation: AnyObject) -> [ChatroomModel] {
    
    var chatroomList = [ChatroomModel]()
    
    println("representation: \(representation)")
    
    for chatroom in representation.valueForKeyPath("rooms") as! [[String: AnyObject]] {
      chatroomList.append(ChatroomModel(JSON: chatroom))
    }
    return chatroomList
  }
  
  
  var name: String?
  var id: Int?
  var avatarUrl: String?
  var lastMessage: String?
  var lastMessageCreatedAt: String?
  var members = [UserModel]()
  
  
  
  override init() {
    super.init()
  }
  
  
  required init(response: NSHTTPURLResponse, representation: AnyObject) {
    
    println("representation: \(representation)")
    
    //super.init()

    id = representation.valueForKeyPath("id") as? Int
    name = representation.valueForKeyPath("name") as? String
    avatarUrl = representation.valueForKeyPath("avatar") as? String
    lastMessage = representation.valueForKeyPath("last_message") as? String
    lastMessageCreatedAt = representation.valueForKeyPath("last_message_created_at") as? String
    
    
    for member in representation.valueForKeyPath("memebers") as! [[String: AnyObject]] {
      members.append(UserModel(JSON: member))
    }

  }
  
  
  init(JSON: AnyObject) {
    id = JSON.valueForKeyPath("id") as? Int
    name = JSON.valueForKeyPath("name") as? String
    avatarUrl = JSON.valueForKeyPath("avatar") as? String
    lastMessage = JSON.valueForKeyPath("last_message") as? String
    lastMessageCreatedAt = JSON.valueForKeyPath("last_message_created_at") as? String
    
    for member in JSON.valueForKeyPath("memebers") as! [[String: AnyObject]] {
      members.append(UserModel(JSON: member))
    }
  }
  
  
  
}