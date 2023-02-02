//
//  DetailViewController.swift
//  training
//
//  Created by Thibault Ballof on 25/01/2023.
//

import UIKit
import SDWebImage

final class MovieDetailViewController: UIViewController {

    @IBOutlet private weak var overviewLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var posterImage: UIImageView!
    @IBOutlet private weak var backdropImage: UIImageView!
    @IBOutlet private weak var releaseDateLabel: UILabel!

    var selectedMovie: Movie?
    var viewModel: MovieDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        posterImage.layer.borderWidth = 2
        posterImage.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
        posterImage.contentMode = .scaleAspectFill
        backdropImage.contentMode = .scaleAspectFill
        titleLabel.textColor = UIColor.white
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowRadius = 20
        releaseDateLabel.textColor = UIColor.white
        releaseDateLabel.layer.shadowColor = UIColor.black.cgColor
        releaseDateLabel.layer.shadowRadius = 60
        overviewLabel.numberOfLines = 0
        if let selectedMovie = selectedMovie {
            let posterURL = viewModel.getURLImage(imgPath: selectedMovie.posterPath)
            posterImage.sd_setImage(with: URL(string: posterURL), placeholderImage: UIImage(named: "placeholder.png"))
            let backdropURL = viewModel.getURLImage(imgPath: selectedMovie.backdropPath)
            backdropImage.sd_setImage(with: URL(string: backdropURL), placeholderImage: UIImage(named: "placeholder.png"))
            titleLabel.text = selectedMovie.title
            overviewLabel.text = selectedMovie.overview
            releaseDateLabel.text = selectedMovie.releaseDate
        }
    }
}
