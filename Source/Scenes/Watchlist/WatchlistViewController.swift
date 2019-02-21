//
//  WatchlistViewController.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/24/18.
//  Copyright (c) 2018 makeuseof. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol WatchlistDisplayLogic: class {
  func displaySomething(viewModel: Watchlist.Something.ViewModel)
  func displayFavorite(viewModel: Watchlist.Favorite.ViewModel)
  func displayNoFavorite()
  func displayNoWatchlist()
}

class WatchlistViewController: UIViewController, WatchlistDisplayLogic {
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .default
  }
  
  weak var sideMenuDelegate: SideMenuDelegate?
  
  var interactor: WatchlistBusinessLogic?
  var router: (NSObjectProtocol & WatchlistRoutingLogic & WatchlistDataPassing)?
  
  private lazy var topCircle: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "top_circle_white")
    imageView.contentMode = .scaleAspectFit
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
    titleLabel.text = "Watchlist"
    titleLabel.textColor = UIColor(red: 40.0/255.0, green: 51.0/255.0, blue: 59.0/255.0, alpha: 0.7)
    titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
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
  
  private func columnTitle(text: String) -> UILabel {
    let label = UILabel()
    label.text = text
    label.textAlignment = .center
    label.textColor = UIColor.white.withAlphaComponent(0.7)
    label.font = UIFont.systemFont(ofSize: 11)
    return label
  }
  
  private lazy var refreshControl: UIRefreshControl = {
    let refresh = UIRefreshControl()
    refresh.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
    return refresh
  }()
  
  private lazy var watchTable: UITableView = {
    let table = UITableView()
    table.translatesAutoresizingMaskIntoConstraints = false
    table.backgroundColor = .clear
    table.rowHeight = 60
    table.delegate = self
    table.dataSource = self
    table.refreshControl = refreshControl
    table.register(TVCCrypto.create(), forCellReuseIdentifier: TVCCrypto.reuseID)
    table.separatorStyle = .none
    return table
  }()
  
  private var currencies: [CRCoin]?

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
    let interactor = WatchlistInteractor()
    let presenter = WatchlistPresenter()
    let router = WatchlistRouter()
    let worker = CoinsWorker()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    interactor.worker = worker
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: View lifecycle
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let request = Watchlist.Something.Request()
    interactor?.doSomething(request: request)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupConstraints()
    doSomething()
    loadFavorite()
  }
  
  private func setupViews() {
    let factory = WidgetFactory()
    factory.setGradientTo(view: view)
    view.addSubview(topCircle)
    navigationView.addSubview(titleLbl)
    navigationView.addSubview(menuBtn)
    view.addSubview(navigationView)
    view.addSubview(chart)
    view.addSubview(headerForCurrenciesList)
    view.addSubview(watchTable)
  }
  
  private func setupConstraints() {
    let topCircleC = [
      topCircle.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      topCircle.topAnchor.constraint(equalTo: view.topAnchor),
      view.trailingAnchor.constraint(equalTo: topCircle.trailingAnchor)
    ]
    
    let navigationViewC = [
      navigationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      navigationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      navigationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      navigationView.heightAnchor.constraint(equalToConstant: 100)
    ]
    
    let chartC = [
      chart.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: chart.trailingAnchor, constant: 20),
      chart.topAnchor.constraint(equalTo: navigationView.bottomAnchor),
      chart.heightAnchor.constraint(equalToConstant: 200)
    ]
    
    let headerForCurrenciesListC = [
      headerForCurrenciesList.topAnchor.constraint(equalTo: chart.bottomAnchor),
      headerForCurrenciesList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: headerForCurrenciesList.trailingAnchor),
      headerForCurrenciesList.heightAnchor.constraint(equalToConstant: 50)
    ]
    
    let watchTableC = [
      watchTable.topAnchor.constraint(equalTo: headerForCurrenciesList.bottomAnchor),
      watchTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: watchTable.trailingAnchor),
      view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: watchTable.bottomAnchor)
    ]
    
    let menuBtnC = [
      menuBtn.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor),
      menuBtn.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor),
      menuBtn.widthAnchor.constraint(equalToConstant: 25),
      menuBtn.heightAnchor.constraint(equalToConstant: 25)
    ]
    
    let titleLblC = [
      titleLbl.leadingAnchor.constraint(equalTo: menuBtn.trailingAnchor, constant: 16),
      titleLbl.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor)
    ]
    
    NSLayoutConstraint.activate(chartC + navigationViewC + headerForCurrenciesListC + watchTableC + menuBtnC + titleLblC + topCircleC)
  }
  
  // MARK: Do something
  
  private func openDetails(_ index: Int) {
    guard let curr = currencies?[index] else {
      return
    }
    
    router?.openDetails(currencyID: curr.id, currencySymbol: curr.symbol)
  }
  
  //@IBOutlet weak var nameTextField: UITextField!
  
  func doSomething() {
    let request = Watchlist.Something.Request()
    interactor?.doSomething(request: request)
  }
  
  func loadFavorite() {
    interactor?.fetchFavorite()
  }
  
  func displaySomething(viewModel: Watchlist.Something.ViewModel) {
    refreshControl.endRefreshing()
    currencies = viewModel.currencies
    watchTable.reloadData()
  }
  
  func displayFavorite(viewModel: Watchlist.Favorite.ViewModel) {
    chart.load(coinID: viewModel.id, coinSymbol: viewModel.symbol, time: .h24)
  }
  
  func displayNoFavorite() {
    chart.noCoin()
  }
  
  func displayNoWatchlist() {
    //TODO: no watchlist
    refreshControl.endRefreshing()
  }
  
  @objc private func menuClicked() {
    sideMenuDelegate?.openMenu()
  }
  
  @objc private func refreshTable() {
    interactor?.doSomething(request: Watchlist.Something.Request())
    interactor?.fetchFavorite()
  }
}

extension WatchlistViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return currencies?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TVCCrypto.reuseID) as? TVCCrypto else {
      fatalError("\(TVCCrypto.self) not registered")
    }
    
    guard let currency = currencies?[indexPath.row] else {
      fatalError("No currency for \(indexPath.row)")
    }
    
    cell.onBind(currency, isTop: indexPath.row == 0)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    openDetails(indexPath.row)
  }
}

extension WatchlistViewController: CurrencyChartDelegate {
  func onChooseFavorite() {
    let favorites = CurrenciesViewController(version: .favorite)
    favorites.favoritePickerDelegate = self
    self.navigationController?.pushViewController(favorites, animated: true)
  }
}

extension WatchlistViewController: OnPickFavoriteDelegate {
  func onPickedFavorite() {
    interactor?.fetchFavorite()
  }
}
