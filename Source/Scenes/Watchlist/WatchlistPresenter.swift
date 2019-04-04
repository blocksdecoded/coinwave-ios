//
//  WatchlistPresenter.swift
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

protocol WatchlistPresentationLogic {
  func presentSomething(response: Watchlist.Something.Response)
  func presentFavorite(response: Watchlist.Favorite.Response)
  func presentNoFavorite()
  func presentError(_ error: NMError)
  func presentSort(_ field: CRCoin.OrderField, _ type: CRCoin.OrderType)
}

class WatchlistPresenter: WatchlistPresentationLogic {
  typealias ViewModel = Watchlist.Favorite.ViewModel
  
  weak var viewController: WatchlistDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: Watchlist.Something.Response) {
    let viewModel = Watchlist.Something.ViewModel(currencies: response.currencies)
    viewController?.displaySomething(viewModel: viewModel)
  }
  
  func presentNoFavorite() {
    viewController?.displayNoFavorite()
  }
  
  func presentFavorite(response: Watchlist.Favorite.Response) {
    viewController?.displayFavorite(viewModel: ViewModel(identifier: response.identifier,
                                                         symbol: response.symbol))
  }
  
  func presentError(_ error: NMError) {
    //TODO: Handle empty watchlist
    viewController?.displayError("You are currently offline.\nCheck your internet connection")
  }
  
  func presentSort(_ field: CRCoin.OrderField, _ type: CRCoin.OrderType) {
    viewController?.setSort(field, type)
  }
}
