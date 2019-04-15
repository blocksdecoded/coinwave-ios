//
//  SEmail.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 2/8/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import UIKit

class SEmail {
  static let shared = SEmail()
  
  // swiftlint:disable line_length
  private let regex = "(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
  
  func send(address: String, subject: String?, error: (() -> Void)?) {
    var mail = "mailto://\(address)"
    
    if subject != nil {
      mail.append("?&subject=\(subject!)")
    }
    
    if let url = URL(string: mail) {
      if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
      } else {
        error?()
      }
    } else {
      error?()
    }
  }
  
  func isValid(_ email: String) -> Bool {
    let matches = email.range(of: regex, options: .regularExpression, range: nil, locale: nil)
    return matches != nil
  }
}
