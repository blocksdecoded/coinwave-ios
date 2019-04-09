//
//  WatchlistModels.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/24/18.
//  Copyright (c) 2018 makeuseof. All rights reserved.


import UIKit

enum Watchlist {
  // MARK: Use cases
  
  enum Favorite {
    struct Response {
      let identifier: Int
      let symbol: String
    }
    struct ViewModel {
      let identifier: Int
      let symbol: String
    }
  }
}
