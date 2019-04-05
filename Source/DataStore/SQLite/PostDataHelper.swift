//
//  PostDataHelper.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/22/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation
import SQLite

// swiftlint:disable type_name identifier_name
class PostDataHelper: DataHelperProtocol {
  typealias T = Post
  
  static let TABLE_NAME = "Post"
  static let table = Table(TABLE_NAME)
  static let postID = Expression<Int64>("id")
  static let postTitle = Expression<String>("title")
  static let postAuthor = Expression<String>("author")
  static let postHtml = Expression<String?>("html")
  static let postUrl = Expression<String>("url")
  static let postDate = Expression<String>("date")
  static let postFeatured = Expression<String?>("featured")
  static let postMiddle = Expression<String?>("middle")
  static let postThumb = Expression<String?>("thumb")
  static let postLikes = Expression<Int>("likes")
  static let postLiked = Expression<Bool>("liked")
  
  static func createTable() throws {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    do {
      _ = try db.run(table.create(ifNotExists: true) { t in
        t.column(postID, primaryKey: true)
        t.column(postTitle)
        t.column(postAuthor)
        t.column(postHtml)
        t.column(postUrl)
        t.column(postDate)
        t.column(postFeatured)
        t.column(postMiddle)
        t.column(postThumb)
        t.column(postLikes)
        t.column(postLiked)
      })
    } catch _ {
      // Error throw if table already exists
    }
  }
  
  static func insert(item: Post) throws -> Bool {
    let lPostID = Int64(item.id)
    
    if try find(id: lPostID) != nil {
      return true
    }
    
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    let insert = table.insert(
      postID <- lPostID,
      postTitle <- item.title,
      postAuthor <- item.author,
      postHtml <- item.html,
      postUrl <- item.url.absoluteString,
      postDate <- item.date,
      postFeatured <- item.image?.featured,
      postMiddle <- item.image?.middle,
      postThumb <- item.image?.thumb,
      postLikes <- item.likes,
      postLiked <- item.liked
    )
    
    do {
      for category in item.categories {
        let categoryError = try !CategoryDataHelper.insert(item: category)
        let postCategoryError = try !PostCategoryDataHelper.insert(item: PostCategoryDataHelper.PostCategory(id: nil, post: lPostID, category: Int64(category.id)))
        if categoryError || postCategoryError {
          return false
        }
      }
    } catch {
      throw DataAccessError.insert
    }
    
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
  
  static func delete(item: Post) throws {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    let lPostID = Int64(item.id)
    let query = table.filter(postID == lPostID)
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
  
  static func find(id: Int64) throws -> Post? {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    let categoriesIds = try PostCategoryDataHelper.find(post: id)
    var categories = [Category]()
    for catID in categoriesIds {
      if let cat = try CategoryDataHelper.find(id: catID) {
        categories.append(cat)
      }
    }
    
    let query = table.filter(postID == id)
    let items = try db.prepare(query)
    for item in items {
      return convert(row: item, categories: categories)
    }
    return nil
  }
  
  static func findAll() throws -> [Post]? {
    guard let db = SQLiteDataStore.sharedInstance.db else {
      throw DataAccessError.datastoreConnection
    }
    
    var result = [Post]()
    let items = try db.prepare(table.order(postDate.desc))
    for item in items {
      let categoriesIds = try PostCategoryDataHelper.find(post: item[postID])
      var categories = [Category]()
      for catID in categoriesIds {
        if let cat = try CategoryDataHelper.find(id: catID) {
          categories.append(cat)
        }
      }
      
      result.append(convert(row: item, categories: categories))
    }
    return result
  }
  
  private static func convert(row: Row, categories: [Category]) -> Post {
    return Post(id: Int(row[postID]),
                title: row[postTitle],
                date: row[postDate],
                author: row[postAuthor],
                html: row[postHtml],
                url: URL(string: row[postUrl])!,
                featured: row[postFeatured],
                middle: row[postMiddle],
                thumb: row[postThumb],
                likes: row[postLikes],
                liked: row[postLiked],
                categories: categories)
  }
}
