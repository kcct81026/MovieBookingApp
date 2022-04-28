//
//  SeatingVO.swift
//  MovieBookingApp
//
//  Created by KC on 09/04/2022.
//

import Foundation
import CoreImage

// MARK: - SeatingPlanResponse
struct SeatingPlanResponse: Codable {
    let code: Int?
    let message: String?
    let data: [[SeatingVO]]?
}

// MARK: - Datum
class SeatingVO: Codable {
    
    
    let id: Int?
    let type: String?
    let seatName, symbol: String?
    let price: Int?

    enum CodingKeys: String, CodingKey {
        case id, type
        case seatName = "seat_name"
        case symbol, price
    }
    
    var isSelected: Bool = false
    
    init(id: Int?, type: String?, seatName: String?, symbol: String?, price: Int?, isSelected: Bool = false) {
        self.id = id
        self.type = type
        self.seatName = seatName
        self.symbol = symbol
        self.price = price
        self.isSelected = isSelected
    }

    func isMovieSeatAvailable() -> Bool{
        return type == SEAT_TYPE_AVAILABLE
    }
    
    func isMovieSeatTaken() -> Bool {
        return type == SEAT_TYPE_TAKEN
    }
    
    func isMovieSeatRowTitle() -> Bool{
        return type == SEAT_TYPE_TEXT
    }
    
    func isMovieSeatNoTitle()->Bool{
        return type == SEAT_TYPE_EMPTY
    }
    
  
}

enum TypeEnum: String, Codable {
    case available = "available"
    case space = "space"
    case text = "text"
    case taken = "taken"
}

