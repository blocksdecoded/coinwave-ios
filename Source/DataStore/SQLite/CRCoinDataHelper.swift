//
//  CRCoinDataHelper.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 1/31/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation
import SQLite

// swiftlint:disable type_name identifier_name
class CRCoinDataHelper: DataHelperProtocol {
  typealias T = CRCoin
  
  static let TABLE_NAME = "CRCoin"
  static let table = Table(TABLE_NAME)
  static let currID = Expression<Int64>("id")
  static let currSlug = Expression<String>("slug")
  static let currSymbol = Expression<String>("symbol")
  static let currName = Expression<String>("name")
  static let currDescription = Expression<String?>("description")
  static let currColor = Expression<String?>("color")
  static let currIconType = Expression<String?>("iconType")
  static let currIconUrl = Expression<String?>("iconUrl")
  static let currWebsiteUrl = Expression<String?>("websiteUrl")
  static let currConfirmedSupply = Expression<Bool>("confirmedSupply")
  static let currType = Expression<String>("type")
  static let currVolume = Expression<Double?>("volume")
  static let currMarketCap = Expression<Double?>("marketCap")
  static let currPrice = Expression<Double?>("price")
  static let currCirculatingSupply = Expression<Double?>("circulatingSupply")
  static let currTotalSupply = Expression<Double?>("totalSupply")
  static let currFirstSeen = Expression<Double?>("firstSeen")
  static let currChange = Expression<Double?>("change")
  static let currRank = Expression<Double>("rank")
  static let currHistory = Expression<String>("history")
  static let currAllTimeHighPrice = Expression<Double?>("allTimeHighPrice")
  static let currAllTimeHighTimestamp = Expression<Double?>("allTimeHighTimestamp")
  static let currPenalty = Expression<Bool>("penalty")
  static let currIsWatchlist = Expression<Bool>("isWatchlist")
  static let currIsFavorite = Expression<Bool>("isFavorite")
  
  static func createTable() throws {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    do {
      _ = try db.run(table.create(ifNotExists: true) { t in
        t.column(currID, primaryKey: true)
        t.column(currSlug)
        t.column(currSymbol)
        t.column(currName)
        t.column(currDescription)
        t.column(currColor)
        t.column(currIconType)
        t.column(currIconUrl)
        t.column(currWebsiteUrl)
        t.column(currConfirmedSupply)
        t.column(currType)
        t.column(currVolume)
        t.column(currMarketCap)
        t.column(currPrice)
        t.column(currCirculatingSupply)
        t.column(currTotalSupply)
        t.column(currFirstSeen)
        t.column(currChange)
        t.column(currRank)
        t.column(currHistory)
        t.column(currAllTimeHighPrice)
        t.column(currAllTimeHighTimestamp)
        t.column(currPenalty)
        t.column(currIsWatchlist)
        t.column(currIsFavorite)
      })
    } catch _ {
      // Error throw if table already exists
    }
  }
  
  static func dropTable() throws {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    try db.run(table.drop(ifExists: true))
  }
  
  static func insertOrUpdate(item: CRCoin) throws {
    if try find(id: Int64(item.identifier)) != nil {
      try update(item: item)
    } else {
      try insert(item: item)
    }
  }
  
