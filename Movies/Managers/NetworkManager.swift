//
//  NetworkManager.swift
//  Movies
//
//  Created by Fabián Ferreira on 2022-02-07.
//

import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    private let cache = NSCache<NSString, UIImage>()
    enum Error: Swift.Error {
        case invalidURL, invalidData, invalidResponse, noImage
    }
    
    private init() {}
    
    func fetchMovieGenres() async throws -> Genres {
        guard let url = RequestType.movieGenres.url else { throw Error.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw Error.invalidResponse
        }
        
        let decoder = JSONDecoder()
        guard let genres = try? decoder.decode(Genres.self, from: data) else { throw Error.invalidData }
        return genres
    }
    
    func fetchMovieListByGenre(genres: [Int], for page: Int = 1) async throws -> [Movie] {
        guard let url = RequestType.moviesByGenre(genreIDs: genres, page: page).url else { throw Error.invalidURL }
    
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw Error.invalidResponse }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let movies = try decoder.decode(Movies.self, from: data)
            return movies.results
        } catch {
            throw Error.invalidData
        }
    }
    
    func fetchMovieByID(for movieID: Int) async -> Movie? {
        guard let url = RequestType.movieByID(movieID: movieID).url else { return nil }
        
        guard let (data, response) = try? await URLSession.shared.data(from: url) else { return nil }
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return nil }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let movie = try? decoder.decode(Movie.self, from: data) else { return nil }
        
        return movie
    }

    func fetchMoviePosterImage(for movie: Movie) async -> UIImage? {
        guard let posterPath = movie.posterPath else { return nil }
        
        if let image = cache.object(forKey: posterPath as NSString) {
            return image
        }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "image.tmdb.org"
        components.path = "/t/p/w185\(posterPath)"
        
        guard let url = components.url else { return nil }
        guard let (data, response) = try? await URLSession.shared.data(from: url) else { return nil }
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return nil }
        
        guard let image = UIImage(data: data) else { return nil }
        self.cache.setObject(image, forKey: posterPath as NSString)
        return image
    }
}
