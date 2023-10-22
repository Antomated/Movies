//
//  Constants.swift
//  Movies
//
//  Created by Anton Petrov on 18.10.2023.
//

import UIKit

enum Constants {
    enum StyleDefaults {
        static let cornerRadius: CGFloat = 16
        static let mediumPadding: CGFloat = 16
        static let smallPadding: CGFloat = 8
        static let pointSeparator: String = " • "
        static let bigItemSideSize: CGFloat = 56
    }

    enum API {
        static let baseUrl = "https://api.themoviedb.org/3/"
        static let baseImageUrl = "https://image.tmdb.org/t/p"
        static let youtubeVideoBaseUrl = "https://www.youtube.com/embed/"
        static let apiKey = "7ca62b73f595a418f832f4440f9fb21e"
    }

    enum SystemImage: String {
        case sortIcon = "arrow.up.arrow.down"
        case sortAscending = "arrow.up"
        case sortDescending = "arrow.down"
        case backButton = "chevron.left"
        case playButton = "play.circle.fill"

        var image: UIImage? { UIImage(systemName: rawValue) }
    }
}