  @discardableResult
  static func insert(item: CRCoin) throws -> Int64 {
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
  
  static func update(item: CRCoin) throws {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    let curr = table.filter(currID == Int64(item.identifier))
    try db.run(curr.update(updateSetters(item: item)))
  }
  
  static func delete(item: CRCoin) throws {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    let lPostID = Int64(item.identifier)
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
  
  static func find(id: Int64) throws -> CRCoin? {
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
  
  static func findAll() throws -> [CRCoin]? {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    var result = [CRCoin]()
    let items = try db.prepare(table)
    for item in items {
      result.append(convert(row: item))
    }
    return result
  }
  
  static func findAll(field: CRCoin.OrderField = .rank, type: CRCoin.OrderType = .asc) throws -> [CRCoin]? {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    let expressible: Expressible
    
    switch type {
    case .asc:
      switch field {
      case .name:
        expressible = currSymbol.asc
      case .marketCap:
        expressible = currMarketCap.asc
      case .price:
        expressible = currPrice.asc
      case .volume:
        expressible = currVolume.asc
      case .rank:
        expressible = currRank.asc
      }
    case .desc:
      switch field {
      case .name:
        expressible = currSymbol.desc
      case .marketCap:
        expressible = currMarketCap.desc
      case .price:
        expressible = currPrice.desc
      case .volume:
        expressible = currVolume.desc
      case .rank:
        expressible = currRank.desc
      }
    }
    
    var result = [CRCoin]()
    let items = try db.prepare(table.order(expressible))
    for item in items {
      result.append(convert(row: item))
    }
    return result
  }
  
  static func watchlist(field: CRCoin.OrderField = .rank, type: CRCoin.OrderType = .asc) throws -> [CRCoin]? {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    let expressible: Expressible
    
    switch type {
    case .asc:
      switch field {
      case .name:
        expressible = currName.asc
      case .marketCap:
        expressible = currMarketCap.asc
      case .price:
        expressible = currPrice.asc
      case .volume:
        expressible = currVolume.asc
      case .rank:
        expressible = currRank.asc
      }
    case .desc:
      switch field {
      case .name:
        expressible = currName.desc
      case .marketCap:
        expressible = currMarketCap.desc
      case .price:
        expressible = currPrice.desc
      case .volume:
        expressible = currVolume.desc
      case .rank:
        expressible = currRank.desc
      }
    }
    
    var result = [CRCoin]()
    let query = table.filter(currIsWatchlist == true).order(expressible)
    let favs = try db.prepare(query)
    for fav in favs {
      result.append(convert(row: fav))
    }
    return result
  }
  
  static func favorite() throws -> CRCoin? {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    let query = table.filter(currIsFavorite == true)
    let favs = try db.prepare(query)
    for fav in favs {
      return convert(row: fav)
    }
    
    return nil
  }
  
  static func resetFavorite() throws {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    let prevFavorite = table.filter(currIsFavorite == true)
    let prevUpdate = prevFavorite.update([currIsFavorite <- false])
    try db.run(prevUpdate)
  }
  
  static func fullUpdate(item: CRCoin) throws {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    let curr = table.filter(currID == Int64(item.identifier))
    try db.run(curr.update(fullUpdateSetters(item: item)))
  }
  
  private static func convert(row: Row) -> CRCoin {
    let allTimeHigh = CRPrice(price: Price(row[currAllTimeHighPrice]),
                              timestamp: row[currAllTimeHighTimestamp])
    
    let sqlHistory = row[currHistory].split(separator: ":")
    var history = [String?]()
    
    for sub in sqlHistory {
      if sub == " " {
        history.append(nil)
      } else {
        history.append(String(sub))
      }
    }
    
    var iconType: CRCoin.IconType?
    if let rawIconType = row[currIconType] {
      iconType = CRCoin.IconType(rawValue: rawIconType)
    }
    
    return CRCoin(identifier: Int(row[currID]),
                  slug: row[currSlug],
                  symbol: row[currSymbol],
                  name: row[currName],
                  description: row[currDescription],
                  color: row[currColor],
                  iconType: iconType,
                  iconUrl: row[currIconUrl],
                  websiteUrl: row[currWebsiteUrl],
                  confirmedSupply: row[currConfirmedSupply],
                  type: CRCoin.CoinType(rawValue: row[currType])!,
                  volume: Price(row[currVolume]),
                  marketCap: Price(row[currMarketCap]),
                  price: Price(row[currPrice]),
                  circulatingSupply: Price(row[currCirculatingSupply]),
                  totalSupply: Price(row[currTotalSupply]),
                  firstSeen: row[currFirstSeen],
                  change: row[currChange],
                  rank: row[currRank],
                  history: history,
                  allTimeHigh: allTimeHigh,
                  penalty: row[currPenalty],
                  isWatchlist: row[currIsWatchlist],
                  isFavorite: row[currIsFavorite])
  }
  
  private static func insertSetters(item: CRCoin) -> [Setter] {
    var setters = fullUpdateSetters(item: item)
    setters.insert(currID <- Int64(item.identifier), at: 0)
    return setters
  }
  
  private static func updateSetters(item: CRCoin, _ setters: [Setter] = []) -> [Setter] {
    var history = ""
    
    for index in 0..<item.history.count {
      if index == 0 {
        history = "\(item.history[index] ?? "")"
      } else {
        history = "\(history):\(item.history[index] ?? " ")"
      }
    }
    
    var sets = [
      currID <- Int64(item.identifier),
      currSlug <- item.slug,
      currSymbol <- item.symbol,
      currName <- item.name,
      currDescription <- item.description,
      currColor <- item.color,
      currIconType <- item.iconType?.rawValue,
      currIconUrl <- item.iconUrl,
      currWebsiteUrl <- item.websiteUrl,
      currConfirmedSupply <- item.confirmedSupply,
      currType <- item.type.rawValue,
      currVolume <- item.volume?.value,
      currMarketCap <- item.marketCap?.value,
      currPrice <- item.price?.value,
      currCirculatingSupply <- item.circulatingSupply?.value,
      currTotalSupply <- item.totalSupply?.value,
      currFirstSeen <- item.firstSeen,
      currChange <- item.change,
      currRank <- item.rank,
      currHistory <- history,
      currAllTimeHighPrice <- item.allTimeHigh.price?.value,
      currAllTimeHighTimestamp <- item.allTimeHigh.timestamp,
      currPenalty <- item.penalty
    ]
    sets.append(contentsOf: setters)
    return sets
  }
  
  private static func fullUpdateSetters(item: CRCoin) -> [Setter] {
    let sets = [
      currIsWatchlist <- item.isWatchlist,
      currIsFavorite <- item.isFavorite
    ]
    
    return updateSetters(item: item, sets)
  }
}
