//
//  MovieListViewController.swift
//  training
//
//  Created by Thibault Ballof on 25/01/2023.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa

final class MovieListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private let nameNib = "MoviesTableViewCell"
    private let identifier = "MoviesCell"
    private var selectedMovie: Movie?
    var viewModel: MovieListViewModel!
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindTableView()
        navigationItem.title = NSLocalizedString("NavTitle", comment: "Title Navigation bar")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Mock", style: .plain, target: self, action: #selector(touchButton))
        tableView.register(UINib.init(nibName: nameNib, bundle: nil), forCellReuseIdentifier: identifier)
        viewModel.updateUI = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.getMovies()
    }

    @objc func touchButton() {
        viewModel.appConfigSelector()
    }

    func bindTableView() {
        tableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)

        viewModel.movies.bind(to: tableView.rx.items(cellIdentifier: identifier, cellType: MoviesTableViewCell.self)) { _, model, cell in
            let posterImgURL = self.viewModel.getURLImage(imgPath: model.posterPath)
            cell.configure(model: MoviesTableViewCell.SetupModel(title: model.title, overview: model.overview, imageURL: posterImgURL))
        }.disposed(by: disposeBag)
    }
}

extension MovieListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = ViewControllerProvider.movieDetailViewController else { return }

        tableView.rx.modelSelected(Movie.self)
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                self.selectedMovie = model
                detailVC.selectedMovie = self.selectedMovie
            }).disposed(by: disposeBag)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
