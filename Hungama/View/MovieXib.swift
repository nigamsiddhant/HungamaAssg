//
//  MovieXib.swift
//  Hungama
//
//  Created by admin_vserv on 19/12/20.
//

import UIKit

class MovieXib: UITableViewCell {

    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var movieAvg: UILabel!
    
    var movie: Movie? {
        didSet {
            self.movieImage.loadImage(ApiHandler.shared.imageBaseUrl + (movie?.backdrop_path)!)
            self.movieAvg.text = "Avg rating: \(movie?.vote_average ?? 0)"
            self.movieTitle.text = movie?.title
            self.movieOverview.text = movie?.overview
            self.releaseDate.text = movie?.release_date
            self.ageLabel.text = movie?.adult == true ? "+18" : "+13"
            self.ageLabel.textColor = movie?.adult == true ? .red : .green
            self.likeCount.text = "Vote: \(movie?.vote_count ?? 0)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
