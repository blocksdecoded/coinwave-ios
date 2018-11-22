//
//  DataAccessError.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/22/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation

enum DataAccessError: Error {
  case datastoreConnection
  case insert
  case delete
  case search
  case update
  case null
}
