//
//  CurrencyDetailsInteractor.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/24/18.
//  Copyright (c) 2018 makeuseof. All rights reserved.
//

import UIKit

class CurrencyDetailsInteractor: DetailsBusinessLogic {
  var view: DetailsDisplayLogic?
  var presenter: CurrencyDetailsPresentationLogic?
  var worker: CoinsWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func fetchDetails(coinID: Int, force: Bool) {
    worker?.fetchCoin(coinID, force: force) { result  in
      switch result {
      case .success(let coin):
        self.presenter?.presentCoinDetails(coin: coin)
      case .failure(let error):
        self.presenter?.presentError(error)
      }
    }
  }
  
  func addToFavorites(coin: CRCoin) {
    guard let worker = worker else {
      return
    }
    
    var mutCoin = coin
    mutCoin.isWatchlist = !coin.isWatchlist
    let result = worker.update(mutCoin)
    switch result {
    case .success:
      presenter?.favorites(coin: mutCoin)
    case .failure:
      //TODO: Handle DSError
      presenter?.presentError(.noData)
    }
  }
  
  func onOpenWeb() {
    presenter?.presentWebsite()
  }
}
