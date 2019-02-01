//
//  CRRoot.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 1/31/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

struct CRRoot<T: Decodable>: Decodable {
  let status: Status
  let data: T
 
  enum Status: String, Decodable {
    case success
  }
}
