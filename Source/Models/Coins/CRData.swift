//
//  CRData.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 1/31/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

struct CRData: Decodable {
  let stats: CRStats
  let base: CRBase
  let coins: [CRCoin]
}
