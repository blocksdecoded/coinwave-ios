//
//  CurrencyDetailsInteractor.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/24/18.
//  Copyright (c) 2018 makeuseof. All rights reserved.
//

import UIKit

protocol CurrencyDetailsBusinessLogic {
  func doSomething(request: CurrencyDetails.Something.Request)
  func addToFavorites(request: CurrencyDetails.AddFavorite.Request)
  func onOpenWeb()
}

protocol CurrencyDetailsDataStore {
  //var name: String { get set }
}

class CurrencyDetailsInteractor: CurrencyDetailsBusinessLogic, CurrencyDetailsDataStore {
  var presenter: CurrencyDetailsPresentationLogic?
  var worker: CoinsWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func doSomething(request: CurrencyDetails.Something.Request) {
    worker?.fetchCoin(request.currID, force: request.force) { result  in
      switch result {
      case .success(let coin):
        let response = CurrencyDetails.Something.Response(coin: coin)
        self.presenter?.presentCoinDetails(response: response)
        break
      case .failure(let error):
        self.presenter?.presentError(error)
      }
    }
  }
  
  func addToFavorites(request: CurrencyDetails.AddFavorite.Request) {
    guard let worker = worker else {
      return
    }
    
    var coin = request.coin
    coin.isWatchlist = !coin.isWatchlist
    let result = worker.update(coin)
    switch result {
    case .success:
      let response = CurrencyDetails.AddFavorite.Response(coin: coin)
      presenter?.favorites(response: response)
    case .failure:
      //TODO: Handle DSError
      presenter?.presentError(.noData)
    }
  }
  
  func onOpenWeb() {
    presenter?.presentWebsite()
  }
}
