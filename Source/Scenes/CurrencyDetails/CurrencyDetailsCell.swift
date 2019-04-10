//
//  CurrencyDetailsCell.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/26/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import UIKit

class CurrencyDetailsCell: UITableViewCell {
  static var reuseID: String {
    return "\(CurrencyDetailsCell.self)"
  }
  
  private lazy var nameLbl: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Theme.Fonts.sfproTextRegular(size: 12)
    label.textColor = UIColor(red: 0.45, green: 0.46, blue: 0.47, alpha: 1.0)
    label.textAlignment = .left
    return label
  }()
  
  private lazy var valueLbl: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Theme.Fonts.sfproTextRegular(size: 12)
    label.textAlignment = .right
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  private func setup() {
    selectionStyle = .none
    setupViews()
    setupConstraints()
  }
  
  private func setupViews() {
    backgroundColor = .clear
//    contentView.backgroundColor = .clear
    contentView.addSubview(nameLbl)
    contentView.addSubview(valueLbl)
  }
  
  private func setupConstraints() {
    let nameC = [
      nameLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      nameLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ]
    
    let valueC = [
      contentView.trailingAnchor.constraint(equalTo: valueLbl.trailingAnchor, constant: 16),
      valueLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      valueLbl.leadingAnchor.constraint(equalTo: nameLbl.trailingAnchor, constant: 4)
    ]
    
    NSLayoutConstraint.activate(nameC + valueC)
  }
  
  func onBind(_ info: DetailsModel.Info) {
    nameLbl.text = info.name
    valueLbl.text = info.value
    valueLbl.textColor = info.valueColor ?? UIColor(red: 0.11, green: 0.14, blue: 0.16, alpha: 1.0)
  }
}
