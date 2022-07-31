//
//  BookingMockData.swift
//  MovieBookingAppTests
//
//  Created by KC on 05/06/2022.
//

import Foundation

public final class BookingMockData{
    
    class SeatingPlanResult{
        public static let seatingPlanResultJSONUrl : URL = Bundle(for: BookingMockData.self).url(forResource: "seating_plan", withExtension: ".json")!
      
    }
}
