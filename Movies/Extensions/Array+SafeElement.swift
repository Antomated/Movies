//
//  Array+SafeElement.swift
//  Movies
//
//  Created by Anton Petrov on 22.10.2023.
//

import Foundation

extension Array {
    func safeElement(at index: Index) -> Element? {
        guard indices.contains(index) else {
            return nil
        }
        return self[index]
    }
}
