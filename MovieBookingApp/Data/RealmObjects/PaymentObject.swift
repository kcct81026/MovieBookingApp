//
//  PaymentVO.swift
//  MovieBookingApp
//
//  Created by KC on 19/04/2022.
//

import Foundation
import RealmSwift

class PaymentObject : Object{
    
    @Persisted(primaryKey: true)
    var id: Int?
    @Persisted
    var name: String?
    @Persisted
    var paymentDescription: String?
    
    func toPaymentVO()-> PaymentVO{
        return PaymentVO(id: id, name: name, description: paymentDescription)
    }
}
