//
//  CalcButton.swift
//  Stanford Calculator
//
//  Created by Katja Hollaar on 13/07/16.
//  Copyright © 2016 Q42. All rights reserved.
//

import UIKit

class CalcButton: UIButton {
  required init?(coder aDecoder: NSCoder) { //sort of constructor, with named parameter
    super.init(coder: aDecoder)
    
    self.layer.cornerRadius = 10
    self.layer.borderWidth = 2
    self.layer.borderColor = UIColor.orangeColor().CGColor
    
    func tests(){
      test(q: "the answer to the universe")
    }
  }
  func test(q question: String) -> Float {
    return 42
  }
  
}
