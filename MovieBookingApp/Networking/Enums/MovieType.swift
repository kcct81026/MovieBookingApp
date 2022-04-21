//
//  MovieType.swift
//  MovieBookingApp
//
//  Created by KC on 06/04/2022.
//

import Foundation
enum MovieType: Int{
    case MOVIE_CURRENT = 0
    case MOVIE_UPCOMING = 1
    
}
enum MovieGroupType : String, CaseIterable{
    case current = "Now Showing"
    case comingsoon = "Coming Soon"
  
}
