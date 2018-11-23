//
//  DataStore.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/22/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation

class DataStore {
  static let shared = DataStore()
  
  private init() {
    do {
      try SQLiteDataStore.sharedInstance.createTables()
    } catch {
      fatalError("Cant create tables")
    }
  }
  
  func insert(posts: [Post]) {
    do {
      for post in posts {
        try PostDataHelper.insert(item: post)
      }
    } catch {
      fatalError("Cannot insert posts")
    }
  }
  
  func loadPost(_ postId: Int) -> Post? {
    do {
      return try PostDataHelper.find(id: Int64(postId))
    } catch {
      fatalError("Cannot load post \(postId)")
    }
  }
}
