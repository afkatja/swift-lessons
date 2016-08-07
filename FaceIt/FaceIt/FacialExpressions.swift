//
//  FacialExpressions.swift
//  FaceIt
//
//  Created by Katja Hollaar on 02/08/16.
//  Copyright © 2016 Q42. All rights reserved.
//

import Foundation

struct FacialExpression {
  enum Eyes: Int {
    case Open
    case Closed
    case Squinting
  }
  enum Mouth: Int {
    case Smile
    case Neutral
    case Frown
    case Smirk

    func happier()->Mouth {
      return Mouth(rawValue: rawValue + 1) ?? .Smile
    }

    func sadder()->Mouth {
      return Mouth(rawValue: rawValue - 1) ?? .Frown
    }
  }

  var eyes: Eyes
  var mouth: Mouth
}
