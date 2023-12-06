//
//  MovieDetails.swift
//  Movies
//
//  Created by Anton Petrov on 20.10.2023.
//

import Foundation

struct MovieDetails {
    let id: Int
    let genres: [GenreDTO]
    let title: String
    let countries: [String]
    let year: String
    let rating: Double
    let votes: Int
    let overview: String
    let video: Bool
    let posterImageURLString: String?
    let backdropImageURLString: String?
}
