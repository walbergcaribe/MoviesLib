//
//  MovieViewController.swift
//  MoviesLib
//
//  Created by user195143 on 12/13/21.
//

import UIKit
import AVKit

class MovieViewController: UIViewController {

    @IBOutlet weak var imageViewPoster: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDuration: UILabel!
    @IBOutlet weak var labelCategories: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelSummary: UITextView!
    
    var movie:Movie?
    var moviePlayer: AVPlayer?
    var moviePlayerController: AVPlayerViewController?
    var trailer: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieFormViewController = segue.destination as? MovieFormViewController {
            movieFormViewController.movie = movie
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        prepareScreen()
        
        if let movieTitle = movie?.title {
            loadTrailer(with: movieTitle)
        }
    }
    
    func loadTrailer(with title: String) {
        let itunesPath = "https://itunes.apple.com/search?media=movie&entity=movie&term="
        
        guard let encodedTitle = title.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL(string: "\(itunesPath)\(encodedTitle)") else {return}
    
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let apiResult = try! JSONDecoder().decode(ItunesResult.self, from: data!)
            self.trailer = apiResult.results.first?.previewUrl ?? ""
            self.prepareVideo()
        }.resume()
    }
    
    func prepareVideo(){
        guard let url = URL(string: trailer) else {return}
        moviePlayer = AVPlayer(url: url)
        
        DispatchQueue.main.async {
            self.moviePlayerController = AVPlayerViewController()
            self.moviePlayerController?.player = self.moviePlayer
        }
    }
    
    func prepareScreen(){
        if let movie = movie {
            if let image = movie.image {
                imageViewPoster.image = UIImage(data: image)
            }
            labelTitle.text = movie.title
            labelDuration.text = movie.duration
            labelCategories.text = movie.categories
            labelRating.text = "⭐️ \(movie.rating)"
            labelSummary.text = movie.summary
        }
    }
    
    @IBAction func play(_ sender: UIButton) {
        guard let moviePlayerController = moviePlayerController else {return}
        present(moviePlayerController, animated: true){
            self.moviePlayer?.play()
        }
    }
}

struct ItunesResult:Codable {
    let results: [MovieInfo]
}
struct MovieInfo: Codable {
    let previewUrl: String
}
