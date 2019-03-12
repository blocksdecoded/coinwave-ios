//
//  CurrencyDetailsViewController.swift
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
import SafariServices
import SVGKit
import Kingfisher

protocol CurrencyDetailsDisplayLogic: class {
  func displaySomething(viewModel: CurrencyDetails.Something.ViewModel)
  func changeFavorites(viewModel: CurrencyDetails.AddFavorite.ViewModel)
  func openCoinWebsite(site: String)
  func openNoCoinWebsite()
  func displayError(_ string: String)
}

class CurrencyDetailsViewController: UIViewController, CurrencyDetailsDisplayLogic {
  private let currencyID: Int
  private let currencySymbol: String
  var interactor: CurrencyDetailsBusinessLogic?
  var router: (NSObjectProtocol & CurrencyDetailsRoutingLogic & CurrencyDetailsDataPassing)?
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  private let todayBtnTag = 100001
  private let weekBtnTag = 100002
  private let monthBtnTag = 100003
  private let yearBtnTag = 100004
  private let year5BtnTag = 100005
  
  private var tmpButton: UIButton?
  
  private lazy var topCircle: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "top_circle_black")
    imageView.contentMode = .scaleToFill
    return imageView
  }()
  
  private lazy var backButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(named: "left_arrow"), for: .normal)
    button.addTarget(self, action: #selector(backClicked), for: .touchUpInside)
    button.contentHorizontalAlignment = .fill
    button.contentVerticalAlignment = .fill
    return button
  }()
  
  private lazy var coinIcon: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private lazy var vectorCoinIcon: SVGKFastImageView = {
    let imageView = SVGKFastImageView(svgkImage: SVGKImage())!
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private lazy var titleLbl: UILabel = {
    let titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.text = title
    titleLabel.textColor = .white
    titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = 1
    titleLabel.adjustsFontSizeToFitWidth = true
    titleLabel.minimumScaleFactor = 0.5
    return titleLabel
  }()
  
  private lazy var navigationView: UIView = {
    let navView = UIView()
    navView.translatesAutoresizingMaskIntoConstraints = false
    return navView
  }()
  
  private lazy var chart: CurrencyChart = {
    let chart = CurrencyChart(version: .details)
    chart.translatesAutoresizingMaskIntoConstraints = false
    return chart
  }()
  
  private lazy var periodStack: UIStackView = {
    let todayBtn = getButton(title: "Today", tag: todayBtnTag, isSelected: true)
    tmpButton = todayBtn
    let stack = UIStackView(arrangedSubviews: [todayBtn,
                                   getButton(title: "Week", tag: weekBtnTag, isSelected: false),
                                   getButton(title: "Month", tag: monthBtnTag, isSelected: false),
                                   getButton(title: "Year", tag: yearBtnTag, isSelected: false),
                                   getButton(title: "All", tag: year5BtnTag, isSelected: false)])
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .horizontal
    stack.distribution = .equalSpacing
    return stack
  }()
  
  func getButton(title: String, tag: Int, isSelected: Bool) -> UIButton {
    let button = UIButton()
    button.setTitle(title, for: .normal)
    button.tag = tag
    button.setTitleColor(UIColor(red: 29.0/255.0, green: 233.0/255.0, blue: 182.0/255.0, alpha: 1.0), for: .selected)
    button.setTitleColor(UIColor(red: 170.0/255.0, green: 174.0/255.0, blue: 179.0/255.0, alpha: 1.0), for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    button.isSelected = isSelected
    button.addTarget(self, action: #selector(changePeriod(sender:)), for: .touchUpInside)
    return button
  }
  
  private lazy var refreshControl: UIRefreshControl = {
    let refresh = UIRefreshControl()
    refresh.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
    return refresh
  }()
  
  private lazy var infoTable: UITableView = {
    let table = UITableView()
    table.translatesAutoresizingMaskIntoConstraints = false
    table.backgroundColor = .clear
    table.dataSource = self
    table.delegate = self
    table.separatorStyle = .none
    table.refreshControl = refreshControl
    table.register(CurrencyDetailsCell.self, forCellReuseIdentifier: CurrencyDetailsCell.reuseID)
    table.register(CurrencyDetailsBottomCell.self, forCellReuseIdentifier: CurrencyDetailsBottomCell.reuseID)
    return table
  }()
  
  private lazy var favoriteBtn: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(addFavorite), for: .touchUpInside)
    button.contentHorizontalAlignment = .fill
    button.contentVerticalAlignment = .fill
    return button
  }()
  
  private var info: [CurrencyDetails.Something.ViewModel.Info]?
  private var saveCurrency: CRCoin?

  // MARK: Object lifecycle
  
  init(currencyID: Int, currencySymbol: String) {
    self.currencyID = currencyID
    self.currencySymbol = currencySymbol
    super.init(nibName: nil, bundle: nil)
    setup()
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    currencyID = -1
    currencySymbol = ""
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    currencyID = -1
    currencySymbol = ""
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup() {
    let viewController = self
    let interactor = CurrencyDetailsInteractor()
    let presenter = CurrencyDetailsPresenter()
    let router = CurrencyDetailsRouter()
    let worker = CoinsWorker()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    interactor.worker = worker
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
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    setupViews()
    setupConstraints()
    doSomething(currID: currencyID)
    chart.load(coinID: currencyID, coinSymbol: currencySymbol, time: .h24)
  }
  
  private func setupViews() {
    view.backgroundColor = .white
    view.addSubview(topCircle)
    navigationView.addSubview(backButton)
    navigationView.addSubview(coinIcon)
    navigationView.addSubview(vectorCoinIcon)
    navigationView.addSubview(titleLbl)
    navigationView.addSubview(favoriteBtn)
    view.addSubview(navigationView)
    view.addSubview(periodStack)
    view.addSubview(infoTable)
    view.addSubview(chart)
  }
  
  private func setupConstraints() {
    let topCircleC = [
      topCircle.topAnchor.constraint(equalTo: view.topAnchor),
      topCircle.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: topCircle.trailingAnchor),
      topCircle.heightAnchor.constraint(equalToConstant: 250)
    ]
    
    let chartC = [
      chart.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: chart.trailingAnchor, constant: 20),
      chart.topAnchor.constraint(equalTo: navigationView.bottomAnchor),
      chart.heightAnchor.constraint(equalToConstant: 200)
    ]
    
    let periodC = [
      periodStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      view.trailingAnchor.constraint(equalTo: periodStack.trailingAnchor, constant: 20),
      periodStack.topAnchor.constraint(equalTo: chart.bottomAnchor),
      periodStack.heightAnchor.constraint(equalToConstant: 50)
    ]
    
    let infoTableC = [
      infoTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      infoTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      infoTable.topAnchor.constraint(equalTo: periodStack.bottomAnchor),
      infoTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ]
    
    let navigationC = [
      navigationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      navigationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      navigationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      navigationView.heightAnchor.constraint(equalToConstant: 100)
    ]
    
    let coinIconC = [
      coinIcon.widthAnchor.constraint(equalToConstant: 20),
      coinIcon.heightAnchor.constraint(equalToConstant: 20),
      coinIcon.centerYAnchor.constraint(equalTo: titleLbl.centerYAnchor),
      titleLbl.leadingAnchor.constraint(equalTo: coinIcon.trailingAnchor, constant: 8)
    ]
    
    let vectorCoinIconC = [
      vectorCoinIcon.widthAnchor.constraint(equalToConstant: 20),
      vectorCoinIcon.heightAnchor.constraint(equalToConstant: 20),
      vectorCoinIcon.centerYAnchor.constraint(equalTo: titleLbl.centerYAnchor),
      titleLbl.leadingAnchor.constraint(equalTo: vectorCoinIcon.trailingAnchor, constant: 8)
    ]
    
    let titleLblC = [
      favoriteBtn.leadingAnchor.constraint(greaterThanOrEqualTo: titleLbl.trailingAnchor, constant: 8),
      titleLbl.leadingAnchor.constraint(greaterThanOrEqualTo: backButton.trailingAnchor, constant: 8),
      titleLbl.centerXAnchor.constraint(equalTo: navigationView.centerXAnchor, constant: 14),
      titleLbl.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor)
    ]
    
    let favoriteC = [
      navigationView.trailingAnchor.constraint(equalTo: favoriteBtn.trailingAnchor, constant: 20),
      favoriteBtn.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor),
      favoriteBtn.widthAnchor.constraint(equalToConstant: 20),
      favoriteBtn.heightAnchor.constraint(equalToConstant: 20)
    ]
    
    let backButtonC = [
      backButton.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor, constant: 20),
      backButton.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor),
      backButton.widthAnchor.constraint(equalToConstant: 9),
      backButton.heightAnchor.constraint(equalToConstant: 15)
    ]
    
    NSLayoutConstraint.activate(infoTableC +
      periodC +
      coinIconC +
      vectorCoinIconC +
      titleLblC +
      navigationC +
      favoriteC +
      chartC +
      backButtonC +
      topCircleC)
  }
  
  // MARK: Do something
  
  //@IBOutlet weak var nameTextField: UITextField!
  
  func doSomething(currID: Int) {
    let request = CurrencyDetails.Something.Request(currID: currID)
    interactor?.doSomething(request: request)
  }
  
  func displaySomething(viewModel: CurrencyDetails.Something.ViewModel) {
    refreshControl.endRefreshing()
    if viewModel.iconType != nil && viewModel.iconUrl != nil {
      switch viewModel.iconType! {
      case .pixel:
        vectorCoinIcon.isHidden = true
        coinIcon.kf.setImage(with: URL(string: viewModel.iconUrl!))
      case .vector:
        coinIcon.isHidden = true
        vectorCoinIcon.load(viewModel.iconUrl!)
      }
    } else {
      coinIcon.isHidden = true
      vectorCoinIcon.isHidden = true
    }
    
    titleLbl.text = viewModel.title
    saveCurrency = viewModel.saveCurrency
    let isFilledStar = saveCurrency?.isWatchlist ?? false
    favoriteBtn.setImage(UIImage(named: isFilledStar ? "filled_star" : "empty_star"), for: .normal)
    info = viewModel.info
    infoTable.reloadData()
  }
  
  func displayError(_ string: String) {
    //TODO: Display error
  }
  
  func changeFavorites(viewModel: CurrencyDetails.AddFavorite.ViewModel) {
    saveCurrency = viewModel.coin
    let isFilledStar = saveCurrency?.isWatchlist ?? false
    favoriteBtn.setImage(UIImage(named: isFilledStar ? "filled_star" : "empty_star"), for: .normal)
  }
  
  func openCoinWebsite(site: String) {
    if let url = URL(string: site) {
      let webVC = SFSafariViewController(url: url)
      webVC.delegate = self
      present(webVC, animated: true, completion: nil)
    }
  }
  
  func openNoCoinWebsite() {
    let alert = UIAlertController(title: "No website", message: nil, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
      alert.dismiss(animated: true, completion: nil)
    })
    alert.addAction(okAction)
    present(alert, animated: true, completion: nil)
  }
  
  @objc private func addFavorite() {
    let request = CurrencyDetails.AddFavorite.Request(coin: saveCurrency!)
    interactor?.addToFavorites(request: request)
  }
  
  @objc private func changePeriod(sender: UIButton) {
    tmpButton?.isSelected = false
    tmpButton = sender
    tmpButton?.isSelected = true
    var timeframe: CRTimeframe
    switch sender.tag {
    case todayBtnTag:
      timeframe = .h24
    case weekBtnTag:
      timeframe = .d7
    case monthBtnTag:
      timeframe = .d30
    case yearBtnTag:
      timeframe = .y1
    case year5BtnTag:
      timeframe = .y5
    default:
      return
    }
    chart.load(coinID: currencyID, coinSymbol: currencySymbol, time: timeframe)
  }
  
  @objc private func backClicked() {
    navigationController?.popViewController(animated: true)
  }
  
  @objc private func refreshTable() {
    let request = CurrencyDetails.Something.Request(currID: currencyID)
    interactor?.doSomething(request: request)
    chart.load(coinID: currencyID, coinSymbol: currencySymbol, time: .h24)
  }
}

extension CurrencyDetailsViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return info?.count ?? 0
    }
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyDetailsCell.reuseID) as? CurrencyDetailsCell
        else {
        fatalError("\(CurrencyDetailsCell.self) not registered")
      }
      
      guard let info = info?[indexPath.row] else {
        fatalError("No info for \(indexPath.row)")
      }
      
      cell.onBind(info)
      
      return cell
    } else {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyDetailsBottomCell.reuseID) as? CurrencyDetailsBottomCell
        else {
          fatalError("\(CurrencyDetailsBottomCell.self) not registered")
      }
      cell.delegate = self
      return cell
    }
  }
}

extension CurrencyDetailsViewController: CurrencyDetailsBottomCellDelegate {
  func onOpenWebSite() {
    interactor?.onOpenWeb()
  }
}

extension CurrencyDetailsViewController: SFSafariViewControllerDelegate {
  func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    dismiss(animated: true, completion: nil)
  }
}

extension CurrencyDetailsViewController: UIGestureRecognizerDelegate {}
