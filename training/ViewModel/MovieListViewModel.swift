//
//  ViewModel.swift
//  training
//
//  Created by Thibault Ballof on 25/01/2023.
//

import Foundation
import UIKit
import SDWebImage

final class MovieListViewModel {
    var movies: [MoviesResult] = []
    var updateUI: (() -> Void)?

    func getMovie() {
        Service.shared.fetchMovies { [weak self] (success, data) in
            if success {
                guard let data = data else {return}

                self?.movies = data.results
                self?.updateUI?()
            }
        }
    }
    func getURLImage(imgPath: String) -> String {
        let imgURL = "https://image.tmdb.org/t/p/w500/" + imgPath
        return imgURL
    }
}
