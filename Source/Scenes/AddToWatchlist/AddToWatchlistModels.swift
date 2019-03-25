//
//  AddToWatchlistModels.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 2/12/19.
//  Copyright (c) 2019 makeuseof. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum AddToWatchlist {
  // MARK: Use cases
  enum Coins {
    // swiftlint:disable nesting
    struct Request {
      let field: CRCoin.OrderField
      let type: CRCoin.OrderType
      let force: Bool
    }
    struct Response {
      let coins: [CRCoin]
    }
    struct ViewModel {
      let coins: [CRCoin]
    }
    
  }
  
  enum Add {
    struct Request {
      let coin: CRCoin
      let position: Int
    }
    
    struct Response {
      let position: Int
      let coin: CRCoin
    }
    
    struct ViewModel {
      let position: Int
      let coin: CRCoin
    }
  }
}
