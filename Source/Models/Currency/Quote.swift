//
//  Quote.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/23/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation

struct Quote {
  let price: Double
  let volume24h: Double
  let marketCap: Double
  let percentChange1h: Double
  let percentChange24h: Double
  let percentChange7d: Double?
}

extension Quote: Codable {
  private enum QuoteCodingKeys: String, CodingKey {
    case price
    case volume24h = "volume_24h"
    case marketCap = "market_cap"
    case percentChange1h = "percent_change_1h"
    case percentChange24h = "percent_change_24h"
    case percentChange7d = "percent_change_7d"
  }
  
  init(from decoder: Decoder) throws {
    let quoteContainer = try decoder.container(keyedBy: QuoteCodingKeys.self)
    
    price = try quoteContainer.decode(Double.self, forKey: .price)
    volume24h = try quoteContainer.decode(Double.self, forKey: .volume24h)
    marketCap = try quoteContainer.decode(Double.self, forKey: .marketCap)
    percentChange1h = try quoteContainer.decode(Double.self, forKey: .percentChange1h)
    percentChange24h = try quoteContainer.decode(Double.self, forKey: .percentChange24h)
    percentChange7d = try quoteContainer.decode(Double?.self, forKey: .percentChange7d)
  }
}
