//
//  EmotionionsViewController.swift
//  FaceIt
//
//  Created by Katja Hollaar on 06/08/16.
//  Copyright © 2016 Q42. All rights reserved.
//

import UIKit

class EmotionionsViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    //but geometry is still unknown (like is it an iPad or iPhone)
  }

  override func viewWillAppear(animated: Bool) {
    // before view appears on screen we will get notified
  }
  override func viewDidAppear(animated: Bool) {
    // geometry is now known
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }

  private let emotions: Dictionary<String, FacialExpression> = [
    "angry": FacialExpression(eyes: .Closed, mouth: .Frown),
    "neutral": FacialExpression(eyes: .Open, mouth: .Neutral),
    "smirk": FacialExpression(eyes: .Open, mouth: .Smirk),
    "happy": FacialExpression(eyes: .Open, mouth: .Smile)
  ]

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      var destinationController = segue.destinationViewController
      if let navController = destinationController as? UINavigationController {
        destinationController = navController.visibleViewController ?? destinationController
      }
      if let faceController = destinationController as? FaceViewController {
        if let identifier = segue.identifier {
          if let expression = emotions[identifier] {
            faceController.expression = expression
            if let sendingBtn = sender as? UIButton {
              faceController.navigationItem.title = sendingBtn.currentTitle
            }
          }
        }
      }
        // Pass the selected object to the new view controller.
    }

}
