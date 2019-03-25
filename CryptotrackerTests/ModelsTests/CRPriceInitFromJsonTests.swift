//
//  CRPriceInitFromJsonTests.swift
//  CryptotrackerTests
//
//  Created by Abai Abakirov on 3/25/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import XCTest
@testable import Cryptotracker

class CRPriceInitFromJsonTests: XCTestCase {
  var crPrice: CRPrice!
  var expPrice: Price!
  var expTimestamp: Double!
  
  override func setUp() {
    super.setUp()
    let bundle = Bundle(for: type(of: self))
    let path = bundle.path(forResource: "CRPrice", ofType: ".json")!
    // swiftlint:disable force_try
    let data = try! Data(contentsOf: URL(fileURLWithPath: path))
    crPrice = try! JSONDecoder().decode(CRPrice.self, from: data)
    expPrice = Price(19500.47124838819)
    expTimestamp = 1513555200000
  }
  
  override func tearDown() {
    super.tearDown()
    crPrice = nil
    expPrice = nil
    expTimestamp = nil
  }
  
  func testPrice() {
    XCTAssertEqual(crPrice.price?.value, expPrice.value)
  }
  
  func testTimestamp() {
    XCTAssertEqual(crPrice.timestamp, expTimestamp)
  }
}
