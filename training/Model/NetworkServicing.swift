//
//  Service.swift
//  training
//
//  Created by Thibault Ballof on 23/01/2023.
//

import Foundation

protocol NetworkServicing {
    func fetchMovies<T: Decodable>(callback: @escaping (Result<T, Error>) -> Void)
}

class GetMoviesService: NetworkServicing {

    func fetchMovies<T: Decodable>(callback: @escaping (Result<T, Error>) -> Void) {
        guard let apiUrl = URL(string: "https://api.themoviedb.org/3/trending/movie/day?api_key=edef578eed4cd92a64fa40066ad4020b") else { return }

        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else { return }

                guard let data = data else { return }

                do {
                    callback(.success(try JSONDecoder().decode(T.self, from: data)))
                } catch let error {
                    print(String(data: data, encoding: .utf8) ?? "nothing received")
                    callback(.failure(error))
                }
            }
        }
        task.resume()
    }
}

class GetMoviesMockService: NetworkServicing {

    private var data: Data? {
        let bundle = Bundle(for: GetMoviesMockService.self)
        let url = bundle.url(forResource: "GetMoviesMockService", withExtension: ".json")!
        return try? Data(contentsOf: url)
    }

    func fetchMovies<T: Decodable>(callback: @escaping (Result<T, Error>) -> Void ) {

        guard let data = data else { return }

        do {
            callback(.success(try JSONDecoder().decode(T.self, from: data)))
        } catch let error {
            print(String(data: data, encoding: .utf8) ?? "nothing received")
            callback(.failure(error))
        }
    }
}
