//
//  CrewAndCastCell.swift
//  Hungama
//
//  Created by admin_vserv on 20/12/20.
//

import UIKit

class CrewAndCastCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var namelbl: UILabel!
    
    var details: CrewAndCastDetais? {
        didSet {
            self.namelbl.text = details?.name
            self.imageView.loadImage(ApiHandler.shared.imageBaseUrl + (details?.profile_path ?? ""))
        }
    }
    var similarMovieDetails: SimilarMovieResult? {
        didSet {
            self.namelbl.text = similarMovieDetails?.title
            self.imageView.loadImage(ApiHandler.shared.imageBaseUrl + (similarMovieDetails?.poster_path ?? ""))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
