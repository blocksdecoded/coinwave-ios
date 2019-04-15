//
//  WatchlistProtocols.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 4/9/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

protocol WatchlistDisplayLogic: class {
  var viewModel: WatchlistBusinessLogic { get set }
  
  func displayCoins()
  func displayFavorite(viewModel: WatchlistModel)
  func displayNoFavorite()
  func displayNoWatchlist(_ string: String)
  func displayError(_ string: String)
}

protocol WatchlistBusinessLogic {
  var coins: [CRCoin] { get set }
  var view: WatchlistDisplayLogic? { get set }
  var worker: CoinsWorkerLogic { get set }
  
  func fetchCoins(sortable: Sortable, force: Bool)
  func fetchFavorite(force: Bool)
}
