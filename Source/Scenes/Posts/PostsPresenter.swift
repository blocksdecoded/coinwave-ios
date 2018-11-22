//
//  PostsPresenter.swift
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

protocol PostsPresentationLogic {
  func presentPosts(response: Posts.FetchPosts.Response)
  func presentNextPosts(response: Posts.FetchPosts.Response)
}

class PostsPresenter: PostsPresentationLogic {
  weak var viewController: PostsDisplayLogic?
  
  func presentPosts(response: Posts.FetchPosts.Response) {
    let displayedPosts = response.posts.map {
      Posts.FetchPosts.ViewModel.DisplayedPost(id: $0.id, title: $0.title, image: $0.image, date: $0.date)
    }
    let viewModel = Posts.FetchPosts.ViewModel(displayedPosts: displayedPosts)
    viewController?.displayPosts(viewModel: viewModel)
  }
  
  func presentNextPosts(response: Posts.FetchPosts.Response) {
    let displayedPosts = response.posts.map {
      Posts.FetchPosts.ViewModel.DisplayedPost(id: $0.id, title: $0.title, image: $0.image, date: $0.date)
    }
    let viewModel = Posts.FetchPosts.ViewModel(displayedPosts: displayedPosts)
    viewController?.displayNextPosts(viewModel: viewModel)
  }
}