//
//  UserModel.swift
//  MovieBookingApp
//
//  Created by KC on 05/04/2022.
//

import Foundation
protocol UserModel{
    
    func register(user: UserInfo, completion : @escaping (MovieBookingResult<RegisterResponse>) -> Void)
    func loginWithEmail(user: UserInfo, completion : @escaping (MovieBookingResult<RegisterResponse>) -> Void)
    
    func addCard(card: Card, completion : @escaping (MovieBookingResult<CardResponse>) -> Void)
    func saveProfile()-> Void
    func getProfile(completion : @escaping (MovieBookingResult<[Card]>) -> Void)
}

class UserModelImpl: BaseModel, UserModel {
    private let cardRespository : CardRepository = CardRepositoryImpl.shared

    static let shared = UserModelImpl()
    private override init() {}
    
    func register(user: UserInfo, completion: @escaping (MovieBookingResult<RegisterResponse>) -> Void) {
        networkAgent.register(user: user) {  (result) in
            switch result {
            case .success(let data):
                completion(.success(data))
                //self.collectionViewImages.reloadData()
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addCard(card: Card, completion: @escaping (MovieBookingResult<CardResponse>) -> Void) {
        networkAgent.createCard(card: card){ (result) in
            switch result {
            case .success(let data):
                if data.message == "Success"{
                    self.cardRespository.saveCards(data: data.data ?? [Card]())
                    //self.goToMain(data: data)
                }
                completion(.success(data))
                //self.collectionViewImages.reloadData()
            case .failure(let error):
                print("\(#function) \(error)")
                
            }
            
        }
        
    }
    
    func getProfile(completion: @escaping (MovieBookingResult<[Card]>) -> Void) {
        self.cardRespository.getCard{
            completion(.success($0))
        }
        
    }
    
    func saveProfile() {
        networkAgent.getProfile() {  (result) in
            switch result {
            case .success(let data):
                if let result = data.data?.cards{
                    self.cardRespository.saveCards(data: result )
                }
                //self.collectionViewImages.reloadData()
            case .failure(let error):
                print("\(#function) \(error)")
                
            }
            
        }
    }
    

    
    
    func loginWithEmail(user: UserInfo, completion: @escaping (MovieBookingResult<RegisterResponse>) -> Void) {
        networkAgent.loginWithEmail(user: user) {  (result) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
    
