//
//  CurrencyDetailsInteractor.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/24/18.
//  Copyright (c) 2018 makeuseof. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
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
    worker?.fetchCoin(request.currID) { coin in
      guard let coinCoin = coin else {
        fatalError("No coin")
      }
      let response = CurrencyDetails.Something.Response(coin: coinCoin)
      self.presenter?.presentSomething(response: response)
    }
  }
  
  func addToFavorites(request: CurrencyDetails.AddFavorite.Request) {
    var coin = request.coin
    coin.isWatchlist = !coin.isWatchlist
    worker?.update(coin)
    let response = CurrencyDetails.AddFavorite.Response(coin: coin)
    self.presenter?.favorites(response: response)
  }
  
  func onOpenWeb() {
    presenter?.presentWebsite()
  }
}
