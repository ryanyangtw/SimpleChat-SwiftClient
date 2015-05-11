//
//  ApiKeys.swift
//  SimpleChatClient
//
//  Created by Ryan on 2015/5/11.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import Foundation

func valueForAPIKey(#keyname:String) -> String {
  let filePath = NSBundle.mainBundle().pathForResource("ApiKeys", ofType:"plist")
  
  let plist = NSDictionary(contentsOfFile:filePath!)
  
  let value:String = plist?.objectForKey(keyname) as! String
  
  return value
}