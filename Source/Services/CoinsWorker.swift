//
//  CoinsWorker.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 2/21/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

class CoinsWorker {
  func fetchCoins(_ completion: @escaping ([CRCoin]?) -> Void) {
    if DataStore.shared.isCoinsOutdated() {
      fetchRemoteCoins(completion)
    } else {
      if let coins = fetchLocalCoins() {
        completion(coins)
      } else {
        fetchRemoteCoins(completion)
      }
    }
  }
  
  func fetchCoin(_ id: Int, _ completion: @escaping (CRCoin?) -> Void) {
    if DataStore.shared.isCoinsOutdated() {
      fetchRemoteCoins {_ in}
      completion(fetchLocalCoin(id))
    } else {
      if let coin = fetchLocalCoin(id) {
        completion(coin)
      } else {
        fatalError("No coin")
      }
    }
  }
  
  func fetchWatchlist(_ completion: @escaping ([CRCoin]?) -> Void) {
    if DataStore.shared.isCoinsOutdated() {
      fetchRemoteCoins { _ in }
      completion(DataStore.shared.loadWatchlist())
    } else {
      completion(DataStore.shared.loadWatchlist())
    }
  }
  
  func fetchFavorite(_ completion: @escaping (CRCoin?) -> Void) {
    if DataStore.shared.isCoinsOutdated() {
      fetchRemoteCoins { _ in }
      completion(DataStore.shared.loadFavorite())
    } else {
      completion(DataStore.shared.loadFavorite())
    }
  }
  
  func setFavorite(_ coin: CRCoin) {
    DataStore.shared.resetFavorite()
    update(coin)
  }
  
  func update(_ coin: CRCoin) {
    DataStore.shared.fullUpdate(coin)
  }
  
  private func fetchLocalCoins() -> [CRCoin]? {
    return DataStore.shared.loadCoins()
  }
  
  private func fetchRemoteCoins(_ completion: @escaping ([CRCoin]?) -> Void) {
    DispatchQueue.global(qos: .background).async {
      let networkManager = CurrenciesNetworkManager()
      networkManager.getCurrencies { currencies, error in
        if error != nil {
          print(error!)
        }
        
        guard let curs = currencies else {
          completion(nil)
          return
        }
        
        DataStore.shared.insertCoins(curs.data.coins)
        
        DispatchQueue.main.async {
          completion(curs.data.coins)
        }
      }
    }
  }
  
  private func fetchLocalCoin(_ id: Int) -> CRCoin? {
    return DataStore.shared.fetchCoin(id)
  }
}
