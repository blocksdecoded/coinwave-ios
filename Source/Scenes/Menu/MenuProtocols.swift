//
//  MenuProtocols.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 4/15/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

protocol MenuDisplayLogic: class {
  var viewModel: MenuBusinessLogic { get set }
  
  func share(_ string: String)
  func closeMenu()
  func onError(title: String)
}

protocol MenuBusinessLogic {
  var view: MenuDisplayLogic? { get set }
  var delegate: MenuDelegate? { get set }
  var options: [MenuOption] { get set }
  
  func didSelect(row: IndexPath)
}

protocol MenuDelegate: class {
  func pickFavoriteClicked()
  func addToWatchlistClicked()
  func rateUsClicked()
}
