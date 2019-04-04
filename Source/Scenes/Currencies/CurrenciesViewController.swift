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

protocol CurrenciesDisplayLogic: class {
  func displayCoins(viewModel: Currencies.FetchCoins.ViewModel)
  func displayLocalCoins(viewModel: Currencies.LocalCoins.Response)
  func displayError(_ string: String)
  func setSort(_ sortable: Sortable)
}

class CurrenciesViewController: UIViewController, CurrenciesDisplayLogic {
  enum Version: String {
    case list
    case favorite
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
  var interactor: CurrenciesBusinessLogic?
  var router: (NSObjectProtocol & CurrenciesRoutingLogic & CurrenciesDataPassing)?
  weak var sideMenuDelegate: SideMenuDelegate?
  private lazy var nameColumn: UIButton = { return columnTitle(text: "Name") }()
  private lazy var marketCapColumn: UIButton = { return columnTitle(text: "Market Cap") }()
  private lazy var volumeColumn: UIButton = { return columnTitle(text: "Volume (24h)") }()
  private lazy var priceColumn: UIButton = { return columnTitle(text: "Price (24h)") }()
  private lazy var titles: [UIButton] = { return [nameColumn, marketCapColumn, volumeColumn, priceColumn] }()
  weak var favoritePickerDelegate: OnPickFavoriteDelegate?
  private let version: Version
  private var currencies: [CRCoin]?
  private let navigationView = UIView()
  private let navigationLoading = NVActivityIndicatorView(frame: CGRect.zero, type: .circleStrokeSpin, color: .white, padding: nil)
  private let loadingView = NVActivityIndicatorView(frame: CGRect.zero, type: .circleStrokeSpin, color: .white, padding: nil)
  
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
  
  private lazy var headerForCurrenciesList: UIView = {
    let headerView = UIView()
    let stackView = UIStackView(arrangedSubviews: titles)
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    headerView.addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.leading.trailing.centerY.equalToSuperview()
    }
    return headerView
  }()
  
  private lazy var refreshControl: UIRefreshControl = {
    let refresh = UIRefreshControl()
    refresh.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
    return refresh
  }()
  
