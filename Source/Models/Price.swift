//
//  Price.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 3/12/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

struct Price {
  private static let letters = ["k", "m", "b", "t", "p", "e"]
  
  let value: Double
}

extension Price {
  init?(_ double: Double?) {
    guard let notNilDouble = double else {
      return nil
    }
    
    value = notNilDouble
  }
  
  init?(string: String?) {
    guard let notNilString = string,
          let value = Double(notNilString) else {
      return nil
    }
    
    self.value = value
  }
}

extension Price {
  var short: String {
    let (short, bill) = classify()
    return "$\(toString(short))\(bill)"
  }
  
  var long: String {
    return "$\(toString(value))"
  }
  
  private func classify() -> (Double, String) {
    if value < 1000 {
      return (value, "")
    }
    
    var exp = Int(log(value) / log(1000.0))
    let result = value / pow(1000.0, Double(exp))
    
    if exp >= Price.letters.count {
      exp = Price.letters.count
    }
    
    return (result, Price.letters[exp - 1])
  }
  
  private func toString(_ value: Double) -> String {
    let formatter = NumberFormatter()
    if value < 0.01 {
      formatter.numberStyle = .scientific
      formatter.positiveFormat = "0.##E+0"
      formatter.negativeFormat = "0.##E+0"
      formatter.exponentSymbol = "e"
    } else {
      formatter.positiveFormat = "#,###,###,###,###,##0.00"
      formatter.negativeFormat = "#,###,###,###,###,##0.00"
    }
    return formatter.string(for: NSNumber(value: value)) ?? ""
  }
}

extension Price: Decodable {}
