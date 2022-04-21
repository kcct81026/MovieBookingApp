//
//  CardRepository.swift
//  MovieBookingApp
//
//  Created by KC on 19/04/2022.
//

import Foundation
import RealmSwift

protocol CardRepository {

    func saveCards(data: [Card])
    func getCard( completion: @escaping ([Card]) -> Void)
    
}

class CardRepositoryImpl: BaseRepository, CardRepository{
    
    static let shared : CardRepository = CardRepositoryImpl()
    
    private override init(){
        super.init()
    }
    
    private func deleteAllCards(){
        let data = realmDB.objects(CardObject.self)
        if data.count > 0{
            do{
                try realmDB.write {
                    realmDB.delete(data)
                }
            }catch{
                debugPrint(error.localizedDescription)
            }
        }
        
       
    }
    
    func saveCards(data: [Card]) {
        self.deleteAllCards()
        var cardList = [CardObject]()
        data.forEach{ item in
            cardList.append(item.toCardObject())
        }
        do{
            try realmDB.write {
                if cardList.count > 0{
                    realmDB.add(cardList, update: .modified)
                }
            }
        }catch{
            debugPrint(error.localizedDescription)
        }
    }
    
//    func addCard(data: Card) {
//        guard let object  = realmDB.object(ofType: CardObject.self, forPrimaryKey: data.id) else{
//            do{
//                try realmDB.write {
//                    realmDB.add(data.toCardObject(), update: .modified)
//                }
//            }catch{
//                debugPrint(error.localizedDescription)
//            }
//            return
//        }
//        
//        
//        do{
//            try realmDB.write{
//                object.cardHolder = data.cardHolder
//                object.cardNumber = data.cardNumber
//                object.expireDate = data.expireDate
//                object.cardType = data.cardType
//                realmDB.add(object, update: .modified)
//            }
//        }catch{
//            debugPrint(error.localizedDescription)
//        }
//    }
    
    func getCard(completion: @escaping ([Card]) -> Void) {
        let items:[Card] = realmDB.objects(CardObject.self)
            .map{ $0.toCardVO() }
        
        completion(items)
    }
    
}
    
