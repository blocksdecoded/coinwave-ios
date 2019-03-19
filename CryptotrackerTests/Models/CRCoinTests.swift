//
//  CRCoinTests.swift
//  CryptotrackerTests
//
//  Created by Abai Abakirov on 3/19/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import XCTest
@testable import Cryptotracker

class CRCoinTests: XCTestCase {
  
  let cIdentifier: Int = 1
  let cSlug: String = "slug"
  let cSymbol: String = "symbol"
  let cName: String = "name"
  let cDescription: String? = "description"
  let cColor: String? = nil
  let cIconType: CRCoin.IconType? = .vector
  let cIconUrl: URL? = URL(string: "https://goo.gl/images/g2mUFA")
  let cWebsiteUrl: URL? = URL(string: "https://apple.com")
  let cConfirmedSupply: Bool = true
  let cType: CRCoin.CoinType = .coin
  let cVolume: Price? = Price(10)
  let cMarketCap: Price? = Price(100)
  let cPrice: Price? = Price(1)
  let cCirculatingSupply: Price? = Price(1000)
  let cTotalSupply: Price? = Price(500)
  let cFirstSeen: Double? = 1000
  let cChange: Double? = 3.48
  let cRank: Double = 1
  let cHistory: [String?] = [nil]
  let cAllTimeHigh: CRPrice = CRPrice(price: Price(20), timestamp: 123123)
  let cPenalty: Bool = false
  let cIsWatchlist: Bool = false
  let cIsFavorite: Bool = false
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testInit() {
    let coin = CRCoin(identifier: cIdentifier,
                      slug: cSlug,
                      symbol: cSymbol,
                      name: cName,
                      description: cDescription,
                      color: cColor,
                      iconType: cIconType,
                      iconUrl: cIconUrl,
                      websiteUrl: cWebsiteUrl,
                      confirmedSupply: cConfirmedSupply,
                      type: cType,
                      volume: cVolume,
                      marketCap: cMarketCap,
                      price: cPrice,
                      circulatingSupply: cCirculatingSupply,
                      totalSupply: cTotalSupply,
                      firstSeen: cFirstSeen,
                      change: cChange,
                      rank: cRank,
                      history: cHistory,
                      allTimeHigh: cAllTimeHigh,
                      penalty: cPenalty,
                      isWatchlist: cIsWatchlist,
                      isFavorite: cIsFavorite)
    
    XCTAssertEqual(coin.identifier, cIdentifier)
    XCTAssertEqual(coin.slug, cSlug)
    XCTAssertEqual(coin.symbol, cSymbol)
    XCTAssertEqual(coin.description, cDescription)
    XCTAssertEqual(coin.color, cColor)
    XCTAssertEqual(coin.iconType, cIconType)
    XCTAssertEqual(coin.iconUrl, cIconUrl)
    XCTAssertEqual(coin.websiteUrl, cWebsiteUrl)
    XCTAssertEqual(coin.confirmedSupply, cConfirmedSupply)
    XCTAssertEqual(coin.type, cType)
    XCTAssertEqual(coin.volume, cVolume)
    XCTAssertEqual(coin.marketCap, cMarketCap)
    XCTAssertEqual(coin.price, cPrice)
    XCTAssertEqual(coin.circulatingSupply, cCirculatingSupply)
    XCTAssertEqual(coin.totalSupply, cTotalSupply)
    XCTAssertEqual(coin.firstSeen, cFirstSeen)
    XCTAssertEqual(coin.change, cChange)
    XCTAssertEqual(coin.rank, cRank)
    XCTAssertEqual(coin.history, cHistory)
    XCTAssertEqual(coin.allTimeHigh, cAllTimeHigh)
    XCTAssertEqual(coin.penalty, cPenalty)
    XCTAssertEqual(coin.isWatchlist, cIsWatchlist)
    XCTAssertEqual(coin.isFavorite, cIsFavorite)
  }
}
