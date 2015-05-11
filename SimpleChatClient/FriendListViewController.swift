//
//  FriendListViewController.swift
//  SimpleChatClient
//
//  Created by Ryan on 2015/5/8.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import UIKit
import Alamofire

class FriendListViewController: UITableViewController {
  
  var friendList = [UserModel]() {
    didSet {
      tableView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
    getFriendList()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  func setupUI() {
    self.tableView.rowHeight = 80
    
    /*
    var logOutBtn = UIBarButtonItem(title: "logout", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("logoutBtnTapped"))
    self.navigationItem.leftBarButtonItem = logOutBtn
    */
  }
  

  
  // 1. Clears the NSUserDefaults flag
  func clearLoggedinFlagInUserDefaults() {
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.removeObjectForKey("userLoggedIn")
    defaults.removeObjectForKey("userHash")
    defaults.synchronize()
  }
  
  // 2. Removes the data array
  // Removes the data array and reloads the collection view. This is to make sure that when a new user signs in they don’t see any cached data.
  func clearFirndListReloadCollectionView() {
    friendList.removeAll(keepCapacity: true)
  }
  
  
  
  
  
  func displayAlertMessage(alertTitle:String, alertDescription:String) -> Void {
    // hide activityIndicator view and display alert message
    //self.activityIndicatorView.hidden = true
    let errorAlert = UIAlertView(title:alertTitle as String, message:alertDescription as String, delegate:nil, cancelButtonTitle:"OK")
    errorAlert.show()
  }
  
  
  private struct Storyboard {
    static let CellReuseIdentifier = "FriendCell"
    static let GotoChatroomSegue = "GotoChatroomFromFriendlist"
    static let LogoutSegue = "Logout"
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    
    if segue.identifier == Storyboard.GotoChatroomSegue {
      // Hide tab bar
  
      let detailViewController = segue.destinationViewController as! ChatroomViewController
      
      //self.hidesBottomBarWhenPushed = true
      detailViewController.hidesBottomBarWhenPushed = true
      
      //let indexPath = sender as! NSIndexPath
      //let chatroom = chatroom
      detailViewController.chatroom = sender as! ChatroomModel
    } else if segue.identifier == Storyboard.LogoutSegue {
      
      
      clearLoggedinFlagInUserDefaults()
      clearFirndListReloadCollectionView()
      
      //let detailViewController = segue.destinationViewController as! ChatroomViewController
    
    }
    

  }
  
  func getFriendList() {
    if refreshControl != nil {
      refreshControl?.beginRefreshing()
    }
    getFriendList(refreshControl)
    
  }

  @IBAction func getFriendList(sender: UIRefreshControl?) {
    Alamofire.request(SimpleChat.Router.GetFriendList).validate().responseCollection() {
      (request, response, friendList: [UserModel]?, error ) in
      
      //println(request)
      //println(response)
      
      if error == nil {
        self.friendList = friendList!
      } else {
        println("error: \(error)")
        self.displayAlertMessage("錯誤", alertDescription: "請重新登入")
      }
      
      sender?.endRefreshing()
    }
  }

  
  // MARK: - UITableView DataSource
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // #warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete method implementation.
    // Return the number of rows in the section.
    return friendList.count
  }
  
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> FriendCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as! FriendCell
    
    let friend = friendList[indexPath.row]
    cell.configureForFriend(friend)
    return cell
    
  }
  
  
  // MARK: - UITableView Delegate
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    
    
  
    let friend = friendList[indexPath.row]
    
    Alamofire.request(SimpleChat.Router.GetOrCreateChatroom(currentUser!.id!, friend.id!)).validate().responseObject() {
      (request, response, chatroom: ChatroomModel?, error ) in
      
      if error == nil && chatroom != nil{
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier(Storyboard.GotoChatroomSegue, sender: chatroom)
        
      } else {
        println("error: \(error)")
        self.displayAlertMessage("錯誤", alertDescription: "請重新登入")
      }
      
    }
    
  }
  
  

}


