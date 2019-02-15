//
//  AddToWatchlistViewController.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 2/12/19.
//  Copyright (c) 2019 makeuseof. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AddToWatchlistDisplayLogic: class {
  func displaySomething(viewModel: AddToWatchlist.Something.ViewModel)
  func refreshCoin(viewModel: AddToWatchlist.Add.ViewModel)
}

class AddToWatchlistViewController: UIViewController, AddToWatchlistDisplayLogic {
  var interactor: AddToWatchlistBusinessLogic?
  var router: (NSObjectProtocol & AddToWatchlistRoutingLogic & AddToWatchlistDataPassing)?
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  private let minimumInterSpacing: CGFloat = 10
  private let minimumLineSpacing: CGFloat = 20
  private let currListMargin: CGFloat = 10
  
  private var coins: [AddToWatchlist.Coin]?
  
  private lazy var cellWidth: CGFloat = {
    return (self.view.frame.width - minimumInterSpacing - (2 * currListMargin)) / 2
  }()
  
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
    button.contentHorizontalAlignment = .fill
    button.contentVerticalAlignment = .fill
    button.addTarget(self, action: #selector(backClicked), for: .touchUpInside)
    return button
  }()
  
  private lazy var titleLbl: UILabel = {
    let titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.text = "Add to watchlist"
    titleLabel.textColor = .white
    titleLabel.font = UIFont(name: Constants.Fonts.regular, size: 18)
    return titleLabel
  }()
  
  private lazy var navigationView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

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
    let interactor = AddToWatchlistInteractor()
    let presenter = AddToWatchlistPresenter()
    let router = AddToWatchlistRouter()
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
    setupBackground()
    setupViews()
    setupConstraints()
    doSomething()
  }
  
  // MARK: Do something
  
  //@IBOutlet weak var nameTextField: UITextField!
  
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
      navigationView.heightAnchor.constraint(equalToConstant: 100)
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
  
  func doSomething() {
    let request = AddToWatchlist.Something.Request()
    interactor?.doSomething(request: request)
  }
  
  func displaySomething(viewModel: AddToWatchlist.Something.ViewModel) {
    refreshControl.endRefreshing()
    coins = viewModel.coins
    currenciesList.reloadData()
  }
  
  func refreshCoin(viewModel: AddToWatchlist.Add.ViewModel) {
    let oldCoin = coins![viewModel.position]
    coins?[viewModel.position] = oldCoin.set(watchlist: viewModel.isWatchlist)
    currenciesList.reloadItems(at: [IndexPath(item: viewModel.position, section: 0)])
  }
  
  @objc private func backClicked() {
    navigationController?.popViewController(animated: true)
  }
  
  @objc private func refreshTable() {
    let request = AddToWatchlist.Something.Request()
    interactor?.doSomething(request: request)
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
    interactor?.addToWatchlist(id: AddToWatchlist.Add.Request(id: coin.id, isWatchlist: coin.isWatchlist, position: indexPath.item))
  }
}

extension AddToWatchlistViewController: UIGestureRecognizerDelegate {}
