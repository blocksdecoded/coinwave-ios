//
//  CRCoin.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 1/31/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import UIKit
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
  
  var priceStrShort: String {
    var str = "null"
    if let price = priceValue {
      str = CurrencyConverter.convertShort(price)
    }
    return str
  }
  
  var priceStrLong: String {
    var str = "null"
    if let price = priceValue {
      str = CurrencyConverter.convertLong(price)
    }
    return str
  }
  
  var marketCapStrShort: String {
    var str = "null"
    if let marketCap = marketCap {
      str = CurrencyConverter.convertShort(marketCap)
    }
    return str
  }
  
  var marketCapStrLong: String {
    var str = "null"
    if let marketCap = marketCap {
      str = CurrencyConverter.convertLong(marketCap)
    }
    return str
  }
  
  var volumeStrShort: String {
    var str = "null"
    if let volume = volume {
      str = CurrencyConverter.convertShort(volume)
    }
    return str
  }
  
  var volumeStrLong: String {
    var str = "null"
    if let volume = volume {
      str = CurrencyConverter.convertLong(volume)
    }
    return str
  }
  
  var circulatingSupplyStrLong: String {
    var str = "null"
    if let value = circulatingSupply {
      str = CurrencyConverter.convertLong(value)
    }
    return str
  }
  
  var totalSupplyStrLong: String {
    var str = "null"
    if let value = totalSupply {
      str = CurrencyConverter.convertLong(value)
    }
    return str
  }
  
  var changeStr: String {
    var str = "null"
    if let value = change {
      if value < 0 {
        str = "\(value)%"
      } else {
        str = "+\(value)%"
      }
    }
    return str
  }
  
  var changeColor: UIColor {
    if let value = change {
      if value < 0 {
        return Constants.Colors.currencyDown
      }
      return Constants.Colors.currencyUp
    }
    return Constants.Colors.def
  }
  
  var iconUrlEncoded: String? {
    return iconUrl?.replacingOccurrences(of: " ", with: "%20")
  }
}
