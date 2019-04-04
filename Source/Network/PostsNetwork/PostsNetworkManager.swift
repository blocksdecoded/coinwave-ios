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
  
  func fetchPosts(completion: @escaping(Result<[Post], CWError>) -> Void) {
    fetch(endPoint: .list, completion: completion)
  }
  
  func fetchNextPosts(date: String, completion: @escaping(Result<[Post], CWError>) -> Void) {
    fetch(endPoint: .next(date), completion: completion)
  }
  
  private func fetch(endPoint: PostsApi, completion: @escaping(Result<[Post], CWError>) -> Void) {
    router.request(endPoint) { data, response, error in
      if error != nil {
        completion(.failure(.network))
      }
      
      if let response = response as? HTTPURLResponse {
        let result = self.handleNetworkResponse(response)
        switch result {
        case .success:
          guard let responseData = data else {
            completion(.failure(.noData))
            return
          }
          
          do {
            let apiResponse = try JSONDecoder().decode(PostsList.self, from: responseData)
            completion(.success(apiResponse.posts))
          } catch let error as DecodingError {
            self.decodingError(error)
            completion(.failure(.network))
          } catch {
            completion(.failure(.network))
          }
        case .failure(let networkFailureError):
          completion(.failure(networkFailureError))
        }
      }
    }
  }
}
