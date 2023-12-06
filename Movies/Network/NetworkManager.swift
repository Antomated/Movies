//
//  NetworkManager.swift
//  Movies
//
//  Created by Anton Petrov on 19.10.2023.

import Alamofire
import Foundation

typealias NetworkManagerProtocol = DetailsNetworkManagerProtocol & SearchNetworkManagerProtocol

protocol SearchNetworkManagerProtocol {
    var isConnected: Bool { get }
    func getPopularMovies(page: Int, completion: @escaping ((Result<MoviesDTO, NetworkError>) -> Void))
    func getMovies(forQuery: String, page: Int, completion: @escaping ((Result<MoviesDTO, NetworkError>) -> Void))
    func getDetailsForMovie(id: Int, completion: @escaping ((Result<MovieDetailsDTO, NetworkError>) -> Void))
    func getGenres(completion: @escaping ((Result<GenresDTO, NetworkError>) -> Void))
}

protocol DetailsNetworkManagerProtocol {
    func getVideos(for movieID: Int, completion: @escaping ((Result<VideosDTO, NetworkError>) -> Void))
}

final class NetworkManager {
    private let reachabilityManager = NetworkReachabilityManager.default
    private let session: Session

    init(session: Session = .default) {
        self.session = session
    }

    private func request(_ request: NetworkRequest, completion: @escaping ((Result<Data, NetworkError>) -> Void)) {
        guard isConnected else {
            completion(.failure(NetworkError.noConnection))
            return
        }
        guard let url = URL(string: request.urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        session.request(url, method: .get, parameters: request.parameters)
            .validate()
            .response { response in
                switch response.result {
                case let .success(data):
                    guard let data else {
                        completion(.failure(NetworkError.noData))
                        return
                    }
                    completion(.success(data))
                case let .failure(error):
                    if response.response?.statusCode == 401 {
                        completion(.failure(NetworkError.unauthorized))
                    } else {
                        completion(.failure(NetworkError.requestFailed(underlyingError: error)))
                    }
                }
            }
    }

    private func decodeData<T: Codable>(of type: T.Type,
                                        from result: Result<Data, NetworkError>,
                                        completion: @escaping ((Result<T, NetworkError>) -> Void)) {
        switch result {
        case let .success(data):
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(NetworkError.invalidData))
            }
        case let .failure(error):
            completion(.failure(error))
        }
    }
}

// MARK: - SearchNetworkManagerProtocol

extension NetworkManager: SearchNetworkManagerProtocol {
    var isConnected: Bool {
        reachabilityManager?.isReachable ?? false
    }

    func getGenres(completion: @escaping ((Result<GenresDTO, NetworkError>) -> Void)) {
        request(.genres) { [weak self] result in
            self?.decodeData(of: GenresDTO.self, from: result, completion: completion)
        }
    }

    func getMovies(forQuery query: String,
                   page: Int,
                   completion: @escaping ((Result<MoviesDTO, NetworkError>) -> Void)) {
        request(.search(query: query, page: page)) { [weak self] result in
            self?.decodeData(of: MoviesDTO.self, from: result, completion: completion)
        }
    }

    func getPopularMovies(page: Int, completion: @escaping ((Result<MoviesDTO, NetworkError>) -> Void)) {
        request(.popular(page: page)) { [weak self] result in
            self?.decodeData(of: MoviesDTO.self, from: result, completion: completion)
        }
    }

    func getDetailsForMovie(id: Int, completion: @escaping ((Result<MovieDetailsDTO, NetworkError>) -> Void)) {
        request(.details(movieID: id)) { [weak self] result in
            self?.decodeData(of: MovieDetailsDTO.self, from: result, completion: completion)
        }
    }
}

// MARK: - DetailsNetworkManagerProtocol

extension NetworkManager: DetailsNetworkManagerProtocol {
    func getVideos(for movieID: Int, completion: @escaping ((Result<VideosDTO, NetworkError>) -> Void)) {
        request(.videos(movieID: movieID)) { [weak self] result in
            self?.decodeData(of: VideosDTO.self, from: result, completion: completion)
        }
    }
}
