//
//  NetworkRequest.swift
//  Movies
//
//  Created by Anton Petrov on 19.10.2023.
//

import Foundation

enum NetworkRequest {
    case search(query: String, page: Int)
    case popular(page: Int)
    case details(movieID: Int)
    case genres
    case videos(movieID: Int)

    var urlString: String {
        Constants.API.baseUrl + {
            switch self {
            case .search:
                return "search/movie"
            case .popular:
                return "movie/popular"
            case .details(let movieID):
                return "movie/\(movieID)"
            case .genres:
                return "genre/movie/list"
            case .videos(let movieID):
                return "movie/\(movieID)/videos"
            }
        }()
    }

    var parameters: [String: Any] {
        var params: [String: Any] = ["language": Locale.current.languageCode ?? "en"]
        switch self {
        case .search(let query, let page):
            params["query"] = query
            params["page"] = page
        case .popular(let page):
            params["page"] = page
        case .details, .genres, .videos:
            break
        }
        return params
    }
}
