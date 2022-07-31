//
//  MockSeatingPlanViewModel.swift
//  MovieBookingAppTests
//
//  Created by KC on 05/06/2022.
//

import Foundation
@testable import MovieBookingApp

class MockCheckOutModel : CheckOutModel{
    
    var seating_list : [[SeatingVO]] = [[]]
    
    var validInputs = true
    
    init(){
        let seatingDataJSON : Data = try! Data(contentsOf: BookingMockData.SeatingPlanResult.seatingPlanResultJSONUrl)
        let seatingDataResponse = try! JSONDecoder().decode(SeatingPlanResponse.self, from: seatingDataJSON)
        seating_list = seatingDataResponse.data!
    }
    
    func getCheckOut(completion: @escaping (MovieBookingResult<CheckOut>) -> Void) {
        completion(.success(CheckOut.dummy()))
    }
    
    func getTimeSlotsByDay(day: String, movieId: Int, completion: @escaping (MovieBookingResult<[CinemaTimeSlot]>) -> Void) {
        
    }
    
    func getSeating(day: String, id: Int, completion: @escaping (MovieBookingResult<[SeatingVO]>) -> Void) {
        if validInputs {
            return completion(.success(SeatingVOHelper.changingToSingleSeatingVOArray(data: seating_list)))
        }
        else{
            return completion(.success([SeatingVO]()))
        }
    }
    
    func getCinemaList(completion: @escaping (MovieBookingResult<[CinemaVO]>) -> Void) {
        
    }
    
    func saveCheckOut(checkout: CheckOut) {
        
    }
    
    func sendCheckOut(checkout: CheckOut, completion: @escaping (MovieBookingResult<CheckOutResponse>) -> Void) {
        
    }
    
    
}
