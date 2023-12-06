//
//  VideoDTO.swift
//  Movies
//
//  Created by Anton Petrov on 20.10.2023.
//

import Foundation

struct VideoDTO: Codable {
    let publishedAt: String
    let site: String
    let type: String
    let key: String

    enum CodingKeys: String, CodingKey {
        case publishedAt = "published_at"
        case site
        case type
        case key
    }
}
