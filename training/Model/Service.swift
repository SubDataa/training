//
//  Service.swift
//  training
//
//  Created by Thibault Ballof on 23/01/2023.
//

import Foundation
import UIKit

protocol NetworkService {
    func fetchMovies(callback: @escaping (Bool, Movies?) -> Void)
}

class Service: NetworkService {

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
                callback(true, responseJSON)
            }
        }
        task?.resume()
    }
}
