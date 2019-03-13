//
//  TVCCrypto.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 8/6/18.
//  Copyright © 2018 MakeUseOf. All rights reserved.
//

import UIKit
import Kingfisher
import SVGKit

class TVCCrypto: UITableViewCell {
  static var reuseID: String {
    return String(describing: self)
  }
  
  static func create() -> UINib {
    return UINib(nibName: String(describing: TVCCrypto.self), bundle: nil)
  }
  
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var marketCap: UILabel!
  @IBOutlet weak var volume: UILabel!
  @IBOutlet weak var price: UILabel!
  @IBOutlet weak var topSeparationLine: UIView!
  @IBOutlet weak var cryptoIcon: UIImageView!
  @IBOutlet weak var svgCryptoIcon: SVGKFastImageView!
  @IBOutlet weak var pricePercent: UILabel!
  @IBOutlet weak var priceUpDownIcon: UIImageView!
  @IBOutlet weak var topSeparatorHeight: NSLayoutConstraint!
  @IBOutlet weak var stackView: UIStackView!
  
  private var task: URLSessionTask?
  
  override func prepareForReuse() {
    super.prepareForReuse()
    task?.cancel()
    task = nil
  }
  
  private func setIcon(_ coin: CRCoin) {
    guard let iconType = coin.iconType,
      let iconUrl = coin.iconUrlEncoded else {
        return
    }
    
    switch iconType {
    case .pixel:
      svgCryptoIcon.isHidden = true
      cryptoIcon.kf.setImage(with: URL(string: iconUrl))
    case .vector:
      cryptoIcon.isHidden = true
      svgCryptoIcon.contentMode = .scaleAspectFit
      task = svgCryptoIcon.load(iconUrl)
    }
  }
  
  func onBind(_ crypto: CRCoin, isTop: Bool) {
    topSeparatorHeight.constant = isTop ? 1 : 0.5
    name.text = crypto.symbol
    marketCap.text = crypto.marketCap?.short ?? "null"
    volume.text = crypto.volume?.short ?? "null"
    price.text = crypto.price?.long ?? "null"
    
    if let percent = crypto.change {
      if percent < 0 {
        pricePercent.textColor = Constants.Colors.currencyDown
        pricePercent.text = crypto.changeStr
        priceUpDownIcon.image = UIImage(named: "curr_arrow_down")
      } else {
        pricePercent.textColor = Constants.Colors.currencyUp
        pricePercent.text = crypto.changeStr
        priceUpDownIcon.image = UIImage(named: "curr_arrow_up")
      }
    } else {
      pricePercent.text = "null"
    }
    
    setIcon(crypto)
  }
}
