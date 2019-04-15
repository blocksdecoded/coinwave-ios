//
//  WatchlistViewModel.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/24/18.
//  Copyright (c) 2018 makeuseof. All rights reserved.
//

import UIKit

class WatchlistViewModel: WatchlistBusinessLogic {
  
  // MARK: - Properties
  
  var coins: [CRCoin]
  var worker: CoinsWorkerLogic
  weak var view: WatchlistDisplayLogic?
  
  // MARK: - Init
  
  init(worker: CoinsWorkerLogic) {
    coins = [CRCoin]()
    self.worker = worker
  }
  
  // MARK: - Business Logic
  
  func fetchCoins(sortable: Sortable, force: Bool) {
    worker.fetchWatchlist(sortable, force: force) { result in
      switch result {
      case .success(let coins):
        self.coins = coins
        self.view?.displayCoins()
      case .failure(let error):
        switch error {
        case .noData:
          self.view?.displayNoWatchlist(R.string.localizable.empty_watchlist())
        default:
          self.view?.displayError(error.localizedDescription)
        }
      }
    }
  }
  
  func fetchFavorite(force: Bool) {
    worker.fetchFavorite(force: force) { result in
      switch result {
      case .success(let coin):
        let viewModel = WatchlistModel(identifier: coin.identifier, symbol: coin.symbol)
        self.view?.displayFavorite(viewModel: viewModel)
      case .failure(let error):
        switch error {
        case .noData:
          self.view?.displayNoFavorite()
        default:
          self.view?.displayError(error.localizedDescription)
        }
      }
    }
  }
}
