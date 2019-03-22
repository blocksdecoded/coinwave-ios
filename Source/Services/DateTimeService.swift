//
//  DateTimeService.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 3/22/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

class DateTimeService {
  static func interval(date: Date) -> String {
    let timeInterval = date.timeIntervalSinceNow
    let allSeconds = abs(Int(timeInterval))
    let days = allSeconds / 86400
    if days < 3 {
      if days < 2 {
        if days < 1 {
          let hours = (allSeconds % 86400) / 3600
          if hours < 1 {
            let minutes = (allSeconds % 3600) / 60
            if minutes < 1 {
              return "just now"
            } else {
              return "\(minutes)m. ago"
            }
          } else {
            return "\(hours)h. ago"
          }
        } else {
          return "yesterday"
        }
      } else {
        return "2 days ago"
      }
    } else {
      let formatter = DateFormatter()
      formatter.dateStyle = .short
      formatter.timeStyle = .none
      return formatter.string(from: date)
    }
  }
}
