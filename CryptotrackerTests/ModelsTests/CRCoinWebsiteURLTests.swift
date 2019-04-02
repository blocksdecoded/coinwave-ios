//
//  CRCoinWebsiteURLTests.swift
//  CryptotrackerTests
//
//  Created by Abai Abakirov on 4/2/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import XCTest
@testable import Cryptotracker

class CRCoinWebsiteURLTests: XCTestCase {
  
  var crCoin: CRCoin!
  var expWebsiteUrl: URL?
  
  override func setUp() {
    super.setUp()
    let bundle = Bundle(for: type(of: self))
    let path = bundle.path(forResource: "InvalidUrlCRCoin", ofType: ".json")!
    // swiftlint:disable force_try
    let data = try! Data(contentsOf: URL(fileURLWithPath: path))
    crCoin = try! JSONDecoder().decode(CRCoin.self, from: data)
    expWebsiteUrl = URL(string: "https://iost.io/")
  }
  
  func testUrl() {
    XCTAssertEqual(crCoin.websiteUrl, expWebsiteUrl)
  }
}
