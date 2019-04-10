//
//  DetailsProtocols.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 4/10/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation.NSURL

protocol DetailsDisplayLogic: class {
  var viewModel: DetailsBusinessLogic { get set }
  
  func displayDetails()
  func changeFavorites(coin: CRCoin)
  func openCoinWebsite(site: URL)
  func openNoCoinWebsite()
  func displayError(_ string: String)
}

protocol DetailsBusinessLogic {
  var info: DetailsModel { get set }
  var view: DetailsDisplayLogic? { get set }
  var worker: CoinsWorkerLogic { get set }
  
  func fetchDetails(force: Bool)
  func addToFavorites()
  func onOpenWeb()
}
