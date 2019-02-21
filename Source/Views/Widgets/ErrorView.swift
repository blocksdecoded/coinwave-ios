//
//  ErrorView.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 2/20/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import UIKit

protocol ErrorViewDelegate: class {
  func onRetry()
}

class ErrorView: UIView {
  
  weak var delegate: ErrorViewDelegate?
  
  private lazy var warningIcon: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "warning")
    return imageView
  }()
  
  private lazy var text: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "TEST TEST TEST"
    return label
  }()
  
  private lazy var button: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(onRetry), for: .touchUpInside)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    setupViews()
    setupConstraints()
  }
  
  private func setupViews() {
    backgroundColor = .white
    addSubview(warningIcon)
    addSubview(text)
    addSubview(button)
  }
  
  private func setupConstraints() {
    let warningC = [
      warningIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
      warningIcon.widthAnchor.constraint(equalToConstant: 118),
      warningIcon.heightAnchor.constraint(equalToConstant: 104)
    ]
    
    let textC = [
      text.topAnchor.constraint(equalTo: warningIcon.bottomAnchor, constant: 8),
      text.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      trailingAnchor.constraint(equalTo: text.trailingAnchor, constant: 8)
    ]
    
    let buttonC = [
      button.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 8),
      button.centerXAnchor.constraint(equalTo: centerXAnchor),
      bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 8)
    ]
    
    let viewC = [
      widthAnchor.constraint(equalToConstant: 250)
    ]
    
    NSLayoutConstraint.activate(
      warningC + textC + buttonC + viewC
    )
  }
  
  @objc private func onRetry() {
    delegate?.onRetry()
  }
}
