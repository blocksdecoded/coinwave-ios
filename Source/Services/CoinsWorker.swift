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
          DataStore.shared.loadCoin(coinId, completion: completion)
        case .failure(let error):
          completion(.failure(error))
        }
      }
    } else {
      DataStore.shared.loadCoin(coinId, completion: completion)
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
          DataStore.shared.loadFavorite(completion: completion)
        case .failure(let error):
          completion(.failure(error))
        }
      }
    } else {
      DataStore.shared.loadFavorite(completion: completion)
    }
  }
  
  func setFavorite(_ coin: CRCoin) -> Result<Bool, DSError> {
    let result = DataStore.shared.resetFavorite()
    switch result {
    case .success:
      return update(coin)
    case .failure(let error):
      return .failure(error)
    }
  }
  
  func update(_ coin: CRCoin) -> Result<Bool, DSError> {
    return DataStore.shared.fullUpdate(coin)
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
}
