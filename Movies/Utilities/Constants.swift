//
//  Constants.swift
//  Movies
//
//  Created by Anton Petrov on 18.10.2023.
//

import UIKit

enum Constants {
    enum StyleDefaults {
        static let articleCellHeight: CGFloat = 340
        static let cornerRadius: CGFloat = 20
    }

    enum API {
        static let articlesPerPage = 30
        static let apiKey = "8b23637d92b147fabc23328863cca344"
        static let baseUrl = "https://newsapi.org/"
        static let headLines = baseUrl + "v2/top-headlines"
        static let sources = headLines + "/sources"
    }

    enum SystemImage: String {
        case bookmarkFill = "bookmark.fill"
        case bookmark
        case note
        case noteText = "note.text"
        case magnifyingglass
        case textMagnifyingglass = "text.magnifyingglass"

        var image: UIImage? { UIImage(systemName: rawValue) }
    }
}
