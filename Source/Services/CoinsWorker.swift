//
//  CoinsWorker.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 2/21/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

class CoinsWorker {
  func fetchCoins(_ orderField: CRCoin.OrderField,
                  _ orderType: CRCoin.OrderType,
                  force: Bool,
                  local: @escaping ([CRCoin]?, String?) -> Void,
                  remote: @escaping ([CRCoin]?, CWError?) -> Void) {
    if DataStore.shared.isCoinsOutdated() || force {
      if let coins = fetchLocalCoins(orderField, orderType) {
        local(coins, "")
      }
      fetchRemoteCoins(orderField, orderType, remote)
    } else {
      if let coins = fetchLocalCoins(orderField, orderType) {
        remote(coins, nil)
      } else {
        fetchRemoteCoins(orderField, orderType, remote)
      }
    }
  }
  
  func fetchCoin(_ coinId: Int, force: Bool, _ completion: @escaping (CRCoin?, CWError?) -> Void) {
    if DataStore.shared.isCoinsOutdated() || force {
      fetchRemoteCoins(.marketCap, .desc) { _, error in
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
  
  func fetchWatchlist(_ orderField: CRCoin.OrderField,
                      _ orderType: CRCoin.OrderType,
                      force: Bool,
                      _ completion: @escaping ([CRCoin]?, CWError?) -> Void) {
    if DataStore.shared.isCoinsOutdated() || force {
      fetchRemoteCoins(orderField, orderType) { _, error in
        if error != nil {
          completion(nil, error)
        } else {
          completion(DataStore.shared.loadWatchlist(orderField, orderType), nil)
        }
      }
    } else {
      completion(DataStore.shared.loadWatchlist(orderField, orderType), nil)
    }
  }
  
  func fetchFavorite(force: Bool, _ completion: @escaping (CRCoin?, CWError?) -> Void) {
    if DataStore.shared.isCoinsOutdated() || force {
      fetchRemoteCoins(.marketCap, .desc) { _, error in
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
  
  private func fetchLocalCoins(_ orderField: CRCoin.OrderField, _ orderType: CRCoin.OrderType) -> [CRCoin]? {
    return DataStore.shared.loadCoins(orderField, orderType)
  }
  
  private func fetchRemoteCoins(_ orderField: CRCoin.OrderField,
                                _ orderType: CRCoin.OrderType,
                                _ completion: @escaping ([CRCoin]?, CWError?) -> Void) {
    DispatchQueue.global(qos: .background).async {
      let networkManager = CurrenciesNetworkManager()
      networkManager.getCurrencies { result in
        switch result {
        case .success(let coinsRoot):
          DataStore.shared.insertCoins(coinsRoot.data.coins)
          DispatchQueue.main.async {
            completion(DataStore.shared.loadCoins(orderField, orderType), nil)
          }
        case .failure(let error):
          DispatchQueue.main.async {
            completion(nil, error)
          }
        }
      }
    }
  }
  
  private func fetchLocalCoin(_ coinId: Int) -> CRCoin? {
    return DataStore.shared.fetchCoin(coinId)
  }
}
