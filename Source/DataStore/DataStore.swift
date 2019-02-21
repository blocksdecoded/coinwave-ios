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
  
  private init() {
    do {
      try SQLiteDataStore.sharedInstance.createTables()
    } catch {
      fatalError("Cant create tables")
    }
  }
  
  func insertSaveCurrency(_ currency: SaveCurrency) {
    do {
      try CurrencySaveDataHelper.insertOrUpdate(item: currency)
    } catch {
      fatalError("Cannot insert save curencies")
    }
  }
  
  func loadSaveCurrency(_ id: Int) -> SaveCurrency? {
    do {
      return try CurrencySaveDataHelper.find(id: Int64(id))
    } catch {
      fatalError("Cannot load save currency")
    }
  }
  
  func loadWatchlistIds() -> [Int64]? {
    do {
      return try CurrencySaveDataHelper.watchlistIds()
    } catch {
      fatalError("Cannot load watchlist ids")
    }
  }
  
  func loadWatchlist() -> [SaveCurrency]? {
    do {
      return try CurrencySaveDataHelper.watchlist()
    } catch {
      fatalError("Cannot load watchlist")
    }
  }
  
  func loadFavorite() -> SaveCurrency? {
    do {
      return try CurrencySaveDataHelper.favorite()
    } catch {
      fatalError("Cannot load favorite")
    }
  }
  
  func setFavorite(id: Int, symbol: String, isFavorite: Bool) {
    do {
      try CurrencySaveDataHelper.setFavorite(id: id, symbol: symbol, isFavorite: isFavorite)
    } catch {
      fatalError("Cannot set favorite")
    }
  }
  
  func setWatchlist(id: Int, symbol: String, isWatchlist: Bool) {
    do {
      try CurrencySaveDataHelper.setWatchlist(id: id, symbol: symbol, isWatchlist: isWatchlist)
    } catch {
      fatalError("Cannot set watchlist")
    }
  }
  
  func insertCurrencies(_ currencies: [CRCoin]) {
    do {
      for curr in currencies {
        try CRCoinDataHelper.insertOrUpdate(item: curr)
      }
    } catch {
      fatalError("Cannot insert curencies")
    }
  }
  
  func loadCurrencies() -> [CRCoin]? {
    do {
      return try CRCoinDataHelper.findAll()
    } catch {
      fatalError("Cannot load currencies")
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
