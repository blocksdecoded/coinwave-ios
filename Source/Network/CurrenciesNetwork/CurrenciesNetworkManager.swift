//
//  CurrenciesNetworkManager.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/23/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation

struct CurrenciesNetworkManager: NetworkManager {
  static let apiVersion: CurrenciesApi.ApiVersions = .v2
  private let router = Router<CurrenciesApi>()
  
  func getCurrencies(completion: @escaping (_ currencies: [Currency]?, _ error: String?) -> Void) {
    router.request(.list) { data, response, error in
      
      if error != nil {
        completion(nil, "Please check your network connection")
      }
      
      if let response = response as? HTTPURLResponse {
        let result = self.handleNetworkResponse(response)
        switch result {
        case .success:
          guard let responseData = data else {
            completion(nil, NetworkResponse.noData.rawValue)
            return
          }
          
          do {
            let apiResponse = try JSONDecoder().decode(CurrencyList.self, from: responseData)
            completion(apiResponse.data, nil)
          } catch {
            completion(nil, NetworkResponse.unableToDecode.rawValue)
          }
        case .failure(let networkFailureError):
          completion(nil, networkFailureError)
        }
      }
    }
  }
}
