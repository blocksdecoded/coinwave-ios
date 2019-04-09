//
//  PostsProtocols.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 4/9/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

protocol PostsDisplayLogic: class {
  var viewModel: PostsBusinessLogic { get set }
  
  func displayPosts()
  func displayNextPosts(start: Int, end: Int)
  func displayError(_ error: String)
}

protocol PostsBusinessLogic {
  var view: PostsDisplayLogic? { get set }
  var posts: [DisplayedPost] { get set }
  var worker: PostsWorkerLogic { get set }
  
  func fetchPosts()
  func getPost(for index: Int) -> DisplayedPost
}

protocol PostsWorkerLogic {
  func fetchPosts(completion: @escaping (Result<[Post], CWError>) -> Void)
  func fetchNextPosts(date: String, completion: @escaping (Result<[Post], CWError>) -> Void)
}
