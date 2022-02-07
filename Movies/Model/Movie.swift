//
//  Movie.swift
//  Movies
//
//  Created by Fabián Ferreira on 2022-02-07.
//

import Foundation

struct Movie: Codable {
    let id: Int
    let title: String
    let releaseDate: String?
    let runtime: Int?
    let overview: String?
    let posterPath: String?
}

struct Movies: Codable {
    let results: [Movie]
}
