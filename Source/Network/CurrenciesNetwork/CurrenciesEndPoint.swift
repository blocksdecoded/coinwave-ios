//
//  CurrenciesEndPoint.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/23/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation

enum CurrenciesApi {
  case list
  case hsitory(String, CRTimeframe)
}

extension CurrenciesApi: EndPointType {
  var constructedURL: String {
    return Constants.coinsBaseURL
  }
  
  var path: String {
    switch self {
    case .list:
      return "/index.json"
    case .hsitory(let curr, let timeframe):
      return"/coin/\(curr)/history/\(timeframe.value)/index.json"
    }
  }
  
  var httpMethod: HTTPMethod {
    return .get
  }
  
  var task: HTTPTask {
    switch self {
    case .list, .hsitory:
      return .request
    }
  }
}
