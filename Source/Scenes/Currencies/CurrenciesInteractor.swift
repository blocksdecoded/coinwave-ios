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
  func sortName()
  func sortPrice()
  func sortMarketCap()
  func sortVolume()
  func viewDidLoad()
}

protocol CurrenciesDataStore {
  //var name: String { get set }
}

class CurrenciesInteractor: CurrenciesBusinessLogic, CurrenciesDataStore {
  private static let orderField = "order_field"
  private static let orderType = "order_type"
  
  var presenter: CurrenciesPresentationLogic?
  var worker: CoinsWorker?
  
  var sortField: CRCoin.OrderField!
  var sortType: CRCoin.OrderType!

  func fetchCoins(request: Currencies.FetchCoins.Request) {
    fetchCoins()
  }
  
  private func fetchCoins() {
    worker?.fetchCoins(sortField, sortType) { coins, error in
      if error != nil {
        self.presenter?.presentError(error!)
      } else {
        if coins != nil && !coins!.isEmpty {
          self.presenter?.presentCurrencies(response: Currencies.FetchCoins.ViewModel(currencies: coins!))
        } else {
          self.presenter?.presentError(.noData)
        }
      }
    }
  }
  
  func setFavorite(_ coin: CRCoin) {
    var mutableCoin = coin
    mutableCoin.isFavorite = true
    worker?.setFavorite(mutableCoin)
  }
  
  func viewDidLoad() {
    let (field, type) = getSortConfig()
    sortField = field ?? .marketCap
    sortType = type ?? .desc
    presenter?.presentSort(sortField, sortType)
  }
  
  func sortName() {
    sortType = sortType == .asc ? .desc : .asc
    sortField = .name
    setSortConfig(field: sortField, type: sortType)
    fetchCoins()
    presenter?.presentSort(sortField, sortType)
  }
  
  func sortPrice() {
    sortType = sortType == .asc ? .desc : .asc
    sortField = .price
    setSortConfig(field: sortField, type: sortType)
    fetchCoins()
    presenter?.presentSort(sortField, sortType)
  }
  
  func sortVolume() {
    sortType = sortType == .asc ? .desc : .asc
    sortField = .volume
    setSortConfig(field: sortField, type: sortType)
    fetchCoins()
    presenter?.presentSort(sortField, sortType)
  }
  
  func sortMarketCap() {
    sortType = sortType == .asc ? .desc : .asc
    sortField = .marketCap
    setSortConfig(field: sortField, type: sortType)
    fetchCoins()
    presenter?.presentSort(sortField, sortType)
  }
  
  private func setSortConfig(field: CRCoin.OrderField, type: CRCoin.OrderType) {
    UserDefaults.standard.set(field.rawValue, forKey: CurrenciesInteractor.orderField)
    UserDefaults.standard.set(type.rawValue, forKey: CurrenciesInteractor.orderType)
  }
  
  private func getSortConfig() -> (CRCoin.OrderField?, CRCoin.OrderType?) {
    var field: CRCoin.OrderField?
    var type: CRCoin.OrderType?
    
    if let fieldRawValue = UserDefaults.standard.value(forKey: CurrenciesInteractor.orderField) as? String {
      field = CRCoin.OrderField(rawValue: fieldRawValue)
    }
    
    if let typeRawValue = UserDefaults.standard.value(forKey: CurrenciesInteractor.orderType) as? String {
      type = CRCoin.OrderType(rawValue: typeRawValue)
    }
    
    return(field, type)
  }
}
