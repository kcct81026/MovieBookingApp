//
//  MovieObjectExtension.swift
//  MovieBookingApp
//
//  Created by KC on 06/04/2022.
//

import Foundation
extension MovieResult {
    static func toMovieObject(movie: MovieResult) -> MovieObject{
        let object = MovieObject()
        object.id = movie.id
        object.originalTitle = movie.originalTitle
        object.releaseDate = movie.releaseDate
        object.genres = movie.genres?.map { $0}.joined(separator: ",")
        object.posterPath = movie.posterPath
        return object
    }
    
}
