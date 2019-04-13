//
//  Chart.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/24/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import UIKit
import Charts
import SnapKit

protocol ChartDelegate: class {
  func onChooseFavorite()
}

class Chart: UIView, ChartDisplayLogic {
  enum Version {
    case favorite
    case details
  }
  
  static func instance(version: Version, coinID: Int?, symbol: String?) -> Chart {
    let coinsWorker = CoinsWorker()
    let chartWorker = ChartWorker()
    let viewModel = ChartViewModel(coinID: coinID, symbol: symbol, coinsWorker: coinsWorker, chartWorker: chartWorker)
    let view = Chart(version: version, viewModel: viewModel)
    viewModel.view = view
    return view
  }
  
  // MARK: - Properties
  
  var viewModel: ChartBusinessLogic
  weak var delegate: ChartDelegate?
  private let version: Version
  private var gradientLayer: CAGradientLayer?
  private var isShowStart = false
  private var isShowDone = false
  private var hideTimer: Timer?
  private var isButtonShowed = false
  
  // MARK: - Views
  
  private lazy var chooseFavButton: UIButton = {
    let button = UIButton()
    button.setTitle(R.string.localizable.choose_favorite(), for: .normal)
    button.titleLabel?.font = R.font.sfProTextRegular(size: 12)
    button.backgroundColor = R.color.chart_choose_fav_btn_back()
    button.layer.cornerRadius = 10
    button.addTarget(self, action: #selector(pickFavorite), for: .touchUpInside)
    return button
  }()
  
  private lazy var infoView: ChartInfoView = {
    return ChartInfoView()
  }()
  
  private lazy var warningView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = R.image.warning()
    return imageView
  }()
  
  private lazy var detailsGradientLayer: CAGradientLayer = {
    let gradient = CAGradientLayer()
    gradient.colors = [R.color.chart_details_back_gradient_1()!.cgColor,
                       R.color.chart_details_back_gradient_2()!.cgColor]
    gradient.startPoint = CGPoint(x: 0, y: 0.5)
    gradient.endPoint = CGPoint(x: 1, y: 0.5)
    gradient.cornerRadius = 10
    return gradient
  }()
  
  private lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.font = R.font.sfProTextRegular(size: 16)
    label.textColor = .white
    return label
  }()
  
  private lazy var priceLabel: UILabel = {
    let label = UILabel()
    label.font = R.font.sfProTextSemibold(size: 12)
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
    chart.noDataText = R.string.localizable.no_history_data()
    
    switch version {
    case .details:
      chart.noDataTextColor = .black
    case .favorite:
      chart.noDataTextColor = .white
    }
    chart.delegate = self
    return chart
  }()
  
  // MARK: - Lifecycle
  
  override func layoutSubviews() {
    super.layoutSubviews()
    switch version {
    case .details:
      detailsGradientLayer.frame = bounds
    case .favorite:
      gradientLayer?.frame = bounds
    }
  }
  
  // MARK: - Init
  
  init(version: Version, viewModel: ChartBusinessLogic) {
    self.version = version
    self.viewModel = viewModel
    super.init(frame: CGRect.zero)
    setup()
  }
  
  internal required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Setup
  
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
    chartView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    infoView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.centerX.equalToSuperview()
    }
  }
  
  private func setupConstraintsForFavorite() {
    nameLabel.snp.makeConstraints { make in
      make.top.leading.equalToSuperview().offset(8)
    }
    priceLabel.snp.makeConstraints { make in
      make.centerY.equalTo(nameLabel.snp.centerY)
      make.trailing.equalToSuperview().offset(-8)
    }
    chartView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(nameLabel.snp.bottom)
    }
    infoView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.centerX.equalToSuperview()
    }
    warningView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.width.equalTo(118)
      make.height.equalTo(104)
    }
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
  
  // MARK: - Display Logic
  
  func displayData(name: String, price: String, color: UIColor) {
    nameLabel.text = name
    priceLabel.text = price
    priceLabel.textColor = color
  }
  
  func displayHistory(history: [ChartDataEntry]) {    
    let chartDataSet = LineChartDataSet(values: history, label: "")
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
      color = R.color.chart_details_line()!
      gradientColors = [R.color.chart_details_fore_gradient_1()!.cgColor,
                        R.color.chart_details_fore_gradient_2()!.cgColor] as CFArray
      
    case .favorite:
      color = R.color.chart_fav_line()!
      gradientColors = [R.color.chart_fav_fore_gradient_1()!.cgColor,
                        R.color.chart_fav_fore_gradient_2()!.cgColor] as CFArray
    }
    
    chartDataSet.colors = [color]
    chartDataSet.fillColor = color
    
    let colorLocations: [CGFloat] = [1.0, 0.0]
    guard let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                         colors: gradientColors,
                                         locations: colorLocations) else {
                                          return
    }
    chartDataSet.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
    
    let chartData = LineChartData(dataSet: chartDataSet)
    chartView.data = chartData
    chartView.animate(xAxisDuration: 2)
  }
  
  func displayError() {
    // TODO: Display error
  }
  
  // MARK: - Handlers
  
  func load(coinID: Int, coinSymbol: String, time: CRTimeframe) {
    warningView.isHidden = true
    chartView.isHidden = false
    chooseFavButton.isHidden = false
    if isButtonShowed {
      chooseFavButton.removeFromSuperview()
    }
    viewModel.set(coinID: coinID, symbol: coinSymbol)
    viewModel.load(time: time)
  }
  
  func noCoin() {
    isButtonShowed = true
    addSubview(chooseFavButton)
    chooseFavButton.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.width.equalTo(120)
      make.height.equalTo(30)
    }
  }
  
  func showError() {
    warningView.isHidden = false
    chartView.isHidden = true
    chooseFavButton.isHidden = true
  }
  
  @objc private func pickFavorite() {
    delegate?.onChooseFavorite()
  }
}

extension Chart: ChartViewDelegate {
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
