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
struct SeatingVO: Codable {
    let id: Int?
    let type: String?
    let seatName, symbol: String?
    let price: Int?
    var isSelected: Bool = false

    enum CodingKeys: String, CodingKey {
        case id, type
        case seatName = "seat_name"
        case symbol, price
    }
    
    mutating func changeSelected(value: Bool){
        self.isSelected = value
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

