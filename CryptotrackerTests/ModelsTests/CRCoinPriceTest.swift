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
  
  var crCoin: CRCoin!
  var expStringPrice: Price!
  var expNilPrice: Price?
  var expDoublePrice: Price!
  
  override func setUp() {
    super.setUp()
    let bundle = Bundle(for: type(of: self))
    let path = bundle.path(forResource: "CRCoinPrice", ofType: ".json")!
    // swiftlint:disable force_try
    let data = try! Data(contentsOf: URL(fileURLWithPath: path))
    crCoin = try! JSONDecoder().decode(CRCoin.self, from: data)
    expStringPrice = Price(4058.8754342943)
    expNilPrice = nil
    expDoublePrice = Price(71398305865)
  }
  
  override func tearDown() {
    super.tearDown()
    crCoin = nil
    expStringPrice = nil
    expNilPrice = nil
    expDoublePrice = nil
  }
  
  func testStringPrice() {
    XCTAssertEqual(crCoin.price, expStringPrice)
  }
  
  func testNilPrice() {
    XCTAssertNil(crCoin.volume)
  }
  
  func testDoublePrice() {
    XCTAssertEqual(crCoin.marketCap, expDoublePrice)
  }
}
