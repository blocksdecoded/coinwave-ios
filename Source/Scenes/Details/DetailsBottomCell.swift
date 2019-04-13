//
//  DetailsBottomCell.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 2/6/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import UIKit

protocol DetailsBottomCellDelegate: class {
  func onOpenWebSite()
}

class DetailsBottomCell: UITableViewCell {
  static var reuseID: String {
    return "\(DetailsBottomCell.self)"
  }
  
  weak var delegate: DetailsBottomCellDelegate?
  
  private lazy var backImage: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.image = UIImage(named: "green_graph")
    return image
  }()
  
  private lazy var planet: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.image = UIImage(named: "planet")
    image.isUserInteractionEnabled = true
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
    tapGesture.numberOfTapsRequired = 1
    image.addGestureRecognizer(tapGesture)
    
    return image
  }()
  
  private lazy var button: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("GO TO WEBSITE", for: .normal)
    button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
    button.setTitleColor(UIColor(red: 29.0/255.0, green: 199.0/255.0, blue: 231.0/255.0, alpha: 1.0), for: .normal)
    button.titleLabel?.font = R.font.sfProTextRegular(size: 8)
    return button
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
    contentView.addSubview(backImage)
    contentView.addSubview(planet)
    contentView.addSubview(button)
  }
  
  private func setupConstraints() {
    let contentViewC = [
      contentView.heightAnchor.constraint(equalToConstant: 80)
    ]
    
    let backImageC = [
      backImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      backImage.topAnchor.constraint(equalTo: contentView.topAnchor),
      trailingAnchor.constraint(equalTo: backImage.trailingAnchor),
      bottomAnchor.constraint(equalTo: backImage.bottomAnchor, constant: 10)
    ]
    
    let planetC = [
      planet.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      planet.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      planet.widthAnchor.constraint(equalToConstant: 45),
      planet.heightAnchor.constraint(equalToConstant: 45)
    ]
    
    let buttonC = [
      button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      contentView.bottomAnchor.constraint(equalTo: button.bottomAnchor)
    ]
    
    NSLayoutConstraint.activate(backImageC + planetC + contentViewC + buttonC)
  }
  
  @objc private func onTap() {
    delegate?.onOpenWebSite()
  }
}
