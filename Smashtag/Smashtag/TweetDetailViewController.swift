//
//  TweetDetailViewController.swift
//  Smashtag
//
//  Created by Katja Hollaar on 07/08/16.
//  Copyright © 2016 Q42. All rights reserved.
//

import UIKit
import Twitter

class TweetDetailViewController: UITableViewController {
  var tweetDetail: Tweet? {
    didSet {
      //set the properties, like user name, image etc
      print("tweet detail \(tweetDetail)")
      if let detail = tweetDetail {
        let user = detail.user
        title = user.name
        if detail.media.count > 0 {
          
        }
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.estimatedRowHeight = tableView.rowHeight
    tableView.rowHeight = UITableViewAutomaticDimension
  }

  var keywords = [Array<Mention>]() {
    didSet {
      tableView.reloadData()
    }
  }

  private func insertKeywords(keywordsToInsert: [Mention]) {
    keywords.insert(keywordsToInsert, atIndex: keywordsToInsert.count)
  }

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return keywords.count
  }

  /*override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
   return "\(tweets.count - section)"
   }*/

  /*override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets[section].count
  }


  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TweetIdentifier, forIndexPath: indexPath)
    let tweet = tweets[indexPath.section][indexPath.row]
    if let tweetCell = cell as? TweetCell {
      tweetCell.tweet = tweet
    }
    return cell
  }*/
}
