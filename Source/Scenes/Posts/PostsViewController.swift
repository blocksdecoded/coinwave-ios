//
//  PostsViewController.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/19/18.
//  Copyright (c) 2018 makeuseof. All rights reserved.
//

import UIKit
import SafariServices
import NVActivityIndicatorView

class PostsViewController: UIViewController, PostsDisplayLogic {
  static func instance() -> PostsViewController {
    let worker = PostsWorker()
    let viewModel = PostsViewModel(worker: worker)
    let view = PostsViewController(viewModel: viewModel)
    viewModel.view = view
    return view
  }
  
  // MARK: - Properties
  
  weak var sideMenuDelegate: SideMenuDelegate?
  var viewModel: PostsBusinessLogic
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: - Views
  
  private lazy var loadingView: NVActivityIndicatorView = {
    let view = NVActivityIndicatorView(frame: CGRect.zero, type: .circleStrokeSpin, color: .white, padding: nil)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var errorView: ErrorView = {
    let errorView = ErrorView(frame: CGRect.zero)
    errorView.delegate = self
    errorView.translatesAutoresizingMaskIntoConstraints = false
    return errorView
  }()
  
  private lazy var menuBtn: BDHamburger = {
    let button = BDHamburger.instance()
    button.addTarget(self, action: #selector(menuClicked), for: .touchUpInside)
    return button
  }()
  
  private lazy var refreshControl: UIRefreshControl = {
    let refresh = UIRefreshControl()
    refresh.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
    return refresh
  }()

  private lazy var postsList: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0.5
    layout.itemSize = CGSize(width: view.frame.width, height: UIScreen.main.bounds.height * 0.27)
    let postTable = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    postTable.backgroundColor = .clear
    postTable.translatesAutoresizingMaskIntoConstraints = false
    postTable.delegate = self
    postTable.dataSource = self
    postTable.register(PostsCell.self, forCellWithReuseIdentifier: PostsCell.reuseID)
    postTable.refreshControl = refreshControl
    return postTable
  }()
  
  // MARK: - View Lifecycle
  
  init(viewModel: PostsBusinessLogic) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    setupTabBar()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    postsList.contentInset = UIEdgeInsets(top: -(view.safeAreaInsets.top), left: 0, bottom: 0, right: 0)
  }
  
  // MARK: Setup
  
  private func setupTabBar() {
    tabBarItem = UITabBarItem(title: "Posts", image: UIImage(named: "earth"), selectedImage: nil)
  }
  
  private func setupViews() {
    let factory = WidgetFactory()
    factory.setGradientTo(view: view)
    view.addSubview(postsList)
    view.addSubview(menuBtn)
    view.addSubview(loadingView)
    view.addSubview(errorView)
    errorView.isHidden = true
  }
  
  private func setupConstraints() {
    let postsTableC = [
      postsList.topAnchor.constraint(equalTo: view.topAnchor),
      postsList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      postsList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      postsList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
    ]
    
    let menuBtnC = [
      menuBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      menuBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50 - 12.5),
      menuBtn.heightAnchor.constraint(equalToConstant: 25),
      menuBtn.widthAnchor.constraint(equalToConstant: 25)
    ]
    
    let errorViewC = [
      errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ]
    
    let loadingViewC = [
      loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      loadingView.widthAnchor.constraint(equalToConstant: 50),
      loadingView.heightAnchor.constraint(equalToConstant: 50)
    ]
    
    NSLayoutConstraint.activate(postsTableC + menuBtnC + errorViewC + loadingViewC)
  }
  
  // MARK: Routing
  
  private func openPost(index: Int) {
    let webVC = SFSafariViewController(url: viewModel.posts[index].url)
    webVC.delegate = self
    present(webVC, animated: true, completion: nil)
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupConstraints()
    loadPosts()
  }
  
  private func loadPosts() {
    loadingView.isHidden = false
    loadingView.startAnimating()
    viewModel.fetchPosts()
  }
  
  func displayPosts() {
    refreshControl.endRefreshing()
    loadingView.stopAnimating()
    loadingView.isHidden = true
    postsList.reloadData()
  }
  
  func displayNextPosts(start: Int, end: Int) {
    var insertingIndexes = [IndexPath]()
    for index in start..<end {
      insertingIndexes.append(IndexPath(row: index, section: 0))
    }
    postsList.performBatchUpdates({
      UIView.setAnimationsEnabled(false)
      postsList.insertItems(at: insertingIndexes)
    }, completion: { _ in
      UIView.setAnimationsEnabled(true)
    })
  }
  
  func displayError(_ error: String) {
    errorView.isHidden = false
    postsList.isHidden = true
    loadingView.stopAnimating()
    loadingView.isHidden = true
    errorView.setText(error)
  }
  
  @objc private func menuClicked() {
    sideMenuDelegate?.openMenu()
  }
  
  @objc private func refreshTable() {
    viewModel.fetchPosts()
  }
}

extension PostsViewController: UICollectionViewDelegateFlowLayout & UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.posts.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostsCell.reuseID,
                                                        for: indexPath) as? PostsCell else {
      fatalError("\(PostsCell.self) not registered")
    }
    
    let post = viewModel.getPost(for: indexPath.row)
    cell.delegate = self
    cell.onBind(post)
    return cell
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

extension PostsViewController: PostsCellDelegate {
  func onReadMore(_ cell: PostsCell) {
    guard let index = postsList.indexPath(for: cell) else {
      return
    }
    
    openPost(index: index.row)
  }
}

extension PostsViewController: ErrorViewDelegate {
  func onRetry() {
    errorView.isHidden = true
    postsList.isHidden = false
    loadPosts()
  }
}
