//
//  ChartViewModel.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 4/11/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation
import Charts

class ChartViewModel: ChartBusinessLogic {
  
  // MARK: - Properties
  
  weak var view: ChartDisplayLogic?
  var coinsWorker: CoinsWorkerLogic
  var chartWorker: ChartWorkerLogic
  private var coinID: Int?
  private var symbol: String?
  
  // MARK: - Init
  
  init(coinID: Int?, symbol: String?, coinsWorker: CoinsWorkerLogic, chartWorker: ChartWorkerLogic) {
    self.coinID = coinID
    self.symbol = symbol
    self.coinsWorker = coinsWorker
    self.chartWorker = chartWorker
  }
  
  // MARK: - Business Logic
  
  func set(coinID: Int, symbol: String) {
    self.coinID = coinID
    self.symbol = symbol
  }
  
  func load(time: CRTimeframe) {
    guard let coinID = coinID, let symbol = symbol else {
      view?.displayError()
      return
    }
    
    coinsWorker.fetchCoin(coinID, force: false) { result in
      switch result {
      case .success(let coin):
        self.view?.displayData(name: coin.name, price: self.priceToString(coin.price), color: self.priceColor(coin.change))
      case .failure:
        self.view?.displayError()
      }
    }
    
    chartWorker.getHistory(coinID: coinID, symbol: symbol, time: time) { result in
      switch result {
      case .success(let history):
        self.view?.displayHistory(history: self.toChartData(history))
      case .failure:
        self.view?.displayError()
      }
    }
  }
  
  // MARK: - Handlers
  
  private func priceToString(_ price: Price?) -> String {
    return price?.long ?? R.string.localizable.null()
  }
  
  private func priceColor(_ change: Double?) -> UIColor {
    guard let change = change else {
      return R.color.coin_default()!
    }
    return change < 0 ? R.color.coin_down()! : R.color.coin_up()!
  }
  
  private func toChartData(_ history: [CRPrice]) -> [ChartDataEntry] {
    return history.map { ChartDataEntry(x: $0.timestamp ?? 0, y: $0.price?.value ?? 0) }
  }
}
