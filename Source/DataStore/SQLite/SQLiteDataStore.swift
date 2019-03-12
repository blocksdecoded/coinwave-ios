//
//  SQLiteDataStore.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/22/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation
import SQLite

class SQLiteDataStore {
  static let sharedInstance = SQLiteDataStore()
  // swiftlint:disable identifier_name
  let db: Connection?
  private let dbName = "database.sqlite3"
  
  private init() {
    let documentsDirectory = (
        NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
      ) as String
    let pathToDB = "\(documentsDirectory)/\(dbName)"
    
    do {
      db = try Connection(pathToDB)
    } catch {
      db = nil
    }
  }
  
  func checkMigrations() throws {
    if db?.userVersion == 0 {
      try CRCoinDataHelper.dropTable()
      db?.userVersion = 1
    }
  }
  
  func createTables() throws {
    try PostDataHelper.createTable()
    try CategoryDataHelper.createTable()
    try PostCategoryDataHelper.createTable()
    try CRCoinDataHelper.createTable()
  }
}

extension Connection {
  public var userVersion: Int32 {
    get {
      do {
        guard let version = try scalar("PRAGMA user_version") as? Int64 else {
          return 0
        }
        return Int32(version)
      } catch {
        return 0
      }
    }
    
    set {
      try? run("PRAGMA user_version = \(newValue)")
    }
  }
}
