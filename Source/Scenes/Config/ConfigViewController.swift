//
//  ConfigViewController.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 3/13/19.
//  Copyright (c) 2019 makeuseof. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ConfigDisplayLogic: class {
  func displayMainScreen()
  func displayError(_ error: String)
}

class ConfigViewController: UIViewController, ConfigDisplayLogic {
  var interactor: ConfigBusinessLogic?
  var router: (NSObjectProtocol & ConfigRoutingLogic & ConfigDataPassing)?
  
  private lazy var logo: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "AppIconDebug")
    return imageView
  }()

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup() {
    let viewController = self
    let interactor = ConfigInteractor()
    let presenter = ConfigPresenter()
    let router = ConfigRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupConstraints()
    interactor?.viewDidLoad()
  }
  
  // MARK: Do something
  
  func setupViews() {
    view.addSubview(logo)
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      logo.centerYAnchor.constraint(equalTo: view.centerYAnchor)
      ])
  }
  
  func displayMainScreen() {
    router?.routeToMainScreen(segue: nil)
  }
  
  func displayError(_ error: String) {
    //TODO
  }
}