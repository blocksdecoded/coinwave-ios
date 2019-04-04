//
//  CWError.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 4/4/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

enum CWError: Error {
  case network
  case noData
  case nilValue
  
  var localizedDescription: String {
    switch self {
    case .network:
      return "You are currently offline.\nCheck your internet connection"
    default:
      return ""
    }
  }
}
