//
//  ViewModel.swift
//  training
//
//  Created by Thibault Ballof on 25/01/2023.
//

import Foundation

final class MovieListViewModel: ViewModeling {
    var movies: [MovieResult] = []
    var updateUI: (() -> Void)?
    private var appConfig: AppConfiguration = .webService
    private var service: NetworkServicing

    init(service: NetworkServicing) {
        self.service = service
    }

    func appConfigSelector() {
        switch appConfig {
        case .webService:
            appConfig = .mock
            service = GetMoviesMockService()
        case .mock:
            appConfig = .webService
            service = GetMoviesService()
        }
        getMovies()
    }

    func getMovies() {
        service.fetchMovies { [weak self] (result: Result<Movies, Error>) in
            switch result {
            case .success(let movies):
                self?.movies = movies.results
                self?.updateUI?()
            case .failure(let error):
                print(error)
            }
        }
    }

    func getURLImage(imgPath: String) -> String {
        let fullImgURL = ImageURL.imgURL + imgPath

        return fullImgURL
    }
}
