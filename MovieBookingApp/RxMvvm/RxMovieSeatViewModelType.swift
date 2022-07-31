//
//  RxMovieSeatViewModelType.swift
//  MovieBookingApp
//
//  Created by KC on 06/06/2022.
//

import Foundation
import RxSwift
import Combine

protocol RxMovieSeatViewModelType{
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

