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
  let cChangeStr: String = "+3.48%"
  let cChangeColor: UIColor = Constants.Colors.currencyUp
  let cRank: Double = 1
  let cHistory: [String?] = [nil]
  let cAllTimeHigh: CRPrice = CRPrice(price: Price(20), timestamp: 123123)
  let cPenalty: Bool = false
  let cIsWatchlist: Bool = false
  let cIsFavorite: Bool = false
  
  var coin: CRCoin?
  
  override func setUp() {
    super.setUp()
    coin = CRCoin(identifier: cIdentifier,
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
  }
  
  override func tearDown() {
    super.tearDown()
    coin = nil
  }
  
  func testIdentifier() {
    XCTAssertEqual(coin?.identifier, cIdentifier)
  }
  
  func testSlug() {
    XCTAssertEqual(coin?.slug, cSlug)
  }
  
  func testSymbol() {
    XCTAssertEqual(coin?.symbol, cSymbol)
  }
  
  func testDescription() {
    XCTAssertEqual(coin?.description, cDescription)
  }
  
  func testColor() {
    XCTAssertEqual(coin?.color, cColor)
  }
  
  func testIconType() {
    XCTAssertEqual(coin?.iconType, cIconType)
  }
  
  func testIconUrl() {
    XCTAssertEqual(coin?.iconUrl, cIconUrl)
  }
  
  func testWebsiteUrl() {
    XCTAssertEqual(coin?.websiteUrl, cWebsiteUrl)
  }
  
  func testConfirmedSupply() {
    XCTAssertEqual(coin?.confirmedSupply, cConfirmedSupply)
  }
  
  func testType() {
    XCTAssertEqual(coin?.type, cType)
  }
  
  func testVolume() {
    XCTAssertEqual(coin?.volume?.value, cVolume?.value)
  }
  
  func testMarketCap() {
    XCTAssertEqual(coin?.marketCap?.value, cMarketCap?.value)
  }
  
  func testPrice() {
    XCTAssertEqual(coin?.price?.value, cPrice?.value)
  }
  
  func testCirculatingSupply() {
    XCTAssertEqual(coin?.circulatingSupply?.value, cCirculatingSupply?.value)
  }
  
  func testTotalSupply() {
    XCTAssertEqual(coin?.totalSupply?.value, cTotalSupply?.value)
  }
  
  func testFirstSeen() {
    XCTAssertEqual(coin?.firstSeen, cFirstSeen)
  }
  
  func testChange() {
    XCTAssertEqual(coin?.change, cChange)
  }
  
  func testPositiveChange() {
    let coin = CRCoin.mock(change: 1.84)
    XCTAssertEqual("+1.84%", coin.changeStr)
  }
  
  func testNegativeChange() {
    let coin = CRCoin.mock(change: -1.84)
    XCTAssertEqual("-1.84%", coin.changeStr)
  }
  
  func testNullChange() {
    let coin = CRCoin.mock(change: nil)
    XCTAssertEqual("null", coin.changeStr)
  }
  
  func testChangeColor() {
    XCTAssertEqual(coin?.changeColor, cChangeColor)
  }
  
  func testPositiveChangeColor() {
    let coin = CRCoin.mock(change: 1.84)
    XCTAssertEqual(Constants.Colors.currencyUp, coin.changeColor)
  }
  
  func testNegativeChangeColor() {
    let coin = CRCoin.mock(change: -1.84)
    XCTAssertEqual(Constants.Colors.currencyDown, coin.changeColor)
  }
  
  func testNilChange() {
    let coin = CRCoin.mock(change: nil)
    XCTAssertEqual(Constants.Colors.def, coin.changeColor)
  }
  
  func testRank() {
    XCTAssertEqual(coin?.rank, cRank)
  }
  
  func testHistory() {
    XCTAssertEqual(coin?.history, cHistory)
  }
  
  func testAllTimeHigh() {
    XCTAssertEqual(coin?.allTimeHigh.price?.value, cAllTimeHigh.price?.value)
    XCTAssertEqual(coin?.allTimeHigh.timestamp, cAllTimeHigh.timestamp)
  }
  
  func testPenalty() {
    XCTAssertEqual(coin?.penalty, cPenalty)
  }
  
  func testIsWatchlist() {
    XCTAssertEqual(coin?.isWatchlist, cIsWatchlist)
  }
  
  func testIsFavorite() {
    XCTAssertEqual(coin?.isFavorite, cIsFavorite)
  }
}
