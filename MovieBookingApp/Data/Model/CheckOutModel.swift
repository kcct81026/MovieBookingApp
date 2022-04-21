//
//  CheckOutModel.swift
//  MovieBookingApp
//
//  Created by KC on 07/04/2022.
//

import Foundation
import RealmSwift
import SwiftUI
protocol CheckOutModel{
    func saveMoiveId(id: Int, movieName: String, poster: String)
    func getCheckOut(completion: @escaping (MovieBookingResult<CheckOut>) -> Void )
    func getTimeSlotsByDay(day: String, movieId: Int, completion: @escaping (MovieBookingResult<[CinemaTimeSlot]>) -> Void)
    func getSeating(day: String, id: Int, completion: @escaping (MovieBookingResult<[[SeatingVO]]>) -> Void)
    func getCinemaList(completion: @escaping (MovieBookingResult<[CinemaVO]>) -> Void)
    func saveCheckOut(checkout: CheckOut)
    func sendCheckOut(checkout: CheckOut, completion: @escaping (MovieBookingResult<CheckOutResponse>) -> Void)
}

class CheckOutModelImpl: BaseModel, CheckOutModel {
    
    

    static let shared = CheckOutModelImpl()
    private let checkOutRepository : CheckOutRepository = CheckOutRepositoryImpl.shared
    
    func saveMoiveId(id: Int, movieName:String, poster: String) {
        checkOutRepository.saveMoiveId(id: id, movieName:movieName, poster: poster, success: {
            print("success")
        },fail: { text in
            print(text)
        })
    }
    
    func saveCheckOut(checkout: CheckOut) {
        checkOutRepository.saveCheckOut(checkout: checkout, success: {
            print("success")
        },fail: { text in
            print(text)
        })
    }
    
    func sendCheckOut(checkout: CheckOut, completion: @escaping (MovieBookingResult<CheckOutResponse>) -> Void) {
        networkAgent.checkOut(checkOut: checkout){ (result) in
            switch result {
            case .success(let data) :
                if data.code == 200 {
                    self.checkOutRepository.savingCheckOutTicket(data: data)
                }
                completion(.success(data))
                //self.checkOutRepository.saveSeating(data: data)
            case .failure(let error):
                print("\(#function) \(error)")
            }
        }
    }
    
    func getCheckOut(completion: @escaping (MovieBookingResult<CheckOut>) -> Void) {
        self.checkOutRepository.getCheckOut(){(result) in
            completion(result)
        }
    }
    
    func getTimeSlotsByDay(day: String, movieId: Int, completion: @escaping (MovieBookingResult<[CinemaTimeSlot]>) -> Void) {
        networkAgent.getTimeSlotsByDay(day: day, movieId: movieId){ (result) in
            switch result {
            case .success(let data) :
                self.checkOutRepository.saveCinemaTimeSlotList(data: data, day: day)
            case .failure(let error):
                print("\(#function) \(error)")
            }

            self.checkOutRepository.getCinemaTimeSlotListByDay(day: day){
                completion(.success($0))
            }
        }
    }
    
    func getSeating(day: String, id: Int, completion: @escaping (MovieBookingResult<[[SeatingVO]]>) -> Void) {
        networkAgent.getSeating(day: day, id: id){ (result) in
            switch result {
            case .success(let data) :
                completion(.success(data))
                //self.checkOutRepository.saveSeating(data: data)
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
//            self.checkOutRepository.getSeatingList{
//                completion(.success($0))
//            }
        }
    }
    
    func getCinemaList(completion: @escaping (MovieBookingResult<[CinemaVO]>) -> Void){
        
        networkAgent.getCinemaList(){ (result) in
            switch result {
            case .success(let data) :
                self.checkOutRepository.saveCinemaList(data: data)
            case .failure(let error):
                print("\(#function) \(error)")
            }

            self.checkOutRepository.getCinemaList{
                completion(.success($0))
            }
        }
    }
}
