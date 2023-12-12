//
//  GenresDTO.swift
//  Movies
//
//  Created by Anton Petrov on 20.10.2023.
//

import Foundation

struct GenresDTO: Decodable {
    let genres: [GenreDTO]
}
