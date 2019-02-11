//
//  CurrenciesViewController.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/17/18.
//  Copyright (c) 2018 makeuseof. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol OnPickFavoriteDelegate: class {
  func onPickedFavorite()
}

protocol CurrenciesDisplayLogic: class {
  func displaySomething(viewModel: Currencies.FetchCoins.ViewModel)
  func displayNext(viewModel: Currencies.LoadNext.ViewModel)
  func displayLoadAll()
}

class CurrenciesViewController: UIViewController, CurrenciesDisplayLogic {
  enum Version {
    case list
    case favorite
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  weak var sideMenuDelegate: SideMenuDelegate?
  
  var interactor: CurrenciesBusinessLogic?
  var router: (NSObjectProtocol & CurrenciesRoutingLogic & CurrenciesDataPassing)?
  
  weak var favoritePickerDelegate: OnPickFavoriteDelegate?
  private let version: Version
  private var currencies: [CRCoin]?
  private var loadingNext = false
  private var loadAll = false
  
  private lazy var backButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(named: "left_arrow"), for: .normal)
    button.contentHorizontalAlignment = .fill
    button.contentVerticalAlignment = .fill
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
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    switch version {
    case .list:
      titleLabel.text = "Currencies"
    case .favorite:
      titleLabel.text = "Pick favorite"
    }
    
    titleLabel.textColor = .white
    titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
    return titleLabel
  }()
  
  private lazy var navigationView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var headerForCurrenciesList: UIView = {
    let headerView = UIView()
    headerView.translatesAutoresizingMaskIntoConstraints = false
    
    let firstColumn = columnTitle(text: "Name")
    let secondColumn = columnTitle(text: "Market Cap")
    let thirdColumn = columnTitle(text: "Volume (24h)")
    let forthColumn = columnTitle(text: "Price (24h)")
    
    let stackView = UIStackView(arrangedSubviews: [firstColumn, secondColumn, thirdColumn, forthColumn])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    
    headerView.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
      stackView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
      ])
    
    return headerView
  }()
  
  private lazy var refreshControl: UIRefreshControl = {
    let refresh = UIRefreshControl()
    refresh.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
    return refresh
  }()
  
  private lazy var currenciesList: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
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
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }

  // MARK: Routing

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  private func openDetails(_ index: Int) {
    guard let curr = currencies?[index] else {
      return
    }
    
    router?.openDetails(currencyID: curr.id)
  }
  
  private func onPickFavorite(_ index: Int) {
    guard let coin = currencies?[index] else {
      return
    }
    
    interactor?.setFavorite(id: coin.id, isFavorite: true)
    favoritePickerDelegate?.onPickedFavorite()
    self.navigationController?.popViewController(animated: true)
  }

  // MARK: View lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    setupViews()
    setupConstraints()
    doSomething()
  }
  
  private func setupViews() {
    let factory = WidgetFactory()
    factory.setGradientTo(view: view)
    
    switch version {
    case .list:
      navigationView.addSubview(menuBtn)
    case .favorite:
      navigationView.addSubview(backButton)
    }
    navigationView.addSubview(titleLbl)
    view.addSubview(navigationView)
    view.addSubview(headerForCurrenciesList)
    view.addSubview(currenciesList)
  }
  
  private func setupConstraints() {
    
    let navigationViewC = [
      navigationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      navigationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      navigationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      navigationView.heightAnchor.constraint(equalToConstant: 100)
    ]
    
    let headerForCurrenciesListC = [
      headerForCurrenciesList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      headerForCurrenciesList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      headerForCurrenciesList.topAnchor.constraint(equalTo: navigationView.bottomAnchor),
      headerForCurrenciesList.heightAnchor.constraint(equalToConstant: 50)
    ]
    
    let currenciesListC = [
      currenciesList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      currenciesList.topAnchor.constraint(equalTo: headerForCurrenciesList.bottomAnchor),
      currenciesList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      currenciesList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
    ]
    
    NSLayoutConstraint.activate(navigationViewC + headerForCurrenciesListC + currenciesListC)
    
    switch version {
    case .list:
      NSLayoutConstraint.activate([
        menuBtn.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor),
        menuBtn.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor),
        menuBtn.widthAnchor.constraint(equalToConstant: 25),
        menuBtn.heightAnchor.constraint(equalToConstant: 25),
        titleLbl.leadingAnchor.constraint(equalTo: menuBtn.trailingAnchor, constant: 16),
        titleLbl.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor)
      ])
    case .favorite:
      NSLayoutConstraint.activate([
        backButton.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor),
        backButton.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor),
        backButton.widthAnchor.constraint(equalToConstant: 25),
        backButton.heightAnchor.constraint(equalToConstant: 25),
        titleLbl.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 16),
        titleLbl.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor)
      ])
    }
  }

  // MARK: Do something

  func doSomething() {
    let request = Currencies.FetchCoins.Request(limit: 50)
    interactor?.doSomething(request: request)
  }

  func displaySomething(viewModel: Currencies.FetchCoins.ViewModel) {
    refreshControl.endRefreshing()
    currencies = viewModel.currencies
    currenciesList.reloadData()
  }
  
  func displayNext(viewModel: Currencies.LoadNext.ViewModel) {
    loadingNext = false
    currencies?.append(contentsOf: viewModel.coins)
    currenciesList.reloadData()
  }
  
  func displayLoadAll() {
    loadAll = true
  }
  
  private func columnTitle(text: String) -> UILabel {
    let label = UILabel()
    label.text = text
    label.textAlignment = .center
    label.textColor = UIColor.white.withAlphaComponent(0.7)
    label.font = UIFont.systemFont(ofSize: 11)
    return label
  }
  
  private func loadNext() {
    interactor?.loadNext()
  }
  
  @objc private func menuClicked() {
    sideMenuDelegate?.openMenu()
  }
  
  @objc private func backClicked() {
    navigationController?.popViewController(animated: true)
  }
  
  @objc private func refreshTable() {
    let request = Currencies.FetchCoins.Request(limit: 50)
    interactor?.doSomething(request: request)
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
    
    if indexPath.row + 3 >= currencies!.count - 1 && !loadingNext && !loadAll {
      loadingNext = true
      loadNext()
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

extension CurrenciesViewController: UIGestureRecognizerDelegate {}
