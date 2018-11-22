//
//  HTTPTask.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/19/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String: String]

public enum HTTPTask {
  case request
  
  case requestParameters(bodyParameters: Parameters?, urlParameters: Parameters?)
  
  case requestParametersAndHeaders(bodyParameters: Parameters?,
                                   urlParameters: Parameters?,
                                   additionalHeaders: HTTPHeaders?)
}
