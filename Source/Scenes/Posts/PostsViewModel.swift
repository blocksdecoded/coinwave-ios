//
//  PostsViewModel.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/19/18.
//  Copyright (c) 2018 makeuseof. All rights reserved.
//

import UIKit

class PostsViewModel: PostsBusinessLogic {
  
  // MARK: - Properties
  
  var worker: PostsWorkerLogic
  var posts: [DisplayedPost]
  weak var view: PostsDisplayLogic?
  
  private var isLoadingNext = false
  
  // MARK: - Init
  
  init(worker: PostsWorkerLogic) {
    self.posts = [DisplayedPost]()
    self.worker = worker
  }
  
  // MARK: - Business Logic
  
  func fetchPosts() {
    worker = PostsWorker()
    worker.fetchPosts(completion: { result in
      switch result {
      case .success(let posts):
        self.posts = self.transform(posts)
        self.view?.displayPosts()
      case .failure(let error):
        self.view?.displayError(error.localizedDescription)
      }
    })
  }
  
  func getPost(for index: Int) -> DisplayedPost {
    let post = posts[index]
    
    if index + 3 >= posts.count - 1 && !isLoadingNext {
      fetchNextPosts()
    }
    
    return post
  }
  
  private func fetchNextPosts() {
    guard let lastPost = posts.last else {
      return
    }
    
    if isLoadingNext {
      return
    }
    
    isLoadingNext = true
    worker = PostsWorker()
    worker.fetchNextPosts(date: lastPost.date, completion: { result in
      self.isLoadingNext = false
      switch result {
      case .success(let posts):
        let nextPosts = self.transform(posts)
        let start = posts.count
        let offset = nextPosts.count
        self.posts.append(contentsOf: nextPosts)
        print("\(start) \(offset)")
        self.view?.displayNextPosts(start: start, end: start + offset)
      case .failure(let error):
        self.view?.displayError(error.localizedDescription)
      }
    })
  }
  
  private func transform(_ posts: [Post]) -> [DisplayedPost] {
    return posts.map { DisplayedPost(identifier: $0.id, title: $0.title, image: $0.image, date: $0.date, url: $0.url) }
  }
  
}
