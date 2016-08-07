//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Katja Hollaar on 06/08/16.
//  Copyright © 2016 Q42. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController, UITextFieldDelegate {

  var tweets = [Array<Tweet>]() {
    didSet {
      tableView.reloadData()
    }
  }

  var searchText: String? {
    didSet {
      tweets.removeAll()
      searchForTweets()
      title = searchText
    }
  }
  
  lazy var refresher: UIRefreshControl = UIRefreshControl() //avoid unwrapping

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.estimatedRowHeight = tableView.rowHeight
    tableView.rowHeight = UITableViewAutomaticDimension
    refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
    refresher.addTarget(self, action: #selector(TweetTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
    tableView.addSubview(refresher)
  }

  private var lastRequest: Twitter.Request?

  private func searchForTweets() {
    if let request = twitterRequest {
      lastRequest = request
      request.fetchTweets { [weak weakSelf = self] newTweets in
        dispatch_async(dispatch_get_main_queue()) {
          if request == weakSelf?.lastRequest {
            if !newTweets.isEmpty {
              weakSelf?.tweets.insert(newTweets, atIndex: 0)
            }
          }
          weakSelf?.refresher.endRefreshing()
        }
      }
    } else {
      self.refresher.endRefreshing()
    }
  }

  func refresh(sender: UIRefreshControl) {
    searchForTweets()
  }

  private var twitterRequest: Twitter.Request? {
    if let query = searchText where !query.isEmpty {
      return Twitter.Request(search: query + "-filter:retweets", count: 100)
    }
    return lastRequest?.requestForNewer
  }

  private struct Storyboard {
    static let TweetIdentifier = "Tweet"
  }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tweets.count
    }

  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "\(tweets.count - section)"
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return tweets[section].count
  }


  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TweetIdentifier, forIndexPath: indexPath)
    let tweet = tweets[indexPath.section][indexPath.row]
    if let tweetCell = cell as? TweetCell {
      tweetCell.tweet = tweet
    }

      return cell
  }

  @IBOutlet weak var searchFieldText: UITextField! {
    didSet {
      searchFieldText.delegate = self
      searchFieldText.text = searchText
    }
  }

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder() //hide the keyboard
    searchText = textField.text
    return true
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
