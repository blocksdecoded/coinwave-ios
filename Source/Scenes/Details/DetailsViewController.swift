//
//  DetailsViewController.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/24/18.
//  Copyright (c) 2018 makeuseof. All rights reserved.
//

import UIKit
import SafariServices
import SVGKit
import Kingfisher
import SnapKit

class DetailsViewController: UIViewController, DetailsDisplayLogic {
  static func instance(coinID: Int, symbol: String) -> DetailsViewController {
    let worker = CoinsWorker()
    let viewModel = DetailsViewModel(coinID: coinID, worker: worker)
    let view = DetailsViewController(coinID: coinID, symbol: symbol, viewModel: viewModel)
    viewModel.view = view
    return view
  }
  
  // MARK: - Properties
  
  private let coinID: Int
  private let symbol: String
  var viewModel: DetailsBusinessLogic
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  private let todayBtnTag = 100001
  private let weekBtnTag = 100002
  private let monthBtnTag = 100003
  private let yearBtnTag = 100004
  private let year5BtnTag = 100005
  
  private let backButtonWidth: CGFloat = 30
  private let backButtonHeight: CGFloat = 30
  private var backButtonLeftMargin: CGFloat {
    return 24.5 - backButtonWidth / 2
  }
  
  private let favoriteButtonWidth: CGFloat = 35
  private let favoriteButtonHeight: CGFloat = 35
  private var favoriteButtonRightMargin: CGFloat {
    return 30 - favoriteButtonWidth / 2
  }
  
  // MARK: - Views
  
  private var tmpButton: UIButton?
  
  private lazy var topCircle: UIImageView = {
    let imageView = UIImageView()
    imageView.image = R.image.top_circle_black()
    imageView.contentMode = .scaleToFill
    return imageView
  }()
  
