//
//  PostsTableViewCell.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/20/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import UIKit
import Kingfisher

class PostsTableViewCell: UITableViewCell {
  static var reuseID: String {
    return String(describing: self)
  }
  
  private lazy var postTitle: UILabel = {
    let title = UILabel()
    title.translatesAutoresizingMaskIntoConstraints = false
    title.textColor = .red
    title.numberOfLines = 0
    title.textAlignment = .center
    return title
  }()
  
  private lazy var postImage: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    return image
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
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
  }
  
  // MARK: Setup cell
  
  private func setup() {
    setupViews()
    setupConstraints()
  }
  
  private func setupViews() {
    separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    contentView.addSubview(postImage)
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
    
    NSLayoutConstraint.activate(titleC + imageC)
  }
  
  func onBind(_ post: Posts.FetchPosts.ViewModel.DisplayedPost) {
    postTitle.text = post.title
    
    guard let imageUrl = post.image?.featured else {
      return
    }
    
    postImage.kf.setImage(with: URL(string: imageUrl))
  }
}
