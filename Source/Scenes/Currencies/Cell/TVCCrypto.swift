//
//  TVCCrypto.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 8/6/18.
//  Copyright © 2018 MakeUseOf. All rights reserved.
//

import UIKit
import Kingfisher

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
  @IBOutlet weak var pricePercent: UILabel!
  @IBOutlet weak var priceUpDownIcon: UIImageView!
  @IBOutlet weak var topSeparatorHeight: NSLayoutConstraint!
  
  func onBind(_ crypto: Currency, isTop: Bool) {
    topSeparatorHeight.constant = isTop ? 1 : 0.5
    name.text = crypto.symbol
    
    marketCap.text = CurrencyConverter.convertShort(crypto.marketCap ?? 1)
    volume.text = CurrencyConverter.convertShort(crypto.volume24h ?? 1)
    price.text = CurrencyConverter.convertShort(crypto.price ?? 1)
    
    if let percent = crypto.pricePercentChange24h {
      if percent < 0 {
        price.textColor = Constants.Colors.currencyDown
        pricePercent.textColor = Constants.Colors.currencyDown
        pricePercent.text = "\(percent)%"
        priceUpDownIcon.image = UIImage(named: "curr_arrow_down")
      } else {
        price.textColor = Constants.Colors.currencyUp
        pricePercent.textColor = Constants.Colors.currencyUp
        pricePercent.text = "+\(percent)%"
        priceUpDownIcon.image = UIImage(named: "curr_arrow_up")
      }
    } else {
      pricePercent.text = "1"
    }
    
    cryptoIcon.kf.setImage(with: URL(string: "https://s2.coinmarketcap.com/static/img/coins/32x32/\(crypto.id).png"))
  }
}
