//
//  FontSelectorView.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/23/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import UIKit

protocol FontSelectorViewDelegate: class {
  func fontSizeValueDidChanged(_ size: Float)
  func fontSelectorViewDidDismiss()
}

class FontSelectorView: UIView {
  
  var fontSize: Float = 0
  
  private let topOffset: CGFloat = 50
  private let sliderStep: Float = 100
  private let fontSizeRange = [-200, -190, -110, -100, -90, -10, 0,
                                200, 190, 110, 100, 90, 10]
  
  weak var delegate: FontSelectorViewDelegate?
  
  private lazy var rightLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 28)
    label.textColor = .white
    label.textAlignment = .center
    label.text = "A"
    return label
  }()
  
  private lazy var leftLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 22)
    label.textColor = .white
    label.textAlignment = .center
    label.text = "A"
    return label
  }()
  
  private lazy var slider: UISlider = {
    let slider = UISlider()
    slider.translatesAutoresizingMaskIntoConstraints = false
    slider.minimumValue = -200
    slider.maximumValue = 200
    slider.isContinuous = true
    slider.minimumTrackTintColor = .white
    slider.maximumTrackTintColor = .white
    slider.setThumbImage(UIImage(named: "knob"), for: .normal)
    slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    slider.setValue(fontSize * sliderStep, animated: false)
    return slider
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  private func setup() {
    backgroundColor = .clear
  }
  
  func presentView(fromView: UIView, animated: Bool) {
    fromView.addSubview(self)
    fromView.bringSubviewToFront(self)
    UIView.animate(withDuration: 0.3, animations: {
      self.backgroundColor = UIColor.black.withAlphaComponent(0.35)
      self.setupViews()
      self.setupConstraints()
    })
  }
  
  func dismiss() {
    UIView.animate(withDuration: 0.3, animations: {
      self.backgroundColor = UIColor.clear
      self.alpha = 0.0
    }, completion: { _ in
      self.delegate?.fontSelectorViewDidDismiss()
      self.removeFromSuperview()
    })
  }
  
  private func setupViews() {
    addSubview(rightLabel)
    addSubview(leftLabel)
    addSubview(slider)
  }
  
  private func setupConstraints() {
    let rightLabelC = [
      rightLabel.topAnchor.constraint(equalTo: topAnchor, constant: topOffset),
      trailingAnchor.constraint(equalTo: rightLabel.trailingAnchor, constant: 16)
    ]
    
    let leftLabelC = [
      leftLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      leftLabel.centerYAnchor.constraint(equalTo: rightLabel.centerYAnchor)
    ]
    
    let sliderC = [
      slider.leadingAnchor.constraint(equalTo: leftLabel.trailingAnchor, constant: 4),
      rightLabel.leadingAnchor.constraint(equalTo: slider.trailingAnchor, constant: 4),
      slider.centerYAnchor.constraint(equalTo: rightLabel.centerYAnchor)
    ]
    
    NSLayoutConstraint.activate(rightLabelC + leftLabelC + sliderC)
  }
  
  @objc private func sliderValueChanged() {
    let step: Float = 10
    let value = roundf(slider.value / step) * step
    slider.setValue(value, animated: true)
    if fontSizeRange.contains(Int(slider.value)) {
      let newFontSize = slider.value / 100
      if newFontSize != fontSize {
        fontSize = newFontSize
        delegate?.fontSizeValueDidChanged(newFontSize)
      }
    }
  }
  
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.7)
    if rect.contains(point) {
      return slider
    }
    
    dismiss()
    return nil
  }
}
