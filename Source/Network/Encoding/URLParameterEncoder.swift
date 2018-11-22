//
//  URLParameterEncoder.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/19/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation

public struct URLParameterEncoder: ParameterEncoder {
  public static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
    guard let url = urlRequest.url else { throw NetworkError.missingURL }
    
    if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
      urlComponents.queryItems = [URLQueryItem]()
      
      for (key, value) in parameters {
//        let queryItem = URLQueryItem(name: key, value: "\(value)"
//        .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
        let queryItem = URLQueryItem(name: key, value: "\(value)")
        urlComponents.queryItems?.append(queryItem)
      }
      
      urlRequest.url = urlComponents.url
    }
    
    if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
      urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
    }
    
  }
}
