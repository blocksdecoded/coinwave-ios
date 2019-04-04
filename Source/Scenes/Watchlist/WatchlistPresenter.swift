//
//  WatchlistPresenter.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/24/18.
//  Copyright (c) 2018 makeuseof. All rights reserved.
//

import UIKit

protocol WatchlistPresentationLogic {
  func presentSomething(response: Watchlist.Something.Response)
  func presentFavorite(response: Watchlist.Favorite.Response)
  func presentNoFavorite()
  func presentError(_ error: CWError)
  func presentSort(_ sortable: Sortable)
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
  
  func presentError(_ error: CWError) {
    switch error {
    case .noData:
      viewController?.displayError("Your watchlist is empty")
    default:
      viewController?.displayError(error.localizedDescription)
    }
  }
  
  func presentSort(_ sortable: Sortable) {
    viewController?.setSort(sortable)
  }
}
