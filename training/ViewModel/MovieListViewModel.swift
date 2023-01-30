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
    var buttonTapped: (() -> Void)?
    var appConfig: AppConfiguration = .webService
    var service: NetworkService
    
    init(service: Service) {
        self.service = service
    }

    @objc func touchButton() {
        switch appConfig {
        case .webService:
        appConfig = .mock
        service = MockService()
        case .mock:
        appConfig = .webService
        service = Service()
        }
        getMovie()
    }

    func getMovie() {

        service.fetchMovies { [weak self] (success, data) in
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
