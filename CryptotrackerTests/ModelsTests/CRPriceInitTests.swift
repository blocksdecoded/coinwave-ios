//
//  CRPriceInitTests.swift
//  CryptotrackerTests
//
//  Created by Abai Abakirov on 3/25/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import XCTest
@testable import Cryptotracker

class CRPriceInitTests: XCTestCase {
  var crPrice: CRPrice!
  var expPrice: Price!
  var expTimestamp: Double!
  
  override func setUp() {
    super.setUp()
    expPrice = Price(2048)
    expTimestamp = 2048
    crPrice = CRPrice(price: expPrice, timestamp: expTimestamp)
  }
  
  override func tearDown() {
    super.tearDown()
    crPrice = nil
    expPrice = nil
    expTimestamp = nil
  }
  
  func testPrice() {
    XCTAssertEqual(crPrice?.price?.value, expPrice.value)
  }
  
  func testTimestamp() {
    XCTAssertEqual(crPrice?.timestamp, expTimestamp)
  }
}
