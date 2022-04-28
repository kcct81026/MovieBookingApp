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
    func isLogin()->Bool
    func addCard(card: Card, completion : @escaping (MovieBookingResult<CardResponse>) -> Void)
    func saveProfile()-> Void
    func getProfile(completion : @escaping (MovieBookingResult<[Card]>) -> Void)
    func logout(completion : @escaping (Bool) -> Void)
}

class UserModelImpl: BaseModel, UserModel {
    
    private let cardRespository : CardRepository = CardRepositoryImpl.shared

    static let shared = UserModelImpl()
    private override init() {}
    
    func isLogin() -> Bool {
        return UDM.shared.defaults.valueExits(forKey: "token")
    }
    
    func register(user: UserInfo, completion: @escaping (MovieBookingResult<RegisterResponse>) -> Void) {
        networkAgent.register(user: user) {  (result) in
            switch result {
            case .success(let data):
                completion(.success(data))
                if data.code == 201{
                    UDM.shared.defaults.setValue(data.token ?? "", forKey: "token")
                    UDM.shared.defaults.setValue(data.userinfo?.name ?? "", forKey: "name")
                    UDM.shared.defaults.setValue(data.userinfo?.phone ?? "", forKey: "phone")
                    UDM.shared.defaults.setValue(data.userinfo?.email ?? "", forKey: "email")
                    UDM.shared.defaults.setValue(data.userinfo?.profileImage ?? "", forKey: "image")
                }            case .failure(let error):
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
    
    func logout(completion: @escaping (Bool) -> Void) {
        networkAgent.logout(){  (result) in
            switch result {
            case .success(let data):
                if data.code == 200 {
                       print("data \(data)")
                    completion(true)
                    
                }
                else {
                    completion(false)
                }
            case .failure(let error):
                completion(false)
                print("\(#function) \(error)")
            }
        }
    }
    
    func loginWithEmail(user: UserInfo, completion: @escaping (MovieBookingResult<RegisterResponse>) -> Void) {
        networkAgent.loginWithEmail(user: user) {  (result) in
            switch result {
            case .success(let data):
                if data.code == 200 {
                    UDM.shared.defaults.setValue(data.token ?? "", forKey: "token")
                    UDM.shared.defaults.setValue(data.userinfo?.name ?? "", forKey: "name")
                    UDM.shared.defaults.setValue(data.userinfo?.phone ?? "", forKey: "phone")
                    UDM.shared.defaults.setValue(data.userinfo?.email ?? "", forKey: "email")
                    UDM.shared.defaults.setValue(data.userinfo?.profileImage ?? "", forKey: "image")
                }
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
    
