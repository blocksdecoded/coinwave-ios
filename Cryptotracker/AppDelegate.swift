//
//  AppDelegate.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/17/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    let rootNavigationController = UINavigationController(rootViewController: MainTabBarController())
    rootNavigationController.setNavigationBarHidden(true, animated: false)
    window?.rootViewController = rootNavigationController
    window?.makeKeyAndVisible()
    return true
  }
}
