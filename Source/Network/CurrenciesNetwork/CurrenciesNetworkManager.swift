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
  
  func getCurrencies(limit: Int, offset: Int, ids: String?,
                     completion: @escaping (_ currencies: CRRoot<CRDataList>?, _ error: String?) -> Void) {
    router.request(.list(limit: limit, offset: offset, ids: ids)) { data, response, error in
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
            completion(apiResponse, nil)
          } catch {
            if let error = error as? DecodingError {
              self.decodingError(error)
            }
            completion(nil, NetworkResponse.unableToDecode.rawValue)
          }
        case .failure(let networkFailureError):
          completion(nil, networkFailureError)
        }
      }
    }
  }
  
  func getCurrency(currID: Int, _ completion: @escaping(_ currency: CRRoot<CRDataCoin>?, _ error: String?) -> Void) {
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
            completion(apiResponse, nil)
          } catch {
            if let error = error as? DecodingError {
              self.decodingError(error)
            }
            completion(nil, NetworkResponse.unableToDecode.rawValue)
          }
        case .failure(let networkFailureError):
          completion(nil, networkFailureError)
        }
      }
    }
  }
  
  func getHistory(currID: Int, time: CRTimeframe, _ completion: @escaping(CRRoot<CRDataHistory>?, _ error: String?) -> Void) {
    router.request(.hsitory(currID, time)) { data, response, error in
      if error != nil {
        completion(nil, "Please check yur network connection")
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
            let apiResponse = try JSONDecoder().decode(CRRoot<CRDataHistory>.self, from: responseData)
            completion(apiResponse, nil)
          } catch {
            if let error = error as? DecodingError {
              self.decodingError(error)
            }
            completion(nil, NetworkResponse.unableToDecode.rawValue)
            
          }
        case .failure(let networkFailureError):
          completion(nil, networkFailureError)
        }
      }
    }
  }
  
  private func decodingError(_ error: DecodingError) {
    //TODO: Analytics
    switch error {
    case .dataCorrupted(let context):
      print("Data corrupted")
      print(context.debugDescription)
      print(context.codingPath)
    case .keyNotFound(let key, let context):
      print("Key not found")
      print(key.debugDescription)
      print(context.debugDescription)
      print(context.codingPath)
    case .typeMismatch(let type, let context):
      print("Type mismatch")
      print(type)
      print(context.debugDescription)
      print(context.codingPath)
    case .valueNotFound(let type, let context):
      print("Value not found")
      print(type)
      print(context.debugDescription)
      print(context.codingPath)
    }
  }
}
