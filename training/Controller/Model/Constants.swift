//
//  Constants.swift
//  training
//
//  Created by Thibault Ballof on 30/01/2023.
//

import Foundation

enum ImageURL {
    static let imgURL = "https://image.tmdb.org/t/p/w500/"
}

enum DataMock {
    case badData, goodData, badDataWithNilValue
}

enum AppConfiguration {
    case webService, mock
}
