//
//  VRateBar.swift
//  WashMyCar
//
//  Created by admin on 3/9/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import UIKit

@IBDesignable
class VRateBar: UIStackView {
  // MARK: Properties
  private var ratingButtons = [UIButton]()
  var rating = 0 {
    didSet {
      updateButtonSelectionStates()
    }
  }
  
  @IBInspectable var starSize: CGSize = CGSize(width: 22.0, height: 22.0) {
    didSet {
      setup()
    }
  }
  @IBInspectable var starCount: Int = 5 {
    didSet {
      setup()
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  func setup() {
    spacing = 8
    
    // clear any existing buttons
    for button in ratingButtons {
      removeArrangedSubview(button)
      button.removeFromSuperview()
    }
    ratingButtons.removeAll()
    
    let emptyStar = UIImage(named: "star_empty")
    let filledStar = UIImage(named: "star_filled")
    
    for _ in 0..<starCount {
      let button = UIButton()
      
      // Set the button images
      button.setImage(emptyStar, for: .normal)
      button.setImage(filledStar, for: .selected)
      
      // Add constraints
      button.translatesAutoresizingMaskIntoConstraints = false
      button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
      button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true

      button.addTarget(self, action: #selector(ratingButtonTapped(button:)), for: .touchUpInside)
      // Add the button to the stack
      addArrangedSubview(button)
      ratingButtons.append(button)
    }
    updateButtonSelectionStates()
  }
  
  @objc func ratingButtonTapped(button: UIButton) {
    guard let index = ratingButtons.index(of: button) else {
      fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
    }
    
    // Calculate the rating of the selected button
    let selectedRating = index + 1
    
    if selectedRating == rating {
      // If the selected star represents the current rating, reset the rating to 0.
      rating = 0
    } else {
      // Otherwise set the rating to the selected star
      rating = selectedRating
    }
  }
  
  private func updateButtonSelectionStates() {
    for (index, button) in ratingButtons.enumerated() {
      // If the index of a button is less than the rating, that button should be selected.
      button.isSelected = index < rating
    }
  }
}
