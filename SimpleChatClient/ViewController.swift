//
//  ViewController.swift
//  SimpleChatClient
//
//  Created by Ryan on 2015/5/6.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift

class ViewController: UIViewController{

  //http://localhost:3000 is different with http://localhost:3000/
  //let socket = SocketIOClient(socketURL: "https://ryan-simple-chat-server.herokuapp.com")
  let socket = SocketIOClient(socketURL: "http://localhost:5000")
  
  
  var backgroundObserver: AnyObject!
  var foregroundObserver: AnyObject!
  
  var closeSocket: Bool = false
  
  
  

  
  @IBOutlet weak var msgTextField: UITextField!
  
  @IBOutlet weak var messageLabel: UILabel!
  
  
  var localMessage: String = "" {
    didSet {
      self.messageLabel.text = localMessage
    }
  }
  
  var msgShouldBeSent: String? {
    didSet {
      if msgShouldBeSent != nil {
        //println("msgShouldBeSent: \(msgShouldBeSent!)")
      }
    }
  }
  
  
  deinit {
    println("Socket ViewController deinit")
    NSNotificationCenter.defaultCenter().removeObserver(backgroundObserver)
    NSNotificationCenter.defaultCenter().removeObserver(foregroundObserver)
    socket.close(fast: false)

  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    setNotificationForBackgroundAndForeGround()
    
    println("viewDleLoad")
    addHandlers()
    socket.connect()
  }
  
  override func viewWillAppear(animated: Bool) {
    /*
    println("In viewWillAppear")
    super.viewWillAppear(animated)
    closeSocket = false
    socket.connect()
    */
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  func setNotificationForBackgroundAndForeGround() {
    println("In listenForBackgroundNotification")
    
    backgroundObserver = NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationDidEnterBackgroundNotification, object: nil, queue: NSOperationQueue.mainQueue()) { [weak self] notification in
        println("In notificatin")
        if let strongSelf = self {
          strongSelf.closeSocket = true
          
          
          afterDelay(5) {
            println("strongSelf.closeSocket : \(strongSelf.closeSocket)")
            if strongSelf.closeSocket {
              println("Close socket")
              strongSelf.socket.close(fast: true)
            }
          }
         
        }
    }
    
    foregroundObserver = NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationWillEnterForegroundNotification, object: nil, queue: NSOperationQueue.mainQueue()) { [weak self] notification in
      println("In notificatin")
      if let strongSelf = self {
        strongSelf.closeSocket = false
        
        strongSelf.socket.connect()
      }
    }

  
  }
  
  
  
  @IBAction func send(sender: UIButton) {
    
    if count(msgTextField.text) > 0 {
      msgShouldBeSent = msgTextField.text
      sendMessage()
    }
  }
  
  
  // MARK: - Socket method
  func addHandlers() {
    
    // It's a goood method for debugging the API.
    socket.onAny() {
      println("Got event: \($0.event), with items: \($0.items)")
    }
    
    socket.on("connect") { [weak self] data, ack in
      println("success connect")
      
      
      let room = 1
      self?.socket.emit("join_room", room)
    }
    
    socket.on("message") { [weak self] data, ack in
      
      if let message = data?[0] as? String {
        println("receive message: \(message)")
        self?.localMessage = self!.localMessage + message + "\n"
      }
      
      /*
      println("in message event")
      println("data: \(data)")
      println("data[0]: \(data?[0])")
      println("data[1]: \(data?[1])")
      */

    }
    
    
    socket.on("room_message") { [weak self] data, ack in
      
      if let message = data?[0] as? String {
        println("receive room_message: \(message)")
        self?.localMessage = self!.localMessage + message + "\n"
      }
    }
    
    
    
    socket.on("disconnect") { [weak self] data, ack in
      println("disconnect to server")
    }
    
  }
  
  
  func sendMessage() {
    socket.emit("room_message", msgTextField.text);
  }
  
  
  
  
  
}



// MARK: - UITextField Delegate
extension ViewController: UITextFieldDelegate {
  
  // This mehod will be trigger when someonw enter the return key
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    
    if textField == msgTextField {
      textField.resignFirstResponder() // dismiss the keyboard
      msgShouldBeSent = textField.text
      sendMessage()
    }
    return true
  }

}

