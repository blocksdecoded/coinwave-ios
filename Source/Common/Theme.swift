//
//  Theme.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 3/26/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import UIKit.UIFont

class Theme {
  class Fonts {
    class func sfuiDisplayHeavy(size: CGFloat) -> UIFont {
      return UIFont(name: "SFUIDisplay-Heavy", size: size)!
    }
    
    class func sfproTextRegular(size: CGFloat) -> UIFont {
      return UIFont(name: "SFProText-Regular", size: size)!
    }
    
    class func sfproTextBold(size: CGFloat) -> UIFont {
      return UIFont(name: "SFProText-Bold", size: size)!
    }
    
    class func sfproTextLight(size: CGFloat) -> UIFont {
      return UIFont(name: "SFProText-Light", size: size)!
    }
    
    class func sfproTextSemibold(size: CGFloat) -> UIFont {
      return UIFont(name: "SFProText-Semibold", size: size)!
    }
  }
}
