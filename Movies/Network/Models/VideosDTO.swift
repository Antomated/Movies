//
//  VideosDTO.swift
//  Movies
//
//  Created by Anton Petrov on 20.10.2023.
//

import Foundation

struct VideosDTO: Decodable {
    let results: [VideoDTO]
}
