//
//  AddToWatchlistViewModel.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 2/12/19.
//  Copyright (c) 2019 makeuseof. All rights reserved.
//

import UIKit

class AddToWatchlistViewModel: AddToWatchlistBusinessLogic {
  
  // MARK: - Properties
  
  weak var view: AddToWatchlistDisplayLogic?
  var worker: CoinsWorkerLogic
  var coins: [CRCoin]
  
  // MARK: - Init
  
  init(worker: CoinsWorkerLogic) {
    self.worker = worker
    self.coins = [CRCoin]()
  }
  
  // MARK: - Coins Worker Logic
  
  func viewDidLoad() {
    let sortable = Sortable(field: .name, direction: .asc)
    fetchCoins(sortable: sortable, force: false)
  }

  func fetchCoins(sortable: Sortable, force: Bool) {
    worker.fetchCoins(sortable, force: force, local: { result in
      switch result {
      case .success(let coins):
        self.coins = coins
        self.view?.displayCoins()
      case .failure:
        break
      }
    }, remote: { result in
      switch result {
      case .success(let coins):
        self.coins = coins
        self.view?.displayCoins()
      case .failure(let error):
        self.view?.displayError(error.localizedDescription)
      }
    })
  }
  
  func addToWatchlist(indexPath: IndexPath) {
    var mutableCoin = coins[indexPath.item]
    mutableCoin.isWatchlist = !mutableCoin.isWatchlist
    let result = worker.update(mutableCoin)
    switch result {
    case .success:
      self.coins[indexPath.item] = mutableCoin
      view?.refreshCoin(indexPaths: [indexPath])
    case .failure:
      //TODO: Handle DSError
      self.view?.displayError(CWError.noData.localizedDescription)
    }
  }
}
