//
//  MainCoordinator.swift
//  Movies
//
//  Created by Anton Petrov on 22.10.2023.
//

import UIKit

protocol MainCoordinatorProtocol: Coordinator {
    func showDetails(for: MovieDetails)
    func showTrailer(with: URL)
    func showPoster(with: String)
    func showAlert(message: String)
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

    func showTrailer(with url: URL) {
        let trailerVC = TrailerViewController(url: url)
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

    func showAlert(message: String) {
        let alert = UIAlertController(title: LocalizedKey.errorTitle.localizedString,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: LocalizedKey.errorOkButton.localizedString,
                                   style: .cancel)
        alert.addAction(action)
        navigationController.present(alert, animated: true)
    }
}
