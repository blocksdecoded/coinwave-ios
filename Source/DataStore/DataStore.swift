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
  
  func loadFavorite(completion: (Result<CRCoin, CWError>) -> Void) {
    do {
      guard let coin = try CRCoinDataHelper.favorite() else {
        completion(.failure(.noData))
        return
      }
      completion(.success(coin))
    } catch {
      completion(.failure(.noData))
    }
  }
  
  func resetFavorite() -> Result<Bool, DSError> {
    do {
      if try CRCoinDataHelper.resetFavorite() {
        return .success(true)
      } else {
        return .failure(.notFound)
      }
    } catch {
      return .failure(.databaseException)
    }
  }
  
  func fullUpdate(_ coin: CRCoin) -> Result<Bool, DSError> {
    do {
      if try CRCoinDataHelper.fullUpdate(item: coin) {
        return .success(true)
      } else {
        return .failure(.notFound)
      }
    } catch {
      return .failure(.databaseException)
    }
  }
  
  func insertCoins(_ coins: [CRCoin]) -> Result<Bool, DSError> {
    lastUpdate = Date()
    do {
      //TODO: If cannot insert one coin, should loop stop?
      for curr in coins {
        if try !CRCoinDataHelper.insertOrUpdate(item: curr) {
          return .failure(.operationFailure)
        }
      }
      return .success(true)
    } catch {
      // TODO: Handle DataAccessErrors
      return .failure(.databaseException)
    }
  }
  
  func loadCoins(_ sortable: Sortable, completion: (Result<[CRCoin], CWError>) -> Void) {
    do {
      guard let coins =  try CRCoinDataHelper.findAll(sortable: sortable) else {
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
  
  func loadCoin(_ identifier: Int, completion: (Result<CRCoin, CWError>) -> Void) {
    do {
      guard let coin = try CRCoinDataHelper.find(id: Int64(identifier)) else {
        completion(.failure(.noData))
        return
      }
      completion(.success(coin))
    } catch {
      completion(.failure(.noData))
    }
  }
  
  func insertPosts(_ posts: [Post]) -> Result<Bool, DSError> {
    do {
      for post in posts {
        if try !PostDataHelper.insert(item: post) {
          return .failure(.operationFailure)
        }
      }
      return .success(true)
    } catch {
      return .failure(.databaseException)
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
