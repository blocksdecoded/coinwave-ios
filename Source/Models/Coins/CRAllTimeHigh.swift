//
//  CRAllTimeHigh.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 1/31/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

struct CRAllTimeHigh: Decodable {
  let price: String?
  let timestamp: Double?
}

extension CRAllTimeHigh {
  init() {
    price = nil
    timestamp = nil
  }
}
