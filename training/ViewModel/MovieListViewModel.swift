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

    let moviesRelay: BehaviorRelay<[Movie]> = BehaviorRelay(value: [])
    private var filteredMovies: [Movie] = []
    let filteredMoviesRelay = BehaviorRelay<[Movie]>(value: [])
    private var disposeBag = DisposeBag()
    var updateUI: (() -> Void)?
    private var appConfig: AppConfiguration = .webService
    private var service: NetworkServicing

    init(service: NetworkServicing) {
        self.service = service
    }

    func search(text: String) {
        filteredMovies = moviesRelay.value.filter { $0.title.contains(text) }
        filteredMoviesRelay.accept(filteredMovies)
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
                self?.moviesRelay.accept(response.results)
            }
        }.disposed(by: disposeBag)
    }

    func getURLImage(imgPath: String) -> String {
        let fullImgURL = ImageURL.imgURL + imgPath

        return fullImgURL
    }

}
