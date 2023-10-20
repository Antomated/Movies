//
//  Movie.swift
//  Movies
//
//  Created by Anton Petrov on 20.10.2023.
//

import Foundation

struct Movie {
    let id: Int
    let rating: Double
    let votes: Int
    let year: String
    let title: String
    let posterImageURLString: String?
    let backdropImageURLString: String?
    let genres: [APIGenre]
    let video: Bool
}
