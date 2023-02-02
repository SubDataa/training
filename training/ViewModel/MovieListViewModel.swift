//
//  ViewModel.swift
//  training
//
//  Created by Thibault Ballof on 25/01/2023.
//

import Foundation
import RxSwift
import RxRelay

final class MovieListViewModel: ViewModeling {

    var movies: BehaviorRelay<[Movie]> = BehaviorRelay(value: [])

    var disposeBag = DisposeBag()
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
        service.fetchMovies(type: MoviesResults.self).subscribe { [weak self] response in
            DispatchQueue.main.async {
                self?.movies.accept(response.results)
            }
        }.disposed(by: disposeBag)
    }

    func getURLImage(imgPath: String) -> String {
        let fullImgURL = ImageURL.imgURL + imgPath

        return fullImgURL
    }

}
