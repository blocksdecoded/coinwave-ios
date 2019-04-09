//
//  CurrenciesViewController.swift
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

protocol CurrenciesDisplayLogic: SortableDisplayLogic {
  func displayCoins(viewModel: Currencies.FetchCoins.ViewModel)
  func displayLocalCoins(viewModel: Currencies.LocalCoins.Response)
  func displayError(_ string: String)
}

class CurrenciesViewController: UIViewController, CurrenciesDisplayLogic {
  enum Version: String {
    case list
    case favorite
  }
  
  // MARK: - Properties
  
  var screenName: String {
    return version.rawValue
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
  var interactor: CurrenciesBusinessLogic?
  var router: (NSObjectProtocol & CurrenciesRoutingLogic & CurrenciesDataPassing)?
  weak var sideMenuDelegate: SideMenuDelegate?
  weak var favoritePickerDelegate: OnPickFavoriteDelegate?
  private let version: Version
  private var currencies: [CRCoin]?
  private let navigationView = UIView()
  private let navigationLoading = NVActivityIndicatorView(frame: CGRect.zero, type: .circleStrokeSpin, color: .white, padding: nil)
  private let loadingView = NVActivityIndicatorView(frame: CGRect.zero, type: .circleStrokeSpin, color: .white, padding: nil)
  
  // MARK: - Views
  
  private lazy var coinsListView: CoinsListView = {
    return CoinsListView(onRefresh: {
      let request = Currencies.FetchCoins.Request(limit: 50, force: true)
      self.interactor?.fetchCoins(request: request)
    }, numberOfCoins: { () -> Int in
      return self.currencies?.count ?? 0
    }, coinForRow: { (index) -> CRCoin in
      return self.currencies![index]
    }, selectCoinAt: { (index) in
      switch self.version {
      case .list:
        self.openDetails(index)
      case .favorite:
        self.onPickFavorite(index)
      }
    }, onName: {
      self.interactor?.sortName(self.screenName)
    }, onMarketCap: {
      self.interactor?.sortMarketCap(self.screenName)
    }, onVolume: {
      self.interactor?.sortVolume(self.screenName)
    }, onPrice: {
      self.interactor?.sortPrice(self.screenName)
    })
  }()
  
  private lazy var errorView: ErrorView = {
    let errorView = ErrorView(frame: CGRect.zero)
    errorView.delegate = self
    return errorView
  }()
  
  private lazy var backButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "left_arrow"), for: .normal)
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
      titleLabel.text = "Cryptocurrencies"
    case .favorite:
      titleLabel.text = "Pick favorite"
    }
    titleLabel.textColor = .white
    titleLabel.font = Theme.Fonts.sfproTextRegular(size: 24)
    return titleLabel
  }()
  
  private lazy var lastUpdated: UILabel = {
    let label = UILabel()
    label.font = Theme.Fonts.sfproTextLight(size: 11)
    label.textColor = UIColor.white
    label.numberOfLines = 2
    return label
  }()
  
  // MARK: - Init
  
  init(version: Version) {
    self.version = version
    super.init(nibName: nil, bundle: nil)
    setup()
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    self.version = .list
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    self.version = .list
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: - Setup
  
  private func setup() {
    let viewController = self
    let interactor = CurrenciesInteractor()
    let presenter = CurrenciesPresenter()
    let router = CurrenciesRouter()
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
    guard let curr = currencies?[index] else {
      return
    }
    router?.openDetails(currencyID: curr.identifier, currencySymbol: curr.symbol)
  }
  
  private func onPickFavorite(_ index: Int) {
    guard let coin = currencies?[index] else {
      return
    }
    
    interactor?.setFavorite(coin)
    favoritePickerDelegate?.onPickedFavorite()
    self.navigationController?.popViewController(animated: true)
  }
  
  // MARK: - View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    setupViews()
    interactor?.viewDidLoad(screenName)
    fetchCoins()
  }
  
  // MARK: - Display logic
  
  func displayCoins(viewModel: Currencies.FetchCoins.ViewModel) {
    errorView.isHidden = true
    loadingView.stopAnimating()
    loadingView.isHidden = true
    navigationLoading.stopAnimating()
    lastUpdated.text = ""
    currencies = viewModel.currencies
    coinsListView.isHidden = false
    coinsListView.stopRefresh()
    coinsListView.reloadData()
  }
  
  func displayError(_ string: String) {
    errorView.isHidden = false
    errorView.setText(string)
    loadingView.stopAnimating()
    loadingView.isHidden = true
    coinsListView.isHidden = true
  }
  
  func displayLocalCoins(viewModel: Currencies.LocalCoins.Response) {
    errorView.isHidden = true
    loadingView.stopAnimating()
    loadingView.isHidden = true
    navigationLoading.startAnimating()
    lastUpdated.text = viewModel.lastUpd
    currencies = viewModel.coins
    coinsListView.isHidden = false
    coinsListView.stopRefresh()
    coinsListView.reloadData()
  }
  
  // MARK: - Sortable logic
  
  func setSort(sortable: Sortable) {
    coinsListView.setSort(sortable: sortable)
  }
  
  // MARK: - Handlers
  
  func fetchCoins() {
    errorView.isHidden = true
    loadingView.isHidden = false
    loadingView.startAnimating()
    coinsListView.isHidden = true
    let request = Currencies.FetchCoins.Request(limit: 50, force: false)
    interactor?.fetchCoins(request: request)
  }
  
  @objc private func menuClicked() {
    sideMenuDelegate?.openMenu()
  }
  
  @objc private func backClicked() {
    navigationController?.popViewController(animated: true)
  }
}

extension CurrenciesViewController: ErrorViewDelegate {
  func onRetry() {
    fetchCoins()
  }
}

extension CurrenciesViewController: UIGestureRecognizerDelegate {}
