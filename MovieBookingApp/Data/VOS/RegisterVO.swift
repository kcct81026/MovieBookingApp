//
//  RegisterVO.swift
//  MovieBookingApp
//
//  Created by KC on 05/04/2022.
//

import Foundation

struct RegisterResponse: Codable{
    let code: Int?
    let message: String?
    let userinfo: UserInfo?
    let token: String?
    let cards: [Card]?
    

    enum CodingKeys: String, CodingKey {
        case code
        case message
        case userinfo = "data"
        case token
        case cards
    }
}

struct ProfileResponse: Codable {
    let code: Int?
    let message: String?
    let data: ProfileVO?
}

// MARK: - DataClass
struct ProfileVO: Codable {
    let id: Int?
    let name, email, phone: String?
    let totalExpense: Int?
    let profileImage: String?
    let cards: [Card]?

    enum CodingKeys: String, CodingKey {
        case id, name, email, phone
        case totalExpense = "total_expense"
        case profileImage = "profile_image"
        case cards
    }
}

struct UserInfo: Codable{
    let id: Int?
    let name: String?
    let email: String?
    let phone: String?
    let totalExpense: Int?
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case phone
        case totalExpense = "total_expense"
        case profileImage = "profile_image"
    }
}

// MARK: - CardResponse
struct CardResponse: Codable {
    let code: Int?
    let message: String?
    let data: [Card]?
    let errors: Errors?
}

// MARK: - Errors
struct Errors: Codable {
    let cvc: [String]?
}

struct Card : Codable{
    let id: Int?
    let cardHolder: String?
    let cardNumber: String?
    let expireDate: String?
    let cardType: String?
    var isSelected: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case cardHolder = "card_holder"
        case cardNumber = "card_number"
        case expireDate = "expiration_date"
        case cardType = "card_type"
    }
    
    mutating func changeSelection(value: Bool){
        self.isSelected =  value
    }
    
    func toCardObject()-> CardObject{
        let object = CardObject()
        object.id = id
        object.cardHolder = cardHolder
        object.cardNumber = cardNumber
        object.expireDate = expireDate
        object.cardType = cardType
        object.isSelected = isSelected
        
        return object
    }
}

