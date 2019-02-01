//
//  CRRoot.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 1/31/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

struct CRRoot: Decodable {
  let status: Status
  let data: CRData
 
  enum Status: String, Decodable {
    case success
  }
}
