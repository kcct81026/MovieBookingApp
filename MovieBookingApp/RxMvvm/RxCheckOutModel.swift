//
//  RxCheckOutModel.swift
//  MovieBookingApp
//
//  Created by KC on 06/06/2022.
//

import Foundation
import RxSwift
import RxAlamofire


protocol RxCheckOutModel{
   // func saveMoiveId(id: Int, movieName: String, poster: String)
    func getCheckOutObservable() -> Observable<CheckOut>
    
    func getSeating(day: String, id: Int) -> Observable<[SeatingVO]>
    func saveCheckOut(checkout: CheckOut)
    
}

class RxCheckOutModelImpl: BaseModel, RxCheckOutModel {
   
    private var disposeBag = DisposeBag()
    static let shared: RxCheckOutModel = RxCheckOutModelImpl()
    private let checkOutRepository : CheckOutRepository = CheckOutRepositoryImpl.shared
    
    func getSeating(day: String, id: Int) -> Observable<[SeatingVO]> {

        return RxNetworkAgent.shared.getSeating(day: day, id: id)
            .do(onNext: { data in
                self.checkOutRepository.saveSeating(data: SeatingVOHelper.changingToSingleSeatingVOArray(data: data.data ?? [[]]) )

        })
            .flatMap{ _ ->  Observable<[SeatingVO]> in
                return Observable.create{ (observer) -> Disposable in
                    self.checkOutRepository.getSeatingList{
                    observer.onNext($0)
                    observer.onCompleted()
            }
                return Disposables.create()
            }
        }
        
    }
    
    func saveCheckOut(checkout: CheckOut) {
        checkOutRepository.saveCheckOut(checkout: checkout, success: {
            print("success")
        },fail: { text in
            print(text)
        })
    }
    
    func getCheckOutObservable() -> Observable<CheckOut> {
        return self.checkOutRepository.getCheckOutObseravable()
   
    }
  
    
    
    func getCheckOut(completion: @escaping (MovieBookingResult<CheckOut>) -> Void) {
        self.checkOutRepository.getCheckOut(){(result) in
            completion(result)
        }
    }
    
    
    func getSeating(day: String, id: Int, completion: @escaping (MovieBookingResult<[SeatingVO]>) -> Void) {
        networkAgent.getSeating(day: day, id: id){ (result) in
            switch result {
            case .success(let data) :
                //completion(.success(data))
                self.checkOutRepository.saveSeating(data: SeatingVOHelper.changingToSingleSeatingVOArray(data: data) )
               
                
                //self.checkOutRepository.saveSeating(data: data)
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.checkOutRepository.getSeatingList{
                completion(.success($0))
            }
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
