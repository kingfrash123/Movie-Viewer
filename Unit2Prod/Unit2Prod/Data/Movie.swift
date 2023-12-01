//
//

import Foundation

struct MoviesResponse: Decodable {
    let results: [Movie]
    
}

struct Movie {
    let title: String
    let overview: String
    let poster_path: String // Path to the poster image
    let backdrop_path: String // Path to the backdrop image
    let vote_average: Double
    let vote_count: Int
    let popularity: Float
    let release_date: String
    
    // Computed properties to construct image URLs
    var posterImageUrl: URL? {
        return constructImageUrl(for: poster_path, size: "w342")
    }
    
    var backdropImageUrl: URL? {
        return constructImageUrl(for: backdrop_path, size: "original")
    }
    
    private func constructImageUrl(for path: String, size: String) -> URL? {
        let baseImageUrl = "https://image.tmdb.org/t/p/"
        let imageUrlString = baseImageUrl + size + path
        return URL(string: imageUrlString)
    }
}


extension Movie: Decodable {
   

}

