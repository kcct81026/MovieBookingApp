//
//  PaymentVO.swift
//  MovieBookingApp
//
//  Created by KC on 19/04/2022.
//

import Foundation

// MARK: - PaymentResponse
struct PaymentResponse: Codable {
    let code: Int?
    let message: String?
    let data: [PaymentVO]?
}

// MARK: - Datum
struct PaymentVO: Codable {
    let id: Int?
    let name: String?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case description 
    }
    
    func toPaymentObject()->PaymentObject{
        let object = PaymentObject()
        object.id = id
        object.paymentDescription = description
        object.name = name
        
        return object
    }
}

