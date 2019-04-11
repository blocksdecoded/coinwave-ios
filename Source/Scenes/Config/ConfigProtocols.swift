//
//  ConfigProtocols.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 4/11/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

protocol ConfigDisplayLogic: class {
  var viewModel: ConfigBusinessLogic { get set }
  
  func displayMainScreen()
  func displayError(_ error: String)
}

protocol ConfigBusinessLogic {
  var view: ConfigDisplayLogic? { get set }
  var worker: ConfigWorkerLogic { get set }
  
  func viewDidLoad()
}

protocol ConfigWorkerLogic {
  func getConfig(completion: @escaping (Result<Bootstrap, CWError>) -> Void)
}
