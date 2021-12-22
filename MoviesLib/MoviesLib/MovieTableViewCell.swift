//
//  MovieTableViewCell.swift
//  MoviesLib
//
//  Created by user195143 on 12/15/21.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageViewPoster: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSummary: UILabel!
    @IBOutlet weak var labelRating: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWith(movie:Movie){
        labelTitle.text = movie.title
        labelRating.text = "⭐️ \(movie.rating)"
        labelSummary.text = movie.summary
        if let image = movie.image {
            imageViewPoster.image = UIImage(data: image)
        }
    }

}
