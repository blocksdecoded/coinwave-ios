//
//  CRDataHistory.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 2/2/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

struct CRDataHistory: Decodable {
  let change: Double?
  let history: [CRPrice]
}
