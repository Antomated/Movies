//
//  SearchViewModel.swift
//  Movies
//
//  Created by Anton Petrov on 19.10.2023.
//

import Foundation

protocol SearchViewModelProtocol {
    var movies: [Movie] { get }
    var selectedSorting: SortOption { get }
    var numberOfItems: Int { get }

    func selectSorting(option: SortOption)
    func setSearchString(string: String)
    func cancelSearch()
    func getMovies(reloadAll: Bool, completion: @escaping (() -> Void))
    func navigateToMovieDetail(index: Int)
}

extension SearchViewModelProtocol {
    var numberOfItems: Int {
        movies.count
    }
}

final class SearchViewModel {
    var moviesProvider: MoviesListProviderProtocol
    var router: MoviesListRouterProtocol

    private var popularMovies = [Movie]()
    private var sortedMovies = [Movie]()
    private var searchedMovies = [Movie]()
    private var searchedSorted = [Movie]()
    private let maxPages = 500
    private var searchMaxPages = 500

    private var isSearching = false {
        didSet {
            if !isSearching {
                searchMaxPages = 500
            }
        }
    }
    private var searchString = ""

    var selectedSorting = SortOption.popularity

    init(moviesProvider: MoviesListProviderProtocol, router: MoviesListRouterProtocol) {
        self.moviesProvider = moviesProvider
        self.router = router
    }

    private func sortMovies(_ movies: [Movie]) -> [Movie] {
        switch selectedSorting {
        case .popularity: return movies
        case .nameAscending: return movies.sorted(by: { $0.title < $1.title })
        case .nameDescending: return movies.sorted(by: { $0.title > $1.title })
        case .yearAscending: return movies.sorted(by: { $0.year < $1.year })
        case .yearDescending: return movies.sorted(by: { $0.year > $1.year })
        case .ratingAscending: return movies.sorted(by: { $0.rating < $1.rating })
        case .ratingDescending: return movies.sorted(by: { $0.rating > $1.rating })
        }
    }

    private func getMovieDetail(for index: Int, completion: @escaping ((Result<MovieDetails, NetworkError>) -> Void)) {
        let movie = isSearching ? searchedMovies[index].id : sortedMovies[index].id
        moviesProvider.getMovieDetail(for: movie, completion: completion)
    }

    private func getPopularMovies(reloadAll: Bool = false, completion: @escaping (() -> Void)) {
        let page = reloadAll ? 1 : (popularMovies.count / 20) + 1

        guard page <= maxPages else {
            completion()
            return
        }

        moviesProvider.getPopularMovies(page: page) { [weak self] result in
            switch result {
            case .success(let list):
                if reloadAll {
                    self?.popularMovies.removeAll()
                }
                self?.popularMovies.append(contentsOf: list.results)
                self?.sortedMovies += self?.sortMovies(list.results) ?? []
                completion()
            case .failure(let error):
                self?.router.presentError(error) {
                    completion()
                }
            }
        }
    }

    private func searchMovies(by name: String, reloadAll: Bool = false, completion: @escaping (() -> Void)) {
        let page = reloadAll ? 1 : Int(ceil(Float(searchedMovies.count) / 20) + 1)

        guard page <= searchMaxPages else {
            completion()
            return
        }

        moviesProvider.searchMovie(by: name, page: page) { [weak self] result in
            switch result {
            case .success(let list):
                if reloadAll {
                    self?.searchedMovies.removeAll()
                }
                self?.searchedMovies.append(contentsOf: list.results)
                self?.searchedSorted += self?.sortMovies(list.results) ?? []
                self?.searchMaxPages = list.totalPages
                completion()
            case .failure(let error):
                self?.searchedMovies = self?.sortedMovies.filter { $0.title.contains(name) } ?? []
                self?.router.presentError(error) {
                    completion()
                }
            }
        }
    }
}

extension SearchViewModel: SearchViewModelProtocol {
    var movies: [Movie] {
        isSearching
        ? selectedSorting == .popularity ? searchedMovies : searchedSorted
        : selectedSorting == .popularity ? popularMovies : sortedMovies
    }

    func selectSorting(option: SortOption) {
        selectedSorting = option
        searchedSorted = sortMovies(searchedMovies)
        sortedMovies = sortMovies(popularMovies)
    }

    func getMovies(reloadAll: Bool = false, completion: @escaping (() -> Void)) {
        if isSearching {
            searchMovies(by: searchString, reloadAll: reloadAll, completion: completion)
        } else {
            getPopularMovies(reloadAll: reloadAll, completion: completion)
        }
    }

    func navigateToMovieDetail(index: Int) {
        getMovieDetail(for: index) { [weak self] result in
            switch result {
            case .success(let details):
                self?.router.navigateToMovieDetails(movieDetails: details)
            case .failure(let error):
                self?.router.presentError(error) {}
            }
        }
    }

    func setSearchString(string: String) {
        guard !string.isEmpty else { return }
        searchString = string
        searchedMovies.removeAll()
        isSearching = true
    }

    func cancelSearch() {
        searchString = ""
        isSearching = false
        searchedMovies.removeAll()
    }
}
