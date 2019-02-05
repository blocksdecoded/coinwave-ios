//
//  WatchlistWorker.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/24/18.
//  Copyright (c) 2018 makeuseof. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class WatchlistWorker {
  
  func fetchSaveCurrencies() -> [SaveCurrency]? {
    return DataStore.shared.loadWatchlist()
  }
  
  func fetchLocalCurrencies() -> [CRCoin]? {
    return DataStore.shared.loadCurrencies()
  }
  
  func fetchWatchlistIds() -> [Int64]? {
    return DataStore.shared.loadWatchlistIds()
  }
  
  func fetchCurrencies(ids: String?, _ completion: @escaping(CRRoot<CRDataList>) -> Void) {
    DispatchQueue.global(qos: .background).async {
      let networkManager = CurrenciesNetworkManager()
      networkManager.getCurrencies(limit: 50, offset: 0, ids: ids, completion: { currencies, _ in
        guard let currs = currencies else {
          return
        }
        
        DataStore.shared.insertCurrencies(currs.data.coins)
        DispatchQueue.main.async {
          completion(currs)
        }
      })
      
    }
  }
}
