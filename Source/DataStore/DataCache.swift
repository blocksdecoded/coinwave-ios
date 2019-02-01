//
//  DataCache.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 1/31/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

class DataCache {
  static var shared = DataCache()
  
  let memCache = NSCache<NSString, NSData>()
  
  func write(data: Data, for key: String) {
    memCache.setObject(data as NSData, forKey: key as NSString)
  }
  
  func read(for key: String) -> Data? {
    return memCache.object(forKey: key as NSString) as Data?
  }
}
