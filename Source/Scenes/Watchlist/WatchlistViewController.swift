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

protocol WatchlistDisplayLogic: class {
  func displaySomething(viewModel: Watchlist.Something.ViewModel)
  func displayFavorite(viewModel: Watchlist.Favorite.ViewModel)
  func displayNoFavorite()
  func displayNoWatchlist(_ string: String)
  func displayError(_ string: String)
  func setSort(_ sortable: Sortable)
}

class WatchlistViewController: UIViewController, WatchlistDisplayLogic {
  
  // MARK: - Properties
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .default
  }
  
  weak var sideMenuDelegate: SideMenuDelegate?
  
  private var isEmptyWatchlist = false
  
  private var screenName: String {
    return "\(WatchlistViewController.self)"
  }
  
  var interactor: WatchlistBusinessLogic?
  var router: (NSObjectProtocol & WatchlistRoutingLogic & WatchlistDataPassing)?
  
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
    titleLabel.text = R.string.localizable.watchlist()
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
    return CoinsListView.instance(screenName: screenName, onRefresh: { sortable, force in
      self.interactor?.fetchCoins(request: Watchlist.Something.Request(sortable: sortable, force: force))
      self.interactor?.fetchFavorite(force: force)
    }, numberOfCoins: { () -> Int in
      return self.currencies?.count ?? 0
    }, coinForRow: { (index) -> CRCoin in
      return self.currencies![index]
    }, selectCoinAt: { (index) in
      self.openDetails(index)
    })
  }()
  
  private var currencies: [CRCoin]?

  // MARK: - Init
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: - Lifecycle
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    doSomething()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print(screenName)
    setupViews()
    setupConstraints()
    doSomething()
    loadFavorite()
    interactor?.viewDidLoad(screenName)
  }
  
  // MARK: - Setup
  
  private func setup() {
    let viewController = self
    let interactor = WatchlistInteractor()
    let presenter = WatchlistPresenter()
    let router = WatchlistRouter()
    let worker = CoinsWorker()
    let sortWorker = SortableWorker()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    interactor.worker = worker
    interactor.sortingWorker = sortWorker
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
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
    guard let curr = currencies?[index] else {
      return
    }
    router?.openDetails(currencyID: curr.identifier, currencySymbol: curr.symbol)
  }
  
  // MARK: - Display Logic
  
  func displaySomething(viewModel: Watchlist.Something.ViewModel) {
    errorView.isHidden = true
    loadingView.stopAnimating()
    loadingView.isHidden = true
    currencies = viewModel.currencies
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
    let sortable = Sortable(field: .name, direction: .asc)
    let request = Watchlist.Something.Request(sortable: sortable, force: false)
    interactor?.fetchCoins(request: request)
  }
  
  func loadFavorite() {
    interactor?.fetchFavorite(force: false)
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
    interactor?.fetchFavorite(force: false)
  }
}

extension WatchlistViewController: ErrorViewDelegate {
  func onRetry() {
    if isEmptyWatchlist {
      isEmptyWatchlist = false
      let addToWatchlist = AddToWatchlistViewController()
      self.navigationController?.pushViewController(addToWatchlist, animated: true)
    } else {
      let sortable = Sortable(field: .name, direction: .asc)
      interactor?.fetchCoins(request: Watchlist.Something.Request(sortable: sortable, force: true))
      interactor?.fetchFavorite(force: true)
    }
  }
}
