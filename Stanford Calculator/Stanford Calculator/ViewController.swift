//
//  ViewController.swift
//  Stanford Calculator
//
//  Created by Katja Hollaar on 29/01/15
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel! //optional, but always automatically unwrap it (like type! - implicitly unwrapped optional)
    //weak is for garbage collection
    //var is when value can change

    var typingDigit = false //type inference
    var model = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        print("digit = \(digit)")
        if typingDigit {
          display.text = display.text! + digit
        } else {
          display.text = digit
          typingDigit = true
        }
    }
    
    var memory = Array<Double>() //creating instance of a class
    @IBAction func enter() {
      typingDigit = false
      if let result = model.pushOperand(displayValue) {
        displayValue = result
      } else {
        displayValue = 0
      }
    }
    
    @IBAction func operate(sender: UIButton) {
      if typingDigit {
          enter()
      }
      if let operation = sender.currentTitle {
        if let result = model.performOperation(operation) {
          displayValue = result
        } else {
          displayValue = 0
        }
      }

    }
  
    
    //computed property
    var displayValue: Double {
        get {
           return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)" //convert to string, newValue = magic of a setter
            typingDigit = false
        }
    }
}

