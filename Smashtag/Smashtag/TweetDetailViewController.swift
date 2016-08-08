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
  var tweet: Tweet? {
    didSet {
      //set the properties, like user name, image etc
    }
  }
}
