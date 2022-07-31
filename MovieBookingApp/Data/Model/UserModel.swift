//
//  UserModel.swift
//  MovieBookingApp
//
//  Created by KC on 05/04/2022.
//

import Foundation
import RealmSwift
protocol UserModel{
    
    func register(user: UserCredentialVO, completion : @escaping (MovieBookingResult<RegisterResponse>) -> Void)
    func loginWithEmail(user: UserInfo, completion : @escaping (MovieBookingResult<RegisterResponse>) -> Void)
    func loginWithFbId(id: String , completion : @escaping (MovieBookingResult<RegisterResponse>) -> Void)
    func loginWithGgId(id: String, completion: @escaping (MovieBookingResult<RegisterResponse>) -> Void)
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
    
    func register(user: UserCredentialVO, completion: @escaping (MovieBookingResult<RegisterResponse>) -> Void) {
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
                    UDM.shared.defaults.removeObject(forKey: "token")
                    UDM.shared.defaults.removeObject(forKey: "name")
                    UDM.shared.defaults.removeObject(forKey: "email")
                    UDM.shared.defaults.removeObject(forKey: "phone")

                    let realm = try! Realm()
                    try! realm.write {
                        realm.deleteAll()
                    }
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
    
    func loginWithFbId(id: String, completion: @escaping (MovieBookingResult<RegisterResponse>) -> Void) {
        networkAgent.loginWithFbId(id: id) {  (result) in
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
    
    func loginWithGgId(id: String, completion: @escaping (MovieBookingResult<RegisterResponse>) -> Void) {
        networkAgent.loginWithGgId(id: id) {  (result) in
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
    
