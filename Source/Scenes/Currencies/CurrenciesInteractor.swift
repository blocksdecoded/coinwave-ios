//
//  CurrenciesInteractor.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/17/18.
//  Copyright (c) 2018 makeuseof. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol CurrenciesBusinessLogic {
  func doSomething(request: Currencies.FetchCoins.Request)
  func setFavorite(id: Int, symbol: String, isFavorite: Bool)
}

protocol CurrenciesDataStore {
  //var name: String { get set }
}

class CurrenciesInteractor: CurrenciesBusinessLogic, CurrenciesDataStore {
  
  var presenter: CurrenciesPresentationLogic?
  var worker: CurrenciesWorker?
  
  var data: CRRoot<CRDataList>?

  // MARK: Do something

  func doSomething(request: Currencies.FetchCoins.Request) {
    worker = CurrenciesWorker()
    if let currs = worker?.fetchLocalCurrencies() {
      presenter?.presentCurrencies(response: Currencies.FetchCoins.ViewModel(currencies: currs))
    }
    
    worker?.fetchCurrencies(limit: request.limit, offset: Constants.COINS_OFFSET) { currencies in
      self.data = currencies
      self.presenter?.presentCurrencies(response: Currencies.FetchCoins.ViewModel(currencies: currencies.data.coins))
    }
  }
  
  func setFavorite(id: Int, symbol: String, isFavorite: Bool) {
    worker?.setFavorite(id: id, symbol: symbol, isFavorite: isFavorite)
  }
}
