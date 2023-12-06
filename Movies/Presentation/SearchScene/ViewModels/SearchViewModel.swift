//
//  SearchViewModel.swift
//  Movies
//
//  Created by Anton Petrov on 19.10.2023.
//

import Foundation

protocol SearchViewModelProtocol: AnyObject {
    var movies: [Movie] { get }
    var sortOption: SortOption { get }
    var numberOfItems: Int { get }
    var canLoadMoreData: Bool { get }
    var onErrorOccurred: ((String?) -> Void)? { get set }

    func setSearch(query: String)
    func getMovies(withReload: Bool, completion: @escaping (() -> Void))
    func getDetailsForMovie(atIndex: Int, completion: @escaping ((MovieDetails?) -> Void))
    func selectSortOption(atIndex: Int)
    func cancelSearch()
}

extension SearchViewModelProtocol {
    var numberOfItems: Int {
        movies.count
    }

    var sortOptions: [String] {
        SortOption.allCases.map { $0.title }
    }
}

final class SearchViewModel: SearchViewModelProtocol {
    // MARK: - Dependencies

    private let networkManager: SearchNetworkManagerProtocol
    private let formatter = DateFormatter().configure {
        $0.dateFormat = "YYYY-MM-dd"
    }

    // MARK: - Properties

    private enum SearchState {
        case popular
        case search
        case offlineSearch
    }

    private var searchState: SearchState = .popular
    private var popularMovies = [Movie]()
    private var sortedMovies = [Movie]()
    private var searchedMovies = [Movie]()
    private var searchedSortedMovies = [Movie]()
    private var searchString = ""
    private var hasReachedEnd = false
    private(set) var sortOption = SortOption.defaultOption
    private var genres = [GenreDTO]()
    var movies: [Movie] {
        switch searchState {
        case .popular:
            return sortOption == .defaultOption ? popularMovies : sortedMovies
        case .search:
            return sortOption == .defaultOption ? searchedMovies : searchedSortedMovies
        case .offlineSearch:
            return sortOption == .defaultOption ? searchedMovies : searchedSortedMovies
        }
    }

    var canLoadMoreData: Bool {
        !hasReachedEnd
    }

    init(networkManager: SearchNetworkManagerProtocol) {
        self.networkManager = networkManager
        getGenres()
    }

    // MARK: - View Modeling

    var onErrorOccurred: ((String?) -> Void)?

    func selectSortOption(atIndex index: Int) {
        sortOption = SortOption(rawValue: index) ?? .defaultOption
        searchedSortedMovies = sortMovies(searchedMovies)
        sortedMovies = sortMovies(popularMovies)
    }

    func getMovies(withReload reload: Bool = false, completion: @escaping (() -> Void)) {
        getGenres()
        guard !hasReachedEnd else { return completion() }
        switch searchState {
        case .popular:
            getPopularMovies(withReload: reload, completion: completion)
        case .search:
            searchMovies(by: searchString, withReload: reload, completion: completion)
        case .offlineSearch:
            searchedMovies = popularMovies.filter { $0.title.lowercased().contains(searchString.lowercased()) }
            searchedSortedMovies = sortMovies(searchedMovies)
            completion()
        }
    }

