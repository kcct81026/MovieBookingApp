//
//  CheckOutRepository.swift
//  MovieBookingApp
//
//  Created by KC on 07/04/2022.
//

import Foundation
import RealmSwift

protocol CheckOutRepository{
    func saveMoiveId(id: Int, movieName: String, poster: String,success: @escaping () -> Void, fail: @escaping (String) -> Void)
    func saveCheckOut(checkout: CheckOut, success: @escaping () -> Void, fail: @escaping (String) -> Void)
    func saveCinemaList(data: [CinemaVO])
    func saveSeating(data: [SeatingVO])
    func saveCinemaTimeSlotList(data: [CinemaTimeSlot], day: String)
    func getCinemaTimeSlotListByDay(day: String, completion: @escaping ([CinemaTimeSlot]) -> Void)
    func getCinemaList( completion: @escaping ([CinemaVO]) -> Void)
    func getSeatingList( completion: @escaping ([SeatingVO]) -> Void)
    func getCheckOut(completion: @escaping (MovieBookingResult<CheckOut>) -> Void )
}

class CheckOutRepositoryImpl: BaseRepository, CheckOutRepository{
    
    
    static let shared : CheckOutRepository = CheckOutRepositoryImpl()
    
    private override init() { }
    
    func getCinemaList( completion: @escaping ([CinemaVO]) -> Void) {
        
         let items:[CinemaVO] = realmDB.objects(CinemaVoObject.self)
             .map{ $0.toCinema() }
         completion(items)
         

     }
    
    func getSeatingList( completion: @escaping ([SeatingVO]) -> Void) {
        
         let items:[SeatingVO] = realmDB.objects(SeatingObject.self)
             .map{ $0.toSeatingVO() }
         completion(items)
         

     }
    
    func getCheckOut(completion: @escaping (MovieBookingResult<CheckOut>) -> Void) {
        let list: [CheckOut] = realmDB.objects(CheckOutObject.self)
            .map{ $0.toCheckOut() }
        if let checkOut = list.first{
            completion(.success(checkOut))
        }
            
    }
    
    func getCinemaTimeSlotListByDay(day: String, completion: @escaping ([CinemaTimeSlot]) -> Void) {
        let items:[CinemaTimeSlot] = realmDB.objects(CinemaTimeSlotObject.self)
            .filter("day == %@", day)
            .map{ $0.toTimeSlotVO() }
        
        completion(items)
    }
    
    func saveCinemaTimeSlotList(data: [CinemaTimeSlot], day: String) {
        let list = List<CinemaTimeSlotObject>()
        data.forEach{ item in
            guard let object  = realmDB.object(ofType: CinemaTimeSlotObject.self, forPrimaryKey: item.cinemaID) else{
                let newObject = CinemaTimeSlotObject()
                newObject.day = day
                newObject.cinema = item.cinema
                newObject.cinemaID = item.cinemaID
//                if let tsList = item.timeslots {
//                    saveTimeslot(id: item.cinemaID ?? 0, data: tsList )
//                }
                list.append(newObject)
                return
            }
            
            do{
                try realmDB.write{
                    object.cinema = item.cinema
                    object.day = day
//                    if let tsList = item.timeslots {
//                        saveTimeslot(id: item.cinemaID ?? 0, data: tsList )
//
//                    }
                    list.append(object)
                }
            }catch{
                debugPrint(error.localizedDescription)
            }
            
        }
        
        do{
            try realmDB.write {
                
                if list.count > 0{
                    realmDB.add(list, update: .modified)
                }
            }
        }catch{
            debugPrint(error.localizedDescription)
        }
        
        
        data.forEach{ item in
            if let tsList = item.timeslots {
                saveTimeslot(id: item.cinemaID ?? 0, data: tsList )

            }
        }
      
    }
    
