//
//  ViewController.swift
//  FaceIt
//
//  Created by Katja Hollaar on 01/08/16.
//  Copyright © 2016 Q42. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {

  var expression: FacialExpression = FacialExpression(eyes: .Open, mouth: .Smirk) {
    didSet {
      updateUi()
    }
  }

  private var mouthExpressions = [
    FacialExpression.Mouth.Frown: -1.0,
    .Neutral: 0,
    .Smirk: 0.5,
    .Smile: 1.0
  ]

  @IBOutlet weak var faceView: FaceView! {
    didSet {
      faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector(faceView.changeScale(_:))))

      let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.increaseSmile))
      upSwipe.direction = .Up
      faceView.addGestureRecognizer(upSwipe)

      let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.decreaseSmile))
      downSwipe.direction = .Down
      faceView.addGestureRecognizer(downSwipe)

      updateUi()
    }
  }

  @IBAction func toggleEyes(sender: UITapGestureRecognizer) {
    if sender.state == .Ended {
      switch expression.eyes {
        case .Closed: expression.eyes = .Open
        case .Open: expression.eyes = .Closed
        case .Squinting: break
      }
    }
  }


  func increaseSmile(){
    expression.mouth = expression.mouth.happier()
  }

  func decreaseSmile(){
    expression.mouth = expression.mouth.sadder()
  }

  func updateUi(){
    if faceView != nil {
      switch expression.eyes {
        case .Open: faceView.eyesOpen = true
        case .Closed: faceView.eyesOpen = false
        case .Squinting: faceView.eyesOpen = false
      }
      faceView.curve = mouthExpressions[expression.mouth] ?? 0.0
    }
  }
}