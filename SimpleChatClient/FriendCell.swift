//
//  FriendCell.swift
//  SimpleChatClient
//
//  Created by Ryan on 2015/5/8.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
  
  
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  
  var downloadTask: NSURLSessionDownloadTask?

  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
  
  func configureForFriend(user: UserModel) {
    nameLabel.text = user.name
    
    if let avatarUrl = user.avatarUrl, let url = NSURL(string: avatarUrl) {
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
