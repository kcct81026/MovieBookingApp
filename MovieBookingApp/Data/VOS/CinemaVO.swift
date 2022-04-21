//
//  CinemaVO.swift
//  MovieBookingApp
//
//  Created by KC on 06/04/2022.
//

import Foundation

// MARK: - CinemaResponse
struct CinemaList: Codable {
    let code: Int?
    let message: String?
    let data: [CinemaVO]?
}

// MARK: - CinemaVO
struct CinemaVO: Codable {
    
    
    let id: Int?
    var address, phone, email :String?

    var name: String?
    
    init(id: Int?, name: String?, phone: String?, email: String?, address: String?) {
        self.id = id
        self.name = name
        self.phone = phone
        self.email = email
        self.address = address
    }
    
    mutating func changeName(){
        self.name = "Akira"
    }
}

