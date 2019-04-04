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
  var sortable: Sortable!

  func fetchCoins(request: Currencies.FetchCoins.Request) {
    fetchCoins(force: request.force)
  }
  
  private func fetchCoins(force: Bool) {
    worker?.fetchCoins(sortable, force: force, local: { result in
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
    sortable = sortingWorker?.getSortConfig(screen: screen) ?? Sortable(field: .marketCap, direction: .desc)
    presenter?.presentSort(sortable)
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
  
  private func sort(_ screen: String, _ field: Sortable.Field) {
    sortable = Sortable(field: field, direction: sortable.direction == .asc ? .desc : .asc)
    sortingWorker?.setSortConfig(screen: screen, sortable: sortable)
    fetchCoins(force: false)
    presenter?.presentSort(sortable)
  }
}
