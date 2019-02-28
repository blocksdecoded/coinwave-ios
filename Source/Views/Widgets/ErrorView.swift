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
  
  private let buttonWidth: CGFloat = 135
  private let buttonHeight: CGFloat = 50
  
  private lazy var warningIcon: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "warning")
    return imageView
  }()
  
  private lazy var text: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .white
    label.font = UIFont(name: Constants.Fonts.regular, size: 20)
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
  
  private lazy var button: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(onRetry), for: .touchUpInside)
    button.setTitle("RETRY", for: .normal)
    button.titleLabel?.font = UIFont(name: Constants.Fonts.semibold, size: 12)
    button.setTitleColor(UIColor(red: 0.11, green: 0.13, blue: 0.16, alpha: 1), for: .normal)
    
    button.layer.cornerRadius = 10
    button.layer.shadowColor = UIColor(red: 0.11, green: 0.86, blue: 0.79, alpha: 0.25).cgColor
    button.layer.shadowOpacity = 1
    button.layer.shadowOffset = CGSize(width: 0, height: 4)
    
    let gradient = CAGradientLayer()
    gradient.colors = [UIColor(red: 0.11, green: 0.91, blue: 0.71, alpha: 1.0).cgColor,
                       UIColor(red: 0.11, green: 0.77, blue: 0.91, alpha: 1.0).cgColor]
    gradient.startPoint = CGPoint(x: 0.25, y: 0.5)
    gradient.endPoint = CGPoint(x: 0.75, y: 0.5)
    
    gradient.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: buttonWidth, height: buttonHeight))
    button.layer.insertSublayer(gradient, at: 0)
    
    button.layer.masksToBounds = true
    
    return button
  }()
  
  convenience init() {
    self.init(frame: CGRect.zero)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    backgroundColor = .clear
    setupViews()
    setupConstraints()
  }
  
  private func setupViews() {
    addSubview(warningIcon)
    addSubview(text)
    addSubview(button)
  }
  
  private func setupConstraints() {
    let warningC = [
      warningIcon.topAnchor.constraint(equalTo: topAnchor, constant: 8),
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
      bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 8),
      button.widthAnchor.constraint(equalToConstant: buttonWidth),
      button.heightAnchor.constraint(equalToConstant: buttonHeight)
    ]
    
    let viewC = [
      widthAnchor.constraint(equalToConstant: 250),
      heightAnchor.constraint(equalToConstant: 300)
    ]
    
    NSLayoutConstraint.activate(
      warningC + textC + buttonC + viewC
    )
  }
  
  func setText(_ text: String, hideWarning: Bool = false, hideButton: Bool = false) {
    self.text.text = text
    self.warningIcon.isHidden = hideWarning
    self.button.isHidden = hideButton
  }
  
  @objc private func onRetry() {
    delegate?.onRetry()
  }
}
