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
  
  func createTables() throws {
    try PostDataHelper.createTable()
    try CategoryDataHelper.createTable()
    try PostCategoryDataHelper.createTable()
    try CRCoinDataHelper.createTable()
  }
}
