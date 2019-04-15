//
//  AddToWatchlistViewController.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 2/12/19.
//  Copyright (c) 2019 makeuseof. All rights reserved.
//

import UIKit
import SnapKit

class AddToWatchlistViewController: UIViewController, AddToWatchlistDisplayLogic {
  
  static func instance() -> AddToWatchlistViewController {
    let worker = CoinsWorker()
    let viewModel = AddToWatchlistViewModel(worker: worker)
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
    button.setImage(R.image.left_arrow(), for: .normal)
    button.addTarget(self, action: #selector(backClicked), for: .touchUpInside)
    return button
  }()
  
  private lazy var titleLbl: UILabel = {
    let titleLabel = UILabel()
    titleLabel.text = R.string.localizable.add_to_watchlist()
    titleLabel.textColor = .white
    titleLabel.font = R.font.sfProTextRegular(size: 18)
    return titleLabel
  }()
  
  private lazy var navigationView: UIView = {
    return UIView()
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
    viewModel.viewDidLoad()
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
    navigationView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(navigationViewHeight)
    }
    backButton.snp.makeConstraints { make in
      make.leading.centerY.equalToSuperview()
      make.width.height.equalTo(40)
    }
    titleLbl.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    currenciesList.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(navigationView.snp.bottom)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }
  }
  
  private func setupBackground() {
    let widgetFactory = WidgetFactory()
    widgetFactory.setGradientTo(view: view)
  }
  
  // MARK: - Display Logic
  
  func displayCoins() {
    refreshControl.endRefreshing()
    currenciesList.reloadData()
  }
  
  func displayError(_ string: String) {
    //TODO: Display error
  }
  
  func refreshCoin(indexPaths: [IndexPath]) {
    currenciesList.reloadItems(at: indexPaths)
  }
  
  // MARK: - Handlers
  
  @objc private func backClicked() {
    navigationController?.popViewController(animated: true)
  }
  
  @objc private func refreshTable() {
    viewModel.refreshTable()
  }
}

extension AddToWatchlistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.coins.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddToWatchlistCell.reuseID,
                                                        for: indexPath) as? AddToWatchlistCell else {
      fatalError()
    }
    cell.onBind(viewModel.coins[indexPath.item])
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel.addToWatchlist(indexPath: indexPath)
  }
}

extension AddToWatchlistViewController: UIGestureRecognizerDelegate {}
