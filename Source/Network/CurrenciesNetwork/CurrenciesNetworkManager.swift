//
//  CurrenciesNetworkManager.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/23/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation

struct CurrenciesNetworkManager: NetworkManager {
  static let apiVersion: CurrenciesApi.ApiVersions = .v1
  static let apiAccessLevel: CurrenciesApi.ApiAccessLevel = .pub
  private let router = Router<CurrenciesApi>()
  
  func getCurrencies(completion: @escaping (_ currencies: [CRCoin]?, _ error: String?) -> Void) {
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
            let apiResponse = try JSONDecoder().decode(CRRoot<CRDataList>.self, from: responseData)
            completion(apiResponse.data.coins, nil)
          } catch {            
            completion(nil, NetworkResponse.unableToDecode.rawValue)
          }
        case .failure(let networkFailureError):
          completion(nil, networkFailureError)
        }
      }
    }
  }
  
  func getCurrency(currID: Int, _ completion: @escaping(_ currency: CRCoin?, _ error: String?) -> Void) {
    router.request(.currency(currID)) { data, response, error in
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
            let apiResponse = try JSONDecoder().decode(CRRoot<CRDataCoin>.self, from: responseData)
            completion(apiResponse.data.coin, nil)
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
