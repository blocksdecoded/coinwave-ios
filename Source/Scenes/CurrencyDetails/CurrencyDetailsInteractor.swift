//
//  CurrencyDetailsInteractor.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/24/18.
//  Copyright (c) 2018 makeuseof. All rights reserved.
//

import UIKit

class CurrencyDetailsInteractor: DetailsBusinessLogic {
  
  // MARK: - Properties
  
  var view: DetailsDisplayLogic?
  var worker: CoinsWorkerLogic
  var coinSite: URL?
  
  // MARK: - Init
  
  init(worker: CoinsWorkerLogic) {
    self.worker = worker
  }
  
  // MARK: - Business Logic
  
  func fetchDetails(coinID: Int, force: Bool) {
    worker.fetchCoin(coinID, force: force) { result  in
      switch result {
      case .success(let coin):
        self.coinSite = coin.websiteUrl
        self.view?.displayDetails(details: self.presentCoinDetails(coin: coin))
      case .failure(let error):
        self.view?.displayError(error.localizedDescription)
      }
    }
  }
  
  func addToFavorites(coin: CRCoin) {
    var mutCoin = coin
    mutCoin.isWatchlist = !coin.isWatchlist
    let result = worker.update(mutCoin)
    switch result {
    case .success:
      self.view?.changeFavorites(coin: mutCoin)
    case .failure:
      //TODO: Handle DSError
      self.view?.displayError(CWError.noData.localizedDescription)
    }
  }
  
  func onOpenWeb() {
    guard let url = coinSite else {
      view?.openNoCoinWebsite()
      return
    }
    view?.openCoinWebsite(site: url)
  }
  
  private func presentCoinDetails(coin: CRCoin) -> DetailsModel {
    let currInfo = [DetailsModel.Info(name: "Price:",
                                 value: coin.price?.long,
                                 valueColor: nil),
                    DetailsModel.Info(name: "% Change:",
                                 value: coin.changeStr,
                                 valueColor: coin.changeColor),
                    DetailsModel.Info(name: "Market Cap:",
                                 value: coin.marketCap?.long,
                                 valueColor: nil),
                    DetailsModel.Info(name: "Volume 24h:",
                                 value: coin.volume?.long,
                                 valueColor: nil),
                    DetailsModel.Info(name: "Available supply:",
                                 value: coin.circulatingSupply?.long,
                                 valueColor: nil),
                    DetailsModel.Info(name: "Total supply:",
                                 value: coin.totalSupply?.long,
                                 valueColor: nil)]
    
    return DetailsModel(iconType: coin.iconType,
                        iconUrl: coin.iconUrl,
                        title: "\(coin.name) \(coin.symbol)",
                        saveCurrency: coin,
                        info: currInfo)
    
  }
}
