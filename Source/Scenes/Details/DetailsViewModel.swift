//
//  DetailsViewModel.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/24/18.
//  Copyright (c) 2018 makeuseof. All rights reserved.
//

import UIKit

class DetailsViewModel: DetailsBusinessLogic {
  
  // MARK: - Properties
  
  var info: DetailsModel
  var view: DetailsDisplayLogic?
  var worker: CoinsWorkerLogic
  var coinSite: URL?
  
  private var coinID: Int
  
  private var coin: CRCoin?
  
  // MARK: - Init
  
  init(coinID: Int, worker: CoinsWorkerLogic) {
    self.worker = worker
    self.coinID = coinID
    self.info = DetailsModel.empty()
  }
  
  // MARK: - Business Logic
  
  func getFavoriteIcon() -> UIImage? {
    guard let coin = coin else {
      return R.image.empty_star()
    }
    
    if coin.isWatchlist {
      return R.image.filled_star()
    } else {
      return R.image.empty_star()
    }
  }
  
  func fetchDetails(force: Bool) {
    worker.fetchCoin(coinID, force: force) { result  in
      switch result {
      case .success(let coin):
        self.coinSite = coin.websiteUrl
        self.info = self.presentCoinDetails(coin: coin)
        self.view?.displayDetails()
      case .failure(let error):
        self.view?.displayError(error.localizedDescription)
      }
    }
  }
  
  func addToFavorites() {
    guard let coin = coin else {
      return
    }
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
                        info: currInfo)
    
  }
}
