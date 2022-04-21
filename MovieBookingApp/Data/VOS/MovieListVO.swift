//
//  MovieListVO.swift
//  MovieBookingApp
//
//  Created by KC on 06/04/2022.
//

import RealmSwift

// MARK: - MovieResponse
struct MovieResponse: Codable {
    let code: Int?
    let message: String?
    let data: [MovieResult]?
}

// MARK: - Datum
struct MovieResult: Codable {
    let id: Int?
    let originalTitle, releaseDate: String?
    let genres: [String]?
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case genres
        case posterPath = "poster_path"
    }
    
    func movieResultToMovieDetail()->MovieDetailVO{
        return MovieDetailVO(id: id, originalTitle: originalTitle,releaseDate: releaseDate,genres: genres, overview: "", rating: 0, runtime: 0, posterPath: posterPath, casts: nil)
    }
    
}

struct BelongToType: Codable{
    let name: String?
    let movies: [MovieResult]?
}

class DateVo{

    var date: Int
    var day: String
    var dayOfSearch: String
    var isSelected: Bool
   
    init(date: Int, day: String, dayOfSearch: String, isSelected: Bool) {
        self.date = date
        self.day = day
        self.dayOfSearch = dayOfSearch
        self.isSelected = isSelected
    }
}


