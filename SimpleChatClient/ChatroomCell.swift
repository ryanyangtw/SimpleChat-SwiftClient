//
//  ChatroomCell.swift
//  SimpleChatClient
//
//  Created by Ryan on 2015/5/8.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import UIKit

class ChatroomCell: UITableViewCell {

  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!

  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  var downloadTask: NSURLSessionDownloadTask?
  
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func configureForChatroom(chatroom: ChatroomModel) {
    nameLabel.text = chatroom.name
    messageLabel.text = chatroom.lastMessage
    dateLabel.text = chatroom.lastMessageCreatedAt
    
    if let avatarUrl = chatroom.avatarUrl, let url = NSURL(string: avatarUrl) {
      self.downloadTask = avatarImageView.loadImageWithURL(url)
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.downloadTask?.cancel()
    self.downloadTask = nil
    self.nameLabel.text = nil
    self.avatarImageView.image = nil
  }


}
