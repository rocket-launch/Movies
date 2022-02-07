//
//  MovieListViewController.swift
//  Movies
//
//  Created by Fabián Ferreira on 2022-02-07.
//

import UIKit

final class MovieListViewController: UITableViewController {

    var movies: [Movie]!
    var genreIDs: [Int]!
    private var page = 1
    private var isFetchingMovies = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
        if movies.isEmpty {
            showNoMoviesFoundView()
            return
        }
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setUpViewController() {
        title = "Movies"
    }
    
    private func setUpTableView() {
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.reuseID)
        tableView.rowHeight = 220
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }
    
    private func fetchMovies() {
        guard movies.count < 50 else { return }
        page += 1
        isFetchingMovies = true
        
        Task {
            let fetchedMovies = try await NetworkManager.shared.fetchMovieListByGenre(genres: genreIDs, for: page)
            movies.append(contentsOf: fetchedMovies)
            isFetchingMovies = false
            
            if movies.count > 50 {
                movies.removeSubrange(50...)
            }
            self.tableView.reloadData()
        }
    }
    
    private func showNoMoviesFoundView() {
        let emptyView = EmptyMoviesView()
        view.addSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension MovieListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movieCell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseID, for: indexPath) as? MovieCell else { preconditionFailure() }
        movieCell.clearCellContent()
        
        let movie = movies[indexPath.row]
        movieCell.setUpCellContent(for: movie)
        return movieCell
    }
}

extension MovieListViewController {
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if (offsetY + height) >= contentHeight {
            guard !isFetchingMovies else {
                return
            }
            self.fetchMovies()
        }
    }
}
