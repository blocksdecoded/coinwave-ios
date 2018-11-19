//
//  PostsEndPoint.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/19/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation
import MUOSimpleNetwork

public enum PostsApi {
  case list
}

extension PostsApi: EndPointType {
  public var baseURL: URL {
    guard let url = URL(string: "http://muoarticles.muoapps.com/makeuseof") else { fatalError("baseURL could not be configured.") }
    return url
  }
  
  public var path: String {
    switch self {
    case .list:
      return "/posts"
    }
  }
  
  public var httpMethod: HTTPMethod {
    switch self {
    case .list:
      return .get
    }
  }
  
  public var task: HTTPTask {
    switch self {
    case .list:
      return .request
    }
  }
  
  public var headers: HTTPHeaders? {
    return nil
  }
}
