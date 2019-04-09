//
//  CoinsViewController.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/17/18.
//  Copyright (c) 2018 makeuseof. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SnapKit

protocol OnPickFavoriteDelegate: class {
  func onPickedFavorite()
}

final class CoinsViewController: UIViewController, CoinsDisplayLogic {
  static func instance(version: CoinsViewController.Version) -> CoinsViewController {
    let coinsWorker = CoinsWorker()
    let viewModel = CoinsViewModel(coinsWorker: coinsWorker)
    let view = CoinsViewController(version: version, viewModel: viewModel)
    viewModel.view = view
    return view
  }
  
  enum Version: String {
    case list
    case favorite
  }
  
  // MARK: - Properties
  
  private let version: Version
  var viewModel: CoinsBusinessLogic
  
  override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
  weak var sideMenuDelegate: SideMenuDelegate?
  weak var favoritePickerDelegate: OnPickFavoriteDelegate?
  
  // MARK: - Views
  
  private let navigationView = UIView()
  
  private lazy var navigationLoading: NVActivityIndicatorView = {
    return NVActivityIndicatorView(frame: CGRect.zero, type: .circleStrokeSpin, color: .white, padding: nil)
  }()
  
  private let loadingView: NVActivityIndicatorView = {
    return NVActivityIndicatorView(frame: CGRect.zero, type: .circleStrokeSpin, color: .white, padding: nil)
  }()
  
  private lazy var coinsListView: CoinsListView = {
    return CoinsListView.instance(screenName: version.rawValue, onRefresh: { sortable, force in
      self.viewModel.fetchCoins(sortable: sortable, limit: 50, force: force)
    }, numberOfCoins: { () -> Int in
      return self.viewModel.coins.count
    }, coinForRow: { (index) -> CRCoin in
      return self.viewModel.coins[index]
    }, selectCoinAt: { (index) in
      switch self.version {
      case .list:
        self.openDetails(index)
      case .favorite:
        self.onPickFavorite(index)
      }
    })
  }()
  
  private lazy var errorView: ErrorView = {
    let errorView = ErrorView(frame: CGRect.zero)
    errorView.delegate = self
    return errorView
  }()
  
  private lazy var backButton: UIButton = {
    let button = UIButton()
    button.setImage(R.image.left_arrow(), for: .normal)
    button.addTarget(self, action: #selector(backClicked), for: .touchUpInside)
    return button
  }()
  
  private lazy var menuBtn: BDHamburger = {
    let button = BDHamburger.instance()
    button.addTarget(self, action: #selector(menuClicked), for: .touchUpInside)
    return button
  }()
  
  private lazy var titleLbl: UILabel = {
    let titleLabel = UILabel()
    switch version {
    case .list:
      titleLabel.text = R.string.localizable.coins_title_list()
    case .favorite:
      titleLabel.text = R.string.localizable.coins_title_favorite()
    }
    titleLabel.textColor = .white
    titleLabel.font = R.font.sfProTextRegular(size: 24)
    return titleLabel
  }()
  
  private lazy var lastUpdated: UILabel = {
    let label = UILabel()
    label.font = R.font.sfProTextLight(size: 11)
    label.textColor = UIColor.white
    label.numberOfLines = 2
    return label
  }()
  
  // MARK: - Init
  
  init(version: Version, viewModel: CoinsBusinessLogic) {
    self.version = version
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    setupTabBar()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  // MARK: - View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    setupViews()
    coinsListView.viewDidLoad()
    fetchCoins()
  }
  
  // MARK: - Setup
  
  private func setupTabBar() {
    tabBarItem = UITabBarItem(title: R.string.localizable.coins_title_list(), image: R.image.list(), selectedImage: nil)
  }
  
  private func setupViews() {
    let factory = WidgetFactory()
    factory.setGradientTo(view: view)
    switch version {
    case .list:
      navigationView.addSubview(menuBtn)
      navigationView.addSubview(navigationLoading)
      navigationView.addSubview(lastUpdated)
    case .favorite:
      navigationView.addSubview(backButton)
    }
    navigationView.addSubview(titleLbl)
    view.addSubview(navigationView)
    view.addSubview(coinsListView)
    view.addSubview(loadingView)
    view.addSubview(errorView)
    setupConstraints()
  }
  
  private func setupConstraints() {
    navigationView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(100)
    }
    coinsListView.snp.makeConstraints { make in
      make.top.equalTo(navigationView.snp.bottom)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }
    errorView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    loadingView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.width.height.equalTo(50)
    }
    switch version {
    case .list:
      menuBtn.snp.makeConstraints { make in
        make.leading.centerY.equalToSuperview()
        make.width.height.equalTo(25)
      }
      titleLbl.snp.makeConstraints { make in
        make.leading.equalTo(menuBtn.snp.trailing).offset(16)
        make.centerY.equalToSuperview()
      }
      navigationLoading.snp.makeConstraints { make in
        make.width.height.equalTo(20)
        make.leading.equalTo(titleLbl.snp.trailing).offset(16)
        make.centerY.equalToSuperview()
      }
      lastUpdated.snp.makeConstraints { make in
        make.trailing.equalToSuperview().offset(-16)
        make.leading.equalTo(navigationLoading.snp.trailing).offset(16)
        make.centerY.equalToSuperview()
      }
    case .favorite:
      backButton.snp.makeConstraints { make in
        make.leading.centerY.equalToSuperview()
        make.size.equalTo(CGSize(width: 40, height: 40))
      }
      titleLbl.snp.makeConstraints { make in
        make.leading.equalTo(backButton.snp.trailing).offset(16)
        make.centerY.equalToSuperview()
      }
    }
  }
  
  // MARK: Routing
  
  private func openDetails(_ index: Int) {
    let curr = viewModel.coins[index]
    let detailsVC = CurrencyDetailsViewController(currencyID: curr.identifier, currencySymbol: curr.symbol)
    navigationController?.pushViewController(detailsVC, animated: true)
  }
  
  private func onPickFavorite(_ index: Int) {
    viewModel.setFavorite(index: index)
    favoritePickerDelegate?.onPickedFavorite()
    self.navigationController?.popViewController(animated: true)
  }
  
  // MARK: - Display logic
  
  func displayCoins(isLocal: Bool) {
    errorView.isHidden = true
    loadingView.stopAnimating()
    loadingView.isHidden = true
    if isLocal {
      navigationLoading.startAnimating()
    } else {
      navigationLoading.stopAnimating()
    }
    lastUpdated.text = ""
    coinsListView.isHidden = false
    coinsListView.stopRefresh()
    coinsListView.reloadData()
  }
  
  func displayError(string: String) {
    errorView.isHidden = false
    errorView.setText(string)
    loadingView.stopAnimating()
    loadingView.isHidden = true
    coinsListView.isHidden = true
  }
  
  // MARK: - Handlers
  
  func fetchCoins() {
    errorView.isHidden = true
    loadingView.isHidden = false
    loadingView.startAnimating()
    coinsListView.isHidden = true
    viewModel.fetchCoins(sortable: coinsListView.viewModel.sortable, limit: 50, force: false)
  }
  
  @objc private func menuClicked() {
    sideMenuDelegate?.openMenu()
  }
  
  @objc private func backClicked() {
    navigationController?.popViewController(animated: true)
  }
}

extension CoinsViewController: ErrorViewDelegate {
  func onRetry() {
    fetchCoins()
  }
}

extension CoinsViewController: UIGestureRecognizerDelegate {}
