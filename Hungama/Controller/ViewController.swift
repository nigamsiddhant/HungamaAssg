//
//  ViewController.swift
//  Hungama
//
//  Created by admin_vserv on 19/12/20.
//

import UIKit

class ViewController: UIViewController {

    var results: [Movie] = []
    var page = 1
    @IBOutlet weak var tableView: UITableView!
    let movieCellName = "MovieXib"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
    }
    
    @IBAction func searchAction(_ sender: Any) {
        self.navigateToSearchView()
    }
    
    @IBAction func filterAction(_ sender: UIBarButtonItem) {
        
    }
    
    // load the main screen
    private func setupView() {
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        
        let logo = UIImage(named: "ilogo.png")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFill
        self.navigationItem.titleView = imageView
        
        self.tableView.register(UINib(nibName: movieCellName, bundle: nil), forCellReuseIdentifier: movieCellName)
        self.tableView.separatorStyle = .none
        
        getPopularMovies(pageNumber: page) // get popular movies
        
    }
    
    
    private func getPopularMovies(pageNumber: Int) {
        let queryItems = [URLQueryItem(name: "api_key", value: ApiHandler.api_key), URLQueryItem(name: "language", value: ApiHandler.language), URLQueryItem(name: "page", value: "\(pageNumber)")]
        
        ApiHandler.shared.getApiCall(urlString: ApiHandler.popular, queryParams: queryItems) { (movie: RootMovie) in
            guard let movies = movie.results else {
                print("no data found")
                return
            }
            self.results.append(contentsOf: movies)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // go to search page
    private func navigateToSearchView() {
        let storyBoard = UIStoryboard(name: "Search", bundle: nil)
        let searchViewController: SearchViewController = storyBoard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        searchViewController.movies = self.results
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    //go to detail page
    private func navigateToDetailScreen(index: Int) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController: DetailViewController = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailViewController.movie = self.results[index]
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }


}

// MARK:- UITableView Delegates
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieXib = tableView.dequeueReusableCell(withIdentifier: movieCellName) as! MovieXib
        cell.selectionStyle = .none
        cell.movie = self.results[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigateToDetailScreen(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK:- UIScrollView Delegates
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        
        if maximumOffset - currentOffset <= 10.0 {
            page = page + 1
            getPopularMovies(pageNumber: page)
        }
    }
}
