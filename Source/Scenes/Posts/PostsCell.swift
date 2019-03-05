//
//  PostsTableViewCell.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/20/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import UIKit
import Kingfisher

protocol PostsCellDelegate: class {
  func onReadMore(_ cell: PostsCell)
}

class PostsCell: UICollectionViewCell {
  static var reuseID: String {
    return String(describing: self)
  }
  
  weak var delegate: PostsCellDelegate?
  
  private let readBtnWidth: CGFloat = 100
  private let readBtnHeight: CGFloat = 40
  private let widgets = WidgetFactory()
  private var backGradientView: UIView?
  
  private lazy var paragraphStyle: NSMutableParagraphStyle = {
    let paragraph = NSMutableParagraphStyle()
    paragraph.lineSpacing = 1
    return paragraph
  }()
  
  private lazy var bdLogo: UIImageView = {
    let image = UIImage(named: "post_background_icon")
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = image
    imageView.contentMode = .scaleAspectFit
    imageView.alpha = 0.6
    return imageView
  }()
  
  private lazy var postTitle: UILabel = {
    let title = UILabel()
    title.translatesAutoresizingMaskIntoConstraints = false
    title.textColor = .white
    title.font = UIFont(name: Constants.Fonts.bold, size: 14)
    title.numberOfLines = 0
    title.lineBreakMode = .byWordWrapping
    title.textAlignment = .left
    return title
  }()
  
  private lazy var postImage: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    return image
  }()
  
  private lazy var imageMask: UIView = {
    let mask = UIView()
    mask.translatesAutoresizingMaskIntoConstraints = false
    mask.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    return mask
  }()
  
  private lazy var readBtn: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate), for: .normal)
    button.imageView?.tintColor = UIColor(red: 18.0/255.0, green: 23.0/255.0, blue: 28.0/255.0, alpha: 1.0)
    button.setTitle("Read more", for: .normal)
    button.titleLabel?.font = UIFont(name: Constants.Fonts.regular, size: 10)
    button.setTitleColor(UIColor(red: 18.0/255.0, green: 23.0/255.0, blue: 28.0/255.0, alpha: 1.0), for: .normal)
    
    button.layer.cornerRadius = readBtnHeight / 2
    
    let gradient = CAGradientLayer()
    gradient.colors = [UIColor(red: 29.0/255.0, green: 196.0/255.0, blue: 233.0/255.0, alpha: 1.0).cgColor,
                       UIColor(red: 29.0/255.0, green: 233.0/255.0, blue: 182.0/255.0, alpha: 1.0).cgColor]
    gradient.startPoint = CGPoint(x: 0, y: 0.5)
    gradient.endPoint = CGPoint(x: 1, y: 0.5)
    
    gradient.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: readBtnWidth, height: readBtnHeight))
    button.layer.insertSublayer(gradient, at: 0)
    
    button.layer.masksToBounds = true
    
    button.bringSubviewToFront(button.imageView!)
    
    button.semanticContentAttribute = UIApplication.shared
      .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
    
    button.addTarget(self, action: #selector(readClicked), for: .touchUpInside)
    
    button.imageEdgeInsets = UIEdgeInsets(top: 0.5, left: 2.5, bottom: -0.5, right: -2.5)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -2.5, bottom: 0, right: 2.5)
    
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Life cycle
  
  override func prepareForReuse() {
    postTitle.text = "Default text"
    postImage.image = nil
    setGradientBackground()
  }
  
  // MARK: Setup cell
  
  private func setup() {
    setGradientBackground()
    setupViews()
    setupConstraints()
  }
  
  private func setupViews() {
    contentView.addSubview(bdLogo)
    contentView.addSubview(postImage)
    contentView.addSubview(imageMask)
    contentView.addSubview(postTitle)
    contentView.addSubview(readBtn)
  }
  
  private func setupConstraints() {
    let titleC = [
      postTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
      readBtn.leadingAnchor.constraint(equalTo: postTitle.trailingAnchor, constant: 20),
      postTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      contentView.bottomAnchor.constraint(equalTo: postTitle.bottomAnchor, constant: 16)
    ]
    
    let readBtnC = [
      readBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      contentView.trailingAnchor.constraint(equalTo: readBtn.trailingAnchor, constant: 20),
      readBtn.widthAnchor.constraint(equalToConstant: readBtnWidth),
      readBtn.heightAnchor.constraint(equalToConstant: readBtnHeight)
    ]
    
    let imageC = [
      postImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      postImage.topAnchor.constraint(equalTo: contentView.topAnchor),
      contentView.trailingAnchor.constraint(equalTo: postImage.trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: postImage.bottomAnchor)
    ]
    
    let imageMaskC = [
      imageMask.leadingAnchor.constraint(equalTo: postImage.leadingAnchor),
      imageMask.trailingAnchor.constraint(equalTo: postImage.trailingAnchor),
      imageMask.topAnchor.constraint(equalTo: postImage.topAnchor),
      imageMask.bottomAnchor.constraint(equalTo: postImage.bottomAnchor)
    ]
    
    let bdLogoC = [
      bdLogo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
      contentView.bottomAnchor.constraint(equalTo: bdLogo.bottomAnchor, constant: 20),
      bdLogo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      contentView.trailingAnchor.constraint(equalTo: bdLogo.trailingAnchor, constant: 20)
    ]
    
    NSLayoutConstraint.activate(titleC + imageC + imageMaskC + bdLogoC + readBtnC)
  }
  
  func onBind(_ post: Posts.FetchPosts.ViewModel.DisplayedPost) {
    postTitle.attributedText = NSMutableAttributedString(string: post.title,
                                                         attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    
    guard let imageUrl = post.image?.image else {
      return
    }

    postImage.kf.setImage(with: URL(string: imageUrl))
  }
  
  private func setGradientBackground() {
    if backGradientView != nil {
      backGradientView!.removeFromSuperview()
      backGradientView = nil
    }
    
    backGradientView = widgets.setGradientToCell(view: contentView)
  }
  
  @objc private func readClicked() {
    delegate?.onReadMore(self)
  }
}
