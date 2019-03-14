//
//  VRoundView.swift
//  WashMyCar
//
//  Created by admin on 3/9/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import UIKit

@IBDesignable
class VRoundShadow: UIView {
  
  @IBInspectable var cornerRadius: CGFloat = 10.0
  @IBInspectable var shadowRadius: CGFloat = 10.0
  @IBInspectable var shadowColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  func setup() {
    layer.cornerRadius = cornerRadius
    layer.shadowRadius = shadowRadius
    layer.shadowColor = shadowColor.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowOpacity = 1.0
  }
}
