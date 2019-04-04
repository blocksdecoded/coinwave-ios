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
  
  func getCurrencies(_ completion: @escaping (Result<CRRoot<CRDataList>, CWError>) -> Void) {
    router.request(.list) { data, response, error in
      if error != nil {
        completion(.failure(.network))
      }
      
      if let response = response as? HTTPURLResponse {
        let result = self.handleNetworkResponse(response)
        switch result {
        case .success:
          guard let responseData = data else {
            completion(.failure(.noData))
            return
          }
          
          do {
            let apiResponse = try JSONDecoder().decode(CRRoot<CRDataList>.self, from: responseData)
            completion(.success(apiResponse))
          } catch let error as DecodingError {
            self.decodingError(error)
            completion(.failure(.network))
          } catch {
            completion(.failure(.network))
          }
        case .failure(let networkFailureError):
          completion(.failure(networkFailureError))
        }
      }
    }
  }
  
  func getHistory(currID: String,
                  time: CRTimeframe,
                  _ completion: @escaping(Result<CRRoot<CRDataHistory>, CWError>) -> Void) {
    router.request(.hsitory(currID, time)) { data, response, error in
      if error != nil {
        completion(.failure(.network))
      }
      
      if let response = response as? HTTPURLResponse {
        let result = self.handleNetworkResponse(response)
        switch result {
        case .success:
          guard let responseData = data else {
            completion(.failure(.noData))
            return
          }
          
          do {
            let apiResponse = try JSONDecoder().decode(CRRoot<CRDataHistory>.self, from: responseData)
            completion(.success(apiResponse))
          } catch let error as DecodingError {
            self.decodingError(error)
            completion(.failure(.network))
          } catch {
            completion(.failure(.network))
          }
        case .failure(let networkFailureError):
          completion(.failure(networkFailureError))
        }
      }
    }
  }
}
