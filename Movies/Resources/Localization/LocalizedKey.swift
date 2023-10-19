//
//  LocalizedKey.swift
//  Movies
//
//  Created by Anton Petrov on 18.10.2023.
//
// TODO: Check with localizable

import Foundation

enum LocalizedKey: String {
    // MARK: - Search screen

    case searchScreenTitle
    case searchPlaceholder
    case noResultsLabel
    case pullToRefresh
    case sortOptionsTitle
    case sortOptionsCancelButton
    case noPosterLabel

    // MARK: - Sort options

    case sortByPopularity
    case sortByRatingAscending
    case sortByRatingDescending
    case sortByNameAscending
    case sortByNameDescending
    case sortByYearAscending
    case sortByYearDescending

    var localizedString: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
