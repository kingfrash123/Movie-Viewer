//
//  MovieCell.swift
//  Unit2Prod
//
//  Created by King on 9/24/23.
//

import UIKit
import Nuke

class MovieCell: UITableViewCell {

    @IBOutlet weak var movieImageM: UIImageView!
    @IBOutlet weak var movieNameLabelM: UILabel!
    @IBOutlet weak var movieDescriptionLabelM: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with movie: Movie) {
        movieNameLabelM.text = movie.title
        movieDescriptionLabelM.text = movie.overview

        // Load image async via Nuke library image loading helper method
        Nuke.loadImage(with: movie.posterImageUrl, into: movieImageM)
    }

}
