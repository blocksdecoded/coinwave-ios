//
//  RatingController.swift
//  WashMyCar
//
//  Created by admin on 3/21/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import UIKit

class RatingController: UIViewController {
  
  static let kRating = "rating"
  
  static func show(root: UIViewController) {
    let storyboard = UIStoryboard(name: String(describing: RatingController.self), bundle: nil)
    if let viewController = storyboard.instantiateInitialViewController() as? RatingController {
      viewController.modalPresentationStyle = .overCurrentContext
      viewController.modalTransitionStyle = .crossDissolve
      root.present(viewController, animated: true, completion: nil)
    }
  }
  
  //Shared
  @IBOutlet weak var roundContainerHeight: NSLayoutConstraint!
  @IBOutlet weak var roundContainer: VRoundShadow!
  
  //Rating
  @IBOutlet weak var rateUsLabel: UILabel!
  @IBOutlet weak var rateBar: VRateBar!
  @IBOutlet weak var rateButton: UIButton!
  @IBOutlet weak var laterButton: UIButton!
  
  //Appstore
  @IBOutlet weak var appStoreView: UIView!
  @IBOutlet weak var rateAppStoreLabel: UILabel!
  @IBOutlet weak var rateAppStoreButton: UIButton!
  @IBOutlet weak var rateAppStoreLater: UIButton!
  
  //Feedback
  @IBOutlet weak var feedbackView: UIView!
  @IBOutlet weak var thankYouLabel: UILabel!
  @IBOutlet weak var noFeedbackButton: UIButton!
  @IBOutlet weak var yesFeedbackButton: UIButton!
  
  //Thank you
  @IBOutlet weak var thankView: UIView!
  
  @IBAction func rateClicked(_ sender: Any) {
    UserDefaults.standard.set(rateBar.rating, forKey: RatingController.kRating)
    appStoreView.isHidden = false
    roundContainerHeight.constant = 250
    UIView.animate(withDuration: 0.5, animations: {
      self.roundContainer.layoutIfNeeded()
    })
  }
  
  @IBAction func rateAppStore(_ sender: Any) {
    if let link = URL(string: Constants.appUrl) {
      if UIApplication.shared.canOpenURL(link) {
        thanks(url: link)
      }
    }
  }
  
  override func viewDidLoad() {
    feedbackView.isHidden = true
    appStoreView.isHidden = true
    thankView.isHidden = true
    let labelFont = R.font.sfProTextRegular(size: 24)
    let buttonFont = R.font.sfProTextSemibold(size: 14)
    
    thankYouLabel.font = labelFont
    rateButton.titleLabel?.font = buttonFont
    laterButton.titleLabel?.font = buttonFont
    rateAppStoreLater.titleLabel?.font = buttonFont
    rateAppStoreButton.titleLabel?.font = buttonFont
    noFeedbackButton.titleLabel?.font = buttonFont
    yesFeedbackButton.titleLabel?.font = buttonFont
    
    if let oldRating = UserDefaults.standard.value(forKey: RatingController.kRating) as? Int {
      rateBar.rating = oldRating
    }
    
    rateUsLabel.text = R.string.localizable.how_would_you_rate(Constants.appName)
    rateUsLabel.font = R.font.sfProTextSemibold(size: 18)
    rateAppStoreLabel.font = R.font.sfProTextSemibold(size: 18)
  }
  
  private func closePopup() {
    dismiss(animated: true, completion: nil)
  }
  
  private func thanks(url: URL) {
    UIApplication.shared.open(url, options: [:], completionHandler: { _ in
      Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { timer in
        timer.invalidate()
        self.thankView.isHidden = false
      })
    })
  }
  
  @IBAction func outerViewTap(_ sender: Any) {
    closePopup()
  }
  
  @IBAction func noFeedbackClicked(_ sender: Any) {
    closePopup()
  }
  
  @IBAction func laterClicked(_ sender: Any) {
    closePopup()
  }
  
  @IBAction func thankViewClicked(_ sender: Any) {
    closePopup()
  }
  
  @IBAction func appStoreLaterClicked(_ sender: Any) {
    closePopup()
  }
  
  @IBAction func yesFeedbackClicked(_ sender: Any) {
    let mail = "mailto://\(Constants.contactEmail)?&subject=\(Constants.contactSubject)"
    if let url = URL(string: mail) {
      if UIApplication.shared.canOpenURL(url) {
        thanks(url: url)
      }
    }
  }
}
