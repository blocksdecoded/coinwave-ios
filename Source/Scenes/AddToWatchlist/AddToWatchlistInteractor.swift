//
//  AddToWatchlistInteractor.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 2/12/19.
//  Copyright (c) 2019 makeuseof. All rights reserved.
//

import UIKit

protocol AddToWatchlistBusinessLogic {
  func doSomething(request: AddToWatchlist.Coins.Request)
  func addToWatchlist(request: AddToWatchlist.Add.Request)
}

protocol AddToWatchlistDataStore {
  //var name: String { get set }
}

class AddToWatchlistInteractor: AddToWatchlistBusinessLogic, AddToWatchlistDataStore {
  var presenter: AddToWatchlistPresentationLogic?
  var worker: CoinsWorker?

  func doSomething(request: AddToWatchlist.Coins.Request) {
    worker?.fetchCoins(request.sortable, force: request.force, local: { result in
      switch result {
      case .success(let coins):
        let response = AddToWatchlist.Coins.Response(coins: coins)
        self.presenter?.presentCoins(response: response)
      case .failure:
        break
      }
    }, remote: { result in
      switch result {
      case .success(let coins):
        let response = AddToWatchlist.Coins.Response(coins: coins)
        self.presenter?.presentCoins(response: response)
      case .failure(let error):
        self.presenter?.presentError(error)
      }
    })
  }
  
  func addToWatchlist(request: AddToWatchlist.Add.Request) {
    guard let worker = worker else {
      return
    }
    
    var mutableCoin = request.coin
    mutableCoin.isWatchlist = !mutableCoin.isWatchlist
    let result = worker.update(mutableCoin)
    switch result {
    case .success:
      presenter?.addToWatchlist(response: AddToWatchlist.Add.Response(position: request.position, coin: mutableCoin))
    case .failure:
      //TODO: Handle DSError
      presenter?.presentError(.noData)
    }
  }
}
