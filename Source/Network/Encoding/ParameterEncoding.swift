//
//  ParameterEncoding.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/19/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]

public protocol ParameterEncoder {
  static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}
