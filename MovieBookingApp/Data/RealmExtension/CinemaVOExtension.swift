//
//  CinemaVOExtension.swift
//  MovieBookingApp
//
//  Created by KC on 08/04/2022.
//

import Foundation
extension CinemaVO{
    static func toCinemaObject(cinema: CinemaVO) -> CinemaVoObject{
        let object = CinemaVoObject()
        object.id = cinema.id
        object.name = cinema.name
        object.address = cinema.address
        object.phone = cinema.phone
        object.email = cinema.email
        
        return object
    }
}
