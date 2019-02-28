//
//  CoinsWorker.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 2/21/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

class CoinsWorker {
  func fetchCoins(_ completion: @escaping ([CRCoin]?, CTError?) -> Void) {
    if DataStore.shared.isCoinsOutdated() {
      fetchRemoteCoins(completion)
    } else {
      if let coins = fetchLocalCoins() {
        completion(coins, nil)
      } else {
        fetchRemoteCoins(completion)
      }
    }
  }
  
  func fetchCoin(_ coinId: Int, _ completion: @escaping (CRCoin?, CTError?) -> Void) {
    if DataStore.shared.isCoinsOutdated() {
      fetchRemoteCoins { _, error in
        if error != nil {
          completion(nil, error)
        } else {
          completion(self.fetchLocalCoin(coinId), nil)
        }
      }
    } else {
      if let coin = fetchLocalCoin(coinId) {
        completion(coin, nil)
      } else {
        completion(nil, .noData)
      }
    }
  }
  
  func fetchWatchlist(_ completion: @escaping ([CRCoin]?, CTError?) -> Void) {
    if DataStore.shared.isCoinsOutdated() {
      fetchRemoteCoins { _, error in
        if error != nil {
          completion(nil, error)
        } else {
          completion(DataStore.shared.loadWatchlist(), nil)
        }
      }
    } else {
      completion(DataStore.shared.loadWatchlist(), nil)
    }
  }
  
  func fetchFavorite(_ completion: @escaping (CRCoin?, CTError?) -> Void) {
    if DataStore.shared.isCoinsOutdated() {
      fetchRemoteCoins { _, error in
        if error != nil {
          completion(nil, error)
        } else {
          completion(DataStore.shared.loadFavorite(), nil)
        }
      }
    } else {
      completion(DataStore.shared.loadFavorite(), nil)
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
  
  private func fetchRemoteCoins(_ completion: @escaping ([CRCoin]?, CTError?) -> Void) {
    DispatchQueue.global(qos: .background).async {
      let networkManager = CurrenciesNetworkManager()
      networkManager.getCurrencies { currencies, error in
        if error != nil {
          DispatchQueue.main.async {
            completion(nil, .network)
          }
        }
        
        guard let curs = currencies else {
          DispatchQueue.main.async {
            completion(nil, .noData)
          }
          return
        }
        
        DataStore.shared.insertCoins(curs.data.coins)
        
        DispatchQueue.main.async {
          completion(curs.data.coins, nil)
        }
      }
    }
  }
  
  private func fetchLocalCoin(_ coinId: Int) -> CRCoin? {
    return DataStore.shared.fetchCoin(coinId)
  }
}
