//
//  PostsWorker.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/19/18.
//  Copyright (c) 2018 makeuseof. All rights reserved.
//

import UIKit

class PostsWorker: PostsWorkerLogic {
  func fetchPosts(completion: @escaping (Result<[Post], CWError>) -> Void) {
    DispatchQueue.global(qos: .background).async {
      let postsNetworkManager = PostsNetworkManager()
      postsNetworkManager.fetchPosts { result in
        DispatchQueue.main.async {
          completion(result)
        }
      }
    }
  }
  
  func fetchNextPosts(date: String, completion: @escaping (Result<[Post], CWError>) -> Void) {
    DispatchQueue.global(qos: .background).async {
      let postsNetworkManager = PostsNetworkManager()
      postsNetworkManager.fetchNextPosts(date: date) { result in
        DispatchQueue.main.async {
          completion(result)
        }
      }
    }
  }
}
