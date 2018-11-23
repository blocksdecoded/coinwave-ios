//
//  PostNavigationView.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/23/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import UIKit

protocol PostNavigationViewDelegate: class {
  func postNavigationBackClicked()
  func postNavigationFontSizeClicked()
  func postNavigationShareClicked()
}

class PostNavigationView: UIView {
  
  private let btnHeight: CGFloat = 44
  
  weak var delegate: PostNavigationViewDelegate?
  
  private lazy var backBtn: UIButton = {
    return createButton("post_back", action: #selector(backClicked))
  }()
  
  private lazy var fontSizeBtn: UIButton = {
    return createButton("post_font_size", action: #selector(fontSizeClicked))
  }()
  
  private lazy var shareBtn: UIButton = {
    return createButton("post_share", action: #selector(shareClicked))
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
    backgroundColor = .clear
  }
  
  func presentView(fromView: UIView) {
    fromView.addSubview(self)
    fromView.bringSubviewToFront(self)
    setupViews()
    setupConstraints()
  }
  
  private func setupViews() {
    addSubview(backBtn)
    addSubview(fontSizeBtn)
    addSubview(shareBtn)
  }
  
  private func setupConstraints() {
    let backC = [
      backBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      backBtn.topAnchor.constraint(equalTo: topAnchor),
      bottomAnchor.constraint(equalTo: backBtn.bottomAnchor),
      backBtn.heightAnchor.constraint(equalToConstant: btnHeight)
    ]
    
    let shareC = [
      shareBtn.heightAnchor.constraint(equalTo: backBtn.heightAnchor),
      shareBtn.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor),
      trailingAnchor.constraint(equalTo: shareBtn.trailingAnchor, constant: 8)
    ]
    
    let fontC = [
      fontSizeBtn.heightAnchor.constraint(equalTo: backBtn.heightAnchor),
      fontSizeBtn.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor),
      shareBtn.leadingAnchor.constraint(equalTo: fontSizeBtn.trailingAnchor, constant: 8)
    ]
    
    NSLayoutConstraint.activate(backC + shareC + fontC)
  }
  
  private func createButton(_ icon: String, action: Selector) -> UIButton {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(named: icon), for: .normal)
    button.addTarget(self, action: action, for: .touchUpInside)
    return button
  }
  
  @objc private func backClicked() {
    delegate?.postNavigationBackClicked()
  }
  
  @objc private func fontSizeClicked() {
    delegate?.postNavigationFontSizeClicked()
  }
  
  @objc private func shareClicked() {
    delegate?.postNavigationShareClicked()
  }
}
