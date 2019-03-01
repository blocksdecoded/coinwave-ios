//
//  CTError.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 2/22/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

enum CTError: String {
  case network = "You are currently offline.\nCheck your internet connection"
  case noData = "No available data. Please, retry later"
  case emptyWatchlist = "Your watchlist is empty"
}
