//
//  TrailerViewController.swift
//  Movies
//
//  Created by Anton Petrov on 19.10.2023.
//

import UIKit
import WebKit

final class TrailerViewController: UIViewController {
    // MARK: - UI Elements

    private let activityIndicator = UIActivityIndicatorView(style: .large).configure {
        $0.color = .label
        $0.hidesWhenStopped = true
        $0.startAnimating()
    }

    private let webView = WKWebView().configure {
        $0.isOpaque = false
        $0.backgroundColor = .clear
        $0.scrollView.backgroundColor = .clear
        $0.scrollView.bounces = false
        $0.scrollView.isMultipleTouchEnabled = false
        $0.scrollView.bouncesZoom = false
    }

    // MARK: - Properties

    private let url: URL

    // MARK: - Initialization

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = LocalizedKey.trailerSceneTitle.localizedString
        setupWebView()
        setupBlur()
        setupCloseButton()
    }

    // MARK: - Setup

    private func setupWebView() {
        view.addSubview(webView)
        webView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                       left: view.leftAnchor,
                       bottom: view.bottomAnchor,
                       right: view.rightAnchor)
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        webView.navigationDelegate = self
        webView.addSubview(activityIndicator)
        activityIndicator.fillSuperview()
    }
}

// MARK: - WKNavigationDelegate

extension TrailerViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
}
