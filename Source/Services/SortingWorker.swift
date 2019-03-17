//
//  SortingWorker.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 3/17/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

class SortingWorker {
  private static let orderField = "order_field"
  private static let orderType = "order_type"
  
  func setSortConfig(screen: String, field: CRCoin.OrderField, type: CRCoin.OrderType) {
    UserDefaults.standard.set(field.rawValue, forKey: "\(screen)_\(SortingWorker.orderField)")
    UserDefaults.standard.set(type.rawValue, forKey: "\(screen)_\(SortingWorker.orderType)")
  }
  
  func getSortConfig(screen: String) -> (CRCoin.OrderField?, CRCoin.OrderType?) {
    var field: CRCoin.OrderField?
    var type: CRCoin.OrderType?
    
    if let fieldRawValue = UserDefaults.standard.value(forKey: "\(screen)_\(SortingWorker.orderField)") as? String {
      field = CRCoin.OrderField(rawValue: fieldRawValue)
    }
    
    if let typeRawValue = UserDefaults.standard.value(forKey: "\(screen)_\(SortingWorker.orderType)") as? String {
      type = CRCoin.OrderType(rawValue: typeRawValue)
    }
    
    return(field, type)
  }
}
