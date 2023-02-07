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

    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!

    private let nameNib = "MoviesTableViewCell"
    private let identifier = "MoviesCell"
    private var selectedMovie: Movie?
    var viewModel: MovieListViewModel!
    var disposeBag = DisposeBag()
    var searchedMovie: [String] = []
    var movies: MoviesResults?

    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        bindTableViews()
        bindSearchField()
        switchBetweenTableViews()
        navigationItem.title = NSLocalizedString(L10n.navTitle, comment: "Title Navigation bar")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: L10n.mock, style: .plain, target: self, action: #selector(touchButton))
        tableView.register(UINib.init(nibName: nameNib, bundle: nil), forCellReuseIdentifier: identifier)
        searchTableView.register(UINib.init(nibName: nameNib, bundle: nil), forCellReuseIdentifier: identifier)
        viewModel.updateUI = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.getMovies()
    }

    @objc private func touchButton() {
        viewModel.appConfigSelector()
    }

    private func bindSearchField() {
        searchBar.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                self?.viewModel.search(text: query)
            }).disposed(by: disposeBag)
    }

    private func bindTableViews() {
        tableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        searchTableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)

        viewModel.filteredMoviesRelay
            .bind(to: searchTableView.rx.items(cellIdentifier: self.identifier, cellType: MoviesTableViewCell.self)) { (_, model, cell) in
                let posterImgURL = self.viewModel.getURLImage(imgPath: model.posterPath)
                cell.configure(model: MoviesTableViewCell.SetupModel(title: model.title, overview: model.overview, imageURL: posterImgURL))
            }.disposed(by: self.disposeBag)

        viewModel.moviesRelay
            .bind(to: tableView.rx.items(cellIdentifier: self.identifier, cellType: MoviesTableViewCell.self)) { (_, model, cell) in
                let posterImgURL = self.viewModel.getURLImage(imgPath: model.posterPath)
                cell.configure(model: MoviesTableViewCell.SetupModel(title: model.title, overview: model.overview, imageURL: posterImgURL))
            }.disposed(by: self.disposeBag)
    }

    private func switchBetweenTableViews() {
        searchBar.rx.text.orEmpty
            .map { !$0.isEmpty }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isNotEmpty in
                guard let strongSelf = self else { return }
                strongSelf.tableView.isHidden = isNotEmpty
                strongSelf.searchTableView.isHidden = !isNotEmpty
            }).disposed(by: disposeBag)
    }

    private func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    private func switchTableViewDidSelectRowAt(_ selectedtableView: UITableView, viewController: MovieDetailViewController) {
             selectedtableView
                 .rx.modelSelected(Movie.self)
                 .subscribe(onNext: { model in
                     viewController.selectedMovie = model
                 })
                 .disposed(by: disposeBag)
             navigationController?.pushViewController(viewController, animated: true)
     }

}

extension MovieListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = ViewControllerProvider.movieDetailViewController else { return }

        if tableView == self.tableView {
            switchTableViewDidSelectRowAt(tableView, viewController: detailVC)
        } else {
            switchTableViewDidSelectRowAt(searchTableView, viewController: detailVC)
        }
    }
}
