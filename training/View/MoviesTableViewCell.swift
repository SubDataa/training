//
//  MoviesTableViewCell.swift
//  training
//
//  Created by Thibault Ballof on 23/01/2023.
//

import UIKit
import SDWebImage

final class MoviesTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func configure(model: SetupModel) {
        overviewLabel.text = model.overview
        titleLabel.text = model.title
        let poster = model.imageURL
        posterImage.sd_setImage(with: URL(string: poster))
    }
}
extension MoviesTableViewCell {
    struct SetupModel {
        let title: String
        let overview: String
        let imageURL: String
    }
}
