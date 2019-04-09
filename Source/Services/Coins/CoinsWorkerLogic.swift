//
//  CoinsWorkerLogic.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 4/9/19.
//  Copyright © 2019 makeuseof. All rights reserved.
//

protocol CoinsWorkerLogic {
  func fetchCoins(_ sortable: Sortable,
                  force: Bool,
                  local: @escaping (Result<[CRCoin], CWError>) -> Void,
                  remote: @escaping (Result<[CRCoin], CWError>) -> Void)
  func fetchCoin(_ coinId: Int, force: Bool, _ completion: @escaping (Result<CRCoin, CWError>) -> Void)
  func fetchWatchlist(_ sortable: Sortable, force: Bool, _ completion: @escaping (Result<[CRCoin], CWError>) -> Void)
  func fetchFavorite(force: Bool, _ completion: @escaping (Result<CRCoin, CWError>) -> Void)
  func setFavorite(_ coin: CRCoin) -> Result<Bool, DSError>
  func update(_ coin: CRCoin) -> Result<Bool, DSError>
}
