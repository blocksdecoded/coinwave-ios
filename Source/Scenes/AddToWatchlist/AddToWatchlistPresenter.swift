//
//  AddToWatchlistPresenter.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 2/12/19.
//  Copyright (c) 2019 makeuseof. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AddToWatchlistPresentationLogic {
  func presentCoins(response: AddToWatchlist.Coins.Response)
  func addToWatchlist(response: AddToWatchlist.Add.Response)
  func presentError(_ error: CTError)
}

class AddToWatchlistPresenter: AddToWatchlistPresentationLogic {
  weak var viewController: AddToWatchlistDisplayLogic?
  
  func presentCoins(response: AddToWatchlist.Coins.Response) {
    let viewModel = AddToWatchlist.Coins.ViewModel(coins: response.coins)
    viewController?.displaySomething(viewModel: viewModel)
  }
  
  func addToWatchlist(response: AddToWatchlist.Add.Response) {
    let viewModel = AddToWatchlist.Add.ViewModel(position: response.position,
                                                 coin: response.coin)
    viewController?.refreshCoin(viewModel: viewModel)
  }
  
  func presentError(_ error: CTError) {
    viewController?.displayError(error.rawValue)
  }
}
