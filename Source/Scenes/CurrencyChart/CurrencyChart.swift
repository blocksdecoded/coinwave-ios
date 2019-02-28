//
//  CurrencyChart.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/24/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import UIKit
import Charts

protocol CurrencyChartDelegate: class {
  func onChooseFavorite()
}

class CurrencyChart: UIView {
  enum Version {
    case favorite
    case details
  }
  
  weak var delegate: CurrencyChartDelegate?
  
  private let version: Version
  private var gradientLayer: CAGradientLayer?
  
  private var isShowStart = false
  private var isShowDone = false
  private var hideTimer: Timer?
  
  private let cache = NSCache<NSString, AnyObject>()
  
  private var isButtonShowed = false
  private lazy var chooseFavButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Choose favorite", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    button.backgroundColor = UIColor(red: 40.0/255.0, green: 52.0/255.0, blue: 59.0/255.0, alpha: 1.0)
    button.layer.cornerRadius = 10
    button.addTarget(self, action: #selector(pickFavorite), for: .touchUpInside)
    return button
  }()
  
  private lazy var infoView: CurrencyChartInfoView = {
    let view = CurrencyChartInfoView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var warningView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "warning_gradient")
    return imageView
  }()
  
  private lazy var detailsGradientLayer: CAGradientLayer = {
    let gradient = CAGradientLayer()
    gradient.colors = [UIColor(red: 29.0/255.0, green: 196.0/255.0, blue: 233.0/255.0, alpha: 1.0).cgColor,
                       UIColor(red: 29.0/255.0, green: 233.0/255.0, blue: 182.0/255.0, alpha: 1.0).cgColor]
    gradient.startPoint = CGPoint(x: 0, y: 0.5)
    gradient.endPoint = CGPoint(x: 1, y: 0.5)
    gradient.cornerRadius = 10
    return gradient
  }()
  
  private lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont(name: Constants.Fonts.regular, size: 16)
    label.textColor = .white
    return label
  }()
  
  private lazy var priceLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont(name: Constants.Fonts.semibold, size: 12)
    return label
  }()
  
  private lazy var chartView: LineChartView = {
    let chart = LineChartView()
    chart.xAxis.enabled = false
    chart.xAxis.drawLabelsEnabled = false
    chart.xAxis.drawGridLinesEnabled = false
    chart.leftAxis.enabled = false
    chart.leftAxis.drawLabelsEnabled = false
    chart.leftAxis.drawGridLinesEnabled = false
    chart.rightAxis.enabled = false
    chart.rightAxis.drawLabelsEnabled = false
    chart.rightAxis.drawGridLinesEnabled = false
    chart.drawGridBackgroundEnabled = false
    chart.legend.enabled = false
    chart.minOffset = 0
    
    chart.borderColor = .clear
    chart.backgroundColor = .clear
    chart.translatesAutoresizingMaskIntoConstraints = false
    chart.noDataText = "No history data"
    
    switch version {
    case .details:
      chart.noDataTextColor = .black
    case .favorite:
      chart.noDataTextColor = .white
    }
    
    chart.delegate = self
    
    return chart
  }()
  
  override func layoutSubviews() {
    super.layoutSubviews()
    switch version {
    case .details:
      detailsGradientLayer.frame = bounds
    case .favorite:
      gradientLayer?.frame = bounds
    }
  }
  
  private override init(frame: CGRect) {
    self.version = .details
    super.init(frame: frame)
    setup()
  }
  
  internal required init?(coder aDecoder: NSCoder) {
    self.version = .details
    super.init(coder: aDecoder)
    setup()
  }
  
  init(version: Version) {
    self.version = version
    super.init(frame: CGRect.zero)
    setup()
  }
  
  private func setup() {
    setupViews()
    switch version {
    case .details:
      setupConstraints()
    case .favorite:
      setupConstraintsForFavorite()
    }
  }
  
  private func setupViews() {
    setupLayer()
    
    switch version {
    case .favorite:
      addSubview(nameLabel)
      addSubview(priceLabel)
      addSubview(warningView)
    case .details:
      break
    }
    
    addSubview(chartView)
    addSubview(infoView)
    
    infoView.isHidden = true
    infoView.alpha = 0
  }
  
  private func setupConstraints() {
    let chartC = [
      chartView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
      trailingAnchor.constraint(equalTo: chartView.trailingAnchor, constant: 0),
      chartView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
      chartView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ]
    
    let infoViewC = [
      infoView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      infoView.centerXAnchor.constraint(equalTo: centerXAnchor)
    ]
    
    NSLayoutConstraint.activate(chartC + infoViewC)
  }
  
  private func setupConstraintsForFavorite() {
    let nameLabelC = [
      nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
      nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
    ]
    
    let priceLabelC = [
      priceLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
      trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 8)
    ]
    
    let chartC = [
      chartView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
      trailingAnchor.constraint(equalTo: chartView.trailingAnchor, constant: 0),
      chartView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
      chartView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ]
    
    let infoViewC = [
      infoView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      infoView.centerXAnchor.constraint(equalTo: centerXAnchor)
    ]
    
    let warningC = [
      warningView.centerYAnchor.constraint(equalTo: centerYAnchor),
      warningView.centerXAnchor.constraint(equalTo: centerXAnchor),
      warningView.widthAnchor.constraint(equalToConstant: 118),
      warningView.heightAnchor.constraint(equalToConstant: 104)
    ]
    
    NSLayoutConstraint.activate(chartC + infoViewC + nameLabelC + priceLabelC + warningC)
  }
  
  private func setupLayer() {
    switch version {
    case .details:
      layer.insertSublayer(detailsGradientLayer, at: 0)
    case .favorite:
      let factory = WidgetFactory()
      gradientLayer = factory.gradientLayer
      gradientLayer?.cornerRadius = 10
      layer.insertSublayer(gradientLayer!, at: 0)
    }
    
    layer.cornerRadius = 10
    layer.shadowColor = UIColor.black.withAlphaComponent(0.8).cgColor
    layer.shadowRadius = 5
    layer.shadowOpacity = 0.2
    layer.masksToBounds = false
  }
  
  func load(coinID: Int, coinSymbol: String, time: CRTimeframe) {
    warningView.isHidden = true
    chartView.isHidden = false
    chooseFavButton.isHidden = false
    if isButtonShowed {
      chooseFavButton.removeFromSuperview()
    }
    
    let key = "\(coinID)_\(time.value)"
    
    if let root = cache.object(forKey: key as NSString) as? CRRoot<CRDataHistory> {
      self.setChartData(prices: root.data.history)
    } else {
      
      let coin = DataStore.shared.fetchCoin(coinID)!
      setCoinData(coin: coin)
      
      let networkManager = CurrenciesNetworkManager()
      networkManager.getHistory(currID: coinSymbol, time: time) { root, error in
        if let error = error {
          print(error)
          return
        }
        
        guard let root = root else {
          return
        }
        self.cache.setObject(root as AnyObject, forKey: key as NSString)
        DispatchQueue.main.async {
          self.setChartData(prices: root.data.history)
        }
      }
    }
  }
  
  func noCoin() {
    isButtonShowed = true
    addSubview(chooseFavButton)
    NSLayoutConstraint.activate([
      chooseFavButton.centerXAnchor.constraint(equalTo: centerXAnchor),
      chooseFavButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      chooseFavButton.widthAnchor.constraint(equalToConstant: 120),
      chooseFavButton.heightAnchor.constraint(equalToConstant: 30)
    ])
  }
  
  func showError() {
    warningView.isHidden = false
    chartView.isHidden = true
    chooseFavButton.isHidden = true
  }
  
  private func setCoinData(coin: CRCoin) {
    nameLabel.text = coin.name
    priceLabel.text = coin.priceStrLong
    
    if let percent = coin.change {
      if percent < 0 {
        priceLabel.textColor = Constants.Colors.currencyDown
      } else {
        priceLabel.textColor = Constants.Colors.currencyUp
      }
    }
  }
  
  private func setChartData(prices: [CRPrice]) {
    var dataEntries = [ChartDataEntry]()
    
    for price in prices {
      let xChart = Double(price.timestamp ?? 0)
      let yChart = Double(price.price ?? "0") ?? 0
      let dataEntry = ChartDataEntry(x: xChart, y: yChart)
      dataEntries.append(dataEntry)
    }
    
    let chartDataSet = LineChartDataSet(values: dataEntries, label: "")
    chartDataSet.drawCirclesEnabled = false
    chartDataSet.mode = LineChartDataSet.Mode.cubicBezier
    chartDataSet.cubicIntensity = 0.3
    chartDataSet.drawFilledEnabled = true
    chartDataSet.lineWidth = 1.2
    chartDataSet.drawValuesEnabled = false
    var color = NSUIColor.white
    var gradientColors = [CGColor]() as CFArray
    switch version {
    case .details:
      color = NSUIColor(red: 40.0/255.0, green: 52.0/255.0, blue: 60.0/255.0, alpha: 1.0)
      gradientColors = [UIColor(red: 40.0/255.0, green: 52.0/255.0, blue: 60.0/255.0, alpha: 1.0).cgColor,
                            UIColor.clear.cgColor] as CFArray
      
    case .favorite:
      color = NSUIColor(red: 29.0/255.0, green: 200.0/255.0, blue: 229.0/255.0, alpha: 1.0)
      gradientColors = [UIColor(red: 29.0/255.0, green: 231.0/255.0, blue: 185.0/255.0, alpha: 1.0).cgColor,
                        UIColor.clear.cgColor] as CFArray
    }
    
    chartDataSet.colors = [color]
    chartDataSet.fillColor = color
    
    let colorLocations: [CGFloat] = [1.0, 0.0]
    guard let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                         colors: gradientColors,
                                         locations: colorLocations) else {
                                          print("gradient error")
                                          return
    }
    chartDataSet.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
    
    let chartData = LineChartData(dataSet: chartDataSet)
    chartView.data = chartData
    chartView.animate(xAxisDuration: 2)
  }
  
  @objc private func pickFavorite() {
    delegate?.onChooseFavorite()
  }
}

extension CurrencyChart: ChartViewDelegate {
  func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
    infoView.setInfo(price: entry.y, timestamp: entry.x)
    if isShowDone {
      hideInfo()
    } else {
      if !isShowStart {
        isShowStart = true
        infoView.isHidden = false
        showInfo()
      }
    }
  }
  
  private func hideInfo() {
    if hideTimer != nil {
      hideTimer?.invalidate()
      hideTimer = nil
    }
    
    hideTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { timer in
      UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn], animations: {
        self.infoView.alpha = 0
      }, completion: { _ in
        self.infoView.alpha = 0
        self.infoView.isHidden = true
        self.isShowDone = false
      })
      timer.invalidate()
    })
  }
  
  private func showInfo() {
    UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn], animations: {
      self.infoView.alpha = 1
    }, completion: { _ in
      self.infoView.alpha = 1
      self.isShowDone = true
      self.isShowStart = false
      self.hideInfo()
    })
  }
}
