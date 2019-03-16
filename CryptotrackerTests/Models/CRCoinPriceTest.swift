//
//  CRCoinPriceTest.swift
//  CryptotrackerTests
//
//  Created by Abai Abakirov on 3/16/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import XCTest
@testable import Cryptotracker

class CRCoinPriceTests: XCTestCase {
  
  var data: Data!
  var expStringPrice: Price!
  var expNilPrice: Price?
  var expDoublePrice: Price!
  
  override func setUp() {
    super.setUp()
    let bundle = Bundle(for: type(of: self))
    let path = bundle.path(forResource: "CRCoinPrice", ofType: ".json")!
    // swiftlint:disable force_try
    data = try! Data(contentsOf: URL(fileURLWithPath: path))
    expStringPrice = Price(4058.8754342943)
    expNilPrice = nil
    expDoublePrice = Price(71398305865)
  }
  
  override func tearDown() {
    super.tearDown()
    data = nil
    expStringPrice = nil
    expNilPrice = nil
    expDoublePrice = nil
  }
  
  func testStringPrice() {
    let actCRCoin = try! JSONDecoder().decode(CRCoin.self, from: data)
    XCTAssertEqual(actCRCoin.price, expStringPrice)
  }
  
  func testNilPrice() {
    let actCRCoin = try! JSONDecoder().decode(CRCoin.self, from: data)
    XCTAssertNil(actCRCoin.volume)
  }
  
  func testDoublePrice() {
    let actCRCoin = try! JSONDecoder().decode(CRCoin.self, from: data)
    XCTAssertEqual(actCRCoin.marketCap, expDoublePrice)
  }
}
