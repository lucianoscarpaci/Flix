//
//  MoviesViewController.swift
//  NewsFlix
//
//  Created by luciano scarpaci on 9/2/22.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredData = searchText.isEmpty ? data : data.filter { (item: String) -> Bool in return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            };
            
            tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as!
            MovieCell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl +
                                posterPath)
        
        
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        cell.synopsisLabel.sizeToFit()
        cell.posterView.af.setImage(withURL:
                                        posterUrl!)
        
        
        return cell
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let data = ["Fall", "Dragon Ball Super: Super Hero", "DC League of Super-Pets", "Beast", "Minions: The Rise of Gru", "Nope", "The Black Phone", "Luck", "Spider-Man: No Way Home", "After Ever Happy", "Wire Room", "Sonic the Hedgehog 2", "The Ledge", "The princess", "I Came By", "Where the Crawdads Sing", "X", "Orphan: First Kill", "Into the Deep"]
    
    var filteredData: [String]!
    
    var searchController: UISearchController!
    
    
    var movies = [[String:Any]]()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("Loading up the details screen")
        
        //Get the selected movie
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        // Pass the selected movie to details
        let detailsViewController =
            segue.destination as!
            MovieDetailsViewController
        detailsViewController.movie = movie
        
        tableView.deselectRow(at: indexPath,
                              animated: true)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        //Search Controller
        filteredData = data
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        definesPresentationContext = true
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                    self.movies = dataDictionary["results"] as! [[String:Any]]
                
                    self.tableView.reloadData()
                    
                    print(dataDictionary)
                    // TODO: Get the array of movies
                    // TODO: Store the movies in a property to use elsewhere
                    // TODO: Reload your table view data

             }
        }
        task.resume()

    }
    


}

