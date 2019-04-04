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
  private static let orderDirection = "order_type"
  
  func setSortConfig(screen: String, sortable: Sortable) {
    UserDefaults.standard.set(sortable.field.rawValue, forKey: "\(screen)_\(SortingWorker.orderField)")
    UserDefaults.standard.set(sortable.direction.rawValue, forKey: "\(screen)_\(SortingWorker.orderDirection)")
  }
  
  func getSortConfig(screen: String) -> Sortable? {
    var field: Sortable.Field?
    var direction: Sortable.Direction?
    
    if let fieldRawValue = UserDefaults.standard.value(forKey: "\(screen)_\(SortingWorker.orderField)") as? String {
      field = Sortable.Field(rawValue: fieldRawValue)
    }
    
    if let directionRawValue = UserDefaults.standard.value(forKey: "\(screen)_\(SortingWorker.orderDirection)") as? String {
      direction = Sortable.Direction(rawValue: directionRawValue)
    }
    
    return Sortable(field: field, direction: direction)
  }
}
