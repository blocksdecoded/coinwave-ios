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
                  local: @escaping (Result<[CRCoin], CWError>) -> Void,
                  remote: @escaping (Result<[CRCoin], CWError>) -> Void) {
    if DataStore.shared.isCoinsOutdated() || force {
      fetchLocalCoins(orderField, orderType, local)
      fetchRemoteCoins(orderField, orderType, remote)
    } else {
      fetchLocalCoins(orderField, orderType) { result in
        switch result {
        case .success:
          remote(result)
        case .failure:
          self.fetchRemoteCoins(orderField, orderType, remote)
        }
      }
    }
  }
  
  func fetchCoin(_ coinId: Int, force: Bool, _ completion: @escaping (Result<CRCoin, CWError>) -> Void) {
    if DataStore.shared.isCoinsOutdated() || force {
      fetchRemoteCoins(.marketCap, .desc) { result in
        switch result {
        case .success:
          self.fetchLocalCoin(coinId, completion)
        case .failure(let error):
          completion(.failure(error))
        }
      }
    } else {
      self.fetchLocalCoin(coinId, completion)
    }
  }
  
  func fetchWatchlist(_ orderField: CRCoin.OrderField,
                      _ orderType: CRCoin.OrderType,
                      force: Bool,
                      _ completion: @escaping (Result<[CRCoin], CWError>) -> Void) {
    if DataStore.shared.isCoinsOutdated() || force {
      fetchRemoteCoins(orderField, orderType) { result in
        switch result {
        case .success:
          self.fetchLocalWatchlist(orderField, orderType, completion)
        case .failure(let error):
          completion(.failure(error))
        }
      }
    } else {
      self.fetchLocalWatchlist(orderField, orderType, completion)
    }
  }
  
  func fetchFavorite(force: Bool, _ completion: @escaping (Result<CRCoin, CWError>) -> Void) {
    if DataStore.shared.isCoinsOutdated() || force {
      fetchRemoteCoins(.marketCap, .desc) { result in
        switch result {
        case .success:
          self.fetchLocalFavorite(completion)
        case .failure(let error):
          completion(.failure(error))
        }
      }
    } else {
      fetchLocalFavorite(completion)
    }
  }
  
  func setFavorite(_ coin: CRCoin) {
    DataStore.shared.resetFavorite()
    update(coin)
  }
  
  func update(_ coin: CRCoin) {
    DataStore.shared.fullUpdate(coin)
  }
  
  private func fetchRemoteCoins(_ orderField: CRCoin.OrderField,
                                _ orderType: CRCoin.OrderType,
                                _ completion: @escaping (Result<[CRCoin], CWError>) -> Void) {
    DispatchQueue.global(qos: .background).async {
      let networkManager = CurrenciesNetworkManager()
      networkManager.getCurrencies { result in
        switch result {
        case .success(let coinsRoot):
          DataStore.shared.insertCoins(coinsRoot.data.coins)
          DispatchQueue.main.async {
            self.fetchLocalCoins(orderField, orderType, completion)
          }
        case .failure(let error):
          DispatchQueue.main.async {
            completion(.failure(error))
          }
        }
      }
    }
  }
  
  private func fetchLocalCoin(_ coinId: Int, _ completion: @escaping (Result<CRCoin, CWError>) -> Void) {
    guard let coin = DataStore.shared.fetchCoin(coinId) else {
      completion(.failure(.noData))
      return
    }
    completion(.success(coin))
  }
  
  private func fetchLocalWatchlist(_ orderField: CRCoin.OrderField,
                                   _ orderType: CRCoin.OrderType,
                                   _ completion: @escaping (Result<[CRCoin], CWError>) -> Void) {
    guard let watchlist = DataStore.shared.loadWatchlist(orderField, orderType) else {
      completion(.failure(.noData))
      return
    }
    completion(.success(watchlist))
  }
  
  private func fetchLocalFavorite(_ completion: @escaping (Result<CRCoin, CWError>) -> Void) {
    guard let favorite = DataStore.shared.loadFavorite() else {
      completion(.failure(.noData))
      return
    }
    completion(.success(favorite))
  }
  
  private func fetchLocalCoins(_ orderField: CRCoin.OrderField,
                               _ orderType: CRCoin.OrderType,
                               _ completion: @escaping (Result<[CRCoin], CWError>) -> Void) {
    guard let coins = DataStore.shared.loadCoins(orderField, orderType) else {
      completion(.failure(.noData))
      return
    }
    completion(.success(coins))
  }
}
