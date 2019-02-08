//
//  MainTabBarController.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/22/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import UIKit
import SideMenu

protocol SideMenuDelegate {
  func openMenu()
}

class MainTabBarController: UITabBarController {
  
  weak var menuVC: VCMenu?

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupTabBar()
    setupSideMenu()
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
  
  private func setupTabBar() {
    tabBar.isTranslucent = false
    tabBar.tintColor = Constants.Colors.currencyUp
    tabBar.barTintColor = UIColor(red: 14.0/255.0, green: 18.0/255.0, blue: 22.0/255.0, alpha: 1.0)
    tabBar.backgroundImage = UIImage(named: "graph_2")
  }
  
  private func setupSideMenu() {
    let rootVC = VCMenu()
    self.menuVC = rootVC
    rootVC.delegate = self
    rootVC.rootNavigationController = navigationController
    
    SideMenuManager.default.menuFadeStatusBar = false
    SideMenuManager.default.menuPresentMode = .menuSlideIn
    let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: rootVC)
    menuLeftNavigationController.setNavigationBarHidden(true, animated: false)
    SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
    SideMenuManager.default.menuWidth = 250
    SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.view)
    
  }
  
  private func setSideDrag() {
    self.navigationController?.interactivePopGestureRecognizer?.delegate = self
  }
}

extension MainTabBarController: MenuDelegate {
  func firstClicked() {
    let favorites = CurrenciesViewController(version: .favorite)
    favorites.favoritePickerDelegate = self
    menuVC?.dismiss(animated: true, completion: nil)
    self.navigationController?.pushViewController(favorites, animated: true)
  }
  
  func secondClicked() {
    selectedIndex = 1
  }
  
  func thirdClicked() {
    //Share

  }
  
  func fourthClicked() {
    //Rate
    
  }
  
  func fifthClicked() {
    //Contact
  }
}

extension MainTabBarController: OnPickFavoriteDelegate {
  func onPickedFavorite() {
    guard let watchVC = viewControllers?[0] as? WatchlistViewController else {
      return
    }
    
    watchVC.loadFavorite()
  }
  
  
}

extension MainTabBarController: UIGestureRecognizerDelegate {}
