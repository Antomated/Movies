//
//  PosterViewController.swift
//  Movies
//
//  Created by Anton Petrov on 19.10.2023.
//

import Kingfisher
import UIKit

final class PosterViewController: UIViewController {
    // MARK: - UI elements & properties

    private let scrollView = UIScrollView().configure {
        $0.minimumZoomScale = 1.0
        $0.maximumZoomScale = 10.0
        $0.isOpaque = false
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }

    private let posterImageView = UIImageView().configure {
        $0.contentMode = .scaleAspectFit
    }

    private let posterUrlString: String

    // MARK: - Initialization

    init(posterUrlString: String) {
        self.posterUrlString = posterUrlString
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupScrollView()
        setupBlur()
        setupCloseButton()
        setupPosterImageView()
    }

    // MARK: - Setup

    private func setupNavigationBar() {
        title = LocalizedKey.posterSceneTitle.localizedString
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                       left: view.leftAnchor,
                       bottom: view.bottomAnchor,
                       right: view.rightAnchor)
        scrollView.addSubview(posterImageView)
        posterImageView.center(inView: scrollView)
        let layoutFrame = scrollView.frameLayoutGuide.layoutFrame
        posterImageView.setDimensions(height: layoutFrame.height, width: layoutFrame.width)
        scrollView.delegate = self
    }

    private func setupPosterImageView() {
        guard let url = URL(string: posterUrlString) else { return }
        posterImageView.kf.setImage(with: url)
    }
}

// MARK: - UIScrollViewDelegate

extension PosterViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        posterImageView
    }
}
