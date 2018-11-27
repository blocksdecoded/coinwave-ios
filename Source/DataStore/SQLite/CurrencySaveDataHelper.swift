//
//  CurrencySaveDataHelper.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/24/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation
import SQLite

// swiftlint:disable type_name identifier_name
class CurrencySaveDataHelper: DataHelperProtocol {
  typealias T = SaveCurrency
  
  static let TABLE_NAME = "CurrencySave"
  static let table = Table(TABLE_NAME)
  static let currID = Expression<Int64>("id")
  static let currWatchlist = Expression<Bool>("is_watchlist")
  static let currFavorite = Expression<Bool>("is_favorite")
  
  static func createTable() throws {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    do {
      _ = try db.run(table.create(ifNotExists: true) { t in
        t.column(currID, primaryKey: true)
        t.column(currWatchlist)
        t.column(currFavorite)
      })
    } catch _ {
      // Error throw if table already exists
    }
  }
  
  static func insertOrUpdate(item: SaveCurrency) throws {
    if try find(id: Int64(item.id)) != nil {
      try update(item: item)
    } else {
      try insert(item: item)
    }
  }
  
  @discardableResult
  static func insert(item: SaveCurrency) throws -> Int64 {
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
  
  static func update(item: SaveCurrency) throws {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    let curr = table.filter(currID == Int64(item.id))
    try db.run(curr.update(updateSetters(item: item)))
  }
  
  static func delete(item: SaveCurrency) throws {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    let query = table.filter(currID == Int64(item.id))
    do {
      let tmp = try db.run(query.delete())
      guard tmp == 1 else {
        throw DataAccessError.delete
      }
    } catch _ {
      throw DataAccessError.delete
    }
  }
  
  static func find(id: Int64) throws -> SaveCurrency? {
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
  
  static func findAll() throws -> [SaveCurrency]? {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    var result = [SaveCurrency]()
    let items = try db.prepare(table)
    for item in items {
      result.append(convert(row: item))
    }
    return result
  }
  
  private static func convert(row: Row) -> SaveCurrency {
    return SaveCurrency(id: Int(row[currID]),
                        isWatchlist: row[currWatchlist],
                        isFavorite: row[currFavorite])
  }
  
  private static func insertSetters(item: SaveCurrency) -> [Setter] {
    var setters = updateSetters(item: item)
    setters.insert(currID <- Int64(item.id), at: 0)
    return setters
  }
  
  private static func updateSetters(item: SaveCurrency) -> [Setter] {
    return [
      currWatchlist <- item.isWatchlist,
      currFavorite <- item.isFavorite
    ]
  }
}
