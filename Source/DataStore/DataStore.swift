//
//  DataStore.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/22/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation

//TODO: Analytics

class DataStore {
  static let shared = DataStore()
  
  private let updateTime: TimeInterval = 60 * 5
  
  private var lastUpdate: Date?
  
  private init() {
    do {
      try SQLiteDataStore.sharedInstance.checkMigrations()
      try SQLiteDataStore.sharedInstance.createTables()
    } catch {
      fatalError("Cant create tables")
    }
  }
  
  func isCoinsOutdated() -> Bool {
    switch Constants.environment {
    case .debug:
      return true
    default:
      break
    }
    guard let lastUpdate = lastUpdate else {
      return true
    }
    
    return Date().timeIntervalSince(lastUpdate) >= updateTime
  }
  
  func loadWatchlist(_ orderField: CRCoin.OrderField, _ orderType: CRCoin.OrderType) -> [CRCoin]? {
    do {
      return try CRCoinDataHelper.watchlist(field: orderField, type: orderType)
    } catch {
      fatalError("Cannot load watchlist")
    }
  }
  
  func loadFavorite() -> CRCoin? {
    do {
      return try CRCoinDataHelper.favorite()
    } catch {
      fatalError("Cannot load favorite")
    }
  }
  
  func resetFavorite() {
    do {
      try CRCoinDataHelper.resetFavorite()
    } catch {
      fatalError("Cannot insert coin")
    }
  }
  
  func fullUpdate(_ coin: CRCoin) {
    do {
      try CRCoinDataHelper.fullUpdate(item: coin)
    } catch {
      fatalError("Cannot insert coin")
    }
  }
  
  func insertCoins(_ coins: [CRCoin]) {
    lastUpdate = Date()
    do {
      for curr in coins {
        try CRCoinDataHelper.insertOrUpdate(item: curr)
      }
    } catch {
      fatalError("Cannot insert curencies")
    }
  }
  
  func loadCoins(_ orderField: CRCoin.OrderField, _ orderType: CRCoin.OrderType) -> [CRCoin]? {
    do {
      return try CRCoinDataHelper.findAll(field: orderField, type: orderType)
    } catch {
      fatalError("Cannot load currencies")
    }
  }
  
  func fetchCoin(_ identifier: Int) -> CRCoin? {
    do {
      return try CRCoinDataHelper.find(id: Int64(identifier))
    } catch {
      fatalError("Cannot fetch coin \(identifier)")
    }
  }
  
  func insertPosts(_ posts: [Post]) {
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
  
  func loadPosts() -> [Post]? {
    do {
      return try PostDataHelper.findAll()
    } catch {
      fatalError("Cannot load all posts")
    }
  }
}
