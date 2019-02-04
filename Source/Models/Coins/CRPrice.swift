//
//  CRAllTimeHigh.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 1/31/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

struct CRPrice: Decodable {
  let price: String?
  let timestamp: Double?
}

extension CRPrice {
  init() {
    price = nil
    timestamp = nil
  }
}
