//
//  WatchlistViewController.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/24/18.
//  Copyright (c) 2018 makeuseof. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SnapKit

class WatchlistViewController: UIViewController, WatchlistDisplayLogic {
  static func instance() -> WatchlistViewController {
    let worker = CoinsWorker()
    let viewModel = WatchlistViewModel(worker: worker)
    let view = WatchlistViewController(viewModel: viewModel)
    viewModel.view = view
    return view
  }
  
  // MARK: - Properties
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .default
  }
  
  var viewModel: WatchlistBusinessLogic
  weak var sideMenuDelegate: SideMenuDelegate?
  
  private var isEmptyWatchlist = false
  
  // MARK: - Views
  
  private lazy var loadingView: NVActivityIndicatorView = {
    let view = NVActivityIndicatorView(frame: CGRect.zero, type: .circleStrokeSpin, color: .white, padding: nil)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var errorView: ErrorView = {
    let errorView = ErrorView(frame: CGRect.zero)
    errorView.delegate = self
    errorView.translatesAutoresizingMaskIntoConstraints = false
    return errorView
  }()
  
  private lazy var topCircle: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = R.image.top_circle_white()
    imageView.contentMode = .scaleToFill
    return imageView
  }()
  
  private lazy var navigationView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var titleLbl: UILabel = {
    let titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.text = R.string.localizable.watchlist_title()
    titleLabel.textColor = R.color.watchlist_title()
    titleLabel.font = R.font.sfProTextRegular(size: 24)
    return titleLabel
  }()
  
  private lazy var menuBtn: BDHamburger = {
    let button = BDHamburger.instance()
    button.addTarget(self, action: #selector(menuClicked), for: .touchUpInside)
    return button
  }()
  
  private lazy var chart: CurrencyChart = {
    let chart = CurrencyChart(version: .favorite)
    chart.translatesAutoresizingMaskIntoConstraints = false
    chart.delegate = self
    return chart
  }()
  
  private lazy var coinsListView: CoinsListView = {
    return CoinsListView.instance(screenName: "\(WatchlistViewController.self)", onRefresh: { sortable, force in
      self.viewModel.fetchCoins(sortable: sortable, force: force)
      self.viewModel.fetchFavorite(force: force)
    }, numberOfCoins: { () -> Int in
      return self.viewModel.coins.count
    }, coinForRow: { (index) -> CRCoin in
      return self.viewModel.coins[index]
    }, selectCoinAt: { (index) in
      self.openDetails(index)
    })
  }()

  // MARK: - Init
  
  init(viewModel: WatchlistBusinessLogic) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    setupTabBar()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Lifecycle
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    doSomething()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupConstraints()
    coinsListView.viewDidLoad()
    doSomething()
    loadFavorite()
  }
  
  // MARK: - Setup
  
  private func setupTabBar() {
    tabBarItem = UITabBarItem(title: R.string.localizable.watchlist_title(), image: R.image.star(), selectedImage: nil)
  }
  
  private func setupViews() {
    let factory = WidgetFactory()
    factory.setGradientTo(view: view)
    view.addSubview(topCircle)
    navigationView.addSubview(titleLbl)
    navigationView.addSubview(menuBtn)
    view.addSubview(navigationView)
    view.addSubview(chart)
    view.addSubview(coinsListView)
    view.addSubview(loadingView)
    view.addSubview(errorView)
  }
  
  private func setupConstraints() {
    topCircle.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.height.equalTo(250)
    }
    
    navigationView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.height.equalTo(100)
    }
    
    chart.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.top.equalTo(navigationView.snp.bottom)
      make.height.equalTo(200)
    }
    
    coinsListView.snp.makeConstraints { make in
      make.top.equalTo(chart.snp.bottom)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }
    
    menuBtn.snp.makeConstraints { make in
      make.leading.centerY.equalToSuperview()
      make.width.height.equalTo(25)
    }
    
    titleLbl.snp.makeConstraints { make in
      make.leading.equalTo(menuBtn.snp.trailing).offset(16)
      make.centerY.equalToSuperview()
    }
    
    errorView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(-104)
    }
    
    loadingView.snp.makeConstraints { make in
      make.center.equalTo(coinsListView.snp.center)
      make.width.height.equalTo(50)
    }
  }
  
  // MARK: - Routing
  
  private func openDetails(_ index: Int) {
    let curr = viewModel.coins[index]
    let detailsVC = DetailsViewController.instance(coinID: curr.identifier, symbol: curr.symbol)
    navigationController?.pushViewController(detailsVC, animated: true)
  }
  
  // MARK: - Display Logic
  
  func displayCoins() {
    errorView.isHidden = true
    loadingView.stopAnimating()
    loadingView.isHidden = true
    coinsListView.stopRefresh()
    coinsListView.isHidden = false
    coinsListView.reloadData()
  }
  
  func displayFavorite(viewModel: Watchlist.Favorite.ViewModel) {
    chart.load(coinID: viewModel.identifier, coinSymbol: viewModel.symbol, time: .hour24)
  }
  
  func displayNoFavorite() {
    chart.noCoin()
  }
  
  func displayNoWatchlist(_ string: String) {
    isEmptyWatchlist = true
    coinsListView.stopRefresh()
    errorView.isHidden = false
    errorView.setText(string, hideWarning: true, buttonText: R.string.localizable.add_coin())
    loadingView.stopAnimating()
    loadingView.isHidden = true
    coinsListView.isHidden = true
  }
  
  func displayError(_ string: String) {
    errorView.isHidden = false
    errorView.setText(string, hideWarning: true)
    loadingView.stopAnimating()
    loadingView.isHidden = true
    coinsListView.isHidden = true
    chart.showError()
  }
  
  func setSort(_ sortable: Sortable) {
    coinsListView.setSort(sortable: sortable)
  }
  
  // MARK: - Handlers
  
  func doSomething() {
    errorView.isHidden = true
    loadingView.isHidden = false
    loadingView.startAnimating()
    coinsListView.isHidden = true
    viewModel.fetchCoins(sortable: coinsListView.viewModel.sortable, force: false)
  }
  
  func loadFavorite() {
    viewModel.fetchFavorite(force: false)
  }
  
  @objc private func menuClicked() {
    sideMenuDelegate?.openMenu()
  }
}

extension WatchlistViewController: CurrencyChartDelegate {
  func onChooseFavorite() {
    let favorites = CoinsViewController.instance(version: .favorite)
    favorites.favoritePickerDelegate = self
    self.navigationController?.pushViewController(favorites, animated: true)
  }
}

extension WatchlistViewController: OnPickFavoriteDelegate {
  func onPickedFavorite() {
    viewModel.fetchFavorite(force: false)
  }
}

extension WatchlistViewController: ErrorViewDelegate {
  func onRetry() {
    if isEmptyWatchlist {
      isEmptyWatchlist = false
      let addToWatchlist = AddToWatchlistViewController()
      self.navigationController?.pushViewController(addToWatchlist, animated: true)
    } else {
      viewModel.fetchCoins(sortable: coinsListView.viewModel.sortable, force: true)
      viewModel.fetchFavorite(force: true)
    }
  }
}
