//
//  MovieObject.swift
//  MovieBookingApp
//
//  Created by KC on 06/04/2022.
//

import Foundation
import RealmSwift

class MovieObject : Object{
    
    @Persisted(primaryKey: true)
    var id : Int?
    @Persisted
    var originalTitle : String?
    @Persisted
    var releaseDate :  String?
    @Persisted
    var genres : String?
    @Persisted
    var posterPath :  String?
    @Persisted
    var overview : String?
    @Persisted
    var rating: Double?
    @Persisted
    var runtime: Int?
    
    @Persisted
    var casts : List<CastObject>
    
    func toMovieResult()-> MovieResult{
        
        return MovieResult(
            id: id,
            originalTitle: originalTitle,
            releaseDate: releaseDate,
            genres: genres?.components(separatedBy: ",").compactMap{ $0.trimmingCharacters(in: .whitespaces) },
            posterPath: posterPath
        )
    }
    
    func toMoiveDetail()-> MovieDetailVO{
        let cast:[Cast] = casts.map{
            $0.toCast()
        }
        
        return MovieDetailVO(id: id, originalTitle: originalTitle,releaseDate: releaseDate,genres: genres?.components(separatedBy: ",").compactMap{ $0.trimmingCharacters(in: .whitespaces) }, overview: overview, rating: rating, runtime: runtime, posterPath: posterPath, casts: cast)
    }
            
            
}
