//
//  BDHamburger.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 2/9/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import UIKit

class BDHamburger: UIButton {  
  static func instance(_ image: UIImage?) -> BDHamburger {
    let button = getButton()
    button.setImage(image, for: .normal)
    return button
  }
  
  static func instance() -> BDHamburger {
    let button = getButton()
    button.setImage(UIImage(named: "hamburger"), for: .normal)
    button.imageEdgeInsets = UIEdgeInsets(top: 2, left: -3, bottom: 2, right: 3)
    return button
  }
  
  private static func getButton() -> BDHamburger {
    let button = BDHamburger()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = UIColor(red: 34.0/255.0, green: 43.0/255.0, blue: 50.0/255.0, alpha: 1.0)
    return button
  }
  
  var semiCircleLayer: CAShapeLayer!
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    if semiCircleLayer == nil {
      let arcCenter = CGPoint(x: 0, y: bounds.size.height / 2)
      let circleRadius = bounds.size.width
      let circlePath = UIBezierPath(arcCenter: arcCenter,
                                    radius: circleRadius,
                                    startAngle: CGFloat.pi,
                                    endAngle: CGFloat.pi * 4,
                                    clockwise: true)
      
      semiCircleLayer = CAShapeLayer()
      semiCircleLayer.path = circlePath.cgPath
      semiCircleLayer.fillColor = backgroundColor?.cgColor
      
      layer.addSublayer(semiCircleLayer)
      
      layer.masksToBounds = false
      
      if imageView != nil {
        bringSubviewToFront(imageView!)
      }
      
      backgroundColor = UIColor.clear
    }
  }
}
