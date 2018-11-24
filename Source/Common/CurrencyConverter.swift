//
//  CurrencyConverter.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/24/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation

class CurrencyConverter {
  
  private static let letters = ["k", "m", "b", "t", "p", "e"]
  
  static func convert(_ value: Double) -> String {
    
    let (short, bill) = classify(value)
    
    return "$\(toString(short))\(bill)"
  }
  
  private static func classify(_ value: Double) -> (Double, String) {
    if value < 1000 {
      return (value, "")
    }
    
    var exp = Int(log(value) / log(1000.0))
    let result = value / pow(1000.0, Double(exp))
    
    if exp >= letters.count {
      exp = letters.count
    }
    
    return (result, letters[exp - 1])
  }
  
  private static func toString(_ value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.groupingSeparator = ","
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 2
    return formatter.string(for: NSNumber(value: value)) ?? ""
  }
  
}
