//
//  Service.swift
//  training
//
//  Created by Thibault Ballof on 23/01/2023.
//

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
                print(responseJSON)
                callback(true, responseJSON)
            }
        }
        task.resume()
    }
}

class MockService: NetworkService {
    let data = Movies(results: [MovieResult(backdropPath: "/zGoZB4CboMzY1z4G3nU6BWnMDB2.jpg", title: "Shotgun Wedding", posterPath: "/t79ozwWnwekO0ADIzsFP1E5SkvR.jpg", releaseDate: "2022-12-28", overview: "Darcy and Tom gather their families for the ultimate destination wedding but when the entire party is taken hostage, “’Til Death Do Us Part” takes on a whole new meaning in this hilarious, adrenaline-fueled adventure as Darcy and Tom must save their loved ones—if they don’t kill each other first."), MovieResult(backdropPath: "/dlrWhn0G3AtxYUx2D9P2bmzcsvF.jpg", title: "M3GAN", posterPath: "/d9nBoowhjiiYc4FBNtQkPY7c11H.jpg", releaseDate: "2022-12-28", overview: "A brilliant toy company roboticist uses artificial intelligence to develop M3GAN, a life-like doll programmed to emotionally bond with her newly orphaned niece. But when the doll\'s programming works too well, she becomes overprotective of her new friend with terrifying results."), MovieResult(backdropPath: "/96SADhPnkXnVN3KaRKsDeBovLcm.jpg", title: "Teen Wolf: The Movie", posterPath: "/wAkpPm3wcHRqZl8XjUI3Y2chYq2.jpg", releaseDate: "2023-01-18", overview: "The wolves are howling once again, as a terrifying ancient evil emerges in Beacon Hills. Scott McCall, no longer a teenager yet still an Alpha, must gather new allies and reunite trusted friends to fight back against this powerful and deadly enemy.")])
    func fetchMovies(callback: @escaping (Bool, Movies?) -> Void) {
        callback(true, data)
    }
}
