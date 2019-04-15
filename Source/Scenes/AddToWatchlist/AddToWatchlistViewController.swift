//
//  AddToWatchlistViewController.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 2/12/19.
//  Copyright (c) 2019 makeuseof. All rights reserved.
//

import UIKit

class AddToWatchlistViewController: UIViewController, AddToWatchlistDisplayLogic {
  
  static func instance() -> AddToWatchlistViewController {
    let worker = CoinsWorker()
    let viewModel = AddToWatchlistInteractor(worker: worker)
    let view = AddToWatchlistViewController(viewModel: viewModel)
    viewModel.view = view
    return view
  }
  
  // MARK: - Properties
  
  var viewModel: AddToWatchlistBusinessLogic
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  private let minimumInterSpacing: CGFloat = 10
  private let minimumLineSpacing: CGFloat = 20
  private let currListMargin: CGFloat = 10
  private let navigationViewHeight: CGFloat = 100
  
  private var coins: [CRCoin]?
  
  private lazy var cellWidth: CGFloat = {
    return (self.view.frame.width - minimumInterSpacing - (2 * currListMargin)) / 2
  }()
  
  // MARK: - Views
  
  private lazy var refreshControl: UIRefreshControl = {
    let refresh = UIRefreshControl()
    refresh.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
    return refresh
  }()
  
  private lazy var currenciesList: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: cellWidth, height: 70)
    layout.minimumLineSpacing = minimumLineSpacing
    layout.minimumInteritemSpacing = minimumInterSpacing
    let collView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    collView.translatesAutoresizingMaskIntoConstraints = false
    collView.register(AddToWatchlistCell.self, forCellWithReuseIdentifier: AddToWatchlistCell.reuseID)
    collView.backgroundColor = .clear
    collView.delegate = self
    collView.dataSource = self
    collView.refreshControl = refreshControl
    collView.contentInset = UIEdgeInsets(top: 20, left: currListMargin, bottom: 0, right: currListMargin)
    return collView
  }()
  
  private lazy var backButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(named: "left_arrow"), for: .normal)
    button.addTarget(self, action: #selector(backClicked), for: .touchUpInside)
    return button
  }()
  
  private lazy var titleLbl: UILabel = {
    let titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.text = "Add to watchlist"
    titleLabel.textColor = .white
    titleLabel.font = R.font.sfProTextRegular(size: 18)
    return titleLabel
  }()
  
  private lazy var navigationView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  // MARK: - Init
  
  init(viewModel: AddToWatchlistBusinessLogic) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    setupBackground()
    setupViews()
    setupConstraints()
    doSomething()
  }
  
  // MARK: - Setup
  
  private func setupViews() {
    view.backgroundColor = .white
    navigationView.addSubview(backButton)
    navigationView.addSubview(titleLbl)
    view.addSubview(navigationView)
    view.addSubview(currenciesList)
  }
  
  private func setupConstraints() {
    let navigationViewC = [
      navigationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      navigationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      navigationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      navigationView.heightAnchor.constraint(equalToConstant: navigationViewHeight)
    ]
    
    let navigationInnerC = [
      backButton.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor),
      backButton.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor),
      backButton.widthAnchor.constraint(equalToConstant: 40),
      backButton.heightAnchor.constraint(equalToConstant: 40),
      titleLbl.centerXAnchor.constraint(equalTo: navigationView.centerXAnchor),
      titleLbl.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor)
    ]
    
    let currsListC = [
      currenciesList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      currenciesList.topAnchor.constraint(equalTo: navigationView.bottomAnchor),
      currenciesList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: currenciesList.trailingAnchor)
    ]
    
    NSLayoutConstraint.activate(currsListC + navigationViewC + navigationInnerC)
  }
  
  private func setupBackground() {
    let widgetFactory = WidgetFactory()
    widgetFactory.setGradientTo(view: view)
  }
  
  // MARK: - Display Logic
  
  func displayCoins(coins: [CRCoin]) {
    refreshControl.endRefreshing()
    self.coins = coins
    currenciesList.reloadData()
  }
  
  func displayError(_ string: String) {
    //TODO: Display error
  }
  
  func refreshCoin(viewModel: AddToWatchlistModel) {
    coins?[viewModel.position] = viewModel.coin
    currenciesList.reloadItems(at: [IndexPath(item: viewModel.position, section: 0)])
  }
  
  // MARK: - Handlers
  
  func doSomething() {
    let sortable = Sortable(field: .name, direction: .asc)
    viewModel.fetchCoins(sortable: sortable, force: false)
  }
  
  @objc private func backClicked() {
    navigationController?.popViewController(animated: true)
  }
  
  @objc private func refreshTable() {
    let sortable = Sortable(field: .name, direction: .asc)
    viewModel.fetchCoins(sortable: sortable, force: true)
  }
}

extension AddToWatchlistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return coins?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddToWatchlistCell.reuseID,
                                                        for: indexPath) as? AddToWatchlistCell else {
      fatalError()
    }
    
    guard let coins = coins else {
      fatalError()
    }
    
    cell.onBind(coins[indexPath.item])
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let coin = coins![indexPath.item]
    viewModel.addToWatchlist(request: AddToWatchlistModel(position: indexPath.item, coin: coin))
  }
}

extension AddToWatchlistViewController: UIGestureRecognizerDelegate {}
