//
//  MainTabBarController.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/22/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    tabBar.isTranslucent = false
    tabBar.tintColor = Constants.Colors.currencyUp
    tabBar.barTintColor = UIColor(red: 14.0/255.0, green: 18.0/255.0, blue: 22.0/255.0, alpha: 1.0)
    tabBar.backgroundImage = UIImage(named: "graph_2")
  }
  
  private func setup() {
    let postsVC = PostsViewController()
    postsVC.tabBarItem = UITabBarItem(title: "Posts", image: UIImage(named: "earth"), selectedImage: nil)

    let currenciesVC = CurrenciesViewController()
    currenciesVC.tabBarItem = UITabBarItem(title: "Currencies", image: UIImage(named: "list"), selectedImage: nil)

    let watchlistVC = WatchlistViewController()
    watchlistVC.tabBarItem = UITabBarItem(title: "Watchlist", image: UIImage(named: "star"), selectedImage: nil)

    let viewControllersList = [watchlistVC, currenciesVC, postsVC]
    viewControllers = viewControllersList
  }
}
