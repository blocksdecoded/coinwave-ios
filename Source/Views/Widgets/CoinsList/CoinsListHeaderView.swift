//
//  CoinsListHeaderView.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 4/8/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import UIKit
import SnapKit

class CoinsListHeaderView: UIView {
  typealias Handler = () -> Void
  
  // MARK: - Handlers
  
  var nameHandler: Handler
  var marketCapHandler: Handler
  var volumeHandler: Handler
  var priceHandler: Handler
  
  // MARK: - Properties
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: titles)
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  private lazy var nameColumn: UIButton = {
    return columnTitle(text: R.string.localizable.name())
  }()
  
  private lazy var marketCapColumn: UIButton = {
    return columnTitle(text: R.string.localizable.market_cap())
  }()
  
  private lazy var volumeColumn: UIButton = {
    return columnTitle(text: R.string.localizable.volume_24h())
  }()
  
  private lazy var priceColumn: UIButton = {
    return columnTitle(text: R.string.localizable.price_24h())
  }()
  
  private lazy var titles: [UIButton] = {
    return [nameColumn, marketCapColumn, volumeColumn, priceColumn]
  }()
  
  // MARK: - Init
  
  init(onName: @escaping Handler,
       onMarketCap: @escaping Handler,
       onVolume: @escaping Handler,
       onPrice: @escaping Handler) {
    nameHandler = onName
    marketCapHandler = onMarketCap
    volumeHandler = onVolume
    priceHandler = onPrice
    super.init(frame: CGRect.zero)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Setup
  
  private func setup() {
    addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func columnTitle(text: String) -> UIButton {
    let button = UIButton()
    button.setTitle(text, for: .normal)
    button.titleLabel?.textAlignment = .center
    button.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
    button.tintColor = UIColor.white.withAlphaComponent(0.7)
    button.titleLabel?.font = R.font.sfProTextLight(size: 11)
    button.addTarget(self, action: #selector(sortCoins(_:)), for: .touchUpInside)
    button.setImage(R.image.triangle_up()?.withRenderingMode(.alwaysTemplate), for: .normal)
    button.semanticContentAttribute = .forceRightToLeft
    button.imageEdgeInsets = UIEdgeInsets(top: 0.5, left: 2.5, bottom: -0.5, right: -2.5)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -2.5, bottom: 0, right: 2.5)
    return button
  }
  
  // MARK: - Handlers
  
  @objc private func sortCoins(_ sender: UIButton) {
    switch sender {
    case nameColumn:
      nameHandler()
    case marketCapColumn:
      marketCapHandler()
    case volumeColumn:
      volumeHandler()
    case priceColumn:
      priceHandler()
    default:
      break
    }
  }
  
  func setSort(sortable: Sortable) {
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
      
    button.tintColor = R.color.sort_enabled()
    button.setTitleColor(R.color.sort_enabled(), for: .normal)
    var image: UIImage?
    switch sortable.direction {
    case .asc:
      image = R.image.triangle_up()?.withRenderingMode(.alwaysTemplate)
    case .desc:
      image = R.image.triangle_down()?.withRenderingMode(.alwaysTemplate)
    }
    button.setImage(image, for: .normal)
    defaultButton(others)
  }
  
  private func defaultButton(_ buttons: [UIButton]) {
    for button in buttons {
      button.tintColor = R.color.sort_disabled()
      button.setTitleColor(R.color.sort_disabled(), for: .normal)
    }
  }
}
