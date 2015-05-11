//
//  MessagesViewController.swift
//  SimpleChatClient
//
//  Created by Ryan on 2015/5/7.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Socket_IO_Client_Swift


class MessagesViewController: JSQMessagesViewController {
  
  

  //http://localhost:3000 is different with http://localhost:3000/
  //let socket = SocketIOClient(socketURL: "https://ryan-simple-chat-server.herokuapp.com")
  let socket = SocketIOClient(socketURL: "http://localhost:5000")

  var backgroundObserver: AnyObject!
  var foregroundObserver: AnyObject!
  
  var closeSocket: Bool = false
  
  
  
  
  var messages = [Message]()
  
  var avatars = Dictionary<String, UIImage>()
  
  //var outgoingBubbleImageView = JSQMessagesBubbleImageFactory().outgoingMessageBubbleImageViewWithColor(UIColor.jsq_messageBubbleLightGrayColor())
  
  //var incomingBubbleImageView = JSQMessagesBubbleImageFactory().incomingMessageBubbleImageViewWithColor(UIColor.jsq_messageBubbleGreenColor())
  

  var outgoingBubbleImageView = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
  
  var incomingBubbleImageView = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
  
 
  var senderImageUrl: String!
  var senderName: String!
//  var batchMessages = true
//  var ref: Firebase!
  
  deinit {
    println("Socket ViewController deinit")
    NSNotificationCenter.defaultCenter().removeObserver(backgroundObserver)
    NSNotificationCenter.defaultCenter().removeObserver(foregroundObserver)
    socket.close(fast: false)
  }


  override func viewDidLoad() {
    super.viewDidLoad()


    //let sender = "arere"
    //var message = Message(sender,  senderDisplayName: senderDisplayName, sMediaMessage: isMediaMessage, hash: hashString, text: text)
    
    
    inputToolbar.contentView.leftBarButtonItem = nil
    automaticallyScrollsToMostRecentMessage = true
    navigationController?.navigationBar.topItem?.title = "Logout"
    
    //let sender = (sender != nil) ? sender : "Anonymous"
    
    self.senderId = "1"
    self.senderDisplayName = "FuckYourMother"
    senderName = self.senderDisplayName
    
    let profileImageUrl: String? = "https://www.ycombinator.com/images/ycombinator-logo-fb889e2e.png"
    if let urlString = profileImageUrl {
      setupAvatarImage(senderId, name: senderName, imageUrl: urlString as String, incoming: false)
      senderImageUrl = urlString as String
    } else {
      setupAvatarColor(senderId, name: senderName, incoming: false)
      senderImageUrl = ""
    }
    

    //setupMessage()
    
    //collectionView.collectionViewLayout.springinessEnabled = true
    
    
    // Socket
    setNotificationForBackgroundAndForeGround()
    
    println("viewDleLoad")
    addHandlers()
    socket.connect()
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
    
    /*
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
    */
    
    
    socket.on("room_message") { [weak self] data, ack in
      
      if let senderId = data?[0] as? String, message = data?[1] as? String {
        
  
        let message = Message(senderId: senderId, text: message)
        self?.messages.append(message)
        
        self?.finishReceivingMessage()
      }
    }
    
    
    
    socket.on("disconnect") { [weak self] data, ack in
      println("disconnect to server")
    }
    
  }
  
  
//  func sendMessage() {
//    socket.emit("room_message", msgTextField.text);
//  }
  
  
  
  
  
  
  func sendMessage(text: String!, senderId: String!) {
    
    socket.emit("room_message", senderId , text);

    // *** STEP 3: ADD A MESSAGE TO FIREBASE
    /*
    messagesRef.childByAutoId().setValue([
      "text":text,
      "sender":sender,
      "imageUrl":senderImageUrl
      ])
    */
  }
  
  func setupMessage() {
    let senderId = "1"
    
    let senderDisplayName = "fake senderDisplayName"
    let isMediaMessage = false
    let hashInt = 1
    let text = "fake text"
    //senderId: String, senderDisplayName: String?, isMediaMessage: Bool, hash: Int, text: String
    let message = Message(senderId: senderId, senderDisplayName: senderDisplayName, isMediaMessage: false, hash: hashInt, text: text)
    
  
    self.messages.append(message)
    
    self.finishReceivingMessage()
  }
  
  
  // MARK- Avatar
  func setupAvatarImage(senderId: String, name: String, imageUrl: String?, incoming: Bool) {
    if let stringUrl = imageUrl {
      if let url = NSURL(string: stringUrl) {
        if let data = NSData(contentsOfURL: url) {
          
          let image = UIImage(data: data)
          let diameter = incoming ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
          let avatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(image, diameter: diameter).avatarImage
          
          avatars[senderId] = avatarImage
          return
        }
      }
    }
    
    // At some point, we failed at getting the image (probably broken URL), so default to avatarColor
    //setupAvatarColor(senderId, name: name, incoming: incoming)
  }
  
  func setupAvatarColor(senderId: String, name: String, incoming: Bool) {
    let diameter = incoming ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
    
    let rgbValue = name.hash
    let r = CGFloat(Float((rgbValue & 0xFF0000) >> 16)/255.0)
    let g = CGFloat(Float((rgbValue & 0xFF00) >> 8)/255.0)
    let b = CGFloat(Float(rgbValue & 0xFF)/255.0)
    let color = UIColor(red: r, green: g, blue: b, alpha: 0.5)
    
    let nameLength = count(name)
    let initials : String? = name.substringToIndex(advance(senderName.startIndex, min(3, nameLength)))
    
    
    let userImage = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(initials, backgroundColor: color, textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(13)), diameter: diameter).avatarImage
    
