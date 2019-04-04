//
//  CurrenciesInteractor.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/17/18.
//  Copyright (c) 2018 makeuseof. All rights reserved.
//

import UIKit

protocol CurrenciesBusinessLogic {
  func fetchCoins(request: Currencies.FetchCoins.Request)
  func setFavorite(_ coin: CRCoin)
  func sortName(_ screen: String)
  func sortPrice(_ screen: String)
  func sortMarketCap(_ screen: String)
  func sortVolume(_ screen: String)
  func viewDidLoad(_ screen: String)
}

protocol CurrenciesDataStore {
  //var name: String { get set }
}

class CurrenciesInteractor: CurrenciesBusinessLogic, CurrenciesDataStore {  
  var presenter: CurrenciesPresentationLogic?
  var worker: CoinsWorker?
  var sortingWorker: SortingWorker?
  
  var sortField: CRCoin.OrderField!
  var sortType: CRCoin.OrderType!

  func fetchCoins(request: Currencies.FetchCoins.Request) {
    fetchCoins(force: request.force)
  }
  
  private func fetchCoins(force: Bool) {
    worker?.fetchCoins(sortField, sortType, force: force, local: { result in
      switch result {
      case .success(let coins):
        self.presenter?.presentLocalCoins(response: Currencies.LocalCoins.Response(coins: coins, lastUpd: ""))
      case .failure:
        break
      }
    }, remote: { result in
      switch result {
      case .success(let coins):
        self.presenter?.presentCurrencies(response: Currencies.FetchCoins.ViewModel(currencies: coins))
      case .failure(let error):
        self.presenter?.presentError(error)
      }
    })
  }
  
  func setFavorite(_ coin: CRCoin) {
    var mutableCoin = coin
    mutableCoin.isFavorite = true
    worker?.setFavorite(mutableCoin)
  }
  
  func viewDidLoad(_ screen: String) {
    let sort = sortingWorker?.getSortConfig(screen: screen)
    sortField = sort?.0 ?? .marketCap
    sortType = sort?.1 ?? .desc
    presenter?.presentSort(sortField, sortType)
  }
  
  func sortName(_ screen: String) {
    sort(screen, .name)
  }
  
  func sortPrice(_ screen: String) {
    sort(screen, .price)
  }
  
  func sortVolume(_ screen: String) {
    sort(screen, .volume)
  }
  
  func sortMarketCap(_ screen: String) {
    sort(screen, .marketCap)
  }
  
  private func sort(_ screen: String, _ field: CRCoin.OrderField) {
    sortType = sortType == .asc ? .desc : .asc
    sortField = field
    sortingWorker?.setSortConfig(screen: screen, field: sortField, type: sortType)
    fetchCoins(force: false)
    presenter?.presentSort(sortField, sortType)
  }
}
