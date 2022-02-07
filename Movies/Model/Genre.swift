//
//  Genre.swift
//  Movies
//
//  Created by Fabián Ferreira on 2022-02-07.
//

import Foundation

struct Genre: Codable {
    let id: Int
    let name: String
}

struct Genres: Codable {
    let genres: [Genre]
}
