//
//  WidgetFactory.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/24/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import UIKit

class WidgetFactory {
  var gradientLayer: CAGradientLayer {
    let gradient = CAGradientLayer()
    gradient.colors = [UIColor(red: 40.0/255.0, green: 52.0/255.0, blue: 60.0/255.0, alpha: 1.0).cgColor,
                       UIColor(red: 14.0/255.0, green: 18.0/255.0, blue: 22.0/255.0, alpha: 1.0).cgColor]
    gradient.startPoint = CGPoint(x: 0.5, y: 0)
    gradient.endPoint = CGPoint(x: 0.5, y: 1)
    return gradient
  }
  
  @discardableResult
  func setGradientTo(view: UIView) -> UIView {
    let gView = UIView(frame: view.bounds)
    gView.translatesAutoresizingMaskIntoConstraints = false
    gView.backgroundColor = UIColor.clear
    view.addSubview(gView)
    view.sendSubviewToBack(gView)
    
    NSLayoutConstraint.activate([
      gView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      gView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      gView.topAnchor.constraint(equalTo: view.topAnchor),
      gView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    
    gView.clipsToBounds = true
    let gradient = gradientLayer
    gradient.frame = gView.bounds
    gView.layer.insertSublayer(gradient, at: 0)
    return gView
  }
  
  func navigationView(title: String, color: UIColor) -> UIView {
    let navView = UIView()
    navView.translatesAutoresizingMaskIntoConstraints = false
    
    let titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.text = title
    titleLabel.textColor = color
    titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
    
    navView.addSubview(titleLabel)
    
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: navView.leadingAnchor, constant: 20),
      titleLabel.trailingAnchor.constraint(equalTo: navView.trailingAnchor, constant: 20),
      titleLabel.centerYAnchor.constraint(equalTo: navView.centerYAnchor)
    ])
    
    return navView
  }
}