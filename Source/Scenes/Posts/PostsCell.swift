//
//  PostsTableViewCell.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/20/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import UIKit
import Kingfisher

class PostsCell: UICollectionViewCell {
  static var reuseID: String {
    return String(describing: self)
  }
  
  private lazy var postTitle: UILabel = {
    let title = UILabel()
    title.translatesAutoresizingMaskIntoConstraints = false
    title.textColor = .white
    title.font = UIFont(name: Constants.Fonts.heavy, size: 20)
    title.numberOfLines = 0
    title.textAlignment = .center
    return title
  }()
  
  private lazy var postImage: UIImageView = {
    let image = UIImageView()
    image.contentMode = .scaleAspectFit
    image.translatesAutoresizingMaskIntoConstraints = false
    return image
  }()
  
  private lazy var imageMask: UIView = {
    let mask = UIView()
    mask.translatesAutoresizingMaskIntoConstraints = false
    mask.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    return mask
  }()
  
  private lazy var underline: UIView = {
    let line = UIView()
    line.translatesAutoresizingMaskIntoConstraints = false
    line.backgroundColor = UIColor.white.withAlphaComponent(0.5)
    return line
  }()
  
  let underlineWidth: CGFloat
  
  override init(frame: CGRect) {
    underlineWidth = frame.width / 3
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    underlineWidth = 100
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Life cycle
  
  override func prepareForReuse() {
    postTitle.text = "Default text"
    postImage.image = nil
  }
  
  // MARK: Setup cell
  
  private func setup() {
    backgroundColor = UIColor.white
    setupViews()
    setupConstraints()
  }
  
  private func setupViews() {
    contentView.addSubview(postImage)
    contentView.addSubview(imageMask)
    contentView.addSubview(underline)
    contentView.addSubview(postTitle)
  }
  
  private func setupConstraints() {
    let titleC = [
      postTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      contentView.trailingAnchor.constraint(equalTo: postTitle.trailingAnchor, constant: 16),
      postTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ]
    
    let imageC = [
      postImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      postImage.topAnchor.constraint(equalTo: contentView.topAnchor),
      trailingAnchor.constraint(equalTo: postImage.trailingAnchor),
      bottomAnchor.constraint(equalTo: postImage.bottomAnchor)
    ]
    
    let imageMaskC = [
      imageMask.leadingAnchor.constraint(equalTo: postImage.leadingAnchor),
      imageMask.trailingAnchor.constraint(equalTo: postImage.trailingAnchor),
      imageMask.topAnchor.constraint(equalTo: postImage.topAnchor),
      imageMask.bottomAnchor.constraint(equalTo: postImage.bottomAnchor)
    ]
    
    let underlineC = [
      underline.centerXAnchor.constraint(equalTo: postTitle.centerXAnchor),
      underline.topAnchor.constraint(equalTo: postTitle.bottomAnchor, constant: 4),
      underline.heightAnchor.constraint(equalToConstant: 3),
      underline.widthAnchor.constraint(equalToConstant: underlineWidth)
    ]
    
    NSLayoutConstraint.activate(titleC + imageC + imageMaskC + underlineC)
    
    contentView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      contentView.heightAnchor.constraint(equalToConstant: 200),
      contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
      ])
  }
  
  func onBind(_ post: Posts.FetchPosts.ViewModel.DisplayedPost) {
    postTitle.text = post.title.uppercased()
    
    guard let imageUrl = post.image?.image else {
      return
    }

    postImage.kf.setImage(with: URL(string: imageUrl))
  }
}
