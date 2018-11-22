//
//  Post.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/19/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation

struct Post: Codable {
  // swiftlint:disable identifier_name
  let id: Int
  let title: String
  let date: String
  let author: String
  let html: String?
  let url: String
  let image: FeaturedImage?
  let likes: Int
  let liked: Bool
  let categories: [Category]
  
  enum CodingKeys: String, CodingKey {
    // swiftlint:disable identifier_name
    case id = "ID"
    case title = "post_title"
    case date = "post_date"
    case author
    case html
    case url
    case image = "featured_image"
    case likes = "likes_count"
    case liked
    case categories
  }
  
  init(id: Int,
       title: String,
       date: String,
       author: String,
       html: String?,
       url: String,
       featured: String?,
       middle: String?,
       thumb: String?,
       likes: Int,
       liked: Bool,
       categories: [Category]) {
    self.init(id: id,
              title: title,
              date: date,
              author: author,
              html: html,
              url: url,
              image: FeaturedImage(featured: featured,
                                   middle: middle,
                                   thumb: thumb),
              likes: likes, liked: liked, categories: categories)
  }
  
  init(id: Int,
       title: String,
       date: String,
       author: String,
       html: String?,
       url: String,
       image: FeaturedImage?,
       likes: Int,
       liked: Bool,
       categories: [Category]) {
    self.id = id
    self.title = title
    self.date = date
    self.author = author
    self.html = html
    self.url = url
    self.image = image
    self.likes = likes
    self.liked = liked
    self.categories = categories
  }
}

struct FeaturedImage: Codable {
  let featured: String?
  let middle: String?
  let thumb: String?
  
  var image: String? {
    if featured != nil {
      return featured
    } else if middle != nil {
      return middle
    } else {
      return thumb
    }
  }
}

struct Category: Codable {
  // swiftlint:disable identifier_name
  let id: Int
  let title: String
  
  init(id: Int, title: String) {
    self.id = id
    self.title = title
  }
  
  init(id: Int64, title: String) {
    self.id = Int(id)
    self.title = title
  }
}

struct PostCategory {
  let postID: Int
  let categoryID: Int
}

struct PostsList: Codable {
  let posts: [Post]
}
