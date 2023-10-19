//
//  Coordinator.swift
//  Movies
//
//  Created by Anton Petrov on 22.10.2023.
//

import UIKit

protocol MainCoordinatorProtocol: Coordinator {
    func showDetails(for movieDetails: MovieDetails)
    func showTrailer(with urlString: String)
    func showPoster(with urlString: String)
}

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}

final class MainCoordinator: MainCoordinatorProtocol {
    var navigationController: UINavigationController
    private let networkManager: NetworkManagerProtocol

    init(navigationController: UINavigationController,
         networkManager: NetworkManagerProtocol) {
        self.navigationController = navigationController
        self.networkManager = networkManager
    }

    func start() {
        let viewModel = SearchViewModel(networkManager: networkManager)
        let viewController = SearchViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }

    func showDetails(for movieDetails: MovieDetails) {
        let viewModel = DetailsViewModel(movieDetails: movieDetails, networkManager: networkManager)
        let detailsViewController = DetailsViewController(viewModel: viewModel)
        detailsViewController.coordinator = self
        navigationController.pushViewController(detailsViewController, animated: true)
    }

    func showTrailer(with urlString: String) {
        let trailerVC = TrailerViewController(urlString: urlString)
        trailerVC.modalPresentationStyle = .popover
        navigationController.present(UINavigationController(rootViewController: trailerVC),
                                     animated: true)
    }

    func showPoster(with urlString: String) {
        let posterModalViewController = PosterViewController(posterUrlString: urlString)
        posterModalViewController.modalPresentationStyle = .popover
        navigationController.present(UINavigationController(rootViewController: posterModalViewController),
                                     animated: true)
    }
}
