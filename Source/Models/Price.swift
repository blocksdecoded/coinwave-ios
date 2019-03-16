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
}

extension Price {
  var short: String {
    let (short, bill) = classify()
    return "$\(Price.toString(short))\(bill)"
  }
  
  var long: String {
    return "$\(Price.toString(value))"
  }
  
  var longForce: String {
    return "$\(Price.toString(value, force: true))"
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
  
  static func toString(_ value: Double, force: Bool = false) -> String {
    let formatter = NumberFormatter()
    if value < 0.000001 {
      formatter.numberStyle = .scientific
      formatter.positiveFormat = "0.##E+0"
      formatter.negativeFormat = "0.##E+0"
      formatter.exponentSymbol = "e"
    } else {
      if value < 0.1 || force {
        formatter.positiveFormat = "#,###,###,###,###,##0.00####"
        formatter.negativeFormat = "#,###,###,###,###,##0.00####"
      } else {
        formatter.positiveFormat = "#,###,###,###,###,##0.00"
        formatter.negativeFormat = "#,###,###,###,###,##0.00"
      }
    }
    return formatter.string(for: NSNumber(value: value)) ?? ""
  }
}

extension Price: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    do {
      let double = try container.decode(Double?.self)
      
      guard let notNilDouble = double else {
        throw ValueError.nilValue
      }
      
      value = notNilDouble
    } catch {
      let string = try container.decode(String?.self)
      
      guard let notNilString = string,
        let value = Double(notNilString) else {
          throw ValueError.nilValue
      }
      
      self.value = value
    }
  }
}

extension Price: Equatable {
  
}
