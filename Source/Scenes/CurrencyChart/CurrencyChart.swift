//
//  CurrencyChart.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/24/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import UIKit

class CurrencyChart: UIView {
  
  private var gradientLayer: CAGradientLayer?
  
  override func layoutSubviews() {
    super.layoutSubviews()
    gradientLayer?.frame = bounds
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  private func setup() {
    setupViews()
    setupConstraints()
  }
  
  private func setupViews() {
    let factory = WidgetFactory()
    gradientLayer = factory.gradientLayer
    gradientLayer?.cornerRadius = 10
    layer.insertSublayer(gradientLayer!, at: 0)
    layer.cornerRadius = 10
    layer.shadowColor = UIColor.black.withAlphaComponent(0.8).cgColor
    layer.shadowRadius = 5
    layer.shadowOpacity = 0.2
    layer.masksToBounds = false
  }
  
  private func setupConstraints() {
    
  }
}
