//
//  NetworkManager.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/19/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation

protocol NetworkManager {
  func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>
  func decodingError(_ error: DecodingError)
}

extension NetworkManager {
  func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
    switch response.statusCode {
    case 200...299: return .success
    case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
    case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
    case 600: return .failure(NetworkResponse.outdated.rawValue)
    default: return .failure(NetworkResponse.failed.rawValue)
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
    }
  }
}

enum NetworkResponse: String {
  case success
  case authenticationError = "You need to be authenticated first."
  case badRequest = "Bad request."
  case outdated = "The url you requested is outdated"
  case failed = "Network request failed."
  case noData = "Response returned with no data to decode."
  case unableToDecode = "We could not decode the response."
}

enum Result<String> {
  case success
  case failure(String)
}
