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
  
  func testShortBig() {
    let price = Price(345.442244)
    XCTAssertEqual("$345.44", price?.short)
  }
  
  func testShortZeroes() {
    let price = Price(0.0100)
    XCTAssertEqual("$0.01", price?.short)
  }
  
  func testShortVerySmall() {
    let price = Price(0.003015999)
    XCTAssertEqual("$0.003016", price?.short)
  }
  
  func testLongForceVerySmall() {
    let price = Price(0.000000145)
    XCTAssertEqual("$1.45e-7", price?.longForce)
  }
  
  func testLongForceSmall() {
    let price = Price(0.000145)
    XCTAssertEqual("$0.000145", price?.longForce)
  }
  
  func testLongForceBig() {
    let price = Price(3456.2299443124556432)
    XCTAssertEqual("$3,456.229944", price?.longForce)
  }
  
  func testShortK() {
    let price = Price(123888)
    XCTAssertEqual("$123.89k", price?.short)
  }
  
  func testShortM() {
    let price = Price(123888000)
    XCTAssertEqual("$123.89m", price?.short)
  }
  
  func testShortB() {
    let price = Price(123888000000)
    XCTAssertEqual("$123.89b", price?.short)
  }
  
  func testShortT() {
    let price = Price(123888000000000)
    XCTAssertEqual("$123.89t", price?.short)
  }
  
  func testShortP() {
    let price = Price(123888000000000000)
    XCTAssertEqual("$123.89p", price?.short)
  }
  
  func testShortE() {
    let price = Price(123888000000000000000)
    XCTAssertEqual("$123.89e", price?.short)
  }
}
