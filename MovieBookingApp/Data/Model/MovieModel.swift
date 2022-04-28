//
//  MovieModel.swift
//  MovieBookingApp
//
//  Created by KC on 06/04/2022.
//

import Foundation
protocol MovieModel{
    func getUpComingMovieList(completion: @escaping (MovieBookingResult<[MovieResult]>) -> Void)
    func getCurrentMovieList(completion: @escaping (MovieBookingResult<[MovieResult]>) -> Void)
    func getMovieDetailById(id : Int, completion : @escaping (MovieBookingResult<MovieDetailVO>) -> Void)
   
}

class MovieModelImpl: BaseModel, MovieModel {
    var totalTopRatedPage: Int = 1

    static let shared = MovieModelImpl()
    private let movieRespository : MovieRepository = MovieRespositoryImpl.shared
    private let contentTypeRepository : ContentTypeRepository = ContentTypeRespositoryImpl.shared

    
    private override init() {}
    
    func getMovieDetailById(id : Int, completion : @escaping (MovieBookingResult<MovieDetailVO>) -> Void){
        networkAgent.getMovieDetailById(id: id){ (result) in
            switch result {
            case .success(let data) :
                
                self.movieRespository.saveDetail( data: data)
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.movieRespository.getDetail(id: id){ (item) in
                completion(.success(item))
          
            }
        }
    }
    
    func getUpComingMovieList(completion: @escaping (MovieBookingResult<[MovieResult]>) -> Void){
        let contentType : MovieGroupType = .comingsoon
        
        networkAgent.getUpcomingMovieList(){ (result) in
            switch result {
            case .success(let data) :
                self.movieRespository.saveList(type: contentType, data: data)
                completion(.success(data))
            case .failure(let error):
                print("\(#function) \(error)")
            }

            self.contentTypeRepository.getMovies(type: contentType){
                completion(.success($0))
            }
        }
    }
    
    func getCurrentMovieList(completion: @escaping (MovieBookingResult<[MovieResult]>) -> Void){
        let contentType : MovieGroupType = .current
        
        networkAgent.getCurrentMovieList(){ (result) in
            switch result {
            case .success(let data) :
                self.movieRespository.saveList(type: contentType, data: data)
                completion(.success(data))
            case .failure(let error):
                print("\(#function) \(error)")
            }
            self.contentTypeRepository.getMovies(type: contentType){
                completion(.success($0))
            }
        }
    }
}
