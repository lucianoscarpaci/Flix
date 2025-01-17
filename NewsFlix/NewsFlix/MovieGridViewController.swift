//
//  MovieGridViewController.swift
//  NewsFlix
//
//  Created by luciano scarpaci on 9/7/22.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
   
    

    @IBOutlet weak var collectionView: UICollectionView!
    var movies = [[String:Any]]()
    //realData for search bar
    var realMovies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout =
            collectionView.collectionViewLayout as!
            UICollectionViewFlowLayout
        // controls the space in between the rows
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        // create a width for the side to change no matter which phone
        let width = (view.frame.size.width -
                        layout.minimumInteritemSpacing * 2) / 2
        layout.itemSize = CGSize(width: width, height:
                                    width * 2 / 2)

        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                    self.movies = dataDictionary["results"] as! [[String:Any]]
                    self.realMovies = dataDictionary["results"] as!
                        [[String:Any]]
                
                self.collectionView.reloadData()
                print(self.movies)

             }
        }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as!
            MovieGridCell
        
        let movie = movies[indexPath.item]
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl +
                                posterPath)
        
        cell.posterView.af.setImage(withURL:
                                        posterUrl!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let searchView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchBar", for: indexPath)
        return searchView
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar, cellForItemAt indexPath: IndexPath) {
        
        
        self.movies.removeAll()
        
        
        if (searchBar.text!.isEmpty) {
            self.movies = self.realMovies
        }
        
        self.collectionView.reloadData()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("Loading up the details screen")
        
        //Find the movie
        let superHeroCell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for:
                                                    superHeroCell)!
        let movie = movies[indexPath.row]
        
        //Pass the selected movie to SuperheroDetailsViewController
        let superHeroDetailsViewController =
            segue.destination as!
            SuperheroDetailsViewController
        superHeroDetailsViewController.movie = movie
    }
    

}
