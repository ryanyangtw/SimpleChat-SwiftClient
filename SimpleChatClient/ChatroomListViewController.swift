//
//  ChatroomListViewController.swift
//  SimpleChatClient
//
//  Created by Ryan on 2015/5/8.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import UIKit
import Alamofire

class ChatroomListViewController: UITableViewController {

  var chatroomList = [ChatroomModel]() {
    didSet {
      tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    getchatroomList()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  func setupUI() {
    self.tableView.rowHeight = 80
    //self.navigationController?.setToolbarHidden(false, animated: true)
  }
  
  
  
  
  
  
  func displayAlertMessage(alertTitle:String, alertDescription:String) -> Void {
    // hide activityIndicator view and display alert message
    //self.activityIndicatorView.hidden = true
    let errorAlert = UIAlertView(title:alertTitle as String, message:alertDescription as String, delegate:nil, cancelButtonTitle:"OK")
    errorAlert.show()
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
    chatroomList.removeAll(keepCapacity: true)
  }
  
  
  private struct Storyboard {
    static let CellReuseIdentifier = "ChatroomCell"
    static let GotoChatroomSegue = "GotoChatroomFromChatroomList"
    static let LogoutSegue = "Logout"
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if segue.identifier == Storyboard.GotoChatroomSegue {
      // Hide tab bar
      
      
      let detailViewController = segue.destinationViewController as! ChatroomViewController
      
      //self.hidesBottomBarWhenPushed = true
      detailViewController.hidesBottomBarWhenPushed = true
      
      let indexPath = sender as! NSIndexPath
      let chatroom = chatroomList[indexPath.row]
      detailViewController.chatroom = chatroom
    } else if segue.identifier == Storyboard.LogoutSegue {
      
      
      clearLoggedinFlagInUserDefaults()
      clearFirndListReloadCollectionView()

    }

    
  }
  
  func getchatroomList() {
    if refreshControl != nil {
      refreshControl?.beginRefreshing()
    }
    getChatroomList(refreshControl)
    
  }
  
  @IBAction func getChatroomList(sender: UIRefreshControl?) {
    Alamofire.request(SimpleChat.Router.GetChatroomList).validate().responseCollection() {
      (request, response, chatroomList: [ChatroomModel]?, error ) in
      
      //println(request)
      //println(response)
      
      if error == nil && chatroomList != nil{
        self.chatroomList = chatroomList!
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
    return chatroomList.count
  }
  
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> ChatroomCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as! ChatroomCell
    
    let chatroom = chatroomList[indexPath.row]
    cell.configureForChatroom(chatroom)
    return cell
    
  }
  
  
  // MARK: - UITableView Delegate
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    // deselect the row with animation
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    // Manually Trigger Segue
    performSegueWithIdentifier(Storyboard.GotoChatroomSegue, sender: indexPath)
    
 
  }
  
  
  
}


