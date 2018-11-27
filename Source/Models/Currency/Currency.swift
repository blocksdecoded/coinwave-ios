//
//  Currency.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/23/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation

struct Currency {
  // swiftlint:disable identifier_name
  let id: Int
  let name: String
  let symbol: String
  let websiteSlug: String
  let rank: Int
  let circulatingSupply: Double
  let totalSupply: Double
  let maxSupply: Double?
  let quotes: [String: Quote]
  let lastUpdated: Int
  
  init(id: Int,
       name: String,
       symbol: String,
       websiteSlug: String,
       rank: Int,
       circulatingSupply: Double,
       totalSupply: Double,
       maxSupply: Double?,
       quotes: [String: Quote],
       lastUpdated: Int) {
    self.id = id
    self.name = name
    self.symbol = symbol
    self.websiteSlug = websiteSlug
    self.rank = rank
    self.circulatingSupply = circulatingSupply
    self.totalSupply = totalSupply
    self.maxSupply = maxSupply
    self.quotes = quotes
    self.lastUpdated = lastUpdated
  }
}

extension Currency {
  var marketCap: Double? {
    return quotes["USD"]?.marketCap
  }
  
  var volume24h: Double? {
    return quotes["USD"]?.volume24h
  }
  
  var price: Double? {
    return quotes["USD"]?.price
  }
  
  var pricePercentChange1h: Double? {
    return quotes["USD"]?.percentChange1h
  }
  
  var pricePercentChange24h: Double? {
    return quotes["USD"]?.percentChange24h
  }
  
  var pricePercentChange7d: Double? {
    return quotes["USD"]?.percentChange7d
  }
}

extension Currency: Codable {
  private enum CodingKeys: String, CodingKey {
    case id
    case name
    case symbol
    case websiteSlug = "website_slug"
    case rank
    case circulatingSupply = "circulating_supply"
    case totalSupply = "total_supply"
    case maxSupply = "max_supply"
    case quotes
    case lastUpdated = "last_updated"
  }
}

struct CurrencyList: Codable {
  let data: [Currency]
}

struct SingleCurrency: Codable {
  let data: Currency
}
