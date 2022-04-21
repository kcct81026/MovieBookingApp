//
//  SnackVO.swift
//  MovieBookingApp
//
//  Created by KC on 19/04/2022.
//

import Foundation

// MARK: - SnakResponse
struct SnakResponse: Codable {
    let code: Int?
    let message: String?
    let data: [SnackVO]?
}

// MARK: - SnackVO
struct SnackVO: Codable {
    let id: Int?
    let name, description: String?
    let price: Int?
    let image: String?
    var count: Int = 0

    enum CodingKeys: String, CodingKey {
        case id, name
        case description
        case price, image
    }
    
    func toSnackObject()-> SnackObject{
        let object = SnackObject()
        object.id = id
        object.name = name
        object.snackDescription = description
        object.price = price
        object.image = image
        
        return object
    }
    
    mutating func changeCount(count: Int){
        self.count = count
    }
    
}
