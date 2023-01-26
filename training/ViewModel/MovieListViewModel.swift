//
//  ViewModel.swift
//  training
//
//  Created by Thibault Ballof on 25/01/2023.
//

import Foundation

final class MovieListViewModel {
    var movies: [Result] = []
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
}
