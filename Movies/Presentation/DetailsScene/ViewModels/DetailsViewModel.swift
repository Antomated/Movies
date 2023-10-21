//
//  DetailsViewModel.swift
//  Movies
//
//  Created by Anton Petrov on 19.10.2023.
//

import Foundation

protocol DetailsViewModelProtocol {
    var movieDetails: MovieDetails { get }
    var trailerURLString: String? { get }
    func getLatestTrailer(completion: @escaping ((Bool) -> Void))
}

final class DetailsViewModel: DetailsViewModelProtocol {
    // MARK: - Dependencies

    private let networkManager: DetailsNetworkManagerProtocol
    private let dateFormatter = DateFormatter().configure {
        $0.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.sssZ"
    }

    // MARK: - Properties

    private let trailerKey = "trailer"
    private let videoSiteKey = "youtube"
    private(set) var trailerURLString: String?
    private(set) var movieDetails: MovieDetails

    // MARK: - Initialization

    init(movieDetails: MovieDetails, networkManager: DetailsNetworkManagerProtocol) {
        self.networkManager = networkManager
        self.movieDetails = movieDetails
    }

    // MARK: - Details modeling

    func getLatestTrailer(completion: @escaping ((Bool) -> Void)) {
        fetchLatestTrailer(for: movieDetails.id) { [weak self] result in
            switch result {
            case let .success(urlString):
                guard let urlString else {
                    completion(false)
                    return
                }
                self?.trailerURLString = urlString
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }

    // MARK: - Private helpers

    private func fetchLatestTrailer(for movieID: Int,
                                    completion: @escaping ((Result<String?, Error>) -> Void)) {
        networkManager.getVideos(for: movieID) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(videos):
                let baseVideoURL = Constants.API.youtubeVideoBaseUrl
                var latestVideoKey = String()
                var latestDate = Date(timeIntervalSince1970: .zero)
                for video in videos.results {
                    guard video.type.lowercased() == self.trailerKey,
                          video.site.lowercased() == self.videoSiteKey,
                          let date = self.dateFormatter.date(from: video.publishedAt)
                    else { continue }
                    if latestDate < date {
                        latestDate = date
                        latestVideoKey = video.key
                    }
                }
                let result = latestVideoKey.isEmpty ? nil : baseVideoURL + latestVideoKey
                completion(.success(result))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
