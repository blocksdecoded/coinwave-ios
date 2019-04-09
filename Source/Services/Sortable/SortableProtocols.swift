//
//  SortableProtocols.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 4/9/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

protocol SortableDisplayLogic {
  var screenName: String { get }
  
  func setSort(sortable: Sortable)
}

protocol SortableBusinessLogic {
  var sortable: Sortable { get set }
  var sortableWorker: SortableWorkerLogic { get set }
  
  func getInitialSort(screen: String)
}

protocol SortableWorkerLogic {
  func getSortConfig(screen: String) -> Sortable
  func setSortConfig(screen: String, sortable: Sortable)
}
