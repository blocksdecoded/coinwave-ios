//
//  CategoryDataHelper.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/22/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation
import SQLite

// swiftlint:disable type_name identifier_name
class CategoryDataHelper: DataHelperProtocol {
  typealias T = Category
  
  static let TABLE_NAME = "Category"
  static let table = Table(TABLE_NAME)
  static let categoryID = Expression<Int64>("id")
  static let categoryTitle = Expression<String>("title")
  
  static func createTable() throws {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    do {
      _ = try db.run(table.create(ifNotExists: true) { t in
        t.column(categoryID, primaryKey: true)
        t.column(categoryTitle)
      })
    } catch _ {
      // Error throw if table already exists
    }
  }
  
  static func insert(item: Category) throws -> Bool {
    let catID = Int64(item.id)
    
    if try find(id: catID) != nil {
      return true
    }
    
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    let insert = table.insert(
      categoryID <- Int64(item.id),
      categoryTitle <- item.title
    )
    
    do {
      let rowId = try db.run(insert)
      guard rowId > 0 else {
        throw DataAccessError.insert
      }
      return true
    } catch _ {
      throw DataAccessError.insert
    }
  }
  
  static func delete(item: Category) throws {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    let catID = Int64(item.id)
    let query = table.filter(categoryID == catID)
    do {
      try PostCategoryDataHelper.delete(category: catID)
      let tmp = try db.run(query.delete())
      guard tmp == 1 else {
        throw DataAccessError.delete
      }
    } catch _ {
      throw DataAccessError.delete
    }
  }
  
  static func find(id: Int64) throws -> Category? {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    let query = table.filter(categoryID == id)
    let items = try db.prepare(query)
    for item in items {
      return convert(row: item)
    }
    return nil
  }
  
  static func findAll() throws -> [Category]? {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    var result = [Category]()
    let items = try db.prepare(table)
    for item in items {
      result.append(convert(row: item))
    }
    return result
  }
  
  private static func convert(row: Row) -> Category {
    return Category(id: row[categoryID], title: row[categoryTitle])
  }
}
