//
//  UserObject.swift
//  MovieBookingApp
//
//  Created by KC on 06/04/2022.
//

import Foundation
import RealmSwift

class BelongsToTypeObject : Object {
    
    @Persisted(primaryKey: true)
    var name : String?
    
    @Persisted
    var movieList : List<MovieObject>
    
    func toBelongToType ()-> BelongToType {
        let movies:[MovieResult] = movieList.map{
            $0.toMovieResult()
        }
        
        return BelongToType(name: name, movies: movies)
    }
    
    
}


/*
 class MovieResultObject : Object {
     @Persisted
     var adult: Bool?
     @Persisted
     var backdropPath: String?
     @Persisted
     var genreIDS: String?
     @Persisted(primaryKey: true)
 */
