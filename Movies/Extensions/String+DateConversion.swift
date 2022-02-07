//
//  String+DateConversion.swift
//  Movies
//
//  Created by Fabián Ferreira on 2022-02-07.
//

import Foundation

extension String {
    var dateRepresentation: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: self)
    }
}
