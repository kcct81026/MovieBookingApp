//
//  CinemaObject.swift
//  MovieBookingApp
//
//  Created by KC on 06/04/2022.
//

import Foundation
import RealmSwift
import SwiftUI

class CinemaVoObject: Object{
    
    @Persisted(primaryKey: true)
    var id: Int?
    @Persisted
    var name : String?
    @Persisted
    var phone : String?
    @Persisted
    var email : String?
    @Persisted
    var address: String?
    
    func toCinema()-> CinemaVO{
        return CinemaVO(id: id, name: name, phone: phone, email: email, address: address)
    }
}

