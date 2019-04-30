//
//  AddToWatchlistCell.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 2/13/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit
import Macaw

class AddToWatchlistCell: UICollectionViewCell {
  
  // MARK: - Properties
  
  static var reuseID: String {
    return "\(AddToWatchlistCell.self)"
  }
  
  private let cornerRadius: CGFloat = 10
  private var isEmpty = true
  private var task: URLSessionTask?
  
  // MARK: - Views
  
  private lazy var backView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = cornerRadius
    view.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
    view.layer.shadowOpacity = 1
    view.layer.shadowRadius = 10
    view.layer.shadowOffset = CGSize(width: 0, height: 24)
    return view
  }()
  
  private lazy var labelBack: UIView = {
    let view = UIView()
    view.layer.cornerRadius = cornerRadius
    view.backgroundColor = R.color.add_to_watchlist_text_back()
    view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
    return view
  }()
  
  private lazy var starBack: UIView = {
    let view = UIView()
    view.layer.cornerRadius = cornerRadius
    view.backgroundColor = R.color.add_to_watchlist_star_back()
    view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    return view
  }()
  
  private lazy var starIV: UIImageView = {
    let imageView = UIImageView()
    imageView.image = R.image.empty_star_gray()
    return imageView
  }()
  
  private lazy var name: UILabel = {
    let label = UILabel()
    label.font = R.font.sfProTextRegular(size: 14)
    label.textColor = R.color.add_to_watchlist_coin_name()
    return label
  }()
  
  private lazy var symbol: UILabel = {
    let label = UILabel()
    label.textColor = R.color.add_to_watchlist_coin_symbol()
    label.font = R.font.sfProTextBold(size: 20)
    return label
  }()
  
  private lazy var icon: UIImageView = {
    let imageView = UIImageView()
    return imageView
  }()
  
  private lazy var svgIcon: SVGView = {
    let imageView = SVGView()
    imageView.contentMode = .scaleAspectFit
    imageView.backgroundColor = .clear
    return imageView
  }()
  
  // MARK: - Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: - Lifecycle
  
  override func prepareForReuse() {
    super.prepareForReuse()
    task?.cancel()
    task = nil
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupViews()
    setupConstraints()
  }
  
  private func setupViews() {
    labelBack.addSubview(name)
    labelBack.addSubview(icon)
    labelBack.addSubview(svgIcon)
    labelBack.addSubview(symbol)
    starBack.addSubview(starIV)
    backView.addSubview(labelBack)
    backView.addSubview(starBack)
    contentView.addSubview(backView)
  }
  
  private func setupConstraints() {
    name.snp.makeConstraints { make in
      make.leading.top.equalToSuperview().offset(8)
      make.trailing.equalToSuperview().offset(-8)
    }
    symbol.snp.makeConstraints { make in
      make.top.equalTo(name.snp.bottom)
      make.trailing.bottom.equalToSuperview().offset(-8)
    }
    icon.snp.makeConstraints { make in
      make.leading.equalTo(name.snp.leading)
      make.trailing.equalTo(symbol.snp.leading)
      make.width.height.equalTo(20)
      make.centerY.equalTo(symbol.snp.centerY)
    }
    svgIcon.snp.makeConstraints { make in
      make.leading.equalTo(name.snp.leading)
      make.trailing.equalTo(symbol.snp.leading)
      make.width.height.equalTo(20)
      make.centerY.equalTo(symbol.snp.centerY)
    }
    starIV.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.width.height.equalTo(25)
    }
    labelBack.snp.makeConstraints { make in
      make.leading.top.bottom.equalToSuperview()
      make.trailing.equalTo(starBack.snp.leading)
    }
    starBack.snp.makeConstraints { make in
      make.top.bottom.trailing.equalToSuperview()
      make.width.equalTo(70)
    }
    backView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  // MARK: - Handlers
  
  func onBind(_ coin: CRCoin) {
    starIV.image = coin.isWatchlist ? R.image.filled_star() : R.image.empty_star_gray()
    name.text = coin.name
    symbol.text = coin.symbol
    setIcon(coin)
  }
  
  private func setIcon(_ coin: CRCoin) {
    guard let iconType = coin.iconType,
      let iconUrl = coin.iconUrl else {
        return
    }
    
    switch iconType {
    case .pixel:
      svgIcon.isHidden = true
      icon.kf.setImage(with: iconUrl)
    case .vector:
      icon.isHidden = true
      SVGLoader.load(iconUrl) { (node) in
        self.svgIcon.node = node
      }
    }
  }
}
