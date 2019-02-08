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
import SafariServices

protocol PostsDisplayLogic: class {
  func displayPosts(viewModel: Posts.FetchPosts.ViewModel)
  func displayNextPosts(viewModel: Posts.FetchPosts.ViewModel)
}

class PostsViewController: UIViewController, PostsDisplayLogic {
  var interactor: PostsBusinessLogic?
  var router: (NSObjectProtocol & PostsRoutingLogic & PostsDataPassing)?
  
  var posts: [Posts.FetchPosts.ViewModel.DisplayedPost]?
  
  override var prefersStatusBarHidden: Bool {
    return true
  }

  private lazy var postsList: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0.5
    let postTable = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    postTable.backgroundColor = .clear
    postTable.translatesAutoresizingMaskIntoConstraints = false
    postTable.delegate = self
    postTable.dataSource = self
    postTable.register(PostsCell.self, forCellWithReuseIdentifier: PostsCell.reuseID)
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
    let factory = WidgetFactory()
    factory.setGradientTo(view: view)
    view.addSubview(postsList)
  }
  
  private func setupConstraints() {
    let postsTableC = [
      postsList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      postsList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      postsList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      postsList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
    ]
    
    NSLayoutConstraint.activate(postsTableC)
  }
  
  // MARK: Routing
  
  private func openPost(index: Int) {
    if let url = URL(string: posts![index].url) {
      let webVC = SFSafariViewController(url: url)
      webVC.delegate = self
      present(webVC, animated: true, completion: nil)
    }
  }
  
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
    postsList.reloadData()
  }
  
  func displayNextPosts(viewModel: Posts.FetchPosts.ViewModel) {    
    guard let oldCount = posts?.count else {
      posts = viewModel.displayedPosts
      postsList.reloadData()
      return
    }
    
    posts?.append(contentsOf: viewModel.displayedPosts)
    var insertingIndexes = [IndexPath]()
    
    for index in oldCount..<posts!.count {
      insertingIndexes.append(IndexPath(row: index, section: 0))
    }
    
    postsList.performBatchUpdates({
      postsList.insertItems(at: insertingIndexes)
    }, completion: nil)
  }
  
  private func loadNextPosts() {
    guard let post = posts?.last else {
      return
    }
    
    interactor?.fetchNextPosts(request: Posts.FetchPosts.Request(date: post.date))
  }
}

extension PostsViewController: UICollectionViewDelegateFlowLayout & UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return posts?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostsCell.reuseID,
                                                        for: indexPath) as? PostsCell else {
      fatalError("\(PostsCell.self) not registered")
    }
    
    guard let post = posts?[indexPath.row] else {
      fatalError("no post for \(indexPath.row)")
    }
    
    if indexPath.row + 3 >= posts!.count - 1 {
      loadNextPosts()
    }
    
    cell.onBind(post)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: 200)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    openPost(index: indexPath.row)
  }
}

extension PostsViewController: SFSafariViewControllerDelegate {
  func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    dismiss(animated: true, completion: nil)
  }
}
