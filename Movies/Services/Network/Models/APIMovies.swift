//
//  APIMovies.swift
//  Movies
//
//  Created by Anton Petrov on 20.10.2023.
//

import Foundation

struct APIMovies: Codable {
    let movies: [APIMovie]
    let totalPages: Int

    enum CodingKeys: String, CodingKey {
        case movies = "results"
        case totalPages = "total_pages"
    }
}
