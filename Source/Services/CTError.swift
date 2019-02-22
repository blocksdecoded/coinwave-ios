//
//  CTError.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 2/22/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

enum CTError: String {
  case network = "Connection error, please check your internet connection and press \"retry\""
  case noData = "No available data. Please, retry later"
}
