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
  
  func loadSaveCurrency() -> [SaveCurrency]? {
    do {
      return try CurrencySaveDataHelper.findAll()
    } catch {
      fatalError("Cannot load save currencies")
    }
  }
  
  func insertCurrencies(_ currencies: [Currency]) {
    do {
      for curr in currencies {
        try CurrencyDataHelper.insertOrUpdate(item: curr)
      }
    } catch {
      fatalError("Cannot insert curencies")
    }
  }
  
  func loadCurrencies() -> [Currency]? {
    do {
      return try CurrencyDataHelper.findAll()
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
