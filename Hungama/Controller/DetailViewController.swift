//
//  DetailViewController.swift
//  Hungama
//
//  Created by admin_vserv on 19/12/20.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var similarMovieCollectionView: UICollectionView!
    @IBOutlet weak var crewCollectionView: UICollectionView!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var releaseDate: UILabel!
    var movie: Movie?
    var crews: [CrewAndCastDetais]?
    var casts: [CrewAndCastDetais]?
    var similarMovie: [SimilarMovieResult]?
    let cellName = "CrewAndCastCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        self.title = movie?.title
        self.castCollectionView.register(UINib(nibName: cellName, bundle: nil), forCellWithReuseIdentifier: cellName)
        self.crewCollectionView.register(UINib(nibName: cellName, bundle: nil), forCellWithReuseIdentifier: cellName)
        self.similarMovieCollectionView.register(UINib(nibName: cellName, bundle: nil), forCellWithReuseIdentifier: cellName)
        let concurrentQueue = DispatchQueue(label: "com.concurrent.queue", attributes: .concurrent)
        
        concurrentQueue.async {
            self.getMovieDetails()
        }
        concurrentQueue.async {
            self.getCastAndCrew()
        }
        concurrentQueue.async {
            self.getSimilarMovies()
        }
        
        
    }
    
    private func getMovieDetails() {
        guard let movie = self.movie else {return}
        let queryItems = [URLQueryItem(name: "api_key", value: ApiHandler.api_key), URLQueryItem(name: "language", value: ApiHandler.language)]
        
        ApiHandler.shared.getApiCall(urlString: "\(movie.id)", queryParams: queryItems) { (movieDetails: MovieDetail) in
            self.setValueToView(movieDetails: movieDetails)
        }
    }
    
    private func getCastAndCrew() {
        guard let movie = self.movie else {return}
        let queryItems = [URLQueryItem(name: "api_key", value: ApiHandler.api_key), URLQueryItem(name: "language", value: ApiHandler.language)]
        
        let appendedUrl = "\(movie.id)" + #"/"# + "\(ApiHandler.credits)"
        
        ApiHandler.shared.getApiCall(urlString: appendedUrl, queryParams: queryItems) { (crewCastDetails: CrewAndCast) in
            self.crews = crewCastDetails.crew
            self.casts = crewCastDetails.cast
            DispatchQueue.main.async {
                self.castCollectionView.reloadData()
                self.crewCollectionView.reloadData()
            }
        }
    }
    
    private func getSimilarMovies(){
        guard let movie = self.movie else {return}
        let queryItems = [URLQueryItem(name: "api_key", value: ApiHandler.api_key), URLQueryItem(name: "language", value: ApiHandler.language), URLQueryItem(name: "page", value: "1")]
        
        let appendedUrl = "\(movie.id)" + #"/"# + "\(ApiHandler.similar)"
        
        ApiHandler.shared.getApiCall(urlString: appendedUrl, queryParams: queryItems) { (similarMovie: SimilarMovie) in
            self.similarMovie = similarMovie.results
            DispatchQueue.main.async {
                self.similarMovieCollectionView.reloadData()
            }
        }
    }
    
    private func setValueToView(movieDetails: MovieDetail){
        DispatchQueue.main.async {
            guard let movie = self.movie else {return}
            self.previewImage.loadImage(ApiHandler.shared.imageBaseUrl + (movie.backdrop_path)!)
            self.movieTitle.text = movie.title
            self.releaseDate.text = movie.release_date
            self.genreLabel.text = movieDetails.genres!.map{$0.name!}.joined(separator: ",")
            self.languageLabel.text = movieDetails.production_countries!.map{$0.name}.joined(separator: ",")
            self.overViewLabel.text = movie.overview
        }
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
//MARK:-  UICollectionView Delegate
extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.crewCollectionView{
            return crews?.count ?? 0
        }
        else if collectionView == castCollectionView {
            return casts?.count ?? 0
        }
        return similarMovie?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CrewAndCastCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as! CrewAndCastCell
        if collectionView == crewCollectionView {
            cell.details = crews?[indexPath.row]
        }
        else if collectionView == castCollectionView {
            cell.details = casts?[indexPath.row]
        }
        else if collectionView == similarMovieCollectionView{
            cell.similarMovieDetails = similarMovie?[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: 161.5)
    }
    
    
}
