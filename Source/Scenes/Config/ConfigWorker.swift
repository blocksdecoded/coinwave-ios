//
//  ConfigWorker.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 3/13/19.
//  Copyright (c) 2019 makeuseof. All rights reserved.
//

import UIKit

class ConfigWorker: ConfigWorkerLogic {
  func getConfig(completion: @escaping (Result<Bootstrap, CWError>) -> Void) {    
    ConfigNetworkManager().getConfig(completion)
  }
}
