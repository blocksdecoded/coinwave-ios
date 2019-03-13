//
//  ConfigEndPoint.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 3/13/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

enum ConfigApi {
  case config
}

extension ConfigApi: EndPointType {
  var constructedURL: String {
    return "http://\(Constants.bootstrapBaseURL)"
  }
  
  var path: String {
    switch self {
    case .config:
      return "/bootstrap.json"
    }
  }
  
  var httpMethod: HTTPMethod {
    switch self {
    case .config:
      return .get
    }
  }
  
  var task: HTTPTask {
    switch self {
    case .config:
      return .request
    }
  }
}
