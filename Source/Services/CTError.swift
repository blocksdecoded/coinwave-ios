//
//  CTError.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 2/22/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

enum CTError: String {
  case network, noData = "You are currently offline.\nCheck your internet connection"
  case emptyWatchlist = "Your watchlist is empty"
}

enum ValueError: Error {
  case nilValue
}
