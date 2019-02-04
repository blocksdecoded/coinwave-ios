//
//  CurrencyChart.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/24/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import UIKit
import Charts

class CurrencyChart: UIView {
  
  enum Version {
    case favorite
    case details
  }
  private let version: Version
  private var gradientLayer: CAGradientLayer?
  
  private lazy var detailsGradientLayer: CAGradientLayer = {
    let gradient = CAGradientLayer()
    gradient.colors = [UIColor(red: 29.0/255.0, green: 196.0/255.0, blue: 233.0/255.0, alpha: 1.0).cgColor,
                       UIColor(red: 29.0/255.0, green: 233.0/255.0, blue: 182.0/255.0, alpha: 1.0).cgColor]
    gradient.startPoint = CGPoint(x: 0, y: 0.5)
    gradient.endPoint = CGPoint(x: 1, y: 0.5)
    gradient.cornerRadius = 10
    return gradient
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
    setupConstraints()
  }
  
  private func setupViews() {
    setupLayer()
    addSubview(chartView)
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      chartView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
      trailingAnchor.constraint(equalTo: chartView.trailingAnchor, constant: 0),
      chartView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
      chartView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
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
  
  func load(coinID: Int, time: CRTimeframe) {
    let networkManager = CurrenciesNetworkManager()
    networkManager.getHistory(currID: coinID, time: time) { root, error in
      if let error = error {
        print(error)
        fatalError()
      }
      
      guard let root = root else {
        fatalError()
      }
      
      DispatchQueue.main.async {
        self.setChartData(prices: root.data.history)
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
      color = NSUIColor(red: 29.0/255.0, green: 231.0/255.0, blue: 185.0/255.0, alpha: 1.0)
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
    chartView.animate(xAxisDuration: 1)
  }
}
