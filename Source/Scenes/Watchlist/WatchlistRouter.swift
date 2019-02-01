//
//  WatchlistRouter.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/24/18.
//  Copyright (c) 2018 makeuseof. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol WatchlistRoutingLogic {
  //func routeToSomewhere(segue: UIStoryboardSegue?)
  func openDetails(currencyID: Int)
}

protocol WatchlistDataPassing {
  var dataStore: WatchlistDataStore? { get }
}

class WatchlistRouter: NSObject, WatchlistRoutingLogic, WatchlistDataPassing {
  weak var viewController: WatchlistViewController?
  var dataStore: WatchlistDataStore?
  
  // MARK: Routing
  
  func openDetails(currencyID: Int) {
    let detailsVC = CurrencyDetailsViewController(currencyID: currencyID)
    viewController?.navigationController?.pushViewController(detailsVC, animated: true)
  }
  
  //func routeToSomewhere(segue: UIStoryboardSegue?)
  //{
  //  if let segue = segue {
  //    let destinationVC = segue.destination as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //  } else {
  //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
  //    let destinationVC = storyboard.instantiateViewController
//  (withIdentifier: "SomewhereViewController") as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //    navigateToSomewhere(source: viewController!, destination: destinationVC)
  //  }
  //}

  // MARK: Navigation
  
  //func navigateToSomewhere(source: WatchlistViewController, destination: SomewhereViewController)
  //{
  //  source.show(destination, sender: nil)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: WatchlistDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}