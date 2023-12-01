//
//  PostersViewController.swift
//  Unit3Prod
//
//  Created by King on 10/1/23.
//

import UIKit
import Nuke

class PostersViewController: UIViewController, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Get a collection view cell (based in the identifier you set in storyboard) and cast it to our custom AlbumCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        
        // Use the indexPath.item to index into the albums array to get the corresponding album
        let poster = movies[indexPath.item]
        
        // Get the artwork image url
        let imageUrl = poster.posterImageUrl
        
        // Set the image on the image view of the cell
        Nuke.loadImage(with: imageUrl, into: cell.posterImageView)
        
        return cell
    }
    
    
    var movies: [Movie] = []
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=60cf78756b8da2760c8bec9f9081ccd5")!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            // Handle any errors
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
            }
            
            // Make sure we have data
            guard let data = data else {
                print("❌ Data is nil")
                return
            }
            
            // Create a JSON Decoder
            let decoder = JSONDecoder()
            do {
                // Try to parse the response into our custom model
                let response = try decoder.decode(MoviesResponse.self, from: data)
                let movies = response.results
                print(movies)
                DispatchQueue.main.async {
                    self?.movies = movies
                    self?.collectionView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
                
            }
        }
        
        // Initiate the network request
        task.resume()
        
        // Get a reference to the collection view's layout
        // We want to dynamically size the cells for the available space and desired number of columns.
        // NOTE: This collection view scrolls vertically, but collection views can alternatively scroll horizontally.
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        // Set the minimum spacing between adjacent cells (left / right)
        layout.minimumInteritemSpacing = 0
        
        // Set the minimum spacing between adjacent cells (top / bottom)
        layout.minimumLineSpacing = 0
        
        // Calculate the width of each cell to fill one-third of the screen width
        let numberOfColumns: CGFloat = 3
        let cellWidth = collectionView.bounds.width / numberOfColumns
        
        // Calculate the cell height based on the aspect ratio of your images
        let cellHeight = cellWidth * (3.0 / 2.0)
        
        // Set the size that each cell should display at
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            // Get the cell that triggered the segue
            if let cell = sender as? PosterCell,
               // Get the index path of the cell from the collection view
               let indexPath = collectionView.indexPath(for: cell),
               // Get the detail view controller
               let detailViewController = segue.destination as? DetailViewController {

                let movie = movies[indexPath.item]

                detailViewController.movie = movie
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
