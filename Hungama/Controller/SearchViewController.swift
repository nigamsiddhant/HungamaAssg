//
//  SearchViewController.swift
//  Hungama
//
//  Created by admin_vserv on 19/12/20.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchHistoryTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var searchHistoryTableView: UITableView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var movies: [Movie]?
    var searchHistory: [String] = []
    var filteredMovie: [Movie] = []
    let movieCellName = "MovieXib"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    private func setupView() {
        self.title = "Search"
        self.showSearchTableView(showTableView: false)
        self.searchHistoryTableView.isHidden = true
        self.tableView.register(UINib(nibName: movieCellName, bundle: nil), forCellReuseIdentifier: movieCellName)
        self.tableView.separatorStyle = .none
    }
    
    private func showSearchTableView(showTableView: Bool) {
        self.searchHistoryTableView.isHidden = showTableView == true ? false : true
        self.searchHistoryTableViewHeight.constant = showTableView == true ? searchHistoryTableView.contentSize.height : 0
    }
    
    private func getFilteredData(searchString: String, movies: [Movie]) -> [Movie] {
        var filteredMovies = [Movie]()
        
        filteredMovies = movies.filter { (movie) -> Bool in
            let name = movie.title?.lowercased()
            let searchText = searchString.lowercased()
            
            if let breakedName = name?.split(separator: " "){
                for names in breakedName {
                    if names.hasPrefix(searchText){
                        return true
                    }
                }
            }
            return false
        }
        return filteredMovies
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

//MARK:-  Searchbar Delegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
//        if searchText == "" {
//
//        }
//        else {
//            guard let movies = self.movies else {
//                print("no movies found")
//                return
//            }
//            self.filteredMovie = self.getFilteredData(searchString: searchBar.text ?? "", movies: movies)
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchHistory.removeAll()
        let searchArray = CoreDataHandler.shared.fetchData().suffix(5).reversed()
        for searchHistorys in searchArray {
            self.searchHistory.append(searchHistorys)
        }
        DispatchQueue.main.async {
            self.searchHistoryTableView.reloadData()
            self.showSearchTableView(showTableView: true)
            print(self.searchHistoryTableView.contentSize.height)
            
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let movies = self.movies else {
            print("no movies found")
            return
        }
        self.filteredMovie = self.getFilteredData(searchString: searchBar.text ?? "", movies: movies)
        DispatchQueue.main.async {
            CoreDataHandler.shared.addData(searchText: searchBar.text)
            self.showSearchTableView(showTableView: false)
            self.tableView.reloadData()
            searchBar.text = ""
        }
    }
}

//MARK:-  UITableView Delegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchHistoryTableView {
            print(self.searchHistory.count)
            return self.searchHistory.count
        }
        return self.filteredMovie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == searchHistoryTableView {
            let searchCell = tableView.dequeueReusableCell(withIdentifier: "cell")
            let lblName = searchCell?.viewWithTag(1) as? UILabel
            lblName?.text = searchHistory[indexPath.row]
            searchCell?.selectionStyle = .none
            return searchCell!
        }
        let cell: MovieXib = tableView.dequeueReusableCell(withIdentifier: movieCellName) as! MovieXib
        cell.selectionStyle = .none
        cell.movie = self.filteredMovie[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.searchHistoryTableView {
            self.searchBar.text = self.searchHistory[indexPath.row]
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
