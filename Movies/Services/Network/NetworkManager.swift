//
//  NetworkManager.swift
//  Movies
//
//  Created by Anton Petrov on 19.10.2023.

// TODO: move to const
//swiftlint: disable line_length

import Foundation
import Alamofire

protocol SearchNetworkManagerProtocol {
    func getPopularMovies(page: Int, completion: @escaping ((Result<Data, NetworkError>) -> Void))
    func getMovies(forQuery: String, page: Int, completion: @escaping ((Result<Data, NetworkError>) -> Void))
    func getDetailsForMovie(id: Int, completion: @escaping ((Result<Data, NetworkError>) -> Void))
    func getGenres(completion: @escaping ((Result<Data, NetworkError>) -> Void))
}

protocol DetailsNetworkManagerProtocol {
    func getVideos(for movieID: Int, completion: @escaping ((Result<Data, NetworkError>) -> Void))
}

final class NetworkManager {
    private let headers: HTTPHeaders = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyMDc0NTNiNmM4MzA3MWY1ODc1MWY0NTE3OTJlYzMxMSIsInN1YiI6IjY1MjJhOWZjMDcyMTY2MDBhY2I4ZjkyYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.9Q0Hs_dyRT-Xh6wMBjXLBbp6O9BUm9NkiuuFVooOq2k"
    ]

    private let reachabilityManager = NetworkReachabilityManager.default
    private let session: Session

    init(session: Session = .default) {
        self.session = session
    }

    private func request(_ request: NetworkRequest, completion: @escaping ((Result<Data, NetworkError>) -> Void)) {
        guard reachabilityManager?.isReachable == true else {
            completion(.failure(NetworkError.noConnection))
            return
        }
        guard let url = URL(string: request.urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        session.request(url, method: .get, parameters: request.parameters, headers: headers)
            .validate()
            .response { response in
                print("DEBUG! response: \(response.debugDescription)")
                switch response.result {
                case .success(let data):
                    guard let data = data else {
                        completion(.failure(NetworkError.noData))
                        return
                    }
                    completion(.success(data))
                case .failure(let error):
                    if response.response?.statusCode == 401 {
                        completion(.failure(NetworkError.unauthorized))
                    } else {
                        completion(.failure(NetworkError.requestFailed(underlyingError: error)))
                    }
                }
            }
    }
}

// MARK: - SearchNetworkManagerProtocol

extension NetworkManager: SearchNetworkManagerProtocol {
    func getGenres(completion: @escaping ((Result<Data, NetworkError>) -> Void)) {
        request(.genres, completion: completion)
    }

    func getMovies(forQuery query: String, page: Int, completion: @escaping ((Result<Data, NetworkError>) -> Void)) {
        request(.search(query: query, page: page), completion: completion)
    }

    func getPopularMovies(page: Int, completion: @escaping ((Result<Data, NetworkError>) -> Void)) {
        request(.popular(page: page), completion: completion)
    }

    func getDetailsForMovie(id: Int, completion: @escaping ((Result<Data, NetworkError>) -> Void)) {
        request(.details(movieID: id), completion: completion)
    }
}

// MARK: - DetailsNetworkManagerProtocol

extension NetworkManager: DetailsNetworkManagerProtocol {
    func getVideos(for movieID: Int, completion: @escaping ((Result<Data, NetworkError>) -> Void)) {
        request(.videos(movieID: movieID), completion: completion)
    }
}
