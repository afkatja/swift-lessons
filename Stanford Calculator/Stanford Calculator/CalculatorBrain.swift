//
//  CalculatorBrain.swift
//  Stanford Calculator
//
//  Created by Katja Hollaar on 09/09/15
//

import Foundation

protocol Printable {
  var description: String {get}
}

class CalculatorBrain {
  private enum Op:Printable {
    case Operand(Double)
    case UnaryOperation(String, Double -> Double)
    case BinaryOperation(String, (Double, Double) -> Double)
    
    var description: String {
      get {
        switch self {
        case .Operand(let operand):
          return "\(operand)"
        case .UnaryOperation(let str, _):
          return str
        case .BinaryOperation(let str, _):
          return str
        }
      }
    }
  }

  
  private var opStack = [Op]() //same as Array<Op>
  private var knownOperations = [String: Op]() // same as Dictionary<String, Op>
  private var internalProgram = [AnyObject]()
  private var accumulator = 0.0
  
  func setOperand(operand: Double){
    accumulator = operand
    internalProgram.append(accumulator)
  }
  
  init(){
    func addOperation(op: Op){
      knownOperations[op.description] = op
    }
    addOperation(Op.BinaryOperation("×", *)) // same as to say {$0 * $1}
    addOperation(Op.BinaryOperation("+", +)) // same as to say {$0 + $1}
    addOperation(Op.BinaryOperation("-"){$1 - $0}) //because the order is different, cannot use -
    addOperation(Op.BinaryOperation("∕"){$1 / $0}) //because the order is different, cannot use /
    addOperation(Op.UnaryOperation("√", sqrt)) // same as to say {sqrt($0)}
  }
    
  func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return giveResult()
    }
    
    func performOperation(symbol: String) -> Double? {
      internalProgram.append(symbol)
      if let operation = knownOperations[symbol] { //lookup in dictionaries always returns an optional
          opStack.append(operation)
      }
      return giveResult()
    }
    
    func giveResult() -> Double? {
      let (result, remainder) = recursiveEvaluate(opStack)
      print("\(opStack) is \(result) with \(remainder) left over")
      return result
    }
  
  typealias PropertyList = AnyObject
  var program: PropertyList {
    get {
      return internalProgram
    }
    set {
      clear()
      if let opStack = newValue as? [AnyObject] {
        for op in opStack {
          if let operand = op as? Double {
            pushOperand(operand)
          } else if let operation = op as? String {
            performOperation(operation)
          }
        }
      }
    }
  }
  
  func clear() {
    accumulator = 0.0
    internalProgram.removeAll()
  }
  
    private func recursiveEvaluate(operations:[Op]) -> (result: Double?, remainingOperations: [Op]){
        if !operations.isEmpty {
            var remainingStack = operations
            let operation = remainingStack.removeLast() //like Array.pop()
            switch operation {
                case .Operand(let operand):
                    return (operand, remainingStack) //we got a Double, return it
                
                case .UnaryOperation(_, let op): //"_" = like "whatever"
                    let operandEvaluation = recursiveEvaluate(remainingStack)
                    if let operand = operandEvaluation.result {
                        return (op(operand), operandEvaluation.remainingOperations)
                    }
                case .BinaryOperation(_, let op):
                    let operandEvaluation = recursiveEvaluate(remainingStack)
                    if let operand1 = operandEvaluation.result {
                        let operandEvaluation2 = recursiveEvaluate(operandEvaluation.remainingOperations)
                        if let operand2 = operandEvaluation2.result {
                            return (op(operand1, operand2), operandEvaluation2.remainingOperations)
                        }
                    }
            }
        }
        return (nil, operations)
    }
}