//
//  CastObject.swift
//  MovieBookingApp
//
//  Created by KC on 06/04/2022.
//

import Foundation
import RealmSwift

class CastObject : Object{
    
    @Persisted(primaryKey: true)
    var id : Int?
    @Persisted
    var name : String?
    @Persisted
    var profilePath : String?
//
//    @Persisted
//    var adult : Bool?
//    @Persisted
//    var gender : Int?
//    @Persisted
//    var knownForDepartment : String?
//    @Persisted
//    var originalName : String?
//    @Persisted
//    var popularity : Double?
//
//    @Persisted
//    var castID : Int?
//    @Persisted
//    var character : String?
//    @Persisted
//    var creditID : String?
//    @Persisted
//    var order : Int?
    
    func toCast() -> Cast{
        return Cast(id: id, name: name, profilePath: profilePath)
    }
    
//    func toCast()-> Cast {
//        Cast(adult: adult, gender: gender, id: id, knownForDepartment: knownForDepartment, name: name, originalName: originalName, popularity: popularity, profilePath: profilePath, castID: castID, character: character, creditID: creditID, order: order)
//    }
}
