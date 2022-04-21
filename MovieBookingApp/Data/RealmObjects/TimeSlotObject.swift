//
//  TimeSlotObject.swift
//  MovieBookingApp
//
//  Created by KC on 08/04/2022.
//

import Foundation
import RealmSwift

class CinemaTimeSlotObject: Object {
    
    @Persisted
    var day: String?
    
    @Persisted(primaryKey: true)
    var cinemaID: Int?
    
    @Persisted
    var cinema: String?
    
    @Persisted
    var timeslots: List<TimeslotObject>
    
    func toTimeSlotVO() -> CinemaTimeSlot{
        let slots:[Timeslot] = timeslots.map{
            $0.toTimeSlot()
        }
        return(CinemaTimeSlot(cinemaID: cinemaID, cinema: cinema, timeslots: slots))
    }


}

class TimeslotObject: Object {
    
    @Persisted(primaryKey: true)
    var cinemaDayTimeslotID: Int?
    
    @Persisted
    var startTime: String?
    

    func toTimeSlot()->Timeslot{
        return Timeslot(cinemaDayTimeslotID: cinemaDayTimeslotID, startTime: startTime)
    }
    
}


