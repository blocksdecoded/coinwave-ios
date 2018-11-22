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
}

struct PostsList: Codable {
  let posts: [Post]
}
