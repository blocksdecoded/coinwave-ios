//
//  PostCategoryDataHelper.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/22/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation
import SQLite

// swiftlint:disable identifier_name
class PostCategoryDataHelper: DataHelperProtocol {
  
  struct PostCategory {
    let id: Int64?
    let post: Int64
    let category: Int64
  }
  
  // swiftlint:disable type_name
  typealias T = PostCategory
  
  static let TABLE_NAME = "PostCategory"
  static let table = Table(TABLE_NAME)
  static let postCategoryID = Expression<Int64>("id")
  static let postID = Expression<Int64>("post_id")
  static let categoryID = Expression<Int64>("category_id")
  
  static func createTable() throws {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    do {
      _ = try db.run(table.create(ifNotExists: true) { t in
        t.column(postCategoryID, primaryKey: .autoincrement)
        t.column(postID)
        t.column(categoryID)
      })
    } catch _ {
      // Error throw if table already exists
    }
  }
  
  static func insert(item: PostCategory) throws -> Bool {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    let insert = table.insert(
      postID <- item.post,
      categoryID <- item.category
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
  
  static func delete(item: PostCategory) throws {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    let query = table.filter(categoryID == item.category && postID == item.post)
    do {
      let tmp = try db.run(query.delete())
      guard tmp == 1 else {
        throw DataAccessError.delete
      }
    } catch _ {
      throw DataAccessError.delete
    }
  }
  
  static func delete(post: Int64) throws {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    let query = table.filter(postID == post)
    do {
      let tmp = try db.run(query.delete())
      guard tmp == 1 else {
        throw DataAccessError.delete
      }
    } catch _ {
      throw DataAccessError.delete
    }
  }
  
  static func delete(category: Int64) throws {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    let query = table.filter(categoryID == category)
    do {
      let tmp = try db.run(query.delete())
      guard tmp == 1 else {
        throw DataAccessError.delete
      }
    } catch _ {
      throw DataAccessError.delete
    }
  }
  
  static func find(post: Int64) throws -> [Int64] {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    var result = [Int64]()
    let query = table.filter(postID == post)
    let items = try db.prepare(query)
    for item in items {
      result.append(item[categoryID])
    }
    return result
  }
  
  static func find(category: Int64) throws -> [Int64] {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    var result = [Int64]()
    let query = table.filter(categoryID == category)
    let items = try db.prepare(query)
    for item in items {
      result.append(item[postID])
    }
    return result
  }
  
  static func find(id: Int64) throws -> PostCategory? { return nil }
  static func findAll() throws -> [PostCategory]? { return nil }
}
