//
//  SVGLoader.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 3/12/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Macaw

struct SVGLoader {
  static func load(_ url: URL, completion: @escaping (Node) -> Void) {
    if let svgData = DataCache.shared.read(for: url.absoluteString) {
      completion(svgView(data: svgData))
    } else {
      let request = URLRequest(url: url,
                               cachePolicy: .reloadRevalidatingCacheData,
                               timeoutInterval: 60 * 60 * 24 * 7)
      let session = URLSession.shared
      session.dataTask(with: request, completionHandler: { data, response, _ in
        guard let response = response as? HTTPURLResponse else {
          return
        }

        if response.statusCode == 200 && data != nil {
          DataCache.shared.write(data: data!, for: url.absoluteString)
          let node = self.svgView(data: data!)
          DispatchQueue.main.async {
            completion(node)
          }
        }
      }).resume()
    }
  }

  static private func svgView(data: Data) -> Node {
    let text = String(data: data, encoding: .utf8)!
    do {
      return try SVGParser.parse(text: text)
    } catch {
      fatalError()
    }
  }
}
