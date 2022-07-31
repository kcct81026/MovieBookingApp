//
//  MockRxCheckOutModel.swift
//  MovieBookingAppTests
//
//  Created by KC on 05/06/2022.
//

import Foundation
@testable import MovieBookingApp
import RxSwift

class MockRxCheckOutModel : RxCheckOutModel{

    
    var seating_list : [[SeatingVO]] = [[]]
    
    var validInputs = true
    
    init(){
        let seatingDataJSON : Data = try! Data(contentsOf: BookingMockData.SeatingPlanResult.seatingPlanResultJSONUrl)
        let seatingDataResponse = try! JSONDecoder().decode(SeatingPlanResponse.self, from: seatingDataJSON)
        seating_list = seatingDataResponse.data!
    }
    
    func getCheckOutObservable() -> Observable<CheckOut> {
        return Observable.just(CheckOut.dummy())
    }
    
    func getSeating(day: String, id: Int) -> Observable<[SeatingVO]> {
        if validInputs {
            return Observable.just(SeatingVOHelper.changingToSingleSeatingVOArray(data: seating_list))
        }
        else{
            return Observable.just([SeatingVO]())
        }
    }
    
    func saveCheckOut(checkout: CheckOut) {
        
    }
    
  
}

