//
//  MovieDetailsDTO.swift
//  Movies
//
//  Created by Anton Petrov on 20.10.2023.
//

import Foundation

struct MovieDetailsDTO: Decodable {
    let id: Int
    let title: String
    let releaseDate: String
    let productionCountries: [CountriesDTO]
    let genres: [GenreDTO]
    let overview: String
    let rating: Double
    let video: Bool
    let votes: Int
    let posterPath: String?
    let backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseDate = "release_date"
        case productionCountries = "production_countries"
        case genres
        case overview
        case rating = "vote_average"
        case video
        case votes = "vote_count"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}
