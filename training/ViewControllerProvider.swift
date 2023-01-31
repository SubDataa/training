//
//  ViewControllerProvider.swift
//  training
//
//  Created by Thibault Ballof on 27/01/2023.
//
import Foundation
import Swinject

enum ViewControllerProvider {

    static var movieListViewController: MovieListViewController? {
        let assembler = Assembler([MovieAssembly()])
        let controller = assembler.resolver.resolve(MovieListViewController.self)
        controller?.viewModel = assembler.resolver.resolve(MovieListViewModel.self)

        return controller
    }

    static var movieDetailViewController: MovieDetailViewController? {
        let assembler = Assembler([MovieAssembly()])
        let controller = assembler.resolver.resolve(MovieDetailViewController.self)
        controller?.viewModel = assembler.resolver.resolve(MovieDetailViewModel.self)

        return controller
    }
}
