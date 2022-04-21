//
//  ComboModel.swift
//  MovieBookingApp
//
//  Created by KC on 19/04/2022.
//

import Foundation

protocol ComboModel{
    func getSnacks(completion: @escaping (MovieBookingResult<[SnackVO]>) -> Void )
    func getPayment(completion: @escaping (MovieBookingResult<[PaymentVO]>) -> Void )
}

class ComboModelImpl: BaseModel, ComboModel {
    

    static let shared = ComboModelImpl()
    private let comboRepository : ComboRepository = ComboRepositoryImpl.shared
    
    
    func getSnacks(completion: @escaping (MovieBookingResult<[SnackVO]>) -> Void) {
        networkAgent.getSnackList(){ (result) in
            switch result {
            case .success(let data) :
                self.comboRepository.saveSnacks(data: data)
            case .failure(let error):
                print("\(#function) \(error)")
            }

            self.comboRepository.getSnacks{
                completion(.success($0))
            }
        }
    }
    
    func getPayment(completion: @escaping (MovieBookingResult<[PaymentVO]>) -> Void) {
        networkAgent.getPaymentList(){ (result) in
            switch result {
            case .success(let data) :
                self.comboRepository.savePayment(data: data)
            case .failure(let error):
                print("\(#function) \(error)")
            }

            self.comboRepository.getPayment{
                completion(.success($0))
            }
        }
    }

}
