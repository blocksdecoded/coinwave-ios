//
//  CoinsProtocols.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 4/9/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

protocol CoinsDisplayLogic: class {
  var viewModel: CoinsBusinessLogic { get set }
  
  func displayCoins(isLocal: Bool)
  func displayError(string: String)
}

protocol CoinsBusinessLogic {
  var view: CoinsDisplayLogic? { get set }
  var coins: [CRCoin] { get set }
  var coinsWorker: CoinsWorkerLogic { get set }
  
  func fetchCoins(sortable: Sortable, limit: Int, force: Bool)
  func setFavorite(coin: CRCoin)
}
