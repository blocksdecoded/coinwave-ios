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
  let identifier: Int
  let slug: String
  let symbol: String
  let name: String
  let description: String?
  let color: String?
  let iconType: IconType?
  let iconUrl: URL?
  let websiteUrl: URL?
  let confirmedSupply: Bool
  let type: CoinType
  let volume: Price?
  let marketCap: Price?
  let price: Price?
  let circulatingSupply: Price?
  let totalSupply: Price?
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
    case identifier = "id"
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
    let identifier = try container.decode(Int.self, forKey: .identifier)
    let slug = try container.decode(String.self, forKey: .slug)
    let symbol = try container.decode(String.self, forKey: .symbol)
    let name = try container.decode(String.self, forKey: .name)
    let description = try container.decode(String?.self, forKey: .description)
    let color = try container.decode(String?.self, forKey: .color)
    let iconType = try container.decode(CRCoin.IconType?.self, forKey: .iconType)
    
    let stringIconUrl = try container.decode(String?.self, forKey: .iconUrl)
    var iconUrl: URL?
    if stringIconUrl != nil {
      iconUrl = URL(string: stringIconUrl!.trimmingCharacters(in: [" "]))
    }
    
    let stringWebsiteUrl = try container.decode(String?.self, forKey: .websiteUrl)
    var websiteUrl: URL?
    if stringWebsiteUrl != nil {
      websiteUrl = URL(string: stringWebsiteUrl!.trimmingCharacters(in: [" "]))
    }
    
    let confirmedSupply = try container.decode(Bool.self, forKey: .confirmedSupply)
    let type = try container.decode(CRCoin.CoinType.self, forKey: .type)
    let volume = try container.decode(Price?.self, forKey: .volume)
    let marketCap = try container.decode(Price?.self, forKey: .marketCap)
    let price = try container.decode(Price?.self, forKey: .price)
    let circulatingSupply = try container.decode(Price?.self, forKey: .circulatingSupply)
    let totalSupply = try container.decode(Price?.self, forKey: .totalSupply)
    let firstSeen = try container.decode(Double?.self, forKey: .firstSeen)
    let change = try container.decode(Double?.self, forKey: .change)
    let rank = try container.decode(Double.self, forKey: .rank)
    let history = try container.decode([String?].self, forKey: .history)
    let allTimeHigh = try container.decode(CRPrice.self, forKey: .allTimeHigh)
    let penalty = try container.decode(Bool.self, forKey: .penalty)
    
    self.init(identifier: identifier,
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
}
