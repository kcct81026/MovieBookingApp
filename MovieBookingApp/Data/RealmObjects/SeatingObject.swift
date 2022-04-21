//
//  SeatingObject.swift
//  MovieBookingApp
//
//  Created by KC on 18/04/2022.
//

import Foundation
import RealmSwift

class SeatingObject : Object{
    
    @Persisted(primaryKey: true)
    var pId: String?
    @Persisted
    var id: Int?
    @Persisted
    var type: String?
    @Persisted
    var seatName: String?
    @Persisted
    var symbol: String?
    @Persisted
    var price: Int?
    @Persisted
    var isSelected: Bool?
    
    func toSeatingVO()-> SeatingVO{
        return SeatingVO(id: id, type: type, seatName: seatName, symbol: symbol, price: price, isSelected: isSelected ?? false)
    }
}
