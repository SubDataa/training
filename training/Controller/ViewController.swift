//
//  ViewController.swift
//  training
//
//  Created by Thibault Ballof on 23/01/2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var movies: [Result] = []
    let nameNib = "MoviesTableViewCell"
    let identifier = "MoviesCell"
    
    override func viewDidLoad() {
        tableView.register(UINib.init(nibName: nameNib, bundle: nil), forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.delegate = self
        Service.shared.fetchMovies { (success, data) in
            if success {
                self.movies.append(contentsOf: data!.results)
                print(self.movies)
            }
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? MoviesTableViewCell else {
            return UITableViewCell() }
        cell.titleLabel.text = movies[indexPath.row].title
        cell.overviewLabel.text = movies[indexPath.row].overview
        let poster = Service.shared.createURLForPoster(poster: movies[indexPath.row].posterPath)
        cell.posterImage.sd_setImage(with: URL(string: poster), placeholderImage: UIImage(named: "placeholder.png"))

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }
}
