//
//  ViewControllerProvider.swift
//  training
//
//  Created by Thibault Ballof on 27/01/2023.
//
import UIKit
import Swinject

// Can be a ENUM?
struct ViewControllerProvider {
    private init() {}

    static var movieListViewController: MovieListViewController = {
        let viewModel = MovieListViewModel()
        let viewController = MovieListViewController()
        viewController.viewModel = viewModel
        return viewController
    }()

    static var movieDetailViewController: MovieDetailViewController = {
        let viewModel = MovieDetailViewModel()
        let viewController = MovieDetailViewController()
        viewController.viewModel = viewModel
        return viewController
    }()
}
