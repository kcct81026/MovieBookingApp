//
//  ContentTypeRepository.swift
//  MovieBookingApp
//
//  Created by KC on 06/04/2022.
//

import Foundation
import RealmSwift

protocol ContentTypeRepository {

    func getMovies(type: MovieGroupType, completion: @escaping ([MovieResult]) -> Void)
    

}

class ContentTypeRespositoryImpl: BaseRepository, ContentTypeRepository{
    
    static let shared : ContentTypeRepository = ContentTypeRespositoryImpl()
    
    private override init(){
        super.init()
   }
    
   
   func getMovies(type: MovieGroupType, completion: @escaping ([MovieResult]) -> Void) {
       
        let items:[BelongToType] = realmDB.objects(BelongsToTypeObject.self)
            .filter(NSPredicate(format: "%K CONTAINS[cd] %@", "name", type.rawValue))
            .map{ $0.toBelongToType() }
        if let firstItem = items.first{
            completion(firstItem.movies ?? [MovieResult]())
        }
        else{
            completion([MovieResult]())
        }
        

    }
    
}
    
