//
//  UIColor+Extensions.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 2/8/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import UIKit

extension UIColor {
  static func darkRandom() -> UIColor {
    let red = randValue()
    let green = randValue()
    let blue = randValue()
    return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
  }
  
  static func darkRandomPair() -> (UIColor, UIColor) {
    let red = randValue()
    let green = randValue()
    let blue = randValue()
    return (UIColor(red: red * 0.5, green: green * 0.5, blue: blue * 0.5, alpha: 1.0),
            UIColor(red: red, green: green, blue: blue, alpha: 1.0))
  }
  
  private static func randValue() -> CGFloat {
    return CGFloat.random(in: 50...170) / 255.0
  }
}
