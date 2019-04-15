//
//  ChartWorker.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 4/11/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

class ChartWorker: ChartWorkerLogic {  
  
  // MARK: - Properties
  
  private let cache = NSCache<NSString, AnyObject>()
  
  // MARK: - Worker Logic
  
  func getHistory(coinID: Int,
                  symbol: String,
                  time: CRTimeframe,
                  completion: @escaping (Result<[CRPrice], CWError>) -> Void) {
    let key = "\(coinID)_\(time.value)"
    if let root = cache.object(forKey: key as NSString) as? CRRoot<CRDataHistory> {
      completion(.success(root.data.history))
    } else {
      let networkManager = CurrenciesNetworkManager()
      networkManager.getHistory(currID: symbol, time: time) { result in
        switch result {
        case .success(let coinRoot):
          self.cache.setObject(coinRoot as AnyObject, forKey: key as NSString)
          DispatchQueue.main.async {
            completion(.success(coinRoot.data.history))
          }
        case .failure(let error):
          completion(.failure(error))
        }
      }
    }
  }
}
