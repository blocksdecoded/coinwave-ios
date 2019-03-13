//
//  EndPointType.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/19/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation

protocol EndPointType {
  var constructedURL: String { get }
  var baseURL: URL { get }
  var path: String { get }
  var httpMethod: HTTPMethod { get }
  var task: HTTPTask { get }
  var headers: HTTPHeaders? { get }
}

extension EndPointType {
  var baseURL: URL {
    guard let url = URL(string: constructedURL) else { fatalError("baseURL could not be configured.") }
    return url
  }
  
  var headers: HTTPHeaders? {
    return nil
  }
}
