//
//  AppDelegate.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/17/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    Fabric.with([Crashlytics.self])
    window = UIWindow(frame: UIScreen.main.bounds)
    let rootNavigationController = UINavigationController(rootViewController: ConfigViewController())
    rootNavigationController.setNavigationBarHidden(true, animated: false)
    window?.rootViewController = rootNavigationController
    window?.makeKeyAndVisible()
    return true
  }
}
