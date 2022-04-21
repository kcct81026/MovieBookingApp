//
//  ComboRepository.swift
//  MovieBookingApp
//
//  Created by KC on 19/04/2022.
//

import Foundation
import RealmSwift

protocol ComboRepository {

    func getSnacks( completion: @escaping ([SnackVO]) -> Void)
    func saveSnacks(data: [SnackVO])
    func getPayment( completion: @escaping ([PaymentVO]) -> Void)
    func savePayment(data: [PaymentVO])
    
}

class ComboRepositoryImpl: BaseRepository, ComboRepository{
    
    static let shared : ComboRepository = ComboRepositoryImpl()
    
    private override init(){
        super.init()
    }
    
    func getPayment(completion: @escaping ([PaymentVO]) -> Void) {
        let items:[PaymentVO] = realmDB.objects(PaymentObject.self)
            .map{ $0.toPaymentVO() }
        completion(items)
    }
    
    func savePayment(data: [PaymentVO]) {
        var paymentList = [PaymentObject]()
        data.forEach{ item in
            guard let object  = realmDB.object(ofType: PaymentObject.self, forPrimaryKey: item.id) else{
                
                paymentList.append(item.toPaymentObject())
                return
            }
            
            do{
                try realmDB.write{
                    object.paymentDescription = item.description
                    object.name = item.name
                    paymentList.append(object)
                }
            }catch{
                debugPrint(error.localizedDescription)
            }
        }
        do{
            try realmDB.write {
                if paymentList.count > 0{
                    realmDB.add(paymentList, update: .modified)
                }
            }
        }catch{
            debugPrint(error.localizedDescription)
        }
    }
    
    func getSnacks(completion: @escaping ([SnackVO]) -> Void) {
        let items:[SnackVO] = realmDB.objects(SnackObject.self)
            .map{ $0.toSnackVO() }
        completion(items)
    }
    
    func saveSnacks(data: [SnackVO]) {
        var snackList = [SnackObject]()
        data.forEach{ item in
            guard let object  = realmDB.object(ofType: SnackObject.self, forPrimaryKey: item.id) else{
                
                snackList.append(item.toSnackObject())
                return
            }
            
            do{
                try realmDB.write{
                    object.name = item.name
                    object.snackDescription = item.description
                    object.price = item.price
                    object.image = item.image
                    snackList.append(object)
                }
            }catch{
                debugPrint(error.localizedDescription)
            }
        }
        do{
            try realmDB.write {
                if snackList.count > 0{
                    realmDB.add(snackList, update: .modified)
                }
            }
        }catch{
            debugPrint(error.localizedDescription)
        }
    }
    
   
    
}
    