    func getDetailsForMovie(atIndex index: Int, completion: @escaping ((MovieDetails?) -> Void)) {
        getGenres()
        guard let movieId = movies.safeElement(at: index)?.id else {
            completion(nil)
            self.onErrorOccurred?(LocalizedKey.networkErrorRequestFailed.localizedString)
            return
        }
        getDetails(for: movieId) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(details):
                completion(details)
            case let .failure(error):
                completion(nil)
                self.onErrorOccurred?(error.errorDescription)
            }
        }
    }

    func setSearch(query string: String) {
        guard !string.isEmpty else { return }
        searchString = string
        sortOption = .defaultOption
        hasReachedEnd = false
        if networkManager.isConnected {
            searchState = .search
        } else {
            if searchState != .offlineSearch {
                self.onErrorOccurred?(NetworkError.noConnection.errorDescription)
            }
            searchState = .offlineSearch
        }
        searchedMovies.removeAll()
    }

    func cancelSearch() {
        searchString = ""
        hasReachedEnd = false
        searchState = .popular
        searchedMovies.removeAll()
    }

    // MARK: - Private helpers

    private func getPopularMovies(page: Int,
                                  completion: @escaping ((Result<Movies, NetworkError>) -> Void)) {
        networkManager.getPopularMovies(page: page) { [weak self] result in
            guard let self else { return }
            self.handleMoviesResult(result, completion: completion)
        }
    }

    private func searchMovie(by name: String,
                             page: Int,
                             completion: @escaping ((Result<Movies, NetworkError>) -> Void)) {
        networkManager.getMovies(forQuery: name, page: page) { [weak self] result in
            guard let self else { return }
            self.handleMoviesResult(result, completion: completion)
        }
    }

    private func getDetails(for movieID: Int,
                            completion: @escaping ((Result<MovieDetails, NetworkError>) -> Void)) {
        networkManager.getDetailsForMovie(id: movieID) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(details):
                let countries = details.productionCountries.map { $0.name }
                let year = details.releaseDate.extractYear(formatter: self.formatter)
                let posterURL = self.getImageURL(for: details.posterPath, imageSize: .original)
                let backdropURL = self.getImageURL(for: details.backdropPath, imageSize: .original)
                let detail = MovieDetails(id: details.id,
                                          genres: details.genres,
                                          title: details.title,
                                          countries: countries,
                                          year: year,
                                          rating: details.rating,
                                          votes: details.votes,
                                          overview: details.overview,
                                          video: details.video,
                                          posterImageURLString: posterURL,
                                          backdropImageURLString: backdropURL)
                completion(.success(detail))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    private func getImageURL(for path: String?, imageSize: ImageSizeQuery) -> String? {
        guard let path else { return nil }
        return Constants.API.baseImageUrl + imageSize.rawValue + path
    }

    private func getGenres() {
        guard genres.isEmpty else { return }
        networkManager.getGenres { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(genres):
                self.genres = genres.genres
            case let .failure(error):
                self.onErrorOccurred?(error.errorDescription)
            }
        }
    }

    private func sortMovies(_ movies: [Movie]) -> [Movie] {
        switch sortOption {
        case .nameAscending:
            return movies.sorted(by: { $0.title < $1.title })
        case .nameDescending:
            return movies.sorted(by: { $0.title > $1.title })
        case .yearAscending:
            return movies.sorted(by: { $0.year < $1.year })
        case .yearDescending:
            return movies.sorted(by: { $0.year > $1.year })
        case .ratingAscending:
            return movies.sorted(by: { $0.rating < $1.rating })
        case .ratingDescending:
            return movies.sorted(by: { $0.rating > $1.rating })
        case .votesAscending:
            return movies.sorted(by: { $0.votes < $1.votes })
        case .votesDescending:
            return movies.sorted(by: { $0.votes > $1.votes })
        case .defaultOption:
            return movies
        }
    }

    private func getPopularMovies(withReload: Bool = false,
                                  completion: @escaping (() -> Void)) {
        let page = withReload ? 1 : (popularMovies.count / 20) + 1
        getPopularMovies(page: page) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(list):
                if withReload {
                    self.popularMovies.removeAll()
                }
                self.popularMovies.append(contentsOf: list.results)
                self.sortedMovies += self.sortMovies(list.results)
                self.hasReachedEnd = list.results.isEmpty
                completion()
            case let .failure(error):
                self.onErrorOccurred?(error.errorDescription)
                completion()
            }
        }
    }

    private func searchMovies(by name: String,
                              withReload: Bool = false,
                              completion: @escaping (() -> Void)) {
        let page = withReload ? 1 : Int(ceil(Float(searchedMovies.count) / 20) + 1)
        searchMovie(by: name, page: page) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(list):
                if withReload {
                    self.searchedMovies.removeAll()
                }
                self.searchedMovies.append(contentsOf: list.results)
                self.searchedSortedMovies += self.sortMovies(list.results)
                self.hasReachedEnd = list.results.isEmpty
                completion()
            case let .failure(error):
                self.onErrorOccurred?(error.errorDescription)
                completion()
            }
        }
    }

    private func convert(movies: [MovieDTO]) -> [Movie] {
        var result = [Movie]()
        for movie in movies {
            let year = movie.releaseDate.extractYear(formatter: formatter)
            let genres = genres.filter { movie.genresIDs.contains($0.id) }
            let mov = Movie(id: movie.id,
                            rating: movie.rating,
                            votes: movie.votes,
                            year: year,
                            title: movie.title,
                            posterImageURLString: getImageURL(for: movie.posterPath,
                                                              imageSize: .small),
                            backdropImageURLString: getImageURL(for: movie.backdropPath,
                                                                imageSize: .medium),
                            genres: genres,
                            video: movie.video)
            result.append(mov)
        }
        return result
    }

    private func handleMoviesResult(_ result: Result<MoviesDTO, NetworkError>,
                                    completion: @escaping ((Result<Movies, NetworkError>) -> Void)) {
        switch result {
        case let .success(result):
            let movies = convert(movies: result.movies)
            let list = Movies(results: movies)
            completion(.success(list))
        case let .failure(error):
            if case NetworkError.noConnection = error {
                searchState = .offlineSearch
            }
            completion(.failure(error))
        }
    }
}
