//
//  NetworkManager.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/19/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation

protocol NetworkManager {
  func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<Int, NMError>
  func decodingError(_ error: DecodingError)
}

extension NetworkManager {
  func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<Int, NMError> {
    switch response.statusCode {
    case 200...299: return .success(response.statusCode)
    case 401...500: return .failure(.authenticationError)
    case 501...599: return .failure(.badRequest)
    case 600: return .failure(.outdated)
    default: return .failure(.failed)
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

enum NMError: Error {
  case authenticationError
  case badRequest
  case outdated
  case failed
  case noData
  case unableToDecode
  case network
  case nilValue
  
  var localizedDescription: String {
    switch self {
    case .authenticationError:
      return "You need to be authenticated first."
    case .badRequest:
      return "Bad request."
    case .failed:
      return "Network request failed."
    case .noData:
      return "Response returned with no data to decode."
    case .outdated:
      return "The url you requested is outdated."
    case .unableToDecode:
      return "We could not decode the response."
    case .network:
      return "Please check your network connection."
    case .nilValue:
      return "Nil value."
    }
  }
}
