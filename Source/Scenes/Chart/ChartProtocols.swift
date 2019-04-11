//
//  ChartProtocols.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 4/11/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Charts

protocol ChartDisplayLogic: class {
  var viewModel: ChartBusinessLogic { get set }
  
  func displayData(name: String, price: String, color: UIColor)
  func displayHistory(history: [ChartDataEntry])
  func displayError()
}

protocol ChartBusinessLogic {
  var view: ChartDisplayLogic? { get set }
  var coinsWorker: CoinsWorkerLogic { get set }
  var chartWorker: ChartWorkerLogic { get set }
  
  func set(coinID: Int, symbol: String)
  func load(time: CRTimeframe)
}

protocol ChartWorkerLogic {
  func getHistory(coinID: Int, symbol: String, time: CRTimeframe, completion: @escaping (Result<[CRPrice], CWError>) -> Void)
}
