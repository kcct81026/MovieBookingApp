//
//  MovieDetailExtension.swift
//  MovieBookingApp
//
//  Created by KC on 06/04/2022.
//

import Foundation
import RealmSwift

extension MovieDetailVO {
    static func detailToMovieObject(movie: MovieDetailVO) -> MovieObject{
        let object = MovieObject()
        object.id = movie.id
        object.originalTitle = movie.originalTitle
        object.releaseDate = movie.releaseDate
        object.genres = movie.genres?.map { $0}.joined(separator: ",")
        object.posterPath = movie.posterPath
        object.overview = movie.overview
        object.rating = movie.rating
        object.runtime = movie.runtime
        let casts = List<CastObject>()
        movie.casts?.forEach{
            casts.append($0.toCastObject())
            
        }
        object.casts = casts
        return object
    }
    
}


/*
 @Persisted(primaryKey: true)
 var  : Int?
 @Persisted
 var  : String?
 @Persisted
 var  :  String?
 @Persisted
 var  : String?
 @Persisted
 var  :  String?
 @Persisted
 var  : String?
 @Persisted
 var rating: Double?
 @Persisted
 var runtime: Int?
 
 @Persisted
 var casts : List<CastObject>
 */
