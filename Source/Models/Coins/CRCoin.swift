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
  let iconType: IconType?
  let iconUrl: String?
  let websiteUrl: String?
  let confirmedSupply: Bool
  let type: CoinType
  let volume: Double?
  let marketCap: Double?
  let price: String?
  let circulatingSupply: Double?
  let totalSupply: Double?
  let firstSeen: Double?
  let change: Double?
  let rank: Double
  let history: [String?]
  let allTimeHigh: CRPrice
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
    description = nil
    color = nil
    iconType = nil
    iconUrl = nil
    websiteUrl = nil
    confirmedSupply = true
    type = .coin
    volume = nil
    marketCap = nil
    price = nil
    circulatingSupply = nil
    totalSupply = nil
    firstSeen = nil
    change = nil
    rank = 1
    history = [String?]()
    allTimeHigh = CRPrice()
    penalty = false
  }
}

extension CRCoin {
  var priceValue: Double? {
    guard let price = price else {
      return nil
    }
    return Double(price)
  }
  
  var iconUrlEncoded: String? {
    return iconUrl?.replacingOccurrences(of: " ", with: "%20")
  }
}
