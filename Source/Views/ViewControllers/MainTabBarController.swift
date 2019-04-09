//
//  MainTabBarController.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/22/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import UIKit
import SideMenu

protocol SideMenuDelegate: class {
  func openMenu()
}

class MainTabBarController: UITabBarController {
  
  weak var menuVC: VCMenu?
  private var bgImage: UIImageView?

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupTabBar()
    setupSideMenu()
  }
  
  private func setup() {
    let postsVC = PostsViewController.instance()
    postsVC.sideMenuDelegate = self
    
    let currenciesVC = CoinsViewController.instance(version: .list)
    currenciesVC.sideMenuDelegate = self

    let watchlistVC = WatchlistViewController.instance()
    watchlistVC.sideMenuDelegate = self

    let viewControllersList = [currenciesVC, watchlistVC, postsVC]
    viewControllers = viewControllersList
  }
  
  private func setupTabBar() {
    tabBar.isTranslucent = false
    tabBar.tintColor = Constants.Colors.currencyUp
    tabBar.barTintColor = UIColor(red: 14.0/255.0, green: 18.0/255.0, blue: 22.0/255.0, alpha: 1.0)
    bgImage = UIImageView(image: UIImage(named: "graph_2"))
    let frame = CGRect(x: 0, y: 0, width: tabBar.bounds.width, height: tabBar.bounds.height)
    bgImage?.frame = frame
    tabBar.addSubview(bgImage!)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let frame = CGRect(x: 0,
                       y: view.safeAreaInsets.bottom / 2,
                       width: tabBar.bounds.width,
                       height: tabBar.bounds.height)
    bgImage?.frame = frame
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
    let favorites = CoinsViewController.instance(version: .favorite)
    favorites.favoritePickerDelegate = self
    menuVC?.dismiss(animated: true, completion: nil)
    self.navigationController?.pushViewController(favorites, animated: true)
  }
  
  func secondClicked() {
    let addToWatchlist = AddToWatchlistViewController()
    menuVC?.dismiss(animated: true, completion: nil)
    self.navigationController?.pushViewController(addToWatchlist, animated: true)
  }
  
  func thirdClicked() {
    //Share

  }
  
  func fourthClicked() {
    //Rate
    RatingController.show(root: self)
  }
  
  func fifthClicked() {
    //Contact
  }
}

extension MainTabBarController: OnPickFavoriteDelegate {
  func onPickedFavorite() {
    guard let watchVC = viewControllers?[1] as? WatchlistViewController else {
      return
    }
    
    watchVC.loadFavorite()
  }
}

extension MainTabBarController: SideMenuDelegate {
  func openMenu() {
    present(SideMenuManager.defaultManager.menuLeftNavigationController!, animated: true, completion: nil)
  }
}

extension MainTabBarController: UIGestureRecognizerDelegate {}
