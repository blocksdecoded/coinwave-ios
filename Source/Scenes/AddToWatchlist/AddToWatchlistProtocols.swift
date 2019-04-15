//
//  AddToWatchlistProtocols.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 4/13/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

protocol AddToWatchlistDisplayLogic: class {
  var viewModel: AddToWatchlistBusinessLogic { get set }
  
  func displayCoins()
  func refreshCoin(indexPaths: [IndexPath])
  func displayError(_ string: String)
}

protocol AddToWatchlistBusinessLogic {
  var coins: [CRCoin] { get set }
  var view: AddToWatchlistDisplayLogic? { get set }
  var worker: CoinsWorkerLogic { get set }
  
  func viewDidLoad()
  func fetchCoins(sortable: Sortable, force: Bool)
  func addToWatchlist(indexPath: IndexPath)
}
