//
//  Configurable.swift
//  Movies
//
//  Created by Anton Petrov on 19.10.2023.
//

import Foundation

protocol Configurable {}

extension Configurable where Self: AnyObject {
    @discardableResult
    func configure(_ action: (Self) throws -> Void) rethrows -> Self {
        try action(self)
        return self
    }
}

extension NSObject: Configurable {}
