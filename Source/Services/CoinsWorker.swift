//
//  CoinsWorker.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 2/21/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

class CoinsWorker {
  func fetchCoins(_ sortable: Sortable,
                  force: Bool,
                  local: @escaping (Result<[CRCoin], CWError>) -> Void,
                  remote: @escaping (Result<[CRCoin], CWError>) -> Void) {
    if DataStore.shared.isCoinsOutdated() || force {
      DataStore.shared.loadCoins(sortable, completion: local)
      fetchRemoteCoins(sortable, remote)
    } else {
      DataStore.shared.loadCoins(sortable) { result in
        switch result {
        case .success:
          remote(result)
        case .failure:
          self.fetchRemoteCoins(sortable, remote)
        }
      }
    }
  }
  
  func fetchCoin(_ coinId: Int, force: Bool, _ completion: @escaping (Result<CRCoin, CWError>) -> Void) {
    if DataStore.shared.isCoinsOutdated() || force {
      let sortable = Sortable(field: .marketCap, direction: .desc)
      fetchRemoteCoins(sortable) { result in
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
  
  func fetchWatchlist(_ sortable: Sortable,
                      force: Bool,
                      _ completion: @escaping (Result<[CRCoin], CWError>) -> Void) {
    if DataStore.shared.isCoinsOutdated() || force {
      fetchRemoteCoins(sortable) { result in
        switch result {
        case .success:
          DataStore.shared.loadWatchlist(sortable, completion: completion)
        case .failure(let error):
          completion(.failure(error))
        }
      }
    } else {
      DataStore.shared.loadWatchlist(sortable, completion: completion)
    }
  }
  
  func fetchFavorite(force: Bool, _ completion: @escaping (Result<CRCoin, CWError>) -> Void) {
    if DataStore.shared.isCoinsOutdated() || force {
      let sortable = Sortable(field: .marketCap, direction: .desc)
      fetchRemoteCoins(sortable) { result in
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
  
  private func fetchRemoteCoins(_ sortable: Sortable,
                                _ completion: @escaping (Result<[CRCoin], CWError>) -> Void) {
    DispatchQueue.global(qos: .background).async {
      let networkManager = CurrenciesNetworkManager()
      networkManager.getCurrencies { result in
        switch result {
        case .success(let coinsRoot):
          DataStore.shared.insertCoins(coinsRoot.data.coins)
          DispatchQueue.main.async {
            DataStore.shared.loadCoins(sortable, completion: completion)
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
  
  private func fetchLocalFavorite(_ completion: @escaping (Result<CRCoin, CWError>) -> Void) {
    guard let favorite = DataStore.shared.loadFavorite() else {
      completion(.failure(.noData))
      return
    }
    completion(.success(favorite))
  }
}
