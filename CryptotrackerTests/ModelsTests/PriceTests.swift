//
//  PriceTests.swift
//  CryptotrackerTests
//
//  Created by Abai Abakirov on 3/16/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import XCTest
@testable import Cryptotracker

class PriceTests: XCTestCase {
  
  func testNilValue() {
    let price = Price(nil)
    XCTAssertNil(price)
  }
  
  func testNormalValue() {
    let price = Price(20)
    XCTAssertEqual(20, price?.value)
  }
  
  func testScientificValue() {
    let price = Price(0.0000001)
    XCTAssertEqual("$1e-7", price?.long)
  }
  
  func testScientificWithTailValue() {
    let price = Price(0.000000145)
    XCTAssertEqual("$1.45e-7", price?.long)
  }
}
