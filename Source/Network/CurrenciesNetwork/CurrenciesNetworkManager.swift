//
//  CurrenciesNetworkManager.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/23/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation

struct CurrenciesNetworkManager: NetworkManager {
  private let router = Router<CurrenciesApi>()
  
  func getCurrencies(_ completion: @escaping (_ currencies: CRRoot<CRDataList>?, _ error: String?) -> Void) {
    router.request(.list) { data, response, error in
      if error != nil {
        completion(nil, "Please check your network connection")
      }
      
      if let response = response as? HTTPURLResponse {
        let result = self.handleNetworkResponse(response)
        switch result {
        case .success:
          guard let responseData = data else {
            completion(nil, NMError.noData.localizedDescription)
            return
          }
          
          do {
            let apiResponse = try JSONDecoder().decode(CRRoot<CRDataList>.self, from: responseData)
            completion(apiResponse, nil)
          } catch let error as DecodingError {
            self.decodingError(error)
            completion(nil, NMError.unableToDecode.localizedDescription)
          } catch {
            completion(nil, NMError.unableToDecode.localizedDescription)
          }
        case .failure(let networkFailureError):
          completion(nil, networkFailureError.localizedDescription)
        }
      }
    }
  }
  
  func getHistory(currID: String,
                  time: CRTimeframe,
                  _ completion: @escaping(CRRoot<CRDataHistory>?,
                  _ error: String?) -> Void) {
    router.request(.hsitory(currID, time)) { data, response, error in
      if error != nil {
        completion(nil, "Please check yur network connection")
      }
      
      if let response = response as? HTTPURLResponse {
        let result = self.handleNetworkResponse(response)
        switch result {
        case .success:
          guard let responseData = data else {
            completion(nil, NMError.noData.localizedDescription)
            return
          }
          
          do {
            let apiResponse = try JSONDecoder().decode(CRRoot<CRDataHistory>.self, from: responseData)
            completion(apiResponse, nil)
          } catch let error as DecodingError {
            self.decodingError(error)
            completion(nil, NMError.unableToDecode.localizedDescription)
          } catch {
            completion(nil, NMError.unableToDecode.localizedDescription)
          }
        case .failure(let networkFailureError):
          completion(nil, networkFailureError.localizedDescription)
        }
      }
    }
  }
}
