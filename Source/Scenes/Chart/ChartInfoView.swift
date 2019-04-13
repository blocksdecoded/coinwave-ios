//
//  CurrencyChartInfoView.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 2/4/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import UIKit

class ChartInfoView: UIView {
  
  private lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
  }()
  
  private lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "February, 2, 2019"
    label.textColor = .white
    label.textAlignment = .center
    label.font = R.font.sfProTextRegular(size: 12)
    return label
  }()
  
  private lazy var priceLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "$3000"
    label.textColor = .white
    label.textAlignment = .center
    label.font = R.font.sfProTextRegular(size: 12)
    return label
  }()
  
  private lazy var stackView: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    return stack
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  private func setup() {
    backgroundColor = UIColor(red: 40.0/255.0, green: 52.0/255.0, blue: 59.0/255.0, alpha: 1.0)
    layer.cornerRadius = 10
    stackView.addArrangedSubview(dateLabel)
    stackView.addArrangedSubview(priceLabel)
    addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3),
      stackView.topAnchor.constraint(equalTo: topAnchor, constant: 3),
      trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 3),
      bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 3)
    ])
  }
  
  func setInfo(price: Double, timestamp: Double) {
    let date = Date(timeIntervalSince1970: timestamp / 1000)
    dateLabel.text = dateFormatter.string(from: date)
    priceLabel.text = Price(price)?.longForce
  }
}
