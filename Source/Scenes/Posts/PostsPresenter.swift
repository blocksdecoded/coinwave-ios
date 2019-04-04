//
//  PostsPresenter.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/19/18.
//  Copyright (c) 2018 makeuseof. All rights reserved.
//

import UIKit

protocol PostsPresentationLogic {
  func presentPosts(response: Posts.FetchPosts.Response)
  func presentNextPosts(response: Posts.FetchPosts.Response)
  func presentError(_ error: NMError)
}

class PostsPresenter: PostsPresentationLogic {
  weak var viewController: PostsDisplayLogic?
  
  func presentPosts(response: Posts.FetchPosts.Response) {
    let displayedPosts = response.posts.map {
      Posts.FetchPosts.ViewModel.DisplayedPost(id: $0.id, title: $0.title, image: $0.image, date: $0.date, url: $0.url)
    }
    let viewModel = Posts.FetchPosts.ViewModel(displayedPosts: displayedPosts)
    viewController?.displayPosts(viewModel: viewModel)
  }
  
  func presentNextPosts(response: Posts.FetchPosts.Response) {
    let displayedPosts = response.posts.map {
      Posts.FetchPosts.ViewModel.DisplayedPost(id: $0.id, title: $0.title, image: $0.image, date: $0.date, url: $0.url)
    }
    let viewModel = Posts.FetchPosts.ViewModel(displayedPosts: displayedPosts)
    viewController?.displayNextPosts(viewModel: viewModel)
  }
  
  func presentError(_ error: NMError) {
    viewController?.displayError("You are currently offline.\nCheck your internet connection")
  }
}
