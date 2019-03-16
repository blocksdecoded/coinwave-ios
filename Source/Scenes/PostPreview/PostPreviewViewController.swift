//
//  PostPreviewViewController.swift
//  Cryptotracker
//
//  Created by Abai Abakirov on 11/22/18.
//  Copyright (c) 2018 makeuseof. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import WebKit
import SafariServices

protocol PostPreviewDisplayLogic: class {
  func displayPost(viewModel: PostPreview.LoadPost.ViewModel)
  func setPostFontSize(viewModel: PostPreview.ChangeFontSize.ViewModel)
}

class PostPreviewViewController: UIViewController, PostPreviewDisplayLogic {
  var interactor: PostPreviewBusinessLogic?
  var router: (NSObjectProtocol & PostPreviewRoutingLogic & PostPreviewDataPassing)?
  
  let postID: Int
  var shouldHandleScroll = false
  var navigationViewHidden = false
  var initialOffset: CGFloat = 0
  let delay: CGFloat = 60
  
  var postUrl: URL!
  var postFontSize: Float = 0
  
  var navigationViewTopConstraint = NSLayoutConstraint()
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  private lazy var webView: WKWebView = {
    let webConfiguration = WKWebViewConfiguration()
    webConfiguration.preferences.javaScriptEnabled = true
    let webView = WKWebView(frame: .zero, configuration: webConfiguration)
    webView.translatesAutoresizingMaskIntoConstraints = false
    webView.scrollView.delegate = self
    webView.navigationDelegate = self
    return webView
  }()
  
  private lazy var navigationView: PostNavigationView = {
    let view = PostNavigationView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.delegate = self
    return view
  }()

  // MARK: Object lifecycle
  
  init(postID: Int) {
    self.postID = postID
    super.init(nibName: nil, bundle: nil)
    setup()
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    self.postID = -1
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    self.postID = -1
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup() {
    let viewController = self
    let interactor = PostPreviewInteractor()
    let presenter = PostPreviewPresenter()
    let router = PostPreviewRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    setupViews()
    setupConstraints()
    fetchPost()
  }
  
  private func setupViews() {
    view.addSubview(webView)
    navigationView.presentView(fromView: view)
  }
  
  private func setupConstraints() {
    let webViewC = [
      webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ]
    
    navigationViewTopConstraint = view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: navigationView.topAnchor)
    
    let navigationC = [
      navigationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      navigationViewTopConstraint,
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: navigationView.trailingAnchor)
    ]
    
    NSLayoutConstraint.activate(webViewC + navigationC)
  }
  
  // MARK: Do something
  
  func fetchPost() {
    let request = PostPreview.LoadPost.Request(postID: postID)
    interactor?.fetchPost(request: request)
  }
  
  func displayPost(viewModel: PostPreview.LoadPost.ViewModel) {
    webView.loadHTMLString(viewModel.html, baseURL: nil)
    postUrl = viewModel.url
    postFontSize = viewModel.fontSize
  }
  
  func setPostFontSize(viewModel: PostPreview.ChangeFontSize.ViewModel) {
    postFontSize = viewModel.size
    applyFontSize(viewModel.size)
  }
  
  private func applyFontSize(_ size: Float) {
    let jsString = "setFontSize(\(size))"
    webView.evaluateJavaScript(jsString, completionHandler: nil)
  }
  
  private func animateNavigationView(_ shouldHide: Bool) {
    if !navigationViewHidden && !shouldHide {
      return
    }
    
    navigationViewHidden = shouldHide
    navigationViewTopConstraint.constant = shouldHide ? navigationView.frame.height + view.safeAreaInsets.top : 0
    UIView.animate(withDuration: 0.4, animations: {
      self.view.layoutIfNeeded()
    })
  }
  
  private func share() {
    let activityVC = UIActivityViewController(activityItems: [postUrl], applicationActivities: nil)
    present(activityVC, animated: true, completion: nil)
    if UI_USER_INTERFACE_IDIOM() == .pad {
      if let popOver = activityVC.popoverPresentationController {
        popOver.sourceView = navigationView
      }
    }
  }
}

extension PostPreviewViewController: PostNavigationViewDelegate {
  func postNavigationBackClicked() {
    navigationController?.popViewController(animated: true)
  }
  
  func postNavigationFontSizeClicked() {
    navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    let fontChangeView = FontSelectorView(frame: CGRect(x: 0,
                                                        y: 0,
                                                        width: UIScreen.main.bounds.width,
                                                        height: UIScreen.main.bounds.height))
    fontChangeView.delegate = self
    fontChangeView.fontSize = postFontSize
    fontChangeView.presentView(fromView: view, animated: true)
  }
  
  func postNavigationShareClicked() {
    share()
  }
}

extension PostPreviewViewController: FontSelectorViewDelegate {
  func fontSizeValueDidChanged(_ size: Float) {
    interactor?.changeFontSize(request: PostPreview.ChangeFontSize.Request(size: size))
  }
  
  func fontSelectorViewDidDismiss() {
    navigationController?.interactivePopGestureRecognizer?.isEnabled = true
  }
}

extension PostPreviewViewController: UIScrollViewDelegate {
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    shouldHandleScroll = true
    initialOffset = scrollView.contentOffset.y
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let yOffset = scrollView.contentOffset.y
    if yOffset == 0 {
      scrolledToTop()
    }
    
    if shouldHandleScroll {
      if yOffset > initialOffset {
        if yOffset - initialOffset > delay {
          scrolledToBottom()
          shouldHandleScroll = false
        }
      } else {
        scrolledToTop()
        shouldHandleScroll = false
      }
    }
  }
  
  func scrolledToTop() {
    animateNavigationView(false)
  }
  
  func scrolledToBottom() {
    animateNavigationView(true)
  }
}

extension PostPreviewViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    applyFontSize(postFontSize)
  }
  
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
               decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    if navigationAction.navigationType == .linkActivated {
      guard var url = navigationAction.request.url else {
        decisionHandler(.allow)
        return
      }
      
      if !url.absoluteString.contains("http:") && !url.absoluteString.contains("https:") {
        url = URL(string: "https:\(url.absoluteString)")!
      }
      
      let safariVC = SFSafariViewController(url: url)
      self.present(safariVC, animated: true, completion: nil)
      decisionHandler(.cancel)
      
    } else {
      decisionHandler(.allow)
    }
  }
}

extension PostPreviewViewController: UIGestureRecognizerDelegate {}
