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
      
      if let svgData = DataCache.shared.read(for: iconUrl) {
        svgCryptoIcon.image = SVGKImage(data: svgData)
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
              self.svgCryptoIcon.image = SVGKImage(data: data!)
            }
          }
        })
        task?.resume()
      }
    }
  }
  
  func onBind(_ crypto: CRCoin, isTop: Bool) {
    topSeparatorHeight.constant = isTop ? 1 : 0.5
    name.text = crypto.symbol
    
    var marketCapValue = "null"
    if let marketCap = crypto.marketCap {
      marketCapValue = CurrencyConverter.convertShort(marketCap)
    }
    marketCap.text = marketCapValue
    
    var volumeValue = "null"
    if let volume = crypto.volume {
      volumeValue = CurrencyConverter.convertShort(volume)
    }
    volume.text = volumeValue
    
    var priceValue = "null"
    if let price = crypto.priceValue {
      priceValue = CurrencyConverter.convertShort(price)
    }
    price.text = priceValue
    
    if let percent = crypto.change {
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
      pricePercent.text = "null"
    }
    
    setIcon(crypto)
  }
}
