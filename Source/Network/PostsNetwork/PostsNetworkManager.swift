//
//  PostsNetworkManager.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/19/18.
//  Copyright © 2018 makeuseof. All rights reserved.
//

import Foundation

class PostsNetworkManager: NetworkManager {
  private let router = Router<PostsApi>()
  
  func fetchPosts(completion: @escaping(_ posts: [Post]?, _ error: String?) -> Void) {
    router.request(.list) { data, response, error in
      if error != nil {
        completion(nil, "Please check your network connection")
      }
      
      if let response = response as? HTTPURLResponse {
        let result = self.handleNetworkResponse(response)
        switch result {
        case .success:
          guard let responseData = data else {
            completion(nil, NetworkResponse.noData.rawValue)
            return
          }
          
          do {
            let apiResponse = try JSONDecoder().decode(PostsList.self, from: responseData)
            completion(apiResponse.posts, nil)
          } catch {
            completion(nil, NetworkResponse.unableToDecode.rawValue)
          }
        case .failure(let networkFailureError):
          completion(nil, networkFailureError)
        }
      }
    }
  }
  
  func fetchNextPosts(date: String, completion: @escaping(_ posts: [Post]?, _ error: String?) -> Void) {
    router.request(.next(date)) { data, response, error in
      if error != nil {
        completion(nil, "Please check your network connection")
      }
      
      if let response = response as? HTTPURLResponse {
        let result = self.handleNetworkResponse(response)
        switch result {
        case .success:
          guard let responseData = data else {
            completion(nil, NetworkResponse.noData.rawValue)
            return
          }
          
          do {
            let apiResponse = try JSONDecoder().decode(PostsList.self, from: responseData)
            completion(apiResponse.posts, nil)
          } catch {
            completion(nil, NetworkResponse.unableToDecode.rawValue)
          }
        case .failure(let networkFailureError):
          completion(nil, networkFailureError)
        }
      }
    }
  }
}
