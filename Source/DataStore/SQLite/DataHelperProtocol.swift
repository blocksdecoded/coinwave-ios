//
//  DataHelperProtocol.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/22/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation

// swiftlint:disable type_name identifier_name
protocol DataHelperProtocol {
  associatedtype T
  static func createTable() throws
  static func insert(item: T) throws -> Int64
  static func delete(item: T) throws
  static func find(id: Int64) throws -> T?
  static func findAll() throws -> [T]?
}
