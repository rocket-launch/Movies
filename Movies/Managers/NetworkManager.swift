//
//  NetworkManager.swift
//  Movies
//
//  Created by Fabián Ferreira on 2022-02-07.
//

import UIKit

#warning("FIX THIS STUFF!")
final class NetworkManager {
    static let shared = NetworkManager()
    private let cache = NSCache<NSString, UIImage>()
    
    private var components: URLComponents = {
        var comp = URLComponents()
        comp.scheme = "https"
        comp.host = "api.themoviedb.org"
        return comp
    }()
    
    var queryItems = [URLQueryItem]()
    
    private let APIKey = "b60160115570e34b27c15dd4c9ddf779"
    
    private init() {}
    
    enum Error: Swift.Error {
        case invalidURL, invalidData, invalidResponse, noImage
    }
    
    /*https://api.themoviedb.org/3/genre/movie/list?api_key=b60160115570e34b27c15dd4c9ddf779&language=en-US*/
    func getMovieGenres() async throws -> Genres {
        components.path = "/3/genre/movie/list"
        let query: [String: String] = [
            "api_key": APIKey,
            "language": "en-US"
        ]
        
        for (key, value) in query {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        components.queryItems = queryItems

        guard let url = components.url else { throw Error.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw Error.invalidResponse
        }
        
        let decoder = JSONDecoder()
        
        guard let genres = try? decoder.decode(Genres.self, from: data) else { throw Error.invalidData }
        
        return genres
    }
    
    /*https://api.themoviedb.org/3/discover/movie?api_key=b60160115570e34b27c15dd4c9ddf779&language=en-US&sort_by=popularity.desc&page=1&with_genres=14%2C9648*/
    func getMovieListByGenre(genres: [Int], for page: Int = 1) async throws -> [Movie] {
        //this has all movies by id in the selected genre(s)
        components.path = "/3/discover/movie"
        #warning("This is changing the URL for every request after this one.")
        let query: [String:String] = [
            "sort_by": "popularity.desc",
            "page": "\(page)",
            "with_genres": genres.map { String($0) }.joined(separator: ",")
        ]
        for (key, value) in query {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        components.queryItems = queryItems
        
        guard let url = components.url else { throw Error.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw Error.invalidResponse }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let movies = try decoder.decode(Movies.self, from: data)
            return movies.results
        } catch {
            print(error)
            throw Error.invalidData
        }
    }
    
    
    /*https://api.themoviedb.org/3/movie/11024?api_key=b60160115570e34b27c15dd4c9ddf779&language=en-US*/
    func getMovieByID(for movieID: Int) async -> Movie? {
        //this has all details I need for my images including the poster path
        components.path = "/3/movie/\(movieID)"
        guard let url = components.url else { return nil }
        guard let (data, response) = try? await URLSession.shared.data(from: url) else { return nil }
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return nil }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let movie = try? decoder.decode(Movie.self, from: data) {
            return movie
        }
        return nil
    }
    
    /*https://image.tmdb.org/t/p/w500/8uO0gUM8aNqYLs1OsTBQiXu0fEv.jpg*/
    func getMoviePosterImage(for movie: Movie) async -> UIImage? {
        
        guard let posterPath = movie.posterPath else { return nil }
        
        if let image = cache.object(forKey: posterPath as NSString) {
            return image
        }
        
        var comp = URLComponents()
        comp.scheme = "https"
        comp.host = "image.tmdb.org"
        comp.path = "/t/p/w185\(posterPath)"
        
        guard let url = comp.url else { return nil }
        guard let (data, response) = try? await URLSession.shared.data(from: url) else { return nil }
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return nil }
        
        if let image = UIImage(data: data) {
            self.cache.setObject(image, forKey: posterPath as NSString)
            return image
        }
        return nil
    }
    
    /*https://api.themoviedb.org/3/configuration?api_key=b60160115570e34b27c15dd4c9ddf779*/
    func getConfiguration() {
        //this has the base url and size for images
    }
}
