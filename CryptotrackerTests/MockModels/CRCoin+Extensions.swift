//
//  CRCoin+Extensions.swift
//  CryptotrackerTests
//
//  Created by Abai Abakirov on 3/25/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation
@testable import Cryptotracker

extension CRCoin {
  static func mock(
  identifier: Int = 1,
  slug: String = "slug",
  symbol: String = "symbol",
  name: String = "name",
  description: String? = "description",
  color: String? = "#ffffff",
  iconType: IconType? = .vector,
  iconUrl: URL? = URL(string: "https://goo.gl/images/g2mUFA"),
  websiteUrl: URL? = URL(string: "https://apple.com"),
  confirmedSupply: Bool = true,
  type: CoinType = .coin,
  volume: Price? = Price(1),
  marketCap: Price? = Price(1),
  price: Price? = Price(1),
  circulatingSupply: Price? = Price(1),
  totalSupply: Price? = Price(1),
  firstSeen: Double? = 1,
  change: Double? = 1,
  rank: Double = 1,
  history: [String?] = [""],
  allTimeHigh: CRPrice = CRPrice(price: Price(1), timestamp: 1),
  penalty: Bool = false,
  isWatchlist: Bool = false,
  isFavorite: Bool = false) -> CRCoin {
    return CRCoin(identifier: identifier,
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
              isWatchlist: isWatchlist,
              isFavorite: isFavorite)
  }
}
