//
//  SortOption.swift
//  Movies
//
//  Created by Anton Petrov on 19.10.2023.
//
// TODO: Draft

import UIKit

enum SortOption: Int, CaseIterable {
    case popularity
    case ratingAscending
    case ratingDescending
    case nameAscending
    case nameDescending
    case yearAscending
    case yearDescending

    var title: String {
        switch self {
        case .popularity:
            return LocalizedKey.sortByPopularity.localizedString
        case .nameAscending:
            return LocalizedKey.sortByNameAscending.localizedString
        case .nameDescending:
            return LocalizedKey.sortByNameDescending.localizedString
        case .yearAscending:
            return LocalizedKey.sortByYearAscending.localizedString
        case .yearDescending:
            return LocalizedKey.sortByYearDescending.localizedString
        case .ratingAscending:
            return LocalizedKey.sortByRatingAscending.localizedString
        case .ratingDescending:
            return LocalizedKey.sortByRatingDescending.localizedString
        }
    }
}
