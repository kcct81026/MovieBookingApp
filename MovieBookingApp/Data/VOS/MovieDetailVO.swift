//
//  MovieDetailVO.swift
//  MovieBookingApp
//
//  Created by KC on 06/04/2022.
//

import Foundation

// MARK: - MovieDetailResponse
struct MovieDetailResponse: Codable {
    let code: Int?
    let message: String?
    let data: MovieDetailVO?
}

// MARK: - DataClass
struct MovieDetailVO: Codable {
    let id: Int?
    let originalTitle, releaseDate: String?
    let genres: [String]?
    let overview: String?
    let rating: Double?
    let runtime: Int?
    let posterPath: String?
    let casts: [Cast]?

    enum CodingKeys: String, CodingKey {
        case id
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case genres, overview, rating, runtime
        case posterPath = "poster_path"
        case casts
    }
}

// MARK: - Cast
struct Cast: Codable {
    let id: Int?
    let name: String?
    let profilePath : String?
    

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePath = "profile_path"

    }
    
    func toCastObject()-> CastObject{
        let object = CastObject()
        object.id = id
        object.name = name
        object.profilePath = profilePath
        
        return object
    }
    
    
}

