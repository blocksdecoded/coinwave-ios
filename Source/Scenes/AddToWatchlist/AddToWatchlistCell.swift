//
//  AddToWatchlistCell.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 2/13/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import UIKit
import Kingfisher
import SVGKit

class AddToWatchlistCell: UICollectionViewCell {
  static var reuseID: String {
    return "\(AddToWatchlistCell.self)"
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  private let cornerRadius: CGFloat = 10
  private var isEmpty = true
  
  private var task: URLSessionTask?
  
  override func prepareForReuse() {
    super.prepareForReuse()
    task?.cancel()
    task = nil
  }
  
  private lazy var backView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = cornerRadius
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOpacity = 1
    view.layer.shadowRadius = 10
    view.layer.shadowOffset = CGSize(width: 0, height: 0)
    return view
  }()
  
  private lazy var labelBack: UIView = {
    let view = UIView()
    view.layer.cornerRadius = cornerRadius
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor(red: 0.07, green: 0.09, blue: 0.11, alpha: 1)
    view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
    return view
  }()
  
  private lazy var starBack: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = cornerRadius
    view.backgroundColor = UIColor(red: 0.12, green: 0.16, blue: 0.18, alpha: 1)
    view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    return view
  }()
  
  private lazy var starIV: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "empty_star_gray")
    return imageView
  }()
  
  private lazy var name: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont(name: Constants.Fonts.regular, size: 14)
    label.textColor = UIColor.white.withAlphaComponent(0.3)
    return label
  }()
  
  private lazy var symbol: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = UIColor.white
    label.font = UIFont(name: Constants.Fonts.bold, size: 20)
    return label
  }()
  
  private lazy var icon: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private lazy var svgIcon: SVGKFastImageView = {
    let imageView = SVGKFastImageView(svgkImage: SVGKImage())!
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
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
    let nameC = [
      name.leadingAnchor.constraint(equalTo: labelBack.leadingAnchor, constant: 8),
      name.topAnchor.constraint(equalTo: labelBack.topAnchor, constant: 8),
      labelBack.trailingAnchor.constraint(equalTo: name.trailingAnchor, constant: 8)
    ]
    
    let symbolC = [
      symbol.topAnchor.constraint(equalTo: name.bottomAnchor),
      labelBack.bottomAnchor.constraint(equalTo: symbol.bottomAnchor, constant: 8),
      labelBack.trailingAnchor.constraint(equalTo: symbol.trailingAnchor, constant: 8)
    ]
    
    let iconC = [
      icon.leadingAnchor.constraint(equalTo: name.leadingAnchor),
      symbol.leadingAnchor.constraint(equalTo: icon.trailingAnchor),
      icon.widthAnchor.constraint(equalTo: icon.heightAnchor),
      icon.centerYAnchor.constraint(equalTo: symbol.centerYAnchor),
      icon.heightAnchor.constraint(equalToConstant: 20)
    ]
    
    let svgIconC = [
      svgIcon.leadingAnchor.constraint(equalTo: icon.leadingAnchor),
      svgIcon.topAnchor.constraint(equalTo: icon.topAnchor),
      svgIcon.trailingAnchor.constraint(equalTo: icon.trailingAnchor),
      svgIcon.bottomAnchor.constraint(equalTo: icon.bottomAnchor)
    ]
    
    let starIVC = [
      starIV.centerXAnchor.constraint(equalTo: starBack.centerXAnchor),
      starIV.centerYAnchor.constraint(equalTo: starBack.centerYAnchor),
      starIV.widthAnchor.constraint(equalToConstant: 35),
      starIV.heightAnchor.constraint(equalToConstant: 35)
    ]
    
    let lblBackViewC = [
      labelBack.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
      labelBack.topAnchor.constraint(equalTo: backView.topAnchor),
      backView.bottomAnchor.constraint(equalTo: labelBack.bottomAnchor),
      starBack.leadingAnchor.constraint(equalTo: labelBack.trailingAnchor)
    ]
    
    let starBackC = [
      starBack.topAnchor.constraint(equalTo: backView.topAnchor),
      backView.bottomAnchor.constraint(equalTo: starBack.bottomAnchor),
      backView.trailingAnchor.constraint(equalTo: starBack.trailingAnchor),
      starBack.widthAnchor.constraint(equalToConstant: 70)
    ]
    
    let backViewC = [
      backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      backView.topAnchor.constraint(equalTo: contentView.topAnchor),
      contentView.bottomAnchor.constraint(equalTo: backView.bottomAnchor),
      contentView.trailingAnchor.constraint(equalTo: backView.trailingAnchor)
    ]
    
    NSLayoutConstraint.activate(backViewC + lblBackViewC + starBackC + starIVC + nameC + iconC + symbolC + svgIconC)
  }
  
  func onBind(_ coin: AddToWatchlist.Coin) {
    starIV.image = UIImage(named: coin.isWatchlist ? "filled_star" : "empty_star_gray")
    
    name.text = coin.name
    symbol.text = coin.symbol
    setIcon(coin)
  }
  
  private func setIcon(_ coin: AddToWatchlist.Coin) {
    guard let iconType = coin.icon,
      let iconUrl = coin.iconUrl else {
        return
    }
    
    switch iconType {
    case .pixel:
      svgIcon.isHidden = true
      icon.kf.setImage(with: URL(string: iconUrl))
    case .vector:
      icon.isHidden = true
      
      
      if let svgData = DataCache.shared.read(for: iconUrl) {
        svgIcon.image = SVGKImage(data: svgData)
      } else {
        guard let url = URL(string: iconUrl) else {
          fatalError()
        }
        let request = URLRequest(url: url,
                                 cachePolicy: .reloadRevalidatingCacheData,
                                 timeoutInterval: 60 * 60 * 24 * 7)
        let session = URLSession.shared
        task = session.dataTask(with: request, completionHandler: { data, response, _ in
          guard let response = response as? HTTPURLResponse else {
            return
          }
          
          if response.statusCode == 200 && data != nil {
            DataCache.shared.write(data: data!, for: iconUrl)
            DispatchQueue.main.async {
              self.svgIcon.image = SVGKImage(data: data!)
            }
          }
        })
        task?.resume()
      }
    }
  }
}
