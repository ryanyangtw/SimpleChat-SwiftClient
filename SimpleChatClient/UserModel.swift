//
//  UserModel.swift
//  FSC
//
//  Created by Ryan on 2015/4/27.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import Foundation
import UIKit




final class UserModel:  NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {
  
  // This makes UserModel conform to ResponseCollectionSerializable
  @objc static func collection(#response: NSHTTPURLResponse, representation: AnyObject) -> [UserModel] {
    
    var userList = [UserModel]()
    
    for user in representation.valueForKeyPath("users") as! [[String: AnyObject]] {
      userList.append(UserModel(JSON: user))
    }
    return userList
  }

  
  var name: String?
  var email: String?
  var avatarUrl: String?
  var id: Int?
  


  override init() {
    super.init()
  }
  

  required init(response: NSHTTPURLResponse, representation: AnyObject) {
    //println("representation: \(representation)")
    
    //super.init()
    
    println("representation: \(representation)")
    
    id = representation.valueForKeyPath("id") as? Int
    name = representation.valueForKeyPath("name") as? String
    email = representation.valueForKeyPath("email") as? String
    avatarUrl = representation.valueForKeyPath("avatar") as? String

  }
  

  
  
  init(JSON: AnyObject) {
    id = JSON.valueForKeyPath("id") as? Int
    name = JSON.valueForKeyPath("name") as? String
    email = JSON.valueForKeyPath("email") as? String
    avatarUrl = JSON.valueForKeyPath("avatar") as? String
  }

  
  
}