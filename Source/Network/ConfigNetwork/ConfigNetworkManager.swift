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
  
  private func callCompletion(_ result: Result<Bootstrap, CWError>,
                              _ completion: @escaping (Result<Bootstrap, CWError>) -> Void) {
    DispatchQueue.main.async {
      completion(result)
    }
  }
  
  func getConfig(_ completion: @escaping (Result<Bootstrap, CWError>) -> Void) {
    DispatchQueue.global(qos: .background).async {
      self.router.request(.config) { data, response, error in
        if error != nil {
          self.callCompletion(.failure(.network), completion)
        }
        if let response = response as? HTTPURLResponse {
          let result = self.handleNetworkResponse(response)
          switch result {
          case .success:
            guard let responseData = data else {
              self.callCompletion(.failure(.noData), completion)
              return
            }
            do {
              let apiResponse = try JSONDecoder().decode(Bootstrap.self, from: responseData)
              if apiResponse.servers.isEmpty {
                self.callCompletion(.failure(.noData), completion)
              } else {
                self.callCompletion(.success(apiResponse), completion)
              }
            } catch let error as DecodingError {
              self.decodingError(error)
              self.callCompletion(.failure(.network), completion)
            } catch {
              self.callCompletion(.failure(.network), completion)
            }
          case .failure(let networkFailureError):
            self.callCompletion(.failure(networkFailureError), completion)
          }
        }
      }
    }
  }
}