    func saveTimeslot(id: Int, data: [Timeslot]) {
        let list = List<TimeslotObject>()
        guard let cinemaObject  = realmDB.object(ofType: CinemaTimeSlotObject.self, forPrimaryKey: id) else{
            return
        }
        
        data.forEach{ item in
            guard let object  = realmDB.object(ofType: TimeslotObject.self, forPrimaryKey: item.cinemaDayTimeslotID) else{
                let newObject = TimeslotObject()
                newObject.cinemaDayTimeslotID = item.cinemaDayTimeslotID
                newObject.startTime = item.startTime
                list.append(newObject)
                return
                
            }
            
            do{
                try realmDB.write{
                    object.startTime = item.startTime
                    list.append(object)
                }
            }catch{
                debugPrint(error.localizedDescription)
            }
        }
        do{
            try realmDB.write {
                
                if list.count > 0{
                    cinemaObject.timeslots = list
                }
                realmDB.add(cinemaObject, update: .modified)
            }
        }catch{
            debugPrint(error.localizedDescription)
        }
        
    }
    
    func saveSeating(data: [SeatingVO]) {
        
        let result = realmDB.objects(SeatingObject.self)
        if result.count > 0{
            do{
                try realmDB.write {
                    realmDB.delete(result)
                }
            }catch{
                debugPrint(error.localizedDescription)
            }
        }
        
        let seatingList = List<SeatingObject>()
        data.forEach{
            seatingList.append(SeatingVO.toSeatingObject(seating: $0))
        }
                
        do{
            try realmDB.write {
                realmDB.add(seatingList, update: .modified)
            }
        }catch{
            debugPrint(error.localizedDescription)
        }


    }
    
    func saveCinemaList(data: [CinemaVO]) {
        let result = realmDB.objects(CinemaVoObject.self)
        if result.count > 0{
            do{
                try realmDB.write {
                    realmDB.delete(result)
                }
            }catch{
                debugPrint(error.localizedDescription)
            }
        }
        
        let cinemaList = List<CinemaVoObject>()
        data.forEach{
            cinemaList.append(CinemaVO.toCinemaObject(cinema: $0))
        }
        do{
            try realmDB.write {
                realmDB.add(cinemaList, update: .modified)
            }
        }catch{
            debugPrint(error.localizedDescription)
        }

        
//        let cinemaList = List<CinemaVoObject>()
//        data.forEach{ item in
//            guard let cinemaObject  = realmDB.object(ofType: CinemaVoObject.self, forPrimaryKey: item.id) else{
//                cinemaList.append(CinemaVO.toCinemaObject(cinema: item))
//                return
//            }
//
//            cinemaObject.name = item.name
//            cinemaObject.address = item.address
//            cinemaObject.phone = item.phone
//            cinemaObject.email = item.email
//
//            cinemaList.append(cinemaObject)
//
//        }
//
//        do{
//            try realmDB.write {
//                realmDB.add(cinemaList, update: .modified)
//            }
//        }catch{
//            debugPrint(error.localizedDescription)
//        }
        

    }
    
    func saveCheckOut(checkout: CheckOut, success: @escaping () -> Void, fail: @escaping (String) -> Void) {
        deleteAllCheckOutData()
        do{
            let object = checkout.toCheckOutObject()
            try realmDB.write {
                realmDB.add(object, update: .modified)
            }
            success()
        }catch{
            debugPrint(error.localizedDescription)
        }
        
    }
    
    func saveMoiveId(id: Int, movieName: String, poster: String, success: @escaping () -> Void, fail: @escaping (String) -> Void) {
        deleteAllCheckOutData()
        do{
            let object = CheckOutObject()
            try realmDB.write {
                object.movieId = id
                object.movieName = movieName
                object.moviePoseter = poster
                realmDB.add(object, update: .modified)
            }
            success()
        }catch{
            debugPrint(error.localizedDescription)
        }
        
    }
    
    private func deleteAllCheckOutData(){
        let data = realmDB.objects(CheckOutObject.self)
        if data.count > 0{
            do{
                try realmDB.write {
                    realmDB.delete(data)
                }
            }catch{
                debugPrint(error.localizedDescription)
            }
        }
        
        let object = realmDB.objects(SnackCheckOutObject.self)
        if object.count > 0{
            do{
                try realmDB.write {
                    realmDB.delete(object)
                }
            }catch{
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    
}
