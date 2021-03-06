//
//  PostsEndPoint.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/19/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation

public enum PostsApi {
  case list
  case next(String)
}

extension PostsApi: EndPointType {
  var constructedURL: String {
    return Constants.postsBaseURL
  }
  
  public var path: String {
    switch self {
    case .list, .next:
      return "/posts"
    }
  }
  
  public var httpMethod: HTTPMethod {
    switch self {
    case .list, .next:
      return .get
    }
  }
  
  public var task: HTTPTask {
    switch self {
    case .list:
      return .request
    case .next(let date):
      return .requestParameters(bodyParameters: nil, urlParameters: ["last_item_datetime": date])
    }
  }
}
