//
//  DateTests.swift
//  CryptotrackerTests
//
//  Created by Abai Abakirov on 3/22/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import XCTest
@testable import Cryptotracker

class DateTests: XCTestCase {  
  func testJustNow() {
    let lastDate = Date(timeIntervalSinceNow: -1)
    let text = DateTimeService.interval(date: lastDate)
    XCTAssertEqual("just now", text)
  }
  
  func test5minuteAgo() {
    let lastDate = Date(timeIntervalSinceNow: -301)
    let text = DateTimeService.interval(date: lastDate)
    XCTAssertEqual("5m. ago", text)
  }
  
  func test2hoursAgo() {
    let lastDate = Date(timeIntervalSinceNow: -7201)
    let text = DateTimeService.interval(date: lastDate)
    XCTAssertEqual("2h. ago", text)
  }
  
  func testYesterday() {
    let lastDate = Date(timeIntervalSinceNow: -86401)
    let text = DateTimeService.interval(date: lastDate)
    XCTAssertEqual("yesterday", text)
  }
  
  func test2daysAgo() {
    let lastDate = Date(timeIntervalSinceNow: -172801)
    let text = DateTimeService.interval(date: lastDate)
    XCTAssertEqual("2 days ago", text)
  }
  
  func testDate() {
    let lastDate = Date(timeIntervalSinceNow: -345600)
    let text = DateTimeService.interval(date: lastDate)
    
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    let expText = formatter.string(from: lastDate)
    XCTAssertEqual(expText, text)
  }
}
