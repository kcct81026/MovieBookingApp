//
//  CheckOutObject.swift
//  MovieBookingApp
//
//  Created by KC on 07/04/2022.
//

import Foundation
import RealmSwift

class CheckOutObject: Object{
    @Persisted
    var cinemaDayTimeSlotId : Int?
    @Persisted
    var cinemaTimeSlot: String?
    @Persisted
    var row : String?
    @Persisted
    var seatNumber: String?
    @Persisted
    var bookingDate: String?
    @Persisted
    var totalPrice : Int?
    @Persisted(primaryKey: true)
    var movieId: Int?
    @Persisted
    var movieName: String?
    @Persisted
    var cardId: Int?
    @Persisted
    var cinemaId: Int?
    @Persisted
    var cinemaName: String?
    @Persisted
    var snacks: List<SnackCheckOutObject>
    @Persisted
    var moviePoseter : String?
    @Persisted
    var bookingNo : String?
    @Persisted
    var qrcode : String?
    
    
    func toCheckOut()->CheckOut{
        let snackList: [SnackCheckOut] = snacks.map{
            $0.toSnackCheckOut()
        }
        
        return CheckOut(cinemaDayTimeSlotId: cinemaDayTimeSlotId,  row: row, seatNumber: seatNumber, bookingDate: bookingDate, totalPrice: totalPrice, movieId: movieId, cardId: cardId, cinemaId: cinemaId, snacks: snackList, cinemaTimeSlot: cinemaTimeSlot, movieName: movieName, cinemaName: cinemaName, moviePoseter: moviePoseter, bookingNo: bookingNo, qrcode: qrcode)
        
       
    }
    
}

struct CheckOut {

    let cinemaDayTimeSlotId : Int?
    let row : String?
    let seatNumber: String?
    let bookingDate: String?
    let totalPrice : Int?
    let movieId: Int?
    let cardId: Int?
    let cinemaId: Int?
    let snacks: [SnackCheckOut]?
    let cinemaTimeSlot: String?
    let movieName: String?
    let cinemaName: String?
    let moviePoseter : String?
    let bookingNo : String?
    let qrcode : String?
    
//    enum CodingKeys: String, CodingKey {
//        case cinemaDayTimeSlotId  = "cinema_day_timeslot_id"
//        case row
//        case seatNumber = "seat_number"
//        case bookingDate = "booking_date"
//        case totalPrice = "total_price"
//        case movieId = "movie_id"
//        case cardId = "card_id"
//        case cinemaId = "cinema_id"
//        case snacks
//        case cinemaTimeSlot
//        case movieName
//        case cinemaName
//
//    }
    
    func toCheckOutObject()-> CheckOutObject{
        let object = CheckOutObject()
        object.cinemaDayTimeSlotId = cinemaDayTimeSlotId
        object.row = row
        object.seatNumber = seatNumber
        object.bookingDate = bookingDate
        object.totalPrice = totalPrice
        object.movieId = movieId
        object.cardId = cardId
        object.cinemaId = cinemaId
        object.cinemaTimeSlot = cinemaTimeSlot
        object.movieName = movieName
        object.cinemaName = cinemaName
        let snackObjList = List<SnackCheckOutObject>()
        snacks?.forEach{
            snackObjList.append($0.toSnackCheckOutObject())
            
        }
        object.snacks = snackObjList
        object.bookingNo = bookingNo
        object.moviePoseter = moviePoseter
        object.qrcode = qrcode
        
        return object
        
    }
    
    
}

struct SnackCheckOut : Codable{
    let id : Int?
    let quantity: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case quantity
    }
    
    func toSnackCheckOutObject()-> SnackCheckOutObject{
        let object = SnackCheckOutObject()
        object.id = id
        object.quantity = quantity
        return object
    }
    
}

class SnackCheckOutObject: Object{
    @Persisted(primaryKey: true)
    var id: Int?
    @Persisted
    var quantity: Int?
    
    func toSnackCheckOut()-> SnackCheckOut{
        return SnackCheckOut(id: id, quantity: quantity)
    }
}
