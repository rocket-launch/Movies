//
//  SearchMoviesButton.swift
//  Movies
//
//  Created by Fabián Ferreira on 2022-02-07.
//

import UIKit

class SearchMoviesButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(with action: UIAction) {
        self.init(frame: .zero)
        setUpSearchMoviesButton(action: action)
    }
    
    private func setUpSearchMoviesButton(action: UIAction) {
        translatesAutoresizingMaskIntoConstraints = false
        isEnabled = false
        
        // Button's action
        addAction(action, for: .touchUpInside)
        
        // Button's title
        var attrContainer = AttributeContainer()
        attrContainer.font = Fonts.searchButtonFont
        let attrTitle = AttributedString("Search Movies", attributes: attrContainer)
        
        // Button's design configuration
        var btnConfiguration = UIButton.Configuration.tinted()
        btnConfiguration.baseBackgroundColor = .systemRed
        btnConfiguration.baseForegroundColor = .systemRed
        btnConfiguration.cornerStyle = .capsule
        btnConfiguration.image = Images.filmImage
        btnConfiguration.imagePlacement = .leading
        btnConfiguration.imagePadding = 5
        btnConfiguration.attributedTitle = attrTitle
        
        configuration = btnConfiguration
    }
}
