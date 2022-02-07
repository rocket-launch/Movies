//
//  MovieGenreTag.swift
//  Movies
//
//  Created by Fabián Ferreira on 2022-02-07.
//

import UIKit

protocol MovieTagDelegate: AnyObject {
    func didTapMovieTag(sender: MovieGenreTag)
}

final class MovieGenreTag: UIButton {
    
    weak var delegate: MovieTagDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String, tag: Int) {
        self.init(frame: .zero)
        setUpMovieTag(with: title, tag: tag)
    }
    
    private func setUpMovieTag(with title: String, tag: Int) {
        translatesAutoresizingMaskIntoConstraints = false
        
        // Button's design configuration
        var btnConfiguration = UIButton.Configuration.filled()
        btnConfiguration.cornerStyle = .large
        btnConfiguration.image = Images.movieTagUnchecked
        btnConfiguration.imagePlacement = .trailing
        btnConfiguration.imagePadding = 5
        btnConfiguration.title = title
        self.tag = tag
        self.sizeToFit()
        
        configuration = btnConfiguration
        
        // Button's action configuration
        let action = UIAction { _ in
            self.isSelected.toggle()
            self.delegate?.didTapMovieTag(sender: self)
        }
        addAction(action, for: .touchUpInside)
        
        // Button's design update configuration
        let handler: UIButton.ConfigurationUpdateHandler = { _ in
            switch self.state {
            case .selected:
                self.configuration?.baseBackgroundColor = .systemRed
                self.configuration?.image = Images.movieTagChecked
                self.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
            default:
                self.configuration?.baseBackgroundColor = Colors.lightRed
                self.configuration?.image = Images.movieTagUnchecked
                self.transform = .identity
            }
        }
        configurationUpdateHandler = handler
    }
}
