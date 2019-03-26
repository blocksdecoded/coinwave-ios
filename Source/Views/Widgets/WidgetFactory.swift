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
    gradient.colors = [UIColor(red: 14.0/255.0, green: 18.0/255.0, blue: 22.0/255.0, alpha: 1.0).cgColor,
                       UIColor(red: 40.0/255.0, green: 52.0/255.0, blue: 60.0/255.0, alpha: 1.0).cgColor]
    gradient.endPoint = CGPoint(x: 0.75, y: 0)
    gradient.startPoint = CGPoint(x: 0.25, y: 1)
    return gradient
  }
  
  private func getGradientLayer() -> CAGradientLayer {
    let (start, end) = UIColor.darkRandomPair()
    let gradient = CAGradientLayer()
    gradient.colors = [start.cgColor,
                       end.cgColor]
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
  
  func setGradientToCell(view: UIView) -> UIView {
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
    let gradient = getGradientLayer()
    gradient.frame = gView.bounds
    gView.layer.insertSublayer(gradient, at: 0)
    return gView
  }
}
