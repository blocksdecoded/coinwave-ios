//
//  Constants.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/22/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import UIKit

struct Constants {
  
  static var appVersion: String {
    #if DEVELOPMENT
    return "\(Bundle.main.appVersion ?? "")(\(Bundle.main.buildVersion ?? "")) debug"
    #elseif STAGING
    return "\(Bundle.main.appVersion ?? "")(\(Bundle.main.buildVersion ?? "")) staging"
    #else
    return Bundle.main.appVersion ?? ""
    #endif
  }
  
  struct Fonts {
    static let heavy = "SFUIDisplay-Heavy"
    static let regular = "SFProText-Regular"
    static let bold = "SFProText-Bold"
    static let light = "SFProText-Light"
    static let semibold = "SFProText-Semibold"
  }
  
  struct Colors {
    static let currencyUp = UIColor(red: 29.0/255.0, green: 227.0/255.0, blue: 191.0/255.0, alpha: 1.0)
    static let currencyDown = UIColor(red: 244.0/255.0, green: 66.0/255.0, blue: 54.0/255.0, alpha: 1.0)
    static let def = UIColor(red: 170.0/255.0, green: 174.0/255.0, blue: 179.0/255.0, alpha: 1.0)
  }
  
  //swiftlint:disable identifier_name
  static let COINS_LIMIT = 50
  static let COINS_OFFSET = 0
}

extension Bundle {
  var appVersion: String? {
    if let name = object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
      return name
    }
    return nil
  }
  
  var buildVersion: String? {
    if let name = object(forInfoDictionaryKey: "CFBundleVersion") as? String {
      return name
    }
    return nil
  }
}
