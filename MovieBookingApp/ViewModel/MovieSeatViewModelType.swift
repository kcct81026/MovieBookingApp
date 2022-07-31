//
//  MovieSeatViewModelType.swift
//  MovieBookingApp
//
//  Created by KC on 04/06/2022.
//

import Foundation
import Combine

protocol MovieSeatViewModelType{
    var rowCount : Int { get }
    var checkOut : CheckOut { get set }
    var seatList : [SeatingVO] { get }
    var chooseTicket : [String] { get }
    var totalPrice : Int  { get }
    var ticketString : String { get }
    
    func fetchSeating()
    func fetchCheckOut()
    func checkSeating()
    func tapComboSet()
}
