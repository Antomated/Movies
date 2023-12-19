//
//  SystemImage.swift
//  Movies
//
//  Created by Anton Petrov on 19.12.2023.
//

import UIKit

enum SystemImage: String {
    case sortIcon = "arrow.up.arrow.down"
    case sortAscending = "arrow.up"
    case sortDescending = "arrow.down"
    case backButton = "chevron.left"
    case playButton = "play.circle.fill"
    
    var image: UIImage? { UIImage(systemName: rawValue) }
}
