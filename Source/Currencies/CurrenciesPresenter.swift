//
//  CurrenciesPresenter.swift
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

protocol CurrenciesPresentationLogic {
  func presentSomething(response: Currencies.Something.Response)
}

class CurrenciesPresenter: CurrenciesPresentationLogic {
  weak var viewController: CurrenciesDisplayLogic?

  // MARK: Do something

  func presentSomething(response: Currencies.Something.Response) {
    let viewModel = Currencies.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
