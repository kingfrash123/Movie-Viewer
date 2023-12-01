//
//  ViewController.swift
//  Unit2Prod
//
//  Created by King on 9/24/23.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource {
    

    var movies: [Movie] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set self to be data source for table view
        tableView.dataSource = self

        // Create a URL for the request
        // In this case, the custom search URL you created in in part 1
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=60cf78756b8da2760c8bec9f9081ccd5")!

        // Use the URL to instantiate a request
        let request = URLRequest(url: url)

        // Create a URLSession using a shared instance and call its dataTask method
        // The data task method attempts to retrieve the contents of a URL based on the specified URL.
        // When finished, it calls it's completion handler (closure) passing in optional values for data (the data we want to fetch), response (info about the response like status code) and error (if the request was unsuccessful)
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

            // The `JSONSerialization.jsonObject(with: data)` method is a "throwing" function (meaning it can throw an error) so we wrap it in a `do` `catch`
            // We cast the resultant returned object to a dictionary with a `String` key, `Any` value pair.
            do {
                // Create a JSON Decoder
                let decoder = JSONDecoder()

                // Use the JSON decoder to try and map the data to our custom model.
                // TrackResponse.self is a reference to the type itself, tells the decoder what to map to.
                let response = try decoder.decode(MoviesResponse.self, from: data)

                // Access the array of tracks from the `results` property
                let movies = response.results
                // Execute UI updates on the main thread when calling from a background callback
                DispatchQueue.main.async {

                    // Set the view controller's tracks property as this is the one the table view references
                    self?.movies = movies

                    // Make the table view reload now that we have new data
                    self?.tableView.reloadData()
                }
                print("✅ \(movies)")
            } catch {
                print("❌ Error parsing JSON: \(error.localizedDescription)")
            }
        }

        // Initiate the network request
        task.resume()
        print(movies)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the cell that triggered the segue
        if let cell = sender as? UITableViewCell,
           // Get the index path of the cell from the table view
           let indexPath = tableView.indexPath(for: cell),
           // Get the detail view controller
           let detailViewController = segue.destination as? DetailViewController {

            let movie = movies[indexPath.row]

            detailViewController.movie = movie
        }

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell

        let movie = movies[indexPath.row]

        cell.configure(with: movie)

        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Get the index path for the current selected table view row (if exists)
        if let indexPath = tableView.indexPathForSelectedRow {

            // Deselect the row at the corresponding index path
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

}

