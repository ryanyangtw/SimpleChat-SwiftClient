//
//  Functions.swift
//  SimpleChatClient
//
//  Created by Ryan on 2015/5/7.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//


import Foundation
import Dispatch

func afterDelay(seconds: Double, closure: () -> ()) {
  let when = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
  
  dispatch_after(when, dispatch_get_main_queue(), closure)
  
}


//func getUserId() -> Int? {
//  let defaults = NSUserDefaults.standardUserDefaults()
//  
//  let id = defaults.integerForKey("userId")
//  
//  if id != 0 {
//    return id
//  }
//  
//  return nil
//}

 var currentUser: UserModel? = {
  
  let defaults = NSUserDefaults.standardUserDefaults()
  
  let userHash = defaults.dictionaryForKey("userHash")
  
  if userHash != nil {
    let user = UserModel(JSON: userHash!)
    return user
  }
  
  return nil

}()

//func currentUser() -> UserModel? {
//  let defaults = NSUserDefaults.standardUserDefaults()
//  
//  let userHash = defaults.dictionaryForKey("userHash")
//  
//  if userHash != nil {
//    let user = UserModel(JSON: userHash!)
//    return user
//  }
//  
//  return nil
//}