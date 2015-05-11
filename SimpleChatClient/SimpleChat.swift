//
//  SimpleChat.swift
//  SimpleChatClient
//
//  Created by Ryan on 2015/5/8.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import Foundation


import UIKit
import Alamofire
import Foundation
import Locksmith



struct SimpleChat {
  
  enum Router: URLRequestConvertible {
    
    static let baseURLString = "https://simple-chat-rails-server.herokuapp.com/api/v1"
    //static let baseURLString = "http://localhost:3000/api/v1"
    
    case Signin(String, String)
    case GetFriendList
    case GetChatroomList
    case GetMessages(Int, Int)
    case GetOrCreateChatroom(Int, Int)
    
    
    
    var URLRequest: NSURLRequest {
      
      var httpMethod: String = "GET"
      
      let (path: String, parameters: [String: AnyObject]) = {
        switch self {
        case .Signin(let email, let password):
          let params = ["user": ["email": "\(email)", "password": "\(password)"] ]
          httpMethod = "POST"
          return ("/users/sign_in", params)
          
        case .GetFriendList:
          let params = ["": ""]
          httpMethod = "GET"
          return ("/users", params)
          
        case .GetChatroomList:
          let params = ["": ""]
          httpMethod = "GET"
          //let userId = getUserId()
          let user = currentUser!
          let path = "/users/\(user.id!)/rooms"
          return (path, params)
          
        case .GetMessages(let roomId, let page):
          let params = ["page": "\(page)"]
          httpMethod = "GET"
          let path = "/rooms/\(roomId)/messages"
          println("path: \(path)")
          return (path, params)
          
        case .GetOrCreateChatroom(let createrId, let friendId):
          let params = ["creater_id": "\(createrId)", "friend_id": "\(friendId)"]
          httpMethod = "POST"
          return ("/rooms", params)
          
        }
      }()
      
      let URL = NSURL(string: Router.baseURLString)
      //let URLRequest = NSURLRequest(URL: URL!.URLByAppendingPathComponent(path))
      let mutableURLRequest = NSMutableURLRequest(URL: URL!.URLByAppendingPathComponent(path))
      mutableURLRequest.HTTPMethod = httpMethod
      //mutableURLRequest.setValue("HI", forHTTPHeaderField: "header")
      let encoding = Alamofire.ParameterEncoding.URL
      
      
      return encoding.encode(mutableURLRequest, parameters: parameters).0
      
    }
    
  }
  
}






@objc public protocol ResponseObjectSerializable {
  init(response: NSHTTPURLResponse, representation: AnyObject)
}


extension Alamofire.Request {
  
  public func responseObject<T: ResponseObjectSerializable>(completionHandler: (NSURLRequest, NSHTTPURLResponse?, T?, NSError?) -> Void) -> Self {
    
    let serializer: Serializer = {
      (request, response, data) in
      let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
      let (JSON: AnyObject?, serializationError) = JSONSerializer(request, response, data)
      
      if response != nil && JSON != nil {
        return (T(response: response!, representation: JSON!), nil)
      } else {
        return (nil, serializationError)
      }
      
    }
    
    return response(serializer: serializer, completionHandler: {
      (request, response, object, error) in
      completionHandler(request, response, object as? T, error)
    })
    
  }
  
}


@objc public protocol ResponseCollectionSerializable {
  // return collection [Self]
  static func collection(#response: NSHTTPURLResponse, representation: AnyObject) -> [Self]
}

extension Alamofire.Request {
  
  public func responseCollection<T: ResponseCollectionSerializable>(completionHandler:
    (NSURLRequest, NSHTTPURLResponse?, [T]?, NSError?) -> Void) -> Self {
      
      let serializer: Serializer = {
        (request, response, data) in
        let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
        let (JSON: AnyObject?, serializationError) = JSONSerializer(request, response, data)
        
        if response != nil && JSON != nil {
          return (T.collection(response: response!, representation: JSON!), nil)
        } else {
          return (nil, serializationError)
        }
      }
      
      return response(serializer: serializer, completionHandler: {
        (request, response, object, error) in
        completionHandler(request, response, object as? [T], error)
      })
  }
  
}