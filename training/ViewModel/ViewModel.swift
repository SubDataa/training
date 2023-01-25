//
//  ViewModel.swift
//  training
//
//  Created by Thibault Ballof on 25/01/2023.
//

import Foundation
class ViewModel {

   var movies: [Result] = []
     func getMovie() {
        Service.shared.fetchMovies { [weak self] (success, data) in
            if success {
                if let data = data {
                    self?.movies = data.results
                    self?.updateUI?()
                }
            }
        }
    }
    var updateUI: (() -> Void)?
}
