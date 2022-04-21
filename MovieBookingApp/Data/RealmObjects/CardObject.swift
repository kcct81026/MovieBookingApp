//
//  CardObject.swift
//  MovieBookingApp
//
//  Created by KC on 19/04/2022.
//

import Foundation
import RealmSwift

class CardObject : Object{
    
    @Persisted(primaryKey: true)
    var id: Int?
    @Persisted
    var cardHolder: String?
    @Persisted
    var cardNumber: String?
    @Persisted
    var expireDate: String?
    @Persisted
    var cardType: String?
    @Persisted
    var isSelected: Bool = false
    
    func toCardVO()-> Card {
        return Card(id: id, cardHolder: cardHolder, cardNumber: cardNumber, expireDate: expireDate, cardType: cardType, isSelected: isSelected)
    }
}
