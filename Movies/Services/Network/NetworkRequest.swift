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
            case let .details(movieID):
                return "movie/\(movieID)"
            case .genres:
                return "genre/movie/list"
            case let .videos(movieID):
                return "movie/\(movieID)/videos"
            }
        }()
    }

    var parameters: [String: Any] {
        var params: [String: Any] = ["language": Locale.current.languageCode ?? "en",
                                     "api_key": Constants.API.apiKey]
        switch self {
        case let .search(query, page):
            params["query"] = query
            params["page"] = page
        case let .popular(page):
            params["page"] = page
        case .details, .genres, .videos:
            break
        }
        return params
    }
}
