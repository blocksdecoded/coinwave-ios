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
  
  private let kLastUpdate = "last_update"
  
  private lazy var formatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    return formatter
  }()
  
  private var lastUpdate: Date? {
    get {
      guard let str = UserDefaults.standard.string(forKey: kLastUpdate) else {
        return nil
      }
      return formatter.date(from: str)
    }
    
    set {
      guard let date = newValue else {
        return
      }
      let str = formatter.string(from: date)
      UserDefaults.standard.set(str, forKey: kLastUpdate)
    }
  }
  
  var lastUpdated: String {
    if let lastUpdate = lastUpdate {
      return DateTimeService.interval(date: lastUpdate)
    } else {
      return ""
    }
  }
  
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
  
  func loadWatchlist(_ sortable: Sortable, completion: (Result<[CRCoin], CWError>) -> Void) {
    do {
      guard let coins = try CRCoinDataHelper.watchlist(sortable: sortable) else {
        completion(.failure(.noData))
        return
      }
      if coins.isEmpty {
        completion(.failure(.noData))
      } else {
        completion(.success(coins))
      }
    } catch {
      completion(.failure(.noData))
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
  
  func loadCoins(_ sortable: Sortable) -> [CRCoin]? {
    do {
      return try CRCoinDataHelper.findAll(sortable: sortable)
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
