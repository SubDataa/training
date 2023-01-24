//
//  Movies.swift
//  training
//
//  Created by Thibault Ballof on 23/01/2023.
//

import Foundation

struct Movies: Decodable {
    let results: [Result]
}

// MARK: - Result
struct Result: Decodable {
    let backdropPath: String
    let title: String
    let posterPath: String
    let releaseDate: String
    let overview: String

    enum CodingKeys: String, CodingKey {
        case title, overview
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
       
    }
}
