//
//  Service.swift
//  training
//
//  Created by Thibault Ballof on 23/01/2023.
//

import Foundation

protocol NetworkServicing {
    func fetchMovies(callback: @escaping (Bool, Movies?) -> Void)
}

class GetMoviesService: NetworkServicing {

    func fetchMovies(callback: @escaping (Bool, Movies?) -> Void) {
        guard let apiUrl = URL(string: "https://api.themoviedb.org/3/trending/movie/day?api_key=edef578eed4cd92a64fa40066ad4020b") else { return }

        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                guard  let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(Movies.self, from: data) else {
                    callback(false, nil)
                    return
                }
                print(responseJSON)
                callback(true, responseJSON)
            }
        }
        task.resume()
    }
}

class GetMoviesMockService: NetworkServicing {

    private var data: Data? {
        let bundle = Bundle(for: GetMoviesMockService.self)
        let url = bundle.url(forResource: "DataMock", withExtension: ".json")!
        return try? Data(contentsOf: url)
    }

    func fetchMovies(callback: @escaping (Bool, Movies?) -> Void) {

        guard let data = data else {
            callback(false, nil)
            return
        }
        guard let responseJSON = try? JSONDecoder().decode(Movies.self, from: data) else {
            callback(false, nil)
            return
        }
        callback(true, responseJSON)
    }
}
