//
//  Assembly.swift
//  training
//
//  Created by Thibault Ballof on 30/01/2023.
//

import Foundation
import Swinject

class MovieAssembly: Assembly {
    public init() {}
    func assemble(container: Container) {

        container.register(MovieDetailViewController.self) { _ in
            return MovieDetailViewController()
        }
        container.register(MovieDetailViewModel.self) { _ in
            return MovieDetailViewModel()
        }
        container.register(MovieListViewModel.self) { _ in
            return MovieListViewModel(service: Service())
        }
        container.register(MovieListViewController.self) { _ in
          return MovieListViewController()
        }
        container.register(Service.self) { _ in
            return Service()
        }
    }

}
