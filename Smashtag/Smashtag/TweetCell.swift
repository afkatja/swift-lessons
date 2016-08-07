//
//  TweetCell.swift
//  Smashtag
//
//  Created by Katja Hollaar on 06/08/16.
//  Copyright © 2016 Q42. All rights reserved.
//

import UIKit
import Twitter

class TweetCell: UITableViewCell {

  @IBOutlet weak var UserAvatar: UIImageView!

  @IBOutlet weak var UserName: UILabel!

  @IBOutlet weak var TweetText: UILabel!

  @IBOutlet weak var TweetCreated: UILabel!

  var tweet: Twitter.Tweet? {
    didSet {
      updateUI()
    }
  }

  private func updateUI () {
    //reset existing information
    TweetText?.attributedText = nil
    UserName?.text = nil
    UserAvatar?.image = nil
    TweetCreated?.text = nil

    if let tweet = self.tweet {
      TweetText?.text = tweet.text
      UserName?.text = "\(tweet.user)"
      if let profileImage = tweet.user.profileImageURL {
        //TODO use dispatch async
        if let imageData = NSData(contentsOfURL: profileImage) {
          UserAvatar?.image = UIImage(data: imageData)
        }
      }
      TweetCreated?.text = "\(tweet.created)"
    }

  }
}
