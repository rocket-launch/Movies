//
//  MovieGenreTagsContainer.swift
//  Movies
//
//  Created by Fabián Ferreira on 2022-02-07.
//

import UIKit

final class MovieGenreTagsContainer: UIView {
    
    private var movieGenreTags: [UIButton]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(movieGenreTags: [UIButton], in view: UIView) {
        self.init(frame: view.bounds)
        self.movieGenreTags = movieGenreTags
    }
    
    private func setUpMovieGenreTagsInContainer() {
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        let padding: CGFloat = 7
        
        // Layout movie genre tags according to available space.
        for movieGenreTag in movieGenreTags {
            if (currentX + movieGenreTag.frame.width) > frame.width {
                currentX = 0
                currentY += movieGenreTag.frame.height + padding
            }
            
            movieGenreTag.frame.origin.x = currentX
            movieGenreTag.frame.origin.y = currentY
            
            addSubview(movieGenreTag)
            
            currentX += movieGenreTag.frame.width + padding
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpMovieGenreTagsInContainer()
    }
}
