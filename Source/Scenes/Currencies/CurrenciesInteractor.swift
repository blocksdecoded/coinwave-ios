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
  func doSomething(request: Currencies.Something.Request)
}

protocol CurrenciesDataStore {
  //var name: String { get set }
}

class CurrenciesInteractor: CurrenciesBusinessLogic, CurrenciesDataStore {
  var presenter: CurrenciesPresentationLogic?
  var worker: CurrenciesWorker?
  //var name: String = ""

  // MARK: Do something

  func doSomething(request: Currencies.Something.Request) {
    worker = CurrenciesWorker()
    worker?.doSomeWork()

    let response = Currencies.Something.Response()
    presenter?.presentSomething(response: response)
  }
}