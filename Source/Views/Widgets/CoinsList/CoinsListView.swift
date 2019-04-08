//
//  CoinsListView.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 4/8/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import UIKit
import SnapKit

class CoinsListView: UIView {
  
  // MARK: - Properties
  
  private var onRefresh: () -> Void
  private var numberOfCoins: () -> Int
  private var coinForRow: (Int) -> CRCoin
  private var selectCoinAt: (Int) -> Void
  
  private var nameHandler: CoinsListHeaderView.Handler
  private var marketCapHandler: CoinsListHeaderView.Handler
  private var volumeHandler: CoinsListHeaderView.Handler
  private var priceHandler: CoinsListHeaderView.Handler
  
  // MARK: - Views
  
  private lazy var headerView: CoinsListHeaderView = {
    return CoinsListHeaderView(onName: nameHandler,
                               onMarketCap: marketCapHandler,
                               onVolume: volumeHandler,
                               onPrice: priceHandler)
  }()
  
  private lazy var refreshView: UIRefreshControl = {
    let refresh = UIRefreshControl()
    refresh.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
    return refresh
  }()
  
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .clear
    tableView.register(TVCCrypto.create(), forCellReuseIdentifier: TVCCrypto.reuseID)
    tableView.rowHeight = 60
    tableView.separatorStyle = .none
    tableView.dataSource = self
    tableView.delegate = self
    tableView.refreshControl = refreshView
    return tableView
  }()
  
  // MARK: - Init
  
  init(onRefresh: @escaping () -> Void,
       numberOfCoins: @escaping () -> Int,
       coinForRow: @escaping (Int) -> CRCoin,
       selectCoinAt: @escaping (Int) -> Void,
       onName: @escaping CoinsListHeaderView.Handler,
       onMarketCap: @escaping CoinsListHeaderView.Handler,
       onVolume: @escaping CoinsListHeaderView.Handler,
       onPrice: @escaping CoinsListHeaderView.Handler) {
    self.onRefresh = onRefresh
    self.numberOfCoins = numberOfCoins
    self.coinForRow = coinForRow
    self.selectCoinAt = selectCoinAt
    self.nameHandler = onName
    self.marketCapHandler = onMarketCap
    self.volumeHandler = onVolume
    self.priceHandler = onPrice
    super.init(frame: CGRect.zero)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Setup
  
  private func setup() {
    addSubview(headerView)
    addSubview(tableView)
    
    headerView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.height.equalTo(50)
    }
    
    tableView.snp.makeConstraints { make in
      make.top.equalTo(headerView.snp.bottom)
      make.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Handlers
  
  @objc private func refreshTable() {
    onRefresh()
  }
  
  func stopRefresh() {
    refreshView.endRefreshing()
  }
  
  func reloadData() {
    tableView.reloadData()
  }
  
  func setSort(sortable: Sortable) {
    headerView.setSort(sortable: sortable)
  }
}

// MARK: - TableView DataSource

extension CoinsListView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return numberOfCoins()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TVCCrypto.reuseID) as? TVCCrypto else {
      return UITableViewCell()
    }
    cell.onBind(coinForRow(indexPath.row), isTop: indexPath.row == 0)
    return cell
  }
}

// MARK: - TableView Delegate

extension CoinsListView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    selectCoinAt(indexPath.row)
  }
}
