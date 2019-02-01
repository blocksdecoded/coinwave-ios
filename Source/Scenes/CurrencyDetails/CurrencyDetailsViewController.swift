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

protocol CurrencyDetailsDisplayLogic: class {
  func displaySomething(viewModel: CurrencyDetails.Something.ViewModel)
  func changeFavorites(viewModel: CurrencyDetails.AddFavorite.ViewModel)
}

class CurrencyDetailsViewController: UIViewController, CurrencyDetailsDisplayLogic {
  private let currencyID: Int
  var interactor: CurrencyDetailsBusinessLogic?
  var router: (NSObjectProtocol & CurrencyDetailsRoutingLogic & CurrencyDetailsDataPassing)?
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  private lazy var titleLbl: UILabel = {
    let titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.text = title
    titleLabel.textColor = .white
    titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
    titleLabel.textAlignment = .center
    return titleLabel
  }()
  
  private lazy var navigationView: UIView = {
    let navView = UIView()
    navView.translatesAutoresizingMaskIntoConstraints = false
    return navView
  }()
  
  private lazy var chart: CurrencyChart = {
    let chart = CurrencyChart()
    chart.translatesAutoresizingMaskIntoConstraints = false
    return chart
  }()
  
  private lazy var infoTable: UITableView = {
    let table = UITableView()
    table.translatesAutoresizingMaskIntoConstraints = false
    table.backgroundColor = .clear
    table.dataSource = self
    table.delegate = self
    table.separatorStyle = .none
    table.register(CurrencyDetailsCell.self, forCellReuseIdentifier: CurrencyDetailsCell.reuseID)
    return table
  }()
  
  private lazy var favoriteBtn: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(addFavorite), for: .touchUpInside)
    return button
  }()
  
  private var info: [CurrencyDetails.Something.ViewModel.Info]?
  private var saveCurrency: SaveCurrency?

  // MARK: Object lifecycle
  
  init(currencyID: Int) {
    self.currencyID = currencyID
    super.init(nibName: nil, bundle: nil)
    setup()
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    currencyID = -1
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    currencyID = -1
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup() {
    let viewController = self
    let interactor = CurrencyDetailsInteractor()
    let presenter = CurrencyDetailsPresenter()
    let router = CurrencyDetailsRouter()
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
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    setupViews()
    setupConstraints()
    doSomething(currID: currencyID)
  }
  
  private func setupViews() {
    addCircleLayer()
    view.backgroundColor = .white
    navigationView.addSubview(titleLbl)
    navigationView.addSubview(favoriteBtn)
    view.addSubview(navigationView)
    view.addSubview(chart)
    view.addSubview(infoTable)
  }
  
  private func setupConstraints() {
    
    let chartC = [
      chart.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: chart.trailingAnchor, constant: 20),
      chart.topAnchor.constraint(equalTo: navigationView.bottomAnchor),
      chart.heightAnchor.constraint(equalToConstant: 200)
    ]
    
    let infoTableC = [
      infoTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      infoTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      infoTable.topAnchor.constraint(equalTo: chart.bottomAnchor),
      infoTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ]
    
    let navigationC = [
      navigationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      navigationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      navigationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      navigationView.heightAnchor.constraint(equalToConstant: 100)
    ]
    
    let titleLblC = [
      titleLbl.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor, constant: 20),
      navigationView.trailingAnchor.constraint(equalTo: titleLbl.trailingAnchor, constant: 20),
      titleLbl.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor)
    ]
    
    let favoriteC = [
      navigationView.trailingAnchor.constraint(equalTo: favoriteBtn.trailingAnchor, constant: 20),
      favoriteBtn.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor),
      favoriteBtn.widthAnchor.constraint(equalToConstant: 30),
      favoriteBtn.heightAnchor.constraint(equalToConstant: 30)
    ]
    
    NSLayoutConstraint.activate(infoTableC +
      titleLblC +
      navigationC +
      favoriteC +
      chartC)
  }
  
  private func addCircleLayer() {
    let circleLayer = CAShapeLayer()
    let radius: CGFloat = 300
    circleLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 2.0 * radius, height: 2.0 * radius),
                                    cornerRadius: radius).cgPath
    circleLayer.position = CGPoint(x: view.frame.midX - radius, y: -400)
    circleLayer.fillColor = UIColor(red: 19.0/255.0, green: 25.0/255.0, blue: 30.0/255.0, alpha: 1.0).cgColor
    view.layer.addSublayer(circleLayer)
  }
  
  // MARK: Do something
  
  //@IBOutlet weak var nameTextField: UITextField!
  
  func doSomething(currID: Int) {
    let request = CurrencyDetails.Something.Request(currID: currID)
    interactor?.doSomething(request: request)
  }
  
  func displaySomething(viewModel: CurrencyDetails.Something.ViewModel) {
    titleLbl.text = viewModel.title
    saveCurrency = viewModel.saveCurrency
    let isFilledStar = saveCurrency?.isWatchlist ?? false
    favoriteBtn.setImage(UIImage(named: isFilledStar ? "filled_star" : "empty_star"), for: .normal)
    info = viewModel.info
    infoTable.reloadData()
  }
  
  func changeFavorites(viewModel: CurrencyDetails.AddFavorite.ViewModel) {
    saveCurrency = viewModel.saveCurrency
    let isFilledStar = saveCurrency?.isWatchlist ?? false
    favoriteBtn.setImage(UIImage(named: isFilledStar ? "filled_star" : "empty_star"), for: .normal)
  }
  
  @objc private func addFavorite() {
    let request = CurrencyDetails.AddFavorite.Request(saveCurrency: saveCurrency ?? SaveCurrency(id: currencyID,
                                                                                                 isWatchlist: false,
                                                                                                 isFavorite: false))
    interactor?.addToFavorites(request: request)
  }
}

extension CurrencyDetailsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return info?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyDetailsCell.reuseID) as? CurrencyDetailsCell
      else {
      fatalError("\(CurrencyDetailsCell.self) not registered")
    }
    
    guard let info = info?[indexPath.row] else {
      fatalError("No info for \(indexPath.row)")
    }
    
    cell.onBind(info)
    
    return cell
  }
}

extension CurrencyDetailsViewController: UIGestureRecognizerDelegate {}