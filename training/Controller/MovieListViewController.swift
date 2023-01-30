//
//  MovieListViewController.swift
//  training
//
//  Created by Thibault Ballof on 25/01/2023.
//

import UIKit
import SDWebImage

final class MovieListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private let nameNib = "MoviesTableViewCell"
    private let identifier = "MoviesCell"
    private var selectedMovie: MovieResult?
    var viewModel: MovieListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = NSLocalizedString("NavTitle", comment: "Title Navigation bar")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Mock", style: .plain, target: viewModel, action: #selector(viewModel.touchButton))
        tableView.register(UINib.init(nibName: nameNib, bundle: nil), forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.delegate = self
        viewModel.updateUI = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.getMovie()
    }
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? MoviesTableViewCell else { return UITableViewCell() }

        let posterImgURL = viewModel.getURLImage(imgPath: viewModel.movies[indexPath.row].posterPath)
        cell.configure(model: MoviesTableViewCell.SetupModel(title: viewModel.movies[indexPath.row].title, overview: viewModel.movies[indexPath.row].overview, imageURL: posterImgURL))

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        selectedMovie = viewModel.movies[indexPath.row]
        guard let detailVC = ViewControllerProvider.movieDetailViewController else {return}
        detailVC.selectedMovie = viewModel.movies[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
