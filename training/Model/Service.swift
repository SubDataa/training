//
//  Service.swift
//  training
//
//  Created by Thibault Ballof on 23/01/2023.
//

import Foundation
import RxSwift

protocol NetworkServicing {
    func fetchMovies<T: Decodable>(type: T.Type) -> Observable<T>
}

class GetMoviesService: NetworkServicing {

    func fetchMovies<T: Decodable>(type: T.Type) -> Observable<T> {

        return Observable<T>.create { observer in
            guard let apiUrl = URL(string: "https://api.themoviedb.org/3/trending/movie/day?api_key=edef578eed4cd92a64fa40066ad4020b") else { return Disposables.create() }

            var request = URLRequest(url: apiUrl)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else { return }
                    guard let data = data else { return }

                    do {
                        let result = try JSONDecoder().decode(type.self, from: data)
                        observer.onNext(result)
                    } catch let error {
                        observer.onError(error)
                    }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }

}

class GetMoviesMockService: NetworkServicing {

    private var data: Data? {
        let bundle = Bundle(for: GetMoviesMockService.self)
        let url = bundle.url(forResource: "GetMoviesMockService", withExtension: ".json")!
        return try? Data(contentsOf: url)
    }

    func fetchMovies<T: Decodable>(type: T.Type) -> Observable<T> {
        return Observable<T>.create { observer in
            let fetchTask = Task {
                guard let data = self.data else { return }

                do {
                    let result = try JSONDecoder().decode(type.self, from: data)
                    observer.onNext(result)
                } catch let error {
                    observer.onError(error)
                }
            }
            return Disposables.create {
                fetchTask.cancel()
            }
        }
    }
}
