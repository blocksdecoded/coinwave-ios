//
//  ConfigViewController.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 3/13/19.
//  Copyright (c) 2019 makeuseof. All rights reserved.
//

import UIKit
import SnapKit

class ConfigViewController: UIViewController, ConfigDisplayLogic {
  
  static func instance() -> ConfigViewController {
    let worker = ConfigWorker()
    let viewModel = ConfigViewModel(worker: worker)
    let view = ConfigViewController(viewModel: viewModel)
    viewModel.view = view
    return view
  }
  
  // MARK: - Properties
  
  var viewModel: ConfigBusinessLogic
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: - Views
  
  private lazy var logo: UIImageView = {
    let imageView = UIImageView()
    imageView.image = R.image.loading_logo()
    return imageView
  }()
  
  private lazy var errorView: ErrorView = {
    let errorView = ErrorView(frame: CGRect.zero)
    errorView.delegate = self
    return errorView
  }()

  // MARK: Init
  
  init(viewModel: ConfigBusinessLogic) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupConstraints()
    viewModel.fetchConfig()
  }
  
  // MARK: Setup
  
  func setupViews() {
    let factory = WidgetFactory()
    factory.setGradientTo(view: view)
    view.addSubview(logo)
    view.addSubview(errorView)
    errorView.isHidden = true
  }
  
  func setupConstraints() {
    logo.snp.makeConstraints { make in
      make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
      make.centerY.equalTo(view.safeAreaLayoutGuide.snp.centerY)
    }
    errorView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }
  
  // MARK: - Display Logic
  
  func displayMainScreen() {
    let mainTabBar = MainTabBarController()
    navigationController?.setViewControllers([mainTabBar], animated: true)
  }
  
  func displayError(_ error: String) {
    logo.isHidden = true
    errorView.isHidden = false
    errorView.setText(error)
  }
}

extension ConfigViewController: ErrorViewDelegate {
  func onRetry() {
    logo.isHidden = false
    errorView.isHidden = true
    viewModel.fetchConfig()
  }
}
