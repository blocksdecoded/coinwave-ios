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
  }
  
  private func setup() {
    let postsVC = PostsViewController()
    postsVC.tabBarItem = UITabBarItem(title: "Posts", image: nil, selectedImage: nil)
    
    let viewControllersList = [postsVC]
    viewControllers = viewControllersList
  }
}
