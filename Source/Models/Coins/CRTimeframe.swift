//
//  CRTimeframe.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 2/2/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

enum CRTimeframe {
  case hour24
  case day7
  case day30
  case year1
  case year5
}

extension CRTimeframe {
  var value: String {
    switch self {
    case .hour24:
      return "24h"
    case .day7:
      return "7d"
    case .day30:
      return "30d"
    case .year1:
      return "1y"
    case .year5:
      return "5y"
    }
  }
}
