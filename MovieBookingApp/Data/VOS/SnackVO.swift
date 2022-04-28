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

class CardVO{
    var cardType: String
    var name:String
    
    init(cardType:String, name:String){
        self.cardType = cardType
        self.name = name
    }
}


// MARK: - SnackVO
class SnackVO: Codable {
    
    
    let id: Int?
    let name, description: String?
    let price: Int?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case description
        case price, image
    }
    var count: Int = 0

    init(id: Int?, name: String?, description: String?, price: Int?, image: String?, count: Int = 0) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.image = image
        self.count = count
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
    
   
    
}
