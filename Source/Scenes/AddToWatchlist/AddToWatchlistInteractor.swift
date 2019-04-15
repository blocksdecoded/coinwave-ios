//
//  AddToWatchlistInteractor.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 2/12/19.
//  Copyright (c) 2019 makeuseof. All rights reserved.
//

import UIKit

class AddToWatchlistInteractor: AddToWatchlistBusinessLogic {
  
  // MARK: - Properties
  
  weak var view: AddToWatchlistDisplayLogic?
  var worker: CoinsWorkerLogic
  
  // MARK: - Init
  
  init(worker: CoinsWorkerLogic) {
    self.worker = worker
  }
  
  // MARK: - Coins Worker Logic

  func fetchCoins(sortable: Sortable, force: Bool) {
    worker.fetchCoins(sortable, force: force, local: { result in
      switch result {
      case .success(let coins):
        self.view?.displayCoins(coins: coins)
      case .failure:
        break
      }
    }, remote: { result in
      switch result {
      case .success(let coins):
        self.view?.displayCoins(coins: coins)
      case .failure(let error):
        self.view?.displayError(error.localizedDescription)
      }
    })
  }
  
  func addToWatchlist(request: AddToWatchlistModel) {
    var mutableCoin = request.coin
    mutableCoin.isWatchlist = !mutableCoin.isWatchlist
    let result = worker.update(mutableCoin)
    switch result {
    case .success:
      view?.refreshCoin(viewModel: AddToWatchlistModel(position: request.position, coin: mutableCoin))
    case .failure:
      //TODO: Handle DSError
      self.view?.displayError(CWError.noData.localizedDescription)
    }
  }
}
