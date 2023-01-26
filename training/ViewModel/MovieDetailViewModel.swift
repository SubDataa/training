//
//  MovieDetailViewModel.swift
//  training
//
//  Created by Thibault Ballof on 26/01/2023.
//

import Foundation

class MovieDetailViewModel {

    func getURLImage(imgPath: String) -> String {
        let imgURL = "https://image.tmdb.org/t/p/w500/" + imgPath
        return imgURL
    }
}