  private lazy var currenciesList: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .clear
    tableView.register(TVCCrypto.create(), forCellReuseIdentifier: TVCCrypto.reuseID)
    tableView.rowHeight = 60
    tableView.separatorStyle = .none
    tableView.dataSource = self
    tableView.delegate = self
    tableView.refreshControl = refreshControl
    return tableView
  }()
  
  // MARK: Object lifecycle
  
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
  
  // MARK: Setup
  
  private func setup() {
    let viewController = self
    let interactor = CurrenciesInteractor()
    let presenter = CurrenciesPresenter()
    let router = CurrenciesRouter()
    let worker = CoinsWorker()
    let sortWorker = SortingWorker()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    interactor.worker = worker
    interactor.sortingWorker = sortWorker
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
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
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    setupViews()
    interactor?.viewDidLoad(version.rawValue)
    fetchCoins()
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
    view.addSubview(headerForCurrenciesList)
    view.addSubview(currenciesList)
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
    headerForCurrenciesList.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(navigationView.snp.bottom)
      make.height.equalTo(50)
    }
    currenciesList.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(headerForCurrenciesList.snp.bottom)
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
  
  func fetchCoins() {
    errorView.isHidden = true
    loadingView.isHidden = false
    loadingView.startAnimating()
    currenciesList.isHidden = true
    headerForCurrenciesList.isHidden = true
    let request = Currencies.FetchCoins.Request(limit: 50, force: false)
    interactor?.fetchCoins(request: request)
  }
  
  func displayCoins(viewModel: Currencies.FetchCoins.ViewModel) {
    refreshControl.endRefreshing()
    errorView.isHidden = true
    loadingView.stopAnimating()
    loadingView.isHidden = true
    currenciesList.isHidden = false
    headerForCurrenciesList.isHidden = false
    navigationLoading.stopAnimating()
    lastUpdated.text = ""
    currencies = viewModel.currencies
    currenciesList.reloadData()
  }
  
  func displayError(_ string: String) {
    errorView.isHidden = false
    errorView.setText(string)
    loadingView.stopAnimating()
    loadingView.isHidden = true
    currenciesList.isHidden = true
    headerForCurrenciesList.isHidden = true
  }
  
  func displayLocalCoins(viewModel: Currencies.LocalCoins.Response) {
    refreshControl.endRefreshing()
    errorView.isHidden = true
    loadingView.stopAnimating()
    loadingView.isHidden = true
    currenciesList.isHidden = false
    headerForCurrenciesList.isHidden = false
    navigationLoading.startAnimating()
    lastUpdated.text = viewModel.lastUpd
    currencies = viewModel.coins
    currenciesList.reloadData()
  }
  
  func setSort(_ sortable: Sortable) {
    var button: UIButton
    var others: [UIButton]
    switch sortable.field {
    case .name:
      button = nameColumn
      others = titles.filter { $0 != nameColumn }
    case .price:
      button = priceColumn
      others = titles.filter { $0 != priceColumn }
    case .volume:
      button = volumeColumn
      others = titles.filter { $0 != volumeColumn }
    case .marketCap:
      button = marketCapColumn
      others = titles.filter { $0 != marketCapColumn }
    }
    button.tintColor = UIColor(red: 0.23, green: 0.58, blue: 1, alpha: 1)
    button.setTitleColor(UIColor(red: 0.23, green: 0.58, blue: 1, alpha: 1), for: .normal)
    var image: UIImage?
    switch sortable.direction {
    case .asc:
      image = UIImage(named: "triangle_up")?.withRenderingMode(.alwaysTemplate)
    case .desc:
      image = UIImage(named: "triangle_down")?.withRenderingMode(.alwaysTemplate)
    }
    button.setImage(image, for: .normal)
    defaultButton(others)
  }
  
  private func defaultButton(_ buttons: [UIButton]) {
    for button in buttons {
      button.tintColor = UIColor.white.withAlphaComponent(0.7)
      button.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
    }
  }
  
  private func columnTitle(text: String) -> UIButton {
    let button = UIButton()
    button.setTitle(text, for: .normal)
    button.titleLabel?.textAlignment = .center
    button.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
    button.tintColor = UIColor.white.withAlphaComponent(0.7)
    button.titleLabel?.font = Theme.Fonts.sfproTextLight(size: 11)
    button.addTarget(self, action: #selector(sortCoins(_:)), for: .touchUpInside)
    button.setImage(UIImage(named: "triangle_up")?.withRenderingMode(.alwaysTemplate), for: .normal)
    button.semanticContentAttribute = .forceRightToLeft
    button.imageEdgeInsets = UIEdgeInsets(top: 0.5, left: 2.5, bottom: -0.5, right: -2.5)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -2.5, bottom: 0, right: 2.5)
    return button
  }
  
  @objc private func menuClicked() {
    sideMenuDelegate?.openMenu()
  }
  
  @objc private func backClicked() {
    navigationController?.popViewController(animated: true)
  }
  
  @objc private func refreshTable() {
    let request = Currencies.FetchCoins.Request(limit: 50, force: true)
    interactor?.fetchCoins(request: request)
  }
  
  @objc private func sortCoins(_ sender: UIButton) {
    switch sender {
    case nameColumn:
      interactor?.sortName(version.rawValue)
    case marketCapColumn:
      interactor?.sortMarketCap(version.rawValue)
    case volumeColumn:
      interactor?.sortVolume(version.rawValue)
    case priceColumn:
      interactor?.sortPrice(version.rawValue)
    default:
      break
    }
  }
}

extension CurrenciesViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return currencies?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TVCCrypto.reuseID) as? TVCCrypto else {
      return UITableViewCell()
    }
    guard let currency = currencies?[indexPath.row] else {
      fatalError()
    }
    cell.onBind(currency, isTop: indexPath.row == 0)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    switch version {
    case .list:
      openDetails(indexPath.row)
    case .favorite:
      onPickFavorite(indexPath.row)
    }
  }
}

extension CurrenciesViewController: ErrorViewDelegate {
  func onRetry() {
    fetchCoins()
  }
}

extension CurrenciesViewController: UIGestureRecognizerDelegate {}
