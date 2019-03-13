//
//  ConfigNetworkManager.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 3/13/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

struct ConfigNetworkManager: NetworkManager {
  private let router = Router<ConfigApi>()
  
  private func callCompletion(_ config: Bootstrap?, _ error: String?, _ completion: @escaping (_ config: Bootstrap?, _ error: String?) -> Void) {
    DispatchQueue.main.async {
      completion(config, error)
    }
  }
  
  func getConfig(_ completion: @escaping (_ config: Bootstrap?, _ error: String?) -> Void) {
    DispatchQueue.global(qos: .background).async {
      self.router.request(.config) { data, response, error in
        if error != nil {
          self.callCompletion(nil, "Please check your network connection", completion)
        }
        
        if let response = response as? HTTPURLResponse {
          let result = self.handleNetworkResponse(response)
          switch result {
          case .success:
            guard let responseData = data else {
              self.callCompletion(nil, NetworkResponse.noData.rawValue, completion)
              return
            }
            
            do {
              let apiResponse = try JSONDecoder().decode(Bootstrap.self, from: responseData)
              self.callCompletion(apiResponse, nil, completion)
            } catch let error as DecodingError {
              self.decodingError(error)
              self.callCompletion(nil, NetworkResponse.unableToDecode.rawValue, completion)
            } catch {
              self.callCompletion(nil, NetworkResponse.unableToDecode.rawValue, completion)
            }
          case .failure(let networkFailureError):
            completion(nil, networkFailureError)
          }
        }
      }
    }
  }
}