  private lazy var backButton: UIButton = {
    let button = UIButton()
    button.setImage(R.image.left_arrow(), for: .normal)
    button.addTarget(self, action: #selector(backClicked), for: .touchUpInside)
    button.contentMode = .scaleAspectFit
    return button
  }()
  
  private lazy var coinIcon: UIImageView = {
    return UIImageView()
  }()
  
  private lazy var vectorCoinIcon: SVGKFastImageView = {
    let imageView = SVGKFastImageView(svgkImage: SVGKImage())!
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private lazy var titleLbl: UILabel = {
    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.textColor = .white
    titleLabel.font = R.font.sfProTextBold(size: 24)
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = 1
    titleLabel.adjustsFontSizeToFitWidth = true
    titleLabel.minimumScaleFactor = 0.5
    return titleLabel
  }()
  
  private lazy var navigationView: UIView = {
    return UIView()
  }()
  
  private lazy var chart: CurrencyChart = {
    return CurrencyChart(version: .details)
  }()
  
  private lazy var periodStack: UIStackView = {
    let todayBtn = getButton(title: R.string.localizable.today(), tag: todayBtnTag, isSelected: true)
    tmpButton = todayBtn
    let stack = UIStackView(arrangedSubviews: [todayBtn,
                                   getButton(title: R.string.localizable.week(), tag: weekBtnTag, isSelected: false),
                                   getButton(title: R.string.localizable.month(), tag: monthBtnTag, isSelected: false),
                                   getButton(title: R.string.localizable.year(), tag: yearBtnTag, isSelected: false),
                                   getButton(title: R.string.localizable.all(), tag: year5BtnTag, isSelected: false)])
    stack.axis = .horizontal
    stack.distribution = .equalSpacing
    return stack
  }()
  
  private lazy var refreshControl: UIRefreshControl = {
    let refresh = UIRefreshControl()
    refresh.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
    return refresh
  }()
  
  private lazy var infoTable: UITableView = {
    let table = UITableView()
    table.backgroundColor = .clear
    table.dataSource = self
    table.delegate = self
    table.separatorStyle = .none
    table.refreshControl = refreshControl
    table.register(DetailsCell.self, forCellReuseIdentifier: DetailsCell.reuseID)
    table.register(DetailsBottomCell.self, forCellReuseIdentifier: DetailsBottomCell.reuseID)
    return table
  }()
  
  private lazy var favoriteBtn: UIButton = {
    let button = UIButton()
    button.addTarget(self, action: #selector(addFavorite), for: .touchUpInside)
    return button
  }()

  // MARK: - Init
  
  init(coinID: Int, symbol: String, viewModel: DetailsBusinessLogic) {
    self.coinID = coinID
    self.symbol = symbol
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
    setupViews()
    setupConstraints()
    viewModel.fetchDetails(force: false)
    chart.load(coinID: coinID, coinSymbol: symbol, time: .hour24)
  }
  
  // MARK: - Setup
  
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
    periodStack.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
      make.top.equalTo(chart.snp.bottom)
      make.height.equalTo(50)
    }
    infoTable.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
      make.top.equalTo(periodStack.snp.bottom)
    }
    coinIcon.snp.makeConstraints { make in
      make.width.height.equalTo(20)
      make.centerY.equalTo(titleLbl.snp.centerY)
      make.trailing.equalTo(titleLbl.snp.leading).offset(-8)
    }
    vectorCoinIcon.snp.makeConstraints { make in
      make.width.height.equalTo(20)
      make.centerY.equalTo(titleLbl.snp.centerY)
      make.trailing.equalTo(titleLbl.snp.leading).offset(-8)
    }
    titleLbl.snp.makeConstraints { make in
      make.trailing.lessThanOrEqualTo(favoriteBtn.snp.leading).offset(-8)
      make.leading.greaterThanOrEqualTo(backButton.snp.trailing).offset(8)
      make.centerX.equalToSuperview().offset(14)
      make.centerY.equalToSuperview()
    }
    favoriteBtn.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(-favoriteButtonRightMargin)
      make.centerY.equalToSuperview()
      make.width.equalTo(favoriteButtonWidth)
      make.height.equalTo(favoriteButtonHeight)
    }
    backButton.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(backButtonLeftMargin)
      make.centerY.equalToSuperview()
      make.width.equalTo(backButtonWidth)
      make.height.equalTo(30)
    }
  }
  
  // MARK: - Handlers
  
  private func getButton(title: String, tag: Int, isSelected: Bool) -> UIButton {
    let button = UIButton()
    button.setTitle(title, for: .normal)
    button.tag = tag
    button.setTitleColor(R.color.history_button_selected(), for: .selected)
    button.setTitleColor(R.color.history_button_normal(), for: .normal)
    button.titleLabel?.font = R.font.sfProTextRegular(size: 12)
    button.isSelected = isSelected
    button.addTarget(self, action: #selector(changePeriod(sender:)), for: .touchUpInside)
    return button
  }
  
  // MARK: - Business Logic
  
  func displayDetails() {
    refreshControl.endRefreshing()
    if viewModel.info.iconType != nil && viewModel.info.iconUrl != nil {
      switch viewModel.info.iconType! {
      case .pixel:
        vectorCoinIcon.isHidden = true
        coinIcon.kf.setImage(with: viewModel.info.iconUrl!)
      case .vector:
        coinIcon.isHidden = true
        vectorCoinIcon.load(viewModel.info.iconUrl!)
      }
    } else {
      coinIcon.isHidden = true
      vectorCoinIcon.isHidden = true
    }
    
    titleLbl.text = viewModel.info.title
    favoriteBtn.setImage(viewModel.getFavoriteIcon(), for: .normal)
    infoTable.reloadData()
  }
  
  func displayError(_ string: String) {
    // TODO: Display error
  }
  
  func changeFavorites(coin: CRCoin) {
    favoriteBtn.setImage(viewModel.getFavoriteIcon(), for: .normal)
  }
  
  func openCoinWebsite(site: URL) {
    let webVC = SFSafariViewController(url: site)
    webVC.delegate = self
    present(webVC, animated: true, completion: nil)
  }
  
  func openNoCoinWebsite() {
    let alert = UIAlertController(title: R.string.localizable.no_website(), message: nil, preferredStyle: .alert)
    let okAction = UIAlertAction(title: R.string.localizable.ok(), style: .default, handler: { _ in
      alert.dismiss(animated: true, completion: nil)
    })
    alert.addAction(okAction)
    present(alert, animated: true, completion: nil)
  }
  
  // MARK: - Handlers
  
  @objc private func addFavorite() {
    viewModel.addToFavorites()
  }
  
  @objc private func changePeriod(sender: UIButton) {
    tmpButton?.isSelected = false
    tmpButton = sender
    tmpButton?.isSelected = true
    var timeframe: CRTimeframe
    switch sender.tag {
    case todayBtnTag:
      timeframe = .hour24
    case weekBtnTag:
      timeframe = .day7
    case monthBtnTag:
      timeframe = .day30
    case yearBtnTag:
      timeframe = .year1
    case year5BtnTag:
      timeframe = .year5
    default:
      return
    }
    chart.load(coinID: coinID, coinSymbol: symbol, time: timeframe)
  }
  
  @objc private func backClicked() {
    navigationController?.popViewController(animated: true)
  }
  
  @objc private func refreshTable() {
    viewModel.fetchDetails(force: true)
    chart.load(coinID: coinID, coinSymbol: symbol, time: .hour24)
  }
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return viewModel.info.info.count
    }
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailsCell.reuseID)
                                                                          as? DetailsCell
        else {
        fatalError("\(DetailsCell.self) not registered")
      }
      
      let info = viewModel.info.info[indexPath.row]
      cell.onBind(info)
      return cell
    } else {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailsBottomCell.reuseID)
                                                                          as? DetailsBottomCell
        else {
          fatalError("\(DetailsBottomCell.self) not registered")
      }
      cell.delegate = self
      return cell
    }
  }
}

extension DetailsViewController: DetailsBottomCellDelegate {
  func onOpenWebSite() {
    viewModel.onOpenWeb()
  }
}

extension DetailsViewController: SFSafariViewControllerDelegate {
  func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    dismiss(animated: true, completion: nil)
  }
}

extension DetailsViewController: UIGestureRecognizerDelegate {}
