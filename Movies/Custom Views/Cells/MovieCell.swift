//
//  MovieCell.swift
//  Movies
//
//  Created by Fabián Ferreira on 2022-02-07.
//

import UIKit

final class MovieCell: UITableViewCell {
    static let reuseID = "MovieCell"
    
    private let moviePosterImageView = UIImageView()
    private let movieTitleLabel = UILabel()
    private let movieReleaseYearLabel = UILabel()
    private let movieRuntimeLabel = UILabel()
    private let movieOverviewLabel = UILabel()
    
    private let containerView = UIView()
    
    private var movieDetailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let padding: CGFloat = 5
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpMovieCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpCellContent(for movie: Movie) {
        Task {
            if let image = await NetworkManager.shared.fetchMoviePosterImage(for: movie) {
                moviePosterImageView.image = image
            }
            if let runtime = await NetworkManager.shared.fetchMovieByID(for: movie.id)?.runtime {
                movieRuntimeLabel.text = runtime > 0 ? "\(runtime) minutes" : "N/A."
            }
            movieTitleLabel.text = movie.title
            movieReleaseYearLabel.text = movie.releaseDate?.dateRepresentation?.convertToYearOnlyFormat() ?? "N/A."
            movieOverviewLabel.text = movie.overview ?? "N/A."
        }
    }
    
    func clearCellContent() {
        moviePosterImageView.image = Images.filmImage
        movieTitleLabel.text = ""
        movieReleaseYearLabel.text = ""
        movieRuntimeLabel.text = ""
        movieOverviewLabel.text = ""
    }
    
    private func setUpMovieCell() {
        setUpContainerView()
        setUpMoviePosterImageView()
        setUpMovieTitleLabel()
        setUpMovieDetailStackView()
        setUpMovieOverviewLabel()
    }
    
    private func setUpContainerView() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 5
        containerView.layer.shadowColor = UIColor.label.cgColor
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 3
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.layer.borderWidth = 0.1
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
    
    private func setUpMoviePosterImageView() {
        containerView.addSubview(moviePosterImageView)
        moviePosterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        moviePosterImageView.contentMode = .scaleAspectFit
        moviePosterImageView.tintColor = .systemRed
        moviePosterImageView.image = Images.filmImage
        moviePosterImageView.clipsToBounds = true
        moviePosterImageView.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            moviePosterImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            moviePosterImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            moviePosterImageView.widthAnchor.constraint(equalToConstant: 67),
            moviePosterImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setUpMovieTitleLabel() {
        containerView.addSubview(movieTitleLabel)
        movieTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        movieTitleLabel.numberOfLines = 2
        movieTitleLabel.lineBreakMode = .byTruncatingTail
        movieTitleLabel.font = Fonts.movieTitleFont
        movieTitleLabel.sizeToFit()
        
        NSLayoutConstraint.activate([
            movieTitleLabel.topAnchor.constraint(equalTo: moviePosterImageView.topAnchor),
            movieTitleLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: padding),
            movieTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            movieTitleLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 80)
        ])
    }
    
    private func setUpMovieDetailStackView() {
        containerView.addSubview(movieDetailStackView)
        movieDetailStackView.translatesAutoresizingMaskIntoConstraints = false
        
        movieRuntimeLabel.textColor = .secondaryLabel
        movieRuntimeLabel.font = Fonts.movieDetailsFont
        
        movieReleaseYearLabel.textColor = .secondaryLabel
        movieReleaseYearLabel.font = Fonts.movieDetailsFont
        
        movieDetailStackView.addArrangedSubview(movieReleaseYearLabel)
        movieDetailStackView.addArrangedSubview(movieRuntimeLabel)
        
        NSLayoutConstraint.activate([
            movieDetailStackView.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: padding),
            movieDetailStackView.leadingAnchor.constraint(equalTo: movieTitleLabel.leadingAnchor),
            movieDetailStackView.trailingAnchor.constraint(equalTo: movieTitleLabel.trailingAnchor),
            movieDetailStackView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setUpMovieOverviewLabel() {
        containerView.addSubview(movieOverviewLabel)
        movieOverviewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        movieOverviewLabel.numberOfLines = 0
        movieOverviewLabel.lineBreakMode = .byTruncatingTail
        movieOverviewLabel.sizeToFit()
        
        NSLayoutConstraint.activate([
            movieOverviewLabel.topAnchor.constraint(equalTo: moviePosterImageView.bottomAnchor, constant: padding),
            movieOverviewLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.leadingAnchor),
            movieOverviewLabel.trailingAnchor.constraint(equalTo: movieTitleLabel.trailingAnchor),
            movieOverviewLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -padding)
        ])
    }
}
