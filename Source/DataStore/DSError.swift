//
//  DSError.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 4/5/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

enum DSError: Error {
  case notFound
  case databaseException
  case operationFailure
}
