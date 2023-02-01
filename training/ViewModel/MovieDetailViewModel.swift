//
//  MovieDetailViewModel.swift
//  training
//
//  Created by Thibault Ballof on 26/01/2023.
//

import Foundation

final class MovieDetailViewModel: ViewModeling {

    func getURLImage(imgPath: String) -> String {
        let fullImgURL = ImageURL.imgURL + imgPath

        return fullImgURL
    }
}
