//
//  SnackObject.swift
//  MovieBookingApp
//
//  Created by KC on 19/04/2022.
//

import Foundation
import RealmSwift

class SnackObject : Object{
    
    @Persisted(primaryKey: true)
    var id: Int?
    @Persisted
    var name: String?
    @Persisted
    var snackDescription: String?
    @Persisted
    var price: Int?
    @Persisted
    var image: String?
    
    func toSnackVO()-> SnackVO{
        return SnackVO(id: id, name: name, description: snackDescription, price: price, image: image)
    }
}
