//
//  ConfigViewModel.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 3/13/19.
//  Copyright (c) 2019 makeuseof. All rights reserved.
//

import UIKit

class ConfigViewModel: ConfigBusinessLogic {
  
  // MARK: - Properties
  
  weak var view: ConfigDisplayLogic?
  var worker: ConfigWorkerLogic
  
  // MARK: - Init
  
  init(worker: ConfigWorkerLogic) {
    self.worker = worker
  }
  
  // MARK: - Business Logic
  
  func fetchConfig() {
    worker.getConfig { result in
      switch result {
      case .success(let bootstrap):
        Constants.coinsBaseURL = bootstrap.servers[0].trimmingCharacters(in: ["/"])
        self.view?.displayMainScreen()
      case .failure(let error):
        switch error {
        case .noData:
          // TODO: Find error message if no remote servers
          self.view?.displayError(CWError.noData.localizedDescription)
        default:
          self.view?.displayError(error.localizedDescription)
        }
      }
    }
  }
}
