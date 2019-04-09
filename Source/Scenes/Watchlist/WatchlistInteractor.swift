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
  var sortingWorker: SortableWorker?
  var sortable: Sortable!
  
  func fetchCoins(request: Watchlist.Something.Request) {
    fetchCoins(request.sortable, force: request.force)
  }
  
  private func fetchCoins(_ sortable: Sortable, force: Bool) {
    worker?.fetchWatchlist(sortable, force: force) { result in
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
    sortable = sortingWorker?.getSortConfig(screen: screen) ?? Sortable(field: .marketCap, direction: .desc)
    presenter?.presentSort(sortable)
  }
  
  private func sort(_ screen: String, _ field: Sortable.Field) {
    sortable = Sortable(field: field, direction: sortable.direction == .asc ? .desc : .asc)
    sortingWorker?.setSortConfig(screen: screen, sortable: sortable)
    fetchCoins(sortable, force: false)
    presenter?.presentSort(sortable)
  }
}
