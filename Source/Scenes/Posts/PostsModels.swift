//
//  PostsModels.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/19/18.
//  Copyright (c) 2018 makeuseof. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum Posts {
  // MARK: Use cases
  
  enum FetchPosts {
    // swiftlint:disable nesting
    struct Request {
      var date: String
    }
    
    struct Response {
      var posts: [Post]
    }
    
    struct ViewModel {
      struct DisplayedPost {
        // swiftlint:disable identifier_name
        let id: Int
        let title: String
        let image: FeaturedImage?
        let date: String
        let url: String
      }
      var displayedPosts: [DisplayedPost]
    }
  }
}
