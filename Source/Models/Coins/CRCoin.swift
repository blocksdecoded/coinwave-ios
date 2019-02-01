//
//  CRCoin.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 1/31/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

struct CRCoin: Decodable {
  let id: Int
  let slug: String
  let symbol: String
  let name: String
  let description: String?
  let color: String?
  let iconType: IconType
  let iconUrl: String
  let websiteUrl: String
  let confirmedSupply: Bool
  let type: CoinType
  let volume: Double
  let marketCap: Double
  let price: String
  let circulatingSupply: Double
  let totalSupply: Double
  let firstSeen: Double
  let change: Double
  let rank: Double
  let history: [String?]
  let allTimeHigh: CRAllTimeHigh
  let penalty: Bool
  
  enum IconType: String, Decodable {
    case vector
    case pixel
  }
  
  enum CoinType: String, Decodable {
    case fiat
    case coin
    case denominator
  }
}

extension CRCoin {
  init() {
    id = -1
    slug = ""
    symbol = ""
    name = ""
    description = ""
    color = ""
    iconType = .pixel
    iconUrl = ""
    websiteUrl = ""
    confirmedSupply = true
    type = .coin
    volume = 1
    marketCap = 1
    price = ""
    circulatingSupply = 1
    totalSupply = 1
    firstSeen = 1
    change = 1
    rank = 1
    history = [String]()
    allTimeHigh = CRAllTimeHigh()
    penalty = false
  }
}

extension CRCoin {
  var priceValue: Double {
    return Double(price) ?? 0
  }
}
