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
    fetchCoins()
  }
  
  private func fetchCoins() {
    worker?.fetchCoins(sortField, sortType, local: { coins, lastUpdated in
      if let coins = coins, let lastUpdated = lastUpdated {
        self.presenter?.presentLocalCoins(response: Currencies.LocalCoins.Response(coins: coins, lastUpd: "last updated:\n\(lastUpdated)"))
      }
    }, remote: { coins, error in
      if error != nil {
        self.presenter?.presentError(error!)
      } else {
        if coins != nil && !coins!.isEmpty {
          self.presenter?.presentCurrencies(response: Currencies.FetchCoins.ViewModel(currencies: coins!))
        } else {
          self.presenter?.presentError(.noData)
        }
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
    fetchCoins()
    presenter?.presentSort(sortField, sortType)
  }
}
