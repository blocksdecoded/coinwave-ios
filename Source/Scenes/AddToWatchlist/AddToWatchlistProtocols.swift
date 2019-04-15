//
//  AddToWatchlistProtocols.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 4/13/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

protocol AddToWatchlistDisplayLogic: class {
  var viewModel: AddToWatchlistBusinessLogic { get set }
  
  func displayCoins(coins: [CRCoin])
  func refreshCoin(viewModel: AddToWatchlistModel)
  func displayError(_ string: String)
}

protocol AddToWatchlistBusinessLogic {
  var view: AddToWatchlistDisplayLogic? { get set }
  var worker: CoinsWorkerLogic { get set }
  
  func fetchCoins(sortable: Sortable, force: Bool)
  func addToWatchlist(request: AddToWatchlistModel)
}
