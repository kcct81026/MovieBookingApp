//
//  TimeSlotVO.swift
//  MovieBookingApp
//
//  Created by KC on 08/04/2022.
//

import Foundation

// MARK: - TimeSlotResponse
struct TimeSlotResponse: Codable {
    let code: Int?
    let message: String?
    let data: [CinemaTimeSlot]?
}

// MARK: - CinemaTimeSlot
struct CinemaTimeSlot: Codable {
    let cinemaID: Int?
    let cinema: String?
    let timeslots: [Timeslot]?

    enum CodingKeys: String, CodingKey {
        case cinemaID = "cinema_id"
        case cinema, timeslots
    }
}

struct DateTimeSlotResponse{
    let day : String?
    let data: [CinemaTimeSlot]
}

// MARK: - Timeslot
struct Timeslot: Codable {
    let cinemaDayTimeslotID: Int?
    let startTime: String?

    enum CodingKeys: String, CodingKey {
        case cinemaDayTimeslotID = "cinema_day_timeslot_id"
        case startTime = "start_time"
    }
    
    func toTheatreType(cid: Int)-> TheatreVO{
        return TheatreVO(cinemaId: cid, id: cinemaDayTimeslotID ?? 0, type: startTime ?? "", isSelected: false)
    }
}

class TheatreVO{
    var cinemaId : Int
    var id: Int
    var type: String
    var isSelected: Bool
    
    init(cinemaId: Int, id:Int,type:String, isSelected:Bool){
        self.cinemaId = cinemaId
        self.id = id
        self.type = type
        self.isSelected = isSelected
    }
}

let theatreList = [
    TheatreVO(cinemaId: 0, id: 0, type: "2D", isSelected: true),
    TheatreVO(cinemaId: 0, id: 0, type: "3D", isSelected: false),
    TheatreVO(cinemaId: 0, id: 0, type: "IMAX", isSelected: false)
]
