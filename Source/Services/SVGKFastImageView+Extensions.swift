//
//  SVGKFastImageView+Extensions.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 3/12/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

//import UIKit
//import Foundation
import SVGKit

extension SVGKFastImageView {
  func load(_ iconUrl: String) -> URLSessionTask? {
    if let svgData = DataCache.shared.read(for: iconUrl) {
      image = SVGKImage(data: svgData)
    } else {
      guard let url = URL(string: iconUrl) else {
        fatalError()
      }
      let request = URLRequest(url: url,
                               cachePolicy: .reloadRevalidatingCacheData,
                               timeoutInterval: 60 * 60 * 24 * 7)
      let session = URLSession.shared
      let task = session.dataTask(with: request, completionHandler: { data, response, _ in
        guard let response = response as? HTTPURLResponse else {
          return
        }
        
        if response.statusCode == 200 && data != nil {
          DataCache.shared.write(data: data!, for: iconUrl)
          DispatchQueue.main.async {
            self.image = SVGKImage(data: data!)
          }
        }
      })
      task.resume()
      return task
    }
    return nil
  }
}
