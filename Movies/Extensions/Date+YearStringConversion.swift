//
//  Date+YearStringConversion.swift
//  Movies
//
//  Created by Fabián Ferreira on 2022-02-07.
//

import Foundation

extension Date {
    func convertToYearOnlyFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
}
