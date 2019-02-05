//
//  CRStats.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 1/31/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

struct CRStats: Decodable {
  let total: Int
  let offset: Int
  let limit: Int?
  let order: Order?
  let base: String
  
  enum Order: String, Decodable {
    case desc
    case asc
  }
}
