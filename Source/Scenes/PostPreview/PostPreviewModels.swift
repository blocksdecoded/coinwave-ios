//
//  PostPreviewModels.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/22/18.
//  Copyright (c) 2018 makeuseof. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum PostPreview {
  // MARK: Use cases
  
  enum Something {
    // swiftlint:disable nesting
    struct Request {
      let postID: Int
    }
    struct Response {
      let post: Post
    }
    struct ViewModel {
      let html: String
    }
  }
}
