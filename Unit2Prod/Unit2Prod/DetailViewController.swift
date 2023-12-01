//
//  DetailViewController.swift
//  Unit2Prod
//
//  Created by King on 9/24/23.
//

import UIKit
import Nuke

private let reuseIdentifier = "Cell"

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var movieNameLabelD: UILabel!
    @IBOutlet weak var movieRatingLabelD: UILabel!
    @IBOutlet weak var movieDateLabelD: UILabel!
    @IBOutlet weak var movieImageD: UIImageView!
    @IBOutlet weak var movieDescriptionD: UILabel!
    
    @IBOutlet weak var movieVoteCount: UILabel!
    @IBOutlet weak var moviePopularity: UILabel!
    
    var movie: Movie!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        Nuke.loadImage(with: movie.backdropImageUrl, into: movieImageD)

        movieNameLabelD.text = movie.title
        movieRatingLabelD.text = "\(movie.vote_average)"
        movieDateLabelD.text = movie.release_date
        movieDescriptionD.text = movie.overview
        movieVoteCount.text = "\(movie.vote_count)"
        moviePopularity.text = "\(movie.popularity)"


        
    }
}
