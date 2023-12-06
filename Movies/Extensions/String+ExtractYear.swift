//
//  String+ExtractYear.swift
//  Movies
//
//  Created by Anton Petrov on 05.12.2023.
//

import Foundation

extension String {
    func extractYear(formatter: DateFormatter) -> String {
        guard let date = formatter.date(from: self) else { return "" }
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        return "\(year)"
    }
}
