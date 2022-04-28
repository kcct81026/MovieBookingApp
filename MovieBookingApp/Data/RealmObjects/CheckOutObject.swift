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
    @Persisted
    var runtime: Int?
    @Persisted
    var type: String?
    
    
    func toCheckOut()->CheckOut{
        let snackList: [SnackCheckOut] = snacks.map{
            $0.toSnackCheckOut()
        }
        
        return CheckOut(cinemaDayTimeSlotId: cinemaDayTimeSlotId,  row: row, seatNumber: seatNumber, bookingDate: bookingDate, totalPrice: totalPrice, movieId: movieId, cardId: cardId, cinemaId: cinemaId, snacks: snackList, cinemaTimeSlot: cinemaTimeSlot, movieName: movieName, cinemaName: cinemaName, moviePoseter: moviePoseter, bookingNo: bookingNo, qrcode: qrcode, runtime : runtime, type: type)
        
       
    }
    
}

class CheckOut : Codable{
   
    
    var cinemaDayTimeSlotId : Int?
    var row : String?
    var seatNumber: String?
    var bookingDate: String?
    var totalPrice : Int?
    var movieId: Int?
    var cardId: Int?
    var cinemaId: Int?
    var snacks: [SnackCheckOut]?
    
    enum CodingKeys: String, CodingKey {
        case cinemaDayTimeSlotId  = "cinema_day_timeslot_id"
        case row
        case seatNumber = "seat_number"
        case bookingDate = "booking_date"
        case totalPrice = "total_price"
        case movieId = "movie_id"
        case cardId = "card_id"
        case cinemaId = "cinema_id"
        case snacks = "snacks"

    }
    
    var cinemaTimeSlot: String?
    var movieName: String?
    var cinemaName: String?
    var moviePoseter : String?
    var bookingNo : String?
    var qrcode : String?
    var runtime: Int?
    var type: String?
    
    init(cinemaDayTimeSlotId: Int? = nil, row: String? = nil, seatNumber: String? = nil, bookingDate: String? = nil, totalPrice: Int? = nil, movieId: Int? = nil, cardId: Int? = nil, cinemaId: Int? = nil, snacks: [SnackCheckOut]? = nil, cinemaTimeSlot: String? = nil, movieName: String? = nil, cinemaName: String? = nil, moviePoseter: String? = nil, bookingNo: String? = nil, qrcode: String? = nil, runtime: Int? = nil, type: String? = nil) {
        self.cinemaDayTimeSlotId = cinemaDayTimeSlotId
        self.row = row
        self.seatNumber = seatNumber
        self.bookingDate = bookingDate
        self.totalPrice = totalPrice
        self.movieId = movieId
        self.cardId = cardId
        self.cinemaId = cinemaId
        self.snacks = snacks
        self.cinemaTimeSlot = cinemaTimeSlot
        self.movieName = movieName
        self.cinemaName = cinemaName
        self.moviePoseter = moviePoseter
        self.bookingNo = bookingNo
        self.qrcode = qrcode
        self.runtime = runtime
        self.type = type
    }
    
    
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
        object.runtime = runtime
        object.type = type
        
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
