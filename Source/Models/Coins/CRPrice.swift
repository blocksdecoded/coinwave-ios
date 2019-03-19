//
//  CRAllTimeHigh.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 1/31/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

struct CRPrice {
  let price: Price?
  let timestamp: Double?
}

extension CRPrice {
  init() {
    price = nil
    timestamp = nil
  }
}

extension CRPrice: Decodable {
  enum Keys: String, CodingKey {
    case price
    case timestamp
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: Keys.self)
    let price = try container.decode(Price?.self, forKey: .price)
    let timestamp = try container.decode(Double?.self, forKey: .timestamp)
    self.init(price: price, timestamp: timestamp)
  }
}

extension CRPrice: Equatable {
  static func == (lhs: CRPrice, rhs: CRPrice) -> Bool {
    return lhs.price == rhs.price &&
           lhs.timestamp == rhs.timestamp
  }
}
