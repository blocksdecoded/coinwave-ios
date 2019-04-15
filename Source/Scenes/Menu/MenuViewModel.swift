//
//  MenuViewModel.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 4/15/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

class MenuViewModel: MenuBusinessLogic {
  
  // MARK: - Properties
  
  // swiftlint:disable identifier_name
  private let PICK_FAVORITE = 0
  private let ADD_TO_WATCHLIST = 1
  private let CONTACT_US = 2
  private let RATE_US = 3
  private let SHARE_THIS_APP = 4
  
  weak var view: MenuDisplayLogic?
  weak var delegate: MenuDelegate?
  var options: [MenuOption]
  
  // MARK: - Init
  
  init(delegate: MenuDelegate?) {
    self.delegate = delegate
    options = [
      MenuOption(identifier: PICK_FAVORITE,
                 icon: R.image.fat_star(),
                 title: R.string.localizable.menu_pick_favorite(),
                 secondIcon: R.image.right_arrow()),
      MenuOption(identifier: ADD_TO_WATCHLIST,
                 icon: R.image.plus(),
                 title: R.string.localizable.menu_add_to_watchlist(),
                 secondIcon: R.image.right_arrow()),
      MenuOption(identifier: CONTACT_US,
                 icon: R.image.question(),
                 title: R.string.localizable.menu_contact_us(),
                 secondIcon: R.image.right_arrow()),
      MenuOption(identifier: RATE_US,
                 icon: R.image.thumb_up(),
                 title: R.string.localizable.menu_rate_us(),
                 secondIcon: R.image.right_arrow()),
      MenuOption(identifier: SHARE_THIS_APP,
                 icon: R.image.share(),
                 title: R.string.localizable.menu_share_this_app(),
                 secondIcon: R.image.right_arrow())
    ]
  }
  
  // MARK: - Business Logic
  
  func didSelect(row: IndexPath) {
    let option = options[row.item]
    switch option.identifier {
    case PICK_FAVORITE:
      delegate?.pickFavoriteClicked()
      view?.closeMenu()
    case ADD_TO_WATCHLIST:
      delegate?.addToWatchlistClicked()
      view?.closeMenu()
    case CONTACT_US:
      SEmail.shared.send(address: Constants.contactEmail, subject: Constants.contactSubject, error: {
        self.view?.onError(title: R.string.localizable.menu_email_error())
      })
    case RATE_US:
      delegate?.rateUsClicked()
      view?.closeMenu()
    case SHARE_THIS_APP:
      view?.share(R.string.localizable.menu_share_text(Constants.shareURL))
    default:
      break
    }
  }
}
