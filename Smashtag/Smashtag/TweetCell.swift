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

      UserName?.text = "\(tweet.user)"

      var tweetText = NSMutableAttributedString(string: tweet.text)
      for mention in tweet.userMentions {
        tweetText.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: mention.nsrange)
        tweetText.addAttributes([NSForegroundColorAttributeName: UIColor.blueColor(), NSFontAttributeName: UIFont.boldSystemFontOfSize(18.0)], range: mention.nsrange)
      }
      for hashtag in tweet.hashtags {
        tweetText.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: hashtag.nsrange)
        tweetText.addAttributes([NSForegroundColorAttributeName: UIColor.blueColor(), NSFontAttributeName: UIFont.boldSystemFontOfSize(18.0)], range: hashtag.nsrange)
      }

      TweetText?.attributedText = tweetText

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

//private extension NSMutableAttributedString {
//  func addAttributes(attrs: [String : AnyObject], mentions: [Tweet.userMentions]) {
//    for keyword in mentions {
//      self.addAttributes(attrs, range: keyword.nsrange)
//    }
//  }
//}
