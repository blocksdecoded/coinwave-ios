//
//  CoinsViewModel.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 4/9/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

class CoinsViewModel: CoinsBusinessLogic {
  
  // MARK: - Properties
  
  weak var view: CoinsDisplayLogic?
  var coins: [CRCoin]
  var coinsWorker: CoinsWorkerLogic  
  
  // MARK: - Init
  
  init(coinsWorker: CoinsWorkerLogic) {
    coins = [CRCoin]()
    self.coinsWorker = coinsWorker
  }
  
  // MARK: - Business Logic
  
  func fetchCoins(sortable: Sortable, limit: Int, force: Bool) {
    coinsWorker.fetchCoins(sortable, force: force, local: { result in
      switch result {
      case .success(let coins):
        self.coins = coins
        self.view?.displayCoins(isLocal: true)
      case .failure:
        break
      }
    }, remote: { result in
      switch result {
      case .success(let coins):
        self.coins = coins
        self.view?.displayCoins(isLocal: false)
      case .failure(let error):
        self.view?.displayError(string: error.localizedDescription)
        // TODO: if local not empty show this in navigation error
      }
    })
  }
  
  func setFavorite(coin: CRCoin) {
    var mutableCoin = coin
    mutableCoin.isFavorite = true
    let result = coinsWorker.setFavorite(mutableCoin)
    switch result {
    case .success:
      break
    case .failure:
      //TODO: Handle DSError
      view?.displayError(string: CWError.nilValue.localizedDescription)
    }
  }
}
