//
//  SeatingVOExtension.swift
//  MovieBookingApp
//
//  Created by KC on 18/04/2022.
//

import Foundation
extension SeatingVO{
    static func toSeatingObject(seating: SeatingVO) -> SeatingObject{
        let object = SeatingObject()
        object.pId = "\(String(describing: seating.id!))\(String(describing: seating.symbol!))"
        object.id = seating.id
        object.type = seating.type
        object.seatName = seating.seatName
        object.symbol = seating.symbol
        object.price = seating.price
        object.isSelected = seating.isSelected
        
        return object
    }
}


