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
    label.font = UIFont.systemFont(ofSize: 12) //TODO: Change to avenir book
    label.textColor = UIColor(red: 170.0/255.0, green: 174.0/255.0, blue: 179.0/255.0, alpha: 1.0)
    label.textAlignment = .left
    return label
  }()
  
  private lazy var valueLbl: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 12) //TODO: Change to avenir book
    label.textColor = UIColor(red: 170.0/255.0, green: 174.0/255.0, blue: 179.0/255.0, alpha: 1.0)
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
  
  func onBind(_ info: CurrencyDetails.Something.ViewModel.Info) {
    nameLbl.text = info.name
    valueLbl.text = info.value
  }
}
