//
//  CRTimeframe.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 2/2/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

enum CRTimeframe {
  case h24
  case d7
  case d30
  case y1
  case y5
}

extension CRTimeframe {
  var value: String {
    switch self {
    case .h24:
      return "24h"
    case .d7:
      return "7d"
    case .d30:
      return "30d"
    case .y1:
      return "1y"
    case .y5:
      return "5y"
    }
  }
}