    avatars[senderId] = userImage
  }
  
  
  // MARK: - Actions
  
  func receivedMessagePressed(sender: UIBarButtonItem) {
    // Simulate reciving message
    showTypingIndicator = !showTypingIndicator
    scrollToBottomAnimated(true)
  }
  
  
  //func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!)
  
  override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
    
    //JSQSystemSoundPlayer.jsq_playMessageSentSound()
    
    println("didPressSendButton")
    
    sendMessage(text, senderId: self.senderId)
    
    finishSendingMessage()
  }
  
  
  func sendMessage(text: String!, senderDisplayName: String!) {
    
  }
  
  
  override func didPressAccessoryButton(sender: UIButton!) {
    println("Camera pressed!")
  }
  
  
  //MARK: - JSQMessagesView Datasource
  
//  override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
//    return messages[indexPath.item]
//  }
  
  override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
    return messages[indexPath.item]
  }
  
  


  //JSQMessagesViewController collectionView:messageBubbleImageDataForItemAtIndexPath:
  override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource {
    
    let message = messages[indexPath.item]
    
    if message.senderId() == self.senderId {
      
    
      
      return outgoingBubbleImageView
      //return UIImageView(image: self.outgoingBubbleImageView.messageBubbleImage, highlightedImage: self.outgoingBubbleImageView.messageBubbleHighlightedImage)
    }
    
    return incomingBubbleImageView
    
    //return UIImageView(image: self.incomingBubbleImageView.messageBubbleImage, highlightedImage: self.incomingBubbleImageView.messageBubbleHighlightedImage)
  }
  
  
  
  
//  func collectionView(collectionView: JSQMessagesCollectionView!, bubbleImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
//    
//    let message = messages[indexPath.item]
//    
//    if message.senderId() == self.senderId {
//      return UIImageView(image: self.outgoingBubbleImageView.messageBubbleImage, highlightedImage: self.outgoingBubbleImageView.messageBubbleHighlightedImage)
//    }
//    
//    return UIImageView(image: self.incomingBubbleImageView.messageBubbleImage, highlightedImage: self.incomingBubbleImageView.messageBubbleHighlightedImage)
//  }
  
  
  override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource?  {
    
    let message = messages[indexPath.item]
    
    if let avatar = avatars[message.senderId()!] {
      
      let diameter = message.senderId() == self.senderId ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
      let avatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(avatar, diameter: diameter)
      
      
      return avatarImage //JSQMessagesAvatarImageFactory.avatarImageWithImage(avatar, diameter: 10)
      //return UIImageView(image: avatar)
      
    } else {
      
      println("else")
      let imageUrl = "https://www.ycombinator.com/images/ycombinator-logo-fb889e2e.png"
      setupAvatarImage(message.senderId()!, name: "Whatever", imageUrl: imageUrl, incoming: true)
      
      let image = avatars[message.senderId()!]
      
      let diameter = message.senderId() == self.senderId ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
      let avatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(image, diameter: diameter)
      
    
      return avatarImage //JSQMessagesAvatarImageFactory.avatarImageWithImage(avatar, diameter: 10)
      
      //return UIImageView(image:avatars[message.sender()])
      
      //let image = avatars[message.senderId()!]
      //return JSQMessagesAvatarImageFactory.avatarImageWithImage(image, diameter: 10)
    }
    //return nil
  }
  
//  func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
//    return nil
//  }
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return messages.count
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
    
    let message = messages[indexPath.item]
    if message.senderId() == self.senderId {
      cell.textView.textColor = UIColor.blackColor()
    } else {
      cell.textView.textColor = UIColor.whiteColor()
    }
    
    let attributes : [NSObject:AnyObject] = [NSForegroundColorAttributeName:cell.textView.textColor, NSUnderlineStyleAttributeName: 1]
    cell.textView.linkTextAttributes = attributes
    
    //        cell.textView.linkTextAttributes = [NSForegroundColorAttributeName: cell.textView.textColor,
    //            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle]
    
    
    
    
    return cell
  }
  
  
  // View  usernames above bubbles
  override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
    let message = messages[indexPath.item];
    
    // Sent by me, skip
    if message.senderId() == self.senderId {
      return nil;
    }
    
    // Same as previous sender, skip
    if indexPath.item > 0 {
      let previousMessage = messages[indexPath.item - 1];
      if previousMessage.senderId() == message.senderId() {
        return nil;
      }
    }
    
    return NSAttributedString(string: message.senderId()! )
  }
  
  
  // 設定最上層bobble所在的高度位置
  override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
    let message = messages[indexPath.item]
    
    println("in heightForMessageBubbleTopLabelAtIndexPath")
    
    // Sent by me, skip
    if message.senderId() == self.senderId {
      return CGFloat(0.0);
    }
    
    // Same as previous sender, skip
    if indexPath.item > 0 {
      let previousMessage = messages[indexPath.item - 1];
      if previousMessage.senderId() == message.senderId() {
        return CGFloat(0.0);
      }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault
  }
  
  
  



}
