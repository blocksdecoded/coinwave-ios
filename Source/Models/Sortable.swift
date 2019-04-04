//
//  Sortable.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 4/4/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

struct Sortable {
  enum Field: String {
    case name
    case marketCap
    case volume
    case price
  }
  
  enum Direction: String {
    case desc
    case asc
  }
  
  let field: Field
  let direction: Direction
  
  init(field: Field, direction: Direction) {
    self.field = field
    self.direction = direction
  }
  
  init?(field: Field?, direction: Direction?) {
    guard let field = field,
      let direction = direction else {
        return nil
    }
    self.field = field
    self.direction = direction
  }
}
