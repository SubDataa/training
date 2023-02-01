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
        inputTableView()
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

    func inputTableView() {
        tableView
            .rx.setDelegate(self)
            .disposed(by: disposeBag)

        viewModel.rxMovie.bind(to: tableView.rx.items(cellIdentifier: identifier, cellType: MoviesTableViewCell.self)) { _, model, cell in
            let posterImgURL = self.viewModel.getURLImage(imgPath: model.posterPath)
            cell.configure(model: MoviesTableViewCell.SetupModel(title: model.title, overview: model.overview, imageURL: posterImgURL))
        }.disposed(by: disposeBag)
    }
}

extension MovieListViewController: UITableViewDelegate {

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.movies.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? MoviesTableViewCell else { return UITableViewCell() }
//
//        let posterImgURL = viewModel.getURLImage(imgPath: viewModel.movies[indexPath.row].posterPath)
//        cell.configure(model: MoviesTableViewCell.SetupModel(title: viewModel.movies[indexPath.row].title, overview: viewModel.movies[indexPath.row].overview, imageURL: posterImgURL))
//
//        return cell
//    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//Observable
//            .zip(
//        tableView.rx.itemSelected
//        ,tableView.rx.modelSelected(MovieResult.Self))
//                            .subscribe(onNext: { [weak self] indexPath, model in
//                                guard let self = self else { return }
//                                self.selectedMovie = self.model[indexPath.row]
//                                self.performSegue(withIdentifier: "ItemDetail", sender: self)
//                            }).disposed(by: disposeBag)
//


        //        Observable
        //                  .zip(
        //                      tableView
        //                          .rx
        //                          .itemSelected
        //                        ,tableView
        //                        .rx
        //                        .modelSelected(MovieResult.self)
        //                  )
        //                  .bind{ [unowned self] indexPath, model in
        //                      guard let detailVC = ViewControllerProvider.movieDetailViewController else { return }
        //                             tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        //                             selectedMovie = model[indexPath.row]
        //                             detailVC.selectedMovie = model[indexPath.row]
        //                             navigationController?.pushViewController(detailVC, animated: true)
        //                  }
        //                  .disposed(by: disposeBag)
        //          }
    }
}

