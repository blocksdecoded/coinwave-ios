//
//  DetailsProtocols.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 4/10/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation.NSURL

protocol DetailsDisplayLogic: class {
  func displayDetails(details: DetailsModel)
  func changeFavorites(coin: CRCoin)
  func openCoinWebsite(site: URL)
  func openNoCoinWebsite()
  func displayError(_ string: String)
}

protocol DetailsBusinessLogic {
  var view: DetailsDisplayLogic? { get set }
  
  func fetchDetails(coinID: Int, force: Bool)
  func addToFavorites(coin: CRCoin)
  func onOpenWeb()
}
