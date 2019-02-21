//
//  CRCoin.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 1/31/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import UIKit
import Foundation

struct CRCoin {
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
  var isWatchlist: Bool
  var isFavorite: Bool
  
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

extension CRCoin: Decodable {
  enum Keys: String, CodingKey {
    case id
    case slug
    case symbol
    case name
    case description
    case color
    case iconType
    case iconUrl
    case websiteUrl
    case confirmedSupply
    case type
    case volume
    case marketCap
    case price
    case circulatingSupply
    case totalSupply
    case firstSeen
    case change
    case rank
    case history
    case allTimeHigh
    case penalty
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: Keys.self)
    let id = try container.decode(Int.self, forKey: .id)
    let slug = try container.decode(String.self, forKey: .slug)
    let symbol = try container.decode(String.self, forKey: .symbol)
    let name = try container.decode(String.self, forKey: .name)
    let description = try container.decode(String?.self, forKey: .description)
    let color = try container.decode(String?.self, forKey: .color)
    let iconType = try container.decode(CRCoin.IconType?.self, forKey: .iconType)
    let iconUrl = try container.decode(String?.self, forKey: .iconUrl)
    let websiteUrl = try container.decode(String?.self, forKey: .websiteUrl)
    let confirmedSupply = try container.decode(Bool.self, forKey: .confirmedSupply)
    let type = try container.decode(CRCoin.CoinType.self, forKey: .type)
    let volume = try container.decode(Double?.self, forKey: .volume)
    let marketCap = try container.decode(Double?.self, forKey: .marketCap)
    let price = try container.decode(String?.self, forKey: .price)
    let circulatingSupply = try container.decode(Double?.self, forKey: .circulatingSupply)
    let totalSupply = try container.decode(Double?.self, forKey: .totalSupply)
    let firstSeen = try container.decode(Double?.self, forKey: .firstSeen)
    let change = try container.decode(Double?.self, forKey: .change)
    let rank = try container.decode(Double.self, forKey: .rank)
    let history = try container.decode([String?].self, forKey: .history)
    let allTimeHigh = try container.decode(CRPrice.self, forKey: .allTimeHigh)
    let penalty = try container.decode(Bool.self, forKey: .penalty)
    
    self.init(id: id,
              slug: slug,
              symbol: symbol,
              name: name,
              description: description,
              color: color,
              iconType: iconType,
              iconUrl: iconUrl,
              websiteUrl: websiteUrl,
              confirmedSupply: confirmedSupply,
              type: type,
              volume: volume,
              marketCap: marketCap,
              price: price,
              circulatingSupply: circulatingSupply,
              totalSupply: totalSupply,
              firstSeen: firstSeen,
              change: change,
              rank: rank,
              history: history,
              allTimeHigh: allTimeHigh,
              penalty: penalty,
              isWatchlist: false,
              isFavorite: false)
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
    isWatchlist = false
    isFavorite = false
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
