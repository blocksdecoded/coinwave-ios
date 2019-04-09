//
//  SortableViewModel.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 4/9/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

import Foundation

class SortableViewModel: SortableBusinessLogic {
  static func instance() -> SortableViewModel {
    let worker = SortableWorker()
    return SortableViewModel(worker: worker)
  }
  
  weak var view: SortableDisplayLogic?
  var sortable: Sortable
  var sortableWorker: SortableWorkerLogic
  
  // MARK: - Init
  
  init(worker: SortableWorkerLogic) {
    sortable = worker.defaultSort
    sortableWorker = worker
  }
  
  // MARK: - Business Logic

  func sortName(screen: String) {
    sort(screen, .name)
  }
  
  func sortPrice(screen: String) {
    sort(screen, .price)
  }
  
  func sortMarketCap(screen: String) {
    sort(screen, .marketCap)
  }
  
  func sortVolume(screen: String) {
    sort(screen, .volume)
  }
  
  private func sort(_ screen: String, _ field: Sortable.Field) {
    sortable = Sortable(field: field, direction: sortable.direction == .asc ? .desc : .asc)
    sortableWorker.setSortConfig(screen: screen, sortable: sortable)
    view?.setSort(sortable: sortable)
  }
}
