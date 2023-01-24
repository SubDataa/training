//
//  Service.swift
//  training
//
//  Created by Thibault Ballof on 23/01/2023.
//

import Foundation
import UIKit
import SDWebImage

class Service {
    // Singleton
    static var shared = Service()
    private init () {}
    
    
    // INJECT
    var task: URLSessionDataTask?
    private var session = URLSession(configuration: .default)
    init(session: URLSession) {
        self.session = session
    }
    func fetchMovies(callback: @escaping (Bool, Movies?) -> Void) {
        let apiUrl = URL(string: "https://api.themoviedb.org/3/trending/movie/day?api_key=edef578eed4cd92a64fa40066ad4020b")
        var request = URLRequest(url: apiUrl!)
        request.httpMethod = "GET"
        task = session.dataTask(with: request) { (data, response, error) in
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
        task?.resume()
    }
    
    func createURLForPoster(poster: String) -> String{
        let url = "https://image.tmdb.org/t/p/w500/" + poster
        return url
    }
    
}
