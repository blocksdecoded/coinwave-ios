//
//  PostsViewController.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/19/18.
//  Copyright (c) 2018 makeuseof. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol PostsDisplayLogic: class {
  func displayPosts(viewModel: Posts.FetchPosts.ViewModel)
  func displayNextPosts(viewModel: Posts.FetchPosts.ViewModel)
}

class PostsViewController: UIViewController, PostsDisplayLogic {
  var interactor: PostsBusinessLogic?
  var router: (NSObjectProtocol & PostsRoutingLogic & PostsDataPassing)?
  
  var posts: [Posts.FetchPosts.ViewModel.DisplayedPost]?

  private lazy var postsTable: UITableView = {
    let postTable = UITableView()
    postTable.translatesAutoresizingMaskIntoConstraints = false
    postTable.delegate = self
    postTable.dataSource = self
    postTable.prefetchDataSource = self
    postTable.register(PostsTableViewCell.self, forCellReuseIdentifier: PostsTableViewCell.reuseID)
    postTable.rowHeight = 200
    return postTable
  }()
  
  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup() {
    let viewController = self
    let interactor = PostsInteractor()
    let presenter = PostsPresenter()
    let router = PostsRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  private func setupViews() {
    view.addSubview(postsTable)
  }
  
  private func setupConstraints() {
    let postsTableC = [
      postsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      postsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      postsTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      postsTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
    ]
    
    NSLayoutConstraint.activate(postsTableC)
  }
  
  // MARK: Routing
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupConstraints()
    loadPosts()
  }
  
  private func loadPosts() {
    interactor?.fetchPosts()
  }
  
  func displayPosts(viewModel: Posts.FetchPosts.ViewModel) {
    posts = viewModel.displayedPosts
    postsTable.reloadData()
  }
  
  func displayNextPosts(viewModel: Posts.FetchPosts.ViewModel) {
    guard
      let oldCount = posts?.count else {
      posts = viewModel.displayedPosts
      postsTable.reloadData()
      return
    }
    
    posts?.append(contentsOf: viewModel.displayedPosts)
    var insertingIndexes = [IndexPath]()
    
    for index in oldCount..<posts!.count {
      insertingIndexes.append(IndexPath(row: index, section: 0))
    }
    
    postsTable.insertRows(at: insertingIndexes, with: .bottom)
    
  }
  
  private func loadNextPosts() {
    guard let post = posts?.last else {
      return
    }
    
    interactor?.fetchNextPosts(request: Posts.FetchPosts.Request(date: post.date))
  }
}

extension PostsViewController: UITableViewDelegate & UITableViewDataSource & UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: PostsTableViewCell.reuseID)
      as? PostsTableViewCell else {
      fatalError("\(PostsTableViewCell.self) not registered")
    }
    
    guard let post = posts?[indexPath.row] else {
      fatalError("no post for \(indexPath.row)")
    }
    
    if indexPath.row == posts!.count - 1 {
      loadNextPosts()
    }
    
    cell.onBind(post)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    
  }
  
  func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
    
  }
}
