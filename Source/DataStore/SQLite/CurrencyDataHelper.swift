//
//  CurrencyDataHelper.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/24/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation
import SQLite

// swiftlint:disable type_name identifier_name
class CurrencyDataHelper: DataHelperProtocol {
  typealias T = Currency
  
  static let TABLE_NAME = "Currency"
  static let table = Table(TABLE_NAME)
  static let currID = Expression<Int64>("id")
  static let currName = Expression<String>("name")
  static let currSymbol = Expression<String>("symbol")
  static let currWebsiteSlug = Expression<String>("website_slug")
  static let currRank = Expression<Int64>("rank")
  static let currCirculatingSupply = Expression<Double>("circulating_supply")
  static let currTotalSupply = Expression<Double>("total_supply")
  static let currMaxSupply = Expression<Double?>("max_supply")
  static let currUSDPrice = Expression<Double?>("usd_double")
  static let currUSDVolume24h = Expression<Double?>("usd_volume_24_h")
  static let currUSDMarketCap = Expression<Double?>("usd_market_cap")
  static let currUSDPercentChange1h = Expression<Double?>("usd_percent_change_1_h")
  static let currUSDPercentChange24h = Expression<Double?>("usd_percent_change_24_h")
  static let currUSDPercentChange7d = Expression<Double?>("usd_percent_change_7_d")
  static let currLastUpdated = Expression<Int64>("last_updated")
  
  static func createTable() throws {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    do {
      _ = try db.run(table.create(ifNotExists: true) { t in
        t.column(currID, primaryKey: true)
        t.column(currName)
        t.column(currSymbol)
        t.column(currWebsiteSlug)
        t.column(currRank)
        t.column(currCirculatingSupply)
        t.column(currTotalSupply)
        t.column(currMaxSupply)
        t.column(currUSDPrice)
        t.column(currUSDVolume24h)
        t.column(currUSDMarketCap)
        t.column(currUSDPercentChange1h)
        t.column(currUSDPercentChange24h)
        t.column(currUSDPercentChange7d)
        t.column(currLastUpdated)
      })
    } catch _ {
      // Error throw if table already exists
    }
  }
  
  static func insertOrUpdate(item: Currency) throws {
    if try find(id: Int64(item.id)) != nil {
      try update(item: item)
    } else {
      try insert(item: item)
    }
  }
  
  @discardableResult
  static func insert(item: Currency) throws -> Int64 {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    let insert = table.insert(insertSetters(item: item))
    
    do {
      let rowId = try db.run(insert)
      guard rowId > 0 else {
        throw DataAccessError.insert
      }
      return rowId
    } catch _ {
      throw DataAccessError.insert
    }
  }
  
  static func update(item: Currency) throws {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    let curr = table.filter(currID == Int64(item.id))
    try db.run(curr.update(updateSetters(item: item)))
  }
  
  static func delete(item: Currency) throws {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    let lPostID = Int64(item.id)
    let query = table.filter(currID == lPostID)
    do {
      try PostCategoryDataHelper.delete(category: lPostID)
      let tmp = try db.run(query.delete())
      guard tmp == 1 else {
        throw DataAccessError.delete
      }
    } catch _ {
      throw DataAccessError.delete
    }
  }
  
  static func find(id: Int64) throws -> Currency? {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    let query = table.filter(currID == id)
    let items = try db.prepare(query)
    for item in items {
      return convert(row: item)
    }
    return nil
  }
  
  static func findAll() throws -> [Currency]? {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    var result = [Currency]()
    let items = try db.prepare(table)
    for item in items {
      result.append(convert(row: item))
    }
    return result
  }
  
  private static func convert(row: Row) -> Currency {
    var quotes = [String: Quote]()
    quotes["USD"] = Quote(price: row[currUSDPrice],
                          volume24h: row[currUSDVolume24h],
                          marketCap: row[currUSDMarketCap],
                          percentChange1h: row[currUSDPercentChange1h],
                          percentChange24h: row[currUSDPercentChange24h],
                          percentChange7d: row[currUSDPercentChange7d])
    return Currency(id: Int(row[currID]),
                    name: row[currName],
                    symbol: row[currSymbol],
                    websiteSlug: row[currWebsiteSlug],
                    rank: Int(row[currRank]),
                    circulatingSupply: row[currCirculatingSupply],
                    totalSupply: row[currTotalSupply],
                    maxSupply: row[currMaxSupply],
                    quotes: quotes,
                    lastUpdated: Int(row[currLastUpdated]))
  }
  
  private static func insertSetters(item: Currency) -> [Setter] {
    var setters = updateSetters(item: item)
    setters.insert(currID <- Int64(item.id), at: 0)
    return setters
  }
  
  private static func updateSetters(item: Currency) -> [Setter] {
    return [
      currName <- item.name,
      currSymbol <- item.symbol,
      currWebsiteSlug <- item.websiteSlug,
      currRank <- Int64(item.rank),
      currCirculatingSupply <- item.circulatingSupply,
      currTotalSupply <- item.totalSupply,
      currMaxSupply <- item.maxSupply,
      currUSDPrice <- item.quotes["USD"]?.price,
      currUSDVolume24h <- item.quotes["USD"]?.volume24h,
      currUSDMarketCap <- item.quotes["USD"]?.marketCap,
      currUSDPercentChange1h <- item.quotes["USD"]?.percentChange1h,
      currUSDPercentChange24h <- item.quotes["USD"]?.percentChange24h,
      currUSDPercentChange7d <- item.quotes["USD"]?.percentChange7d,
      currLastUpdated <- Int64(item.lastUpdated)
    ]
  }
}
