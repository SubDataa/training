//
//  DetailViewController.swift
//  training
//
//  Created by Thibault Ballof on 25/01/2023.
//

import UIKit
import SDWebImage

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!

    var selectedMovie: Result?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if let selectedMovie = selectedMovie {
            let posterUrl = Service.shared.createURLForPoster(poster: selectedMovie.posterPath)
            let backdropUrl = Service.shared.createURLForPoster(poster: selectedMovie.backdropPath)
            posterImage.sd_setImage(with: URL(string: posterUrl), placeholderImage: UIImage(named: "placeholder.png"))
            backdropImage.sd_setImage(with: URL(string: backdropUrl), placeholderImage: UIImage(named: "placeholder.png"))
            titleLabel.text = selectedMovie.title
            overviewLabel.text = selectedMovie.overview
            releaseDateLabel.text = selectedMovie.releaseDate
        }
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
    }
}
