//
//  UIImageView+DownloadImage.swift
//  StoreSearch
//
//  Created by Ryan on 2015/3/20.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import UIKit

extension UIImageView {
  func loadImageWithURL(url: NSURL) -> NSURLSessionDownloadTask {
    let session = NSURLSession.sharedSession()
    
    // 1 Create a downloadtask
    let downloadTask = session.downloadTaskWithURL( url, completionHandler: {
        [weak self] url, response, error in
      
        // 2 Giving a url where you can find the downloaded file (this url points to a local file rather than an internet address)
        if error == nil && url != nil {
          // 3 With this local utl, Load the file into an NSData object. And make an image from that.
          if let data = NSData(contentsOfURL: url) {
            if let image = UIImage(data: data) {
              // 4
              dispatch_async(dispatch_get_main_queue()) {
                if let strongSelf = self {
                  strongSelf.image = image
                }
              }
            }
          }
        }
        
      })
    
    // 5
    downloadTask.resume()
    return downloadTask
    
  }
}
