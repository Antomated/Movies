//
//  TrailerViewController.swift
//  Movies
//
//  Created by Anton Petrov on 19.10.2023.
//

import WebKit
import UIKit

final class TrailerViewController: UIViewController {
    // MARK: - UI & properties

    private let webView = WKWebView().configure {
        $0.isOpaque = false
        $0.backgroundColor = .clear
        $0.scrollView.backgroundColor = .clear
    }
    private let urlString: String

    // MARK: - Initialization

    init(urlString: String) {
        self.urlString = urlString
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

    // MARK: - Actions

    // TODO: coordinator?
    @objc private func didTapCloseButton() {
        navigationController?.dismiss(animated: true)
    }

    // MARK: - Setup

    private func setupWebView() {
        guard let url = URL(string: urlString) else { return }
        view.addSubview(webView)
        webView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                       left: view.leftAnchor,
                       bottom: view.bottomAnchor,
                       right: view.rightAnchor)
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }

    private func setupBlur() {
        let blurEffect = UIBlurEffect(style: traitCollection.userInterfaceStyle == .dark ? .dark : .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 0)
    }

    private func setupCloseButton() {
        let item = UIBarButtonItem(barButtonSystemItem: .close,
                                   target: self,
                                   action: #selector(didTapCloseButton))
        navigationItem.leftBarButtonItem = item
    }
}
