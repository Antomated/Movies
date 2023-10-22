//
//  LocalizedKeyswift
//  Movies
//
//  Created by Anton Petrov on 18102023
//

import Foundation

enum LocalizedKey: String {
    // MARK: - Search scene

    case searchScreenTitle
    case searchPlaceholder
    case noResultsLabel
    case pullToRefresh
    case sortOptionsTitle
    case sortOptionsCancelButton
    case noPosterLabel

    // MARK: - Sort options

    case sortByDefault
    case sortByRatingAscending
    case sortByRatingDescending
    case sortByNameAscending
    case sortByNameDescending
    case sortByYearAscending
    case sortByYearDescending
    case sortByVotesAscending
    case sortByVotesDescending

    // MARK: - Errors

    case errorTitle
    case errorOkButton
    case networkErrorNoConnection
    case networkErrorNoData
    case networkErrorRequestFailed
    case networkErrorInvalidData
    case networkErrorInvalidURL
    case networkErrorUnauthorized
    case networkErrorDecodingFailed

    // MARK: - Trailer scene

    case trailerSceneTitle

    // MARK: - Poster scene

    case posterSceneTitle

    var localizedString: String {
        return NSLocalizedString(rawValue, comment: "")
    }
}
