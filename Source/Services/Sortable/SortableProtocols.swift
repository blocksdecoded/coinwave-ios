//
//  SortableProtocols.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 4/9/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

protocol SortableDisplayLogic: class {
  var screenName: String { get set }
  var viewModel: SortableBusinessLogic { get set }
  
  func setSort(sortable: Sortable)
}

protocol SortableBusinessLogic {
  var view: SortableDisplayLogic? { get set }
  var sortable: Sortable { get set }
  var sortableWorker: SortableWorkerLogic { get set }
  
  mutating func getInitialSort(screen: String)
  func sortName(screen: String)
  func sortPrice(screen: String)
  func sortMarketCap(screen: String)
  func sortVolume(screen: String)
}

extension SortableBusinessLogic {
  mutating func getInitialSort(screen: String) {
    let sortable = sortableWorker.getSortConfig(screen: screen)
    self.sortable = sortable    
    self.view?.setSort(sortable: sortable)
  }
}

protocol SortableWorkerLogic {
  var defaultSort: Sortable { get }
  
  func getSortConfig(screen: String) -> Sortable
  func setSortConfig(screen: String, sortable: Sortable)
}
