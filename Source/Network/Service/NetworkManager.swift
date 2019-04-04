//
//  NetworkManager.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/19/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation

protocol NetworkManager {
  func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<Int, CWError>
  func decodingError(_ error: DecodingError)
}

extension NetworkManager {
  func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<Int, CWError> {
    switch response.statusCode {
    case 200...299: return .success(response.statusCode)
    default: return .failure(.network)
    }
  }
  
  func decodingError(_ error: DecodingError) {
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
    default:
      print("Default")
      print(error.localizedDescription)
    }
  }
}
