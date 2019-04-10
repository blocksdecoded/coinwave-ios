//
//  CurrencyDetailsModels.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/24/18.
//  Copyright (c) 2018 makeuseof. All rights reserved.
//

import UIKit

struct DetailsModel {
  let iconType: CRCoin.IconType?
  let iconUrl: URL?
  let title: String
  let saveCurrency: CRCoin?
  let info: [Info]
  struct Info {
    let name: String
    let value: String?
    let valueColor: UIColor?
  }
}
