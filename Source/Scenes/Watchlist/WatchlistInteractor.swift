//
//  WatchlistInteractor.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/24/18.
//  Copyright (c) 2018 makeuseof. All rights reserved.
//

import UIKit

protocol WatchlistBusinessLogic {
  func fetchCoins(request: Watchlist.Something.Request)
  func fetchFavorite(force: Bool)
  func sortName(_ screen: String)
  func sortPrice(_ screen: String)
  func sortMarketCap(_ screen: String)
  func sortVolume(_ screen: String)
  func viewDidLoad(_ screen: String)
}

protocol WatchlistDataStore {
  //var name: String { get set }
}

class WatchlistInteractor: WatchlistBusinessLogic, WatchlistDataStore {
  typealias Response = Watchlist.Favorite.Response
  
  var presenter: WatchlistPresentationLogic?
  var worker: CoinsWorker?
  var sortingWorker: SortingWorker?
  
  var sortField: CRCoin.OrderField!
  var sortType: CRCoin.OrderType!
  
  func fetchCoins(request: Watchlist.Something.Request) {
    fetchCoins(request.field, request.type, force: request.force)
  }
  
  private func fetchCoins(_ field: CRCoin.OrderField, _ type: CRCoin.OrderType, force: Bool) {
    worker?.fetchWatchlist(field, type, force: force) { result in
      switch result {
      case .success(let coins):
        let response = Watchlist.Something.Response(currencies: coins)
        self.presenter?.presentSomething(response: response)
      case .failure(let error):
        self.presenter?.presentError(error)
      }
    }
  }
  
  func fetchFavorite(force: Bool) {
    worker?.fetchFavorite(force: force) { result in
      switch result {
      case .success(let coin):
        self.presenter?.presentFavorite(response: Response(identifier: Int(coin.identifier),
                                                           symbol: coin.symbol))
      case .failure(let error):
        switch error {
        case .noData:
          self.presenter?.presentNoFavorite()
        default:
          self.presenter?.presentError(error)
        }
      }
    }
  }
  
  func sortName(_ screen: String) {
    sort(screen, .name)
  }
  
  func sortPrice(_ screen: String) {
    sort(screen, .price)
  }
  
  func sortMarketCap(_ screen: String) {
    sort(screen, .marketCap)
  }
  
  func sortVolume(_ screen: String) {
    sort(screen, .volume)
  }
  
  func viewDidLoad(_ screen: String) {
    let sort = sortingWorker?.getSortConfig(screen: screen)
    sortField = sort?.0 ?? .marketCap
    sortType = sort?.1 ?? .desc
    presenter?.presentSort(sortField, sortType)
  }
  
  private func sort(_ screen: String, _ field: CRCoin.OrderField) {
    sortType = sortType == .asc ? .desc : .asc
    sortField = field
    sortingWorker?.setSortConfig(screen: screen, field: sortField, type: sortType)
    fetchCoins(sortField, sortType, force: false)
    presenter?.presentSort(sortField, sortType)
  }
}
