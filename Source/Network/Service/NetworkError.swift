//
//  NetworkError.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/19/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation

public enum NetworkError: String, Error {
  case parametersNil = "Parameters were nil."
  case encodingFailed = "Parameter encoding failed."
  case missingURL = "URL is nil."
}

public enum NetworkResultError: String {
  case network = "Connection error, please check your internet connection and press \"retry\""
  case noData = "No available data. Please, retry later"
}
