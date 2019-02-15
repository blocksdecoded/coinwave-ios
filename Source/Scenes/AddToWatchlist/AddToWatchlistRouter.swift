//
//  AddToWatchlistRouter.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 2/12/19.
//  Copyright (c) 2019 makeuseof. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol AddToWatchlistRoutingLogic {
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol AddToWatchlistDataPassing {
  var dataStore: AddToWatchlistDataStore? { get }
}

class AddToWatchlistRouter: NSObject, AddToWatchlistRoutingLogic, AddToWatchlistDataPassing {
  weak var viewController: AddToWatchlistViewController?
  var dataStore: AddToWatchlistDataStore?
  
  // MARK: Routing
  
  //func routeToSomewhere(segue: UIStoryboardSegue?)
  //{
  //  if let segue = segue {
  //    let destinationVC = segue.destination as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //  } else {
  //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
  //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //    navigateToSomewhere(source: viewController!, destination: destinationVC)
  //  }
  //}

  // MARK: Navigation
  
  //func navigateToSomewhere(source: AddToWatchlistViewController, destination: SomewhereViewController)
  //{
  //  source.show(destination, sender: nil)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: AddToWatchlistDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
