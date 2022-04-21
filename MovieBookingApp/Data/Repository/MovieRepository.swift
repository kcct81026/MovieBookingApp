//
//  MovieRepository.swift
//  MovieBookingApp
//
//  Created by KC on 06/04/2022.
//

import Foundation
import RealmSwift

protocol MovieRepository{
    func saveList(type: MovieGroupType, data: [MovieResult])
    func saveDetail(data: MovieDetailVO)
    func getDetail(id: Int, completion: @escaping (MovieDetailVO) -> Void)
}

class MovieRespositoryImpl: BaseRepository, MovieRepository{
    
    
    static let shared : MovieRepository = MovieRespositoryImpl()
    
    private override init() { }
    
    private func deleteMovieList(type: MovieGroupType){
        
        let data = realmDB.objects(BelongsToTypeObject.self)
            .filter(NSPredicate(format: "%K CONTAINS[cd] %@", "name", type.rawValue))
        
        data.first?.movieList.forEach{ item in
            guard let object  = realmDB.object(ofType: MovieObject.self, forPrimaryKey: item.id) else{
                return
            }
            do{
                try realmDB.write {
                    realmDB.delete(object)
                }
            }catch{
                debugPrint(error.localizedDescription)
            }
        }
            
    }
    
    func getDetail(id: Int, completion: @escaping (MovieDetailVO) -> Void) {
        let items:[MovieDetailVO] = realmDB.objects(MovieObject.self)
            .filter("id == %@", id)
            .map{ $0.toMoiveDetail() }
        
        if let item = items.first{
            completion(item)
        }
        
        

    }
    
    func saveDetail(data: MovieDetailVO) {
        guard let object  = realmDB.object(ofType: MovieObject.self, forPrimaryKey: data.id) else{
            return
        }
        
        if let cast = data.casts {
           saveCasts(id: data.id ?? 0, data: cast)
        }
        do{
            try realmDB.write {
                object.overview = data.overview
                object.rating = data.rating
                object.runtime = data.runtime
                realmDB.add(object, update: .modified)
            }
        }catch{
            debugPrint(error.localizedDescription)
        }
        
    }
    
    func saveCasts(id: Int, data: [Cast]) {
        let castList = List<CastObject>()
        
        guard let movieObject  = realmDB.object(ofType: MovieObject.self, forPrimaryKey: id) else{
            return
        }
        
        data.forEach{ item in
            guard let object  = realmDB.object(ofType: CastObject.self, forPrimaryKey: item.id) else{
                
                let object = CastObject()
                object.id = item.id
                object.name = item.name
                object.profilePath = item.profilePath
                castList.append(object)
                return
            }
            
            do{
                try realmDB.write{
                    object.name = item.name
                    object.profilePath = item.profilePath
                    castList.append(object)
                }
            }catch{
                debugPrint(error.localizedDescription)
            }
        }
        do{
            try realmDB.write {
                if castList.count > 0{
                    movieObject.casts = castList
                }
                realmDB.add(movieObject, update: .modified)
            }
        }catch{
            debugPrint(error.localizedDescription)
        }
        
    }
   
    func saveList(type: MovieGroupType, data: [MovieResult]) {
        //deleteMovieList(type: type)
        let object = BelongsToTypeObject()
        object.name = type.rawValue
        data.forEach{
            object.movieList.append(MovieResult.toMovieObject(movie: $0))
            
        }
        do{
            try realmDB.write {
                realmDB.add(object, update: .modified)
            }
        }catch{
            debugPrint(error.localizedDescription)
        }
        
        
       
    }
    
    
}
