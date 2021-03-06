//
//  Images.swift
//  Movies
//
//  Created by Fabián Ferreira on 2022-02-07.
//

import UIKit

enum Images {
    static let movieTagUnchecked = UIImage(systemName: "circle")
    static let movieTagChecked = UIImage(systemName: "checkmark.circle.fill")
    static let filmImage = UIImage(systemName: "film")
}

enum Colors {
    static let lightRed = UIColor(red: 1.00, green: 0.53, blue: 0.55, alpha: 1.00)
}

enum Fonts {
    static let movieTitleFont = UIFont.systemFont(ofSize: 25, weight: .bold)
    static let movieDetailsFont = UIFont.systemFont(ofSize: 20, weight: .medium)
    static let searchButtonFont = UIFont.systemFont(ofSize: 20)
    static let noMoviewFoundFont = UIFont.systemFont(ofSize: 40, weight: .bold)
}
