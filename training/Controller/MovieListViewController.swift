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
    private var selectedMovie: Result?

    private let viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = NSLocalizedString("NavTitle", comment: "Title Navigation bar")
        tableView.register(UINib.init(nibName: nameNib, bundle: nil), forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.delegate = self
        //getMovie()

        viewModel.updateUI = { [weak self] in
            self?.tableView.reloadData()

        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getMovie()
    }
    
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? MoviesTableViewCell else { return UITableViewCell() }

        cell.titleLabel.text = viewModel.movies[indexPath.row].title
        cell.overviewLabel.text = viewModel.movies[indexPath.row].overview
        let poster = Service.shared.createURLForPoster(poster: viewModel.movies[indexPath.row].posterPath)
        cell.posterImage.sd_setImage(with: URL(string: poster), placeholderImage: UIImage(named: "placeholder.png"))

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        selectedMovie = viewModel.movies[indexPath.row]
        let detailVC = MovieDetailViewController(nibName: "DetailViewController", bundle: nil)
        detailVC.selectedMovie = viewModel.movies[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
