//
//  MovieGenreViewController.swift
//  Movies
//
//  Created by Fabián Ferreira on 2022-02-07.
//

import UIKit

final class MovieGenresViewController: UIViewController {
    
    private var movieGenreTags = [Genre]()
    private var selectedMovieGenres = [Int]() {
        didSet {
            searchMoviesButton.isEnabled = selectedMovieGenres.isEmpty ? false : true
        }
    }
    private var searchMoviesButton: SearchMoviesButton!
    private var movieGenreTagsContainer: MovieGenreTagsContainer!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
        setUpSearchMoviesButton()
        fetchMovieTags()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setUpViewController() {
        title = "Movie Genres"
        navigationItem.backButtonTitle = "Back"
        view.backgroundColor = .systemBackground
    }
    
    private func setUpSearchMoviesButton() {
        let searchAction = UIAction { _ in
            self.fetchMoviesByGenre()
        }
        searchMoviesButton = SearchMoviesButton(with: searchAction)
        
        view.addSubview(searchMoviesButton)
        NSLayoutConstraint.activate([
            searchMoviesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchMoviesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    
    private func fetchMoviesByGenre() {
        Task {
            let movieListViewController = MovieListViewController()
            movieListViewController.movies = try await NetworkManager.shared.getMovieListByGenre(genres: selectedMovieGenres)
            movieListViewController.genreIDs = selectedMovieGenres
            navigationController?.pushViewController(movieListViewController, animated: true)
        }
    }
    
    private func fetchMovieTags() {
        Task {
            do {
                movieGenreTags = try await NetworkManager.shared.getMovieGenres().genres
                setUpMovieTags()
            }
        }
    }
    
    private func setUpMovieTags() {
        var genreButtons = [UIButton]()
        
        for movieGenreTag in movieGenreTags {
            let genreBtn = MovieGenreTag(title: movieGenreTag.name, tag: movieGenreTag.id)
            genreBtn.delegate = self
            genreButtons.append(genreBtn)
        }
        
        movieGenreTagsContainer = MovieGenreTagsContainer(movieGenreTags: genreButtons, in: view)
        setUpMovieTagsContainer()
    }
    
    private func setUpMovieTagsContainer() {
        movieGenreTagsContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(movieGenreTagsContainer)
        
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            movieGenreTagsContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            movieGenreTagsContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            movieGenreTagsContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            movieGenreTagsContainer.bottomAnchor.constraint(equalTo: searchMoviesButton.topAnchor, constant: -padding)
        ])
    }
}


extension MovieGenresViewController: MovieTagDelegate {
    func didTapMovieTag(sender: MovieGenreTag) {
        if let index = selectedMovieGenres.firstIndex(of: sender.tag) {
            self.selectedMovieGenres.remove(at: index)
        } else {
            self.selectedMovieGenres.append(sender.tag)
        }
    }
}
