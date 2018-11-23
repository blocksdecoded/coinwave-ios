//
//  PostPreviewPresenter.swift
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

protocol PostPreviewPresentationLogic {
  func presentSomething(response: PostPreview.Something.Response)
}

class PostPreviewPresenter: PostPreviewPresentationLogic {
  weak var viewController: PostPreviewDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: PostPreview.Something.Response) {
    guard let html = response.post.html else {
      return
    }
    
    let viewModel = PostPreview.Something.ViewModel(html: html, url: response.post.url)
    viewController?.displaySomething(viewModel: viewModel)
  }
}
