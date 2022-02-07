//
//  RequestType.swift
//  Movies
//
//  Created by Fabián Ferreira on 2022-02-07.
//

import Foundation

enum RequestType {
    case movieGenres
    case moviesByGenre(genreIDs: [Int], page: Int)
    case movieByID(movieID: Int)
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        
        var queryItems = [URLQueryItem(name: "api_key", value: "b60160115570e34b27c15dd4c9ddf779"), URLQueryItem(name: "language", value: "en-US")]
        
        switch self {
        case .movieGenres:
            components.path = "/3/genre/movie/list"
            components.queryItems = queryItems
            return components.url
            
        case .moviesByGenre(let genres, let page):
            components.path = "/3/discover/movie"
            queryItems += [URLQueryItem(name: "sort_by", value: "popularity.desc"), URLQueryItem(name: "page", value: "\(page)"), URLQueryItem(name: "with_genres", value: genres.map { String($0) }.joined(separator: ","))]
            components.queryItems = queryItems
            return components.url
            
        case .movieByID(let movieID):
            components.path = "/3/movie/\(movieID)"
            components.queryItems = queryItems
            return components.url
        }
    }
}
