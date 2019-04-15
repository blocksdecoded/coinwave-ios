//
//  MenuOptionCell.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 4/15/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import UIKit
import SnapKit

class MenuOptionCell: UITableViewCell {
  
  // MARK: - Properties
  
  static let reuseID = "\(MenuOptionCell.self)"
  
  // MARK: - Views
  
  private lazy var icon: UIImageView = {
    let icon = UIImageView()
    icon.contentMode = .scaleAspectFit
    icon.tintColor = R.color.menu_unselected_icon()
    return icon
  }()
  
  private lazy var secondIcon: UIImageView = {
    let icon = UIImageView()
    icon.contentMode = .scaleAspectFit
    icon.tintColor = R.color.menu_unselected()
    return icon
  }()
  
  private lazy var title: UILabel = {
    let label = UILabel()
    label.textColor = R.color.menu_unselected()
    label.font = R.font.sfProTextLight(size: 14)
    return label
  }()
  
  private lazy var selectedBgView: UIView = {
    let view = UIView()
    view.backgroundColor = R.color.menu_selected_background()
    return view
  }()
  
  // MARK: - Init
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    super.setHighlighted(highlighted, animated: animated)
    if highlighted {
      icon.tintColor = R.color.menu_selected()
      secondIcon.tintColor = R.color.menu_selected()
      title.textColor = R.color.menu_selected()
    } else {
      icon.tintColor = R.color.menu_unselected_icon()
      secondIcon.tintColor = R.color.menu_unselected()
      title.textColor = R.color.menu_unselected()
    }
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupViews()
    setupConstraints()
  }
  
  private func setupViews() {
    backgroundColor = R.color.menu_unselected_background()
    selectedBackgroundView = selectedBgView
    separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    contentView.addSubview(icon)
    contentView.addSubview(title)
    contentView.addSubview(secondIcon)
  }
  
  private func setupConstraints() {
    icon.snp.makeConstraints { make in
      make.width.height.equalTo(15)
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(20)
    }
    secondIcon.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(-20)
      make.width.height.equalTo(10)
      make.centerY.equalToSuperview()
    }
    title.snp.makeConstraints { make in
      make.leading.equalTo(icon.snp.trailing).offset(20)
      make.trailing.equalTo(secondIcon.snp.trailing).offset(-20)
      make.centerY.equalToSuperview()
    }
  }
  
  func onBind(_ option: MenuOption) {
    title.text = option.title
    icon.image = option.icon
    secondIcon.image = option.secondIcon
  }
}
