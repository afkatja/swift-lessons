//
//  FaceView.swift
//  FaceIt
//
//  Created by Katja Hollaar on 01/08/16.
//  Copyright © 2016 Q42. All rights reserved.
//

import UIKit

@IBDesignable

class FaceView: UIView {

  @IBInspectable
  var scale: CGFloat = 0.9 {
    didSet {
      setNeedsDisplay()
    }
  }
  @IBInspectable
  var thickness: CGFloat = 8.0 {
    didSet {
      setNeedsDisplay()
    }
  }
  @IBInspectable
  var curve: Double = 1.0 {//sad face would be -1.0
    didSet {
      setNeedsDisplay()
    }
  }
  @IBInspectable
  var eyesOpen: Bool = true {
    didSet {
      setNeedsDisplay()
    }
  }
  @IBInspectable
  var color:UIColor = UIColor.blackColor() {
    didSet {
      setNeedsDisplay()
    }
  }

  //will be called from the controller
  func changeScale(recognizer: UIPinchGestureRecognizer){
    switch recognizer.state {
    case .Changed, .Ended:
      scale *= recognizer.scale
      recognizer.scale = 1.0 //reset incrementally
    default:
      break
    }
  }

  private var width: CGFloat {
    return bounds.size.width
  }
  private var height:CGFloat {
    return bounds.size.height
  }
  private var faceRadius: CGFloat {
    return min(width, height) / 2 * scale
  }
  private var faceCenter:CGPoint {
    return CGPoint(x: bounds.midX, y: bounds.midY)
  }

  private struct Ratios {
    static let EyeRadius: CGFloat = 20
    static let EyeOffset: CGFloat = 20
    static let MouthWidth: CGFloat = 100
    static let MouthOffset: CGFloat = 5
  }

  private enum Eye {
    case Left
    case Right
  }

  private func pathForCircleAtCenter(midPoint: CGPoint, radius: CGFloat) -> UIBezierPath {
    let path = UIBezierPath(arcCenter: midPoint, radius: radius, startAngle: 0.0, endAngle: CGFloat(2*M_PI), clockwise: true)

    path.lineWidth = thickness
    return path
  }

  private func getEyeCenter(eye: Eye) -> CGPoint {
    let eyeOffset = faceRadius / Ratios.EyeOffset + Ratios.EyeOffset * 2
    var eyeCenter = faceCenter
    eyeCenter.y -= eyeOffset
    switch eye {
    case .Left: eyeCenter.x -= eyeOffset
    case .Right: eyeCenter.x += eyeOffset
    }
    return eyeCenter
  }

  private func drawEye(eye: Eye) -> UIBezierPath {
    let eyeRadius = Ratios.EyeRadius * scale
    let eyeCenter = getEyeCenter(eye)
    if eyesOpen {
      return pathForCircleAtCenter(eyeCenter, radius: eyeRadius)
    } else {
      let path = UIBezierPath()
      path.moveToPoint(CGPoint(x: eyeCenter.x - eyeRadius * 2, y: eyeCenter.y - eyeRadius))
      let eyeEnd = CGPoint(x: eyeCenter.x + eyeRadius * 2, y: eyeCenter.y - eyeRadius)
      let cp1 = CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y + eyeRadius)
      let cp2 = CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y + eyeRadius)
      path.addCurveToPoint(eyeEnd, controlPoint1: cp1, controlPoint2: cp2)
      path.lineWidth = thickness
      path.lineCapStyle = .Round
      return path
    }
  }

  private func drawMouth()-> UIBezierPath {
    let mouthSize = (faceRadius / Ratios.MouthWidth + Ratios.MouthWidth * 2) * scale
    let mouthOffset = faceRadius / Ratios.MouthOffset
    let mouthRect = CGRect(x: faceCenter.x - mouthSize / 2, y: faceCenter.y + mouthOffset, width: mouthSize, height: mouthSize / 2)
    let smileOffset = CGFloat(max(-1, min(curve, 1))) * mouthRect.height
    let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
    let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
    let controlPoint1 = CGPoint(x: mouthRect.minX + mouthSize / 4, y: mouthRect.minY + smileOffset)
    let controlPoint2 = CGPoint(x: mouthRect.maxX - mouthSize / 4, y: mouthRect.minY + smileOffset)
    let path = UIBezierPath()
    path.moveToPoint(start)
    path.addCurveToPoint(end, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
    path.lineWidth = thickness
    path.lineCapStyle = .Round
    return path
  }

    override func drawRect(rect: CGRect) {
      UIColor.yellowColor().setFill()
      color.setStroke()
      let face = pathForCircleAtCenter(faceCenter, radius: faceRadius)
      face.fill()
      face.stroke()
      drawEye(.Left).stroke()
      drawEye(.Right).stroke()
      drawMouth().stroke()
    }

}
