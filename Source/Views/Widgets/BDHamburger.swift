//
//  BDHamburger.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 2/9/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import UIKit

class BDHamburger: UIButton {  
  static func instance(_ image: UIImage) -> BDHamburger {
    let button = BDHamburger()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = UIColor(red: 34.0/255.0, green: 43.0/255.0, blue: 50.0/255.0, alpha: 1.0)
    button.setImage(image, for: .normal)
    return button
  }
  
  static func instance() -> BDHamburger {
    let button = BDHamburger()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = UIColor(red: 34.0/255.0, green: 43.0/255.0, blue: 50.0/255.0, alpha: 1.0)
    button.setImage(UIImage(named: "hamburger"), for: .normal)
    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -1, bottom: 0, right: 1)
    return button
  }
  
  var semiCircleLayer: CAShapeLayer!
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    if semiCircleLayer == nil {
      let arcCenter = CGPoint(x: 0, y: bounds.size.height / 2)
      let circleRadius = bounds.size.width
      let circlePath = UIBezierPath(arcCenter: arcCenter, radius: circleRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 4, clockwise: true)
      
      semiCircleLayer = CAShapeLayer()
      semiCircleLayer.path = circlePath.cgPath
      semiCircleLayer.fillColor = backgroundColor?.cgColor
      layer.addSublayer(semiCircleLayer)
      
      if imageView != nil {
        bringSubviewToFront(imageView!)
      }
      
      backgroundColor = UIColor.clear
    }
  }
}