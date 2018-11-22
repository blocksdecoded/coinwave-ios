//
//  JSONParameterEncoder.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/19/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation

public struct JSONParameterEncoder: ParameterEncoder {
  public static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
    do {
      let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
      urlRequest.httpBody = jsonAsData
      if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
      }
    } catch {
      throw NetworkError.encodingFailed
    }
  }
}
