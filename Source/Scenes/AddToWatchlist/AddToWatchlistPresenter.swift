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
  func presentSomething(response: AddToWatchlist.Something.Response)
  func presentEmptyList()
  func addToWatchlist(response: AddToWatchlist.Add.Response)
}

class AddToWatchlistPresenter: AddToWatchlistPresentationLogic {
  weak var viewController: AddToWatchlistDisplayLogic?
  
  private var currencies: CRRoot<CRDataList>?
  
  // MARK: Do something
  
  func presentSomething(response: AddToWatchlist.Something.Response) {
    let viewModel = AddToWatchlist.Something.ViewModel(coins: response.coins)
    viewController?.displaySomething(viewModel: viewModel)
  }
  
  func presentEmptyList() {
    
  }
  
  func addToWatchlist(response: AddToWatchlist.Add.Response) {
    viewController?.refreshCoin(viewModel: AddToWatchlist.Add.ViewModel(position: response.position, isWatchlist: response.isWatchlist))
  }
}