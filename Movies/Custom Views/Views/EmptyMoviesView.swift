//
//  EmptyMoviesView.swift
//  Movies
//
//  Created by Fabián Ferreira on 2022-02-07.
//

import UIKit

class EmptyMoviesView: UIView {
    
    let noMoviesFoundLabel = UILabel()
    let noMoviesImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpEmptyMoviesView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpEmptyMoviesView() {
        translatesAutoresizingMaskIntoConstraints = false
        setUpNoMoviesImageView()
        setUpNoMoviesFoundLabel()
    }
    
    private func setUpNoMoviesImageView() {
        noMoviesImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(noMoviesImageView)
        
        noMoviesImageView.image = Images.filmImage
        noMoviesImageView.tintColor = .quaternaryLabel
        
        NSLayoutConstraint.activate([
            noMoviesImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noMoviesImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            noMoviesImageView.heightAnchor.constraint(equalToConstant: 150),
            noMoviesImageView.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setUpNoMoviesFoundLabel() {
        noMoviesFoundLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(noMoviesFoundLabel)
        
        noMoviesFoundLabel.font = Fonts.noMoviewFoundFont
        noMoviesFoundLabel.text = "No movies found!"
        noMoviesFoundLabel.textAlignment = .center
        noMoviesFoundLabel.textColor = .quaternaryLabel
        
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            noMoviesFoundLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            noMoviesFoundLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            noMoviesFoundLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            noMoviesFoundLabel.bottomAnchor.constraint(equalTo: noMoviesImageView.topAnchor, constant: -padding),
            noMoviesFoundLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
