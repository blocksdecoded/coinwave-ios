//
//  MenuViewController.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 4/15/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, MenuDisplayLogic {
  static func instance(navigation: UINavigationController?, delegate: MenuDelegate?) -> MenuViewController {
    let viewModel = MenuViewModel(delegate: delegate)
    let view = MenuViewController(viewModel: viewModel, navigation: navigation)
    viewModel.view = view
    return view
  }
  
  // MARK: - Properties
  
  var viewModel: MenuBusinessLogic
  weak var rootNavigationController: UINavigationController?
  
  // MARK: - Views
  
  private lazy var topView: UIView = {
    return UIView()
  }()
  
  private lazy var closeMenuBtn: UIButton = {
    let button = BDHamburger.instance(R.image.x())
    button.addTarget(self, action: #selector(onCloseMenu), for: .touchUpInside)
    button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2, bottom: 0, right: 2)
    return button
  }()
  
  private lazy var titleLbl: UILabel = {
    let label = UILabel()
    label.font = R.font.sfProTextBold(size: 24)
    label.textColor = R.color.menu_unselected()
    label.text = R.string.localizable.menu_title()
    return label
  }()
  
  private lazy var optionsTable: UITableView = {
    let table = UITableView()
    table.register(MenuOptionCell.self, forCellReuseIdentifier: MenuOptionCell.reuseID)
    table.dataSource = self
    table.delegate = self
    table.bounces = false
    table.backgroundColor = .clear
    table.separatorStyle = .none
    return table
  }()
  
  private lazy var versionLbl: UILabel = {
    let label = UILabel()
    label.text = Constants.appVersion
    label.font = R.font.sfProTextRegular(size: 12)
    label.textColor = R.color.menu_default_color()
    return label
  }()
  
  private lazy var companyName: UILabel = {
    let label = UILabel()
    label.text = Constants.companyName
    label.font = R.font.sfProTextRegular(size: 12)
    label.textColor = R.color.menu_default_color()
    return label
  }()
  
  private lazy var companyIcon: UIImageView = {
    let image = UIImageView()
    image.image = R.image.blocks_decoded_icon()
    return image
  }()
  
  // MARK: - Init
  
  init(viewModel: MenuBusinessLogic, navigation: UINavigationController?) {
    self.viewModel = viewModel
    self.rootNavigationController = navigation
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  // MARK: - Setup
  
  private func setup() {
    setupViews()
    setupConstraints()
  }
  
  private func setupViews() {
    navigationController?.setNavigationBarHidden(true, animated: false)
    view.backgroundColor = R.color.menu_selected()
    topView.addSubview(closeMenuBtn)
    topView.addSubview(titleLbl)
    view.addSubview(topView)
    view.addSubview(optionsTable)
    view.addSubview(companyIcon)
    view.addSubview(companyName)
    view.addSubview(versionLbl)
  }
  
  private func setupConstraints() {
    topView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(80)
    }
    closeMenuBtn.snp.makeConstraints { make in
      make.leading.centerY.equalToSuperview()
      make.width.height.equalTo(25)
    }
    titleLbl.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(closeMenuBtn.snp.trailing).offset(16)
    }
    optionsTable.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(topView.snp.bottom)
      make.height.equalTo(350)
    }
    versionLbl.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
    }
    companyName.snp.makeConstraints { make in
      make.centerX.equalToSuperview().offset(14)
      make.bottom.equalTo(versionLbl.snp.top).offset(-8)
    }
    companyIcon.snp.makeConstraints { make in
      make.trailing.equalTo(companyName.snp.leading).offset(-8)
      make.centerY.equalTo(companyName.snp.centerY)
      make.width.height.equalTo(20)
    }
  }
  
  // MARK: - Display Logic
  
  func share(_ string: String) {
    let activity = UIActivityViewController(activityItems: [string], applicationActivities: nil)
    present(activity, animated: true, completion: nil)
    if UI_USER_INTERFACE_IDIOM() == .pad {
      if let popOver = activity.popoverPresentationController {
        let indexPath = IndexPath(row: 2, section: 0)
        guard let cell = optionsTable.cellForRow(at: indexPath) else {
          popOver.sourceView = optionsTable
          return
        }
        popOver.sourceView = cell
        popOver.sourceRect = CGRect(x: cell.frame.width / 4, y: cell.frame.height / 2, width: 0, height: 0)
      }
    }
  }
  
  func closeMenu() {
    dismiss(animated: true, completion: nil)
  }
  
  func onError(title: String) {
    let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
    let okAction = UIAlertAction(title: R.string.localizable.ok(), style: UIAlertAction.Style.default) { _ in
      alertController.dismiss(animated: true, completion: nil)
    }
    alertController.addAction(okAction)
    self.present(alertController, animated: true, completion: nil)
  }
  
  // MARK: - Handlers
  
  @objc private func onCloseMenu() {
    dismiss(animated: true, completion: nil)
  }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.options.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuOptionCell.reuseID) as? MenuOptionCell else {
      return UITableViewCell()
    }
    let option = viewModel.options[indexPath.row]
    cell.onBind(option)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    viewModel.didSelect(row: indexPath)
  }
}
