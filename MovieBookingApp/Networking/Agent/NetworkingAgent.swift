//
//  NetworkingAgetn.swift
//  MovieBookingApp
//
//  Created by KC on 05/04/2022.
//

import Foundation
import UIKit
import Alamofire

protocol MovieDBNetworkAgentProtocol {
    
    //MARK: - register
    func register(user: UserInfo, completion : @escaping (MovieBookingResult<RegisterResponse>) -> Void)
    func loginWithEmail(user: UserInfo, completion : @escaping (MovieBookingResult<RegisterResponse>) -> Void)
    func getProfile(completion : @escaping (MovieBookingResult<ProfileResponse>) -> Void)
    func createCard(card: Card ,completion : @escaping (MovieBookingResult<CardResponse>) -> Void)
    func logout(completion : @escaping (MovieBookingResult<Logout>) -> Void)
    
    //MARK: - movies
    func getUpcomingMovieList(completion: @escaping (MovieBookingResult<[MovieResult]>) -> Void)
    func getCurrentMovieList(completion: @escaping (MovieBookingResult<[MovieResult]>) -> Void)
    func getMovieDetailById(id: Int, completion: @escaping (MovieBookingResult<MovieDetailVO>) -> Void)

    //MARK: - cinema list
    func getCinemaList(completion: @escaping (MovieBookingResult<[CinemaVO]>) -> Void)
    func getTimeSlotsByDay(day: String, movieId: Int, completion: @escaping (MovieBookingResult<[CinemaTimeSlot]>) -> Void)
    func getSeating(day: String, id: Int, completion: @escaping (MovieBookingResult<[[SeatingVO]]>) -> Void)
    
    //MARK: - combo list
    func getSnackList(completion: @escaping (MovieBookingResult<[SnackVO]>) -> Void)
    func getPaymentList(completion: @escaping (MovieBookingResult<[PaymentVO]>) -> Void)
    
    func checkOut(checkOut: CheckOut ,completion : @escaping (MovieBookingResult<CheckOutResponse>) -> Void)
    
}

struct MovieDBNetworkAgent : MovieDBNetworkAgentProtocol{
    
    static let shared = MovieDBNetworkAgent()
    
    private init(){}
    
    
    
    func checkOut(checkOut: CheckOut, completion: @escaping (MovieBookingResult<CheckOutResponse>) -> Void) {
        
        let headers : HTTPHeaders = [
            .authorization(bearerToken: UDM.shared.defaults.string(forKey: "token") ?? "")
        ]
        AF.request(MBEndPoint.checkOut, method: .post, parameters: checkOut, encoder: .json, headers: headers )
            .responseDecodable(of: CheckOutResponse.self) { response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MBCommonResponseError.self)))
             }
        }
    }
    
    // MARK: - comboList
    func getSnackList(completion: @escaping (MovieBookingResult<[SnackVO]>) -> Void) {
    
        let headers: HTTPHeaders = [.authorization(bearerToken: UDM.shared.defaults.string(forKey: "token") ?? "")]
              
        AF.request(MBEndPoint.getSnack, headers: headers)
            .responseDecodable(of: SnakResponse.self){ response in
                switch response.result{
                case .success(let result):
                    completion(.success(result.data ?? [SnackVO]()))
                    
                case .failure(let error):
                    completion(.failure(handleError(response, error, MBCommonResponseError.self)))
            }
        }
    }
    
    func getPaymentList(completion: @escaping (MovieBookingResult<[PaymentVO]>) -> Void) {
        let headers: HTTPHeaders = [.authorization(bearerToken: UDM.shared.defaults.string(forKey: "token") ?? "")]
        AF.request(MBEndPoint.getPaymentList, headers: headers)
            .responseDecodable(of: PaymentResponse.self){ response in
                switch response.result{
                case .success(let result):
                    completion(.success(result.data ?? [PaymentVO]()))
                    
                case .failure(let error):
                    completion(.failure(handleError(response, error, MBCommonResponseError.self)))
            }
        }
    }
    
    
    //MARK: - cinema list
    func getCinemaList(completion: @escaping (MovieBookingResult<[CinemaVO]>) -> Void) {
        AF.request(MBEndPoint.getCinemas)
            .responseDecodable(of: CinemaList.self){ response in
                switch response.result{
                case .success(let result):
                    completion(.success(result.data ?? [CinemaVO]()))
                    
                case .failure(let error):
                    completion(.failure(handleError(response, error, MBCommonResponseError.self)))
            }
        }
    }
    
    func getSeating(day: String, id: Int, completion: @escaping (MovieBookingResult<[[SeatingVO]]>) -> Void) {
        let headers: HTTPHeaders = [.authorization(bearerToken: UDM.shared.defaults.string(forKey: "token") ?? "")]
       
        AF.request(MBEndPoint.getSetaing(day, id), headers: headers)
            .responseDecodable(of: SeatingPlanResponse.self){ response in
                switch response.result{
                case .success( let result ):
                    completion(.success(result.data ?? [[SeatingVO]]() ))
                    
                case .failure(let error):
                    completion(.failure(handleError(response, error, MBCommonResponseError.self)))
            }
        }
    }
    
    func getTimeSlotsByDay(day: String, movieId: Int, completion: @escaping (MovieBookingResult<[CinemaTimeSlot]>) -> Void) {
        
        let headers: HTTPHeaders = [.authorization(bearerToken: UDM.shared.defaults.string(forKey: "token") ?? "")]
        
        AF.request(MBEndPoint.getTimeSlotByDay(day, movieId), headers: headers)
            .responseDecodable(of: TimeSlotResponse.self){ response in
                switch response.result{
                case .success( let result ):
                    completion(.success(result.data ?? [CinemaTimeSlot]()))
                    
                case .failure(let error):
                    completion(.failure(handleError(response, error, MBCommonResponseError.self)))
            }
        }
    }
    
    //MARK: - movies
    func getUpcomingMovieList(completion: @escaping (MovieBookingResult<[MovieResult]>) -> Void) {

        AF.request(MBEndPoint.getUpComing)
        
            .responseDecodable(of: MovieResponse.self){ response in
                switch response.result{
                case .success(let result):
                    completion(.success(result.data ?? [MovieResult]()))
                    
                case .failure(let error):
                    completion(.failure(handleError(response, error, MBCommonResponseError.self)))
            }
        }
    }
    
    func getMovieDetailById(id: Int, completion: @escaping (MovieBookingResult<MovieDetailVO>) -> Void) {
        AF.request(MBEndPoint.movieDetails(id))
            .responseDecodable(of: MovieDetailResponse.self) { response in
                switch response.result{
                case .success(let result):
                    if let data = result.data{
                        completion(.success(data))

                    }
                case .failure(let error):
                    completion(.failure(handleError(response, error, MBCommonResponseError.self)))
            }
        }
    }
    
    func getCurrentMovieList(completion: @escaping (MovieBookingResult<[MovieResult]>) -> Void){
        
        AF.request(MBEndPoint.getCurrent)
            .responseDecodable(of: MovieResponse.self){ response in
                switch response.result{
                case .success(let result):
                    completion(.success(result.data ?? [MovieResult]()))
                    
                case .failure(let error):
                    completion(.failure(handleError(response, error, MBCommonResponseError.self)))
            }
        }
    }
    

    //MARK: - register
    func register(user: UserInfo, completion: @escaping (MovieBookingResult<RegisterResponse>) -> Void) {

        let headers : HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters : Parameters = [
            "name": user.name ?? "",
            "email": user.email ?? "",
            "phone": user.phone ?? "",
            "password": user.profileImage ?? ""
        ]
        AF.request(MBEndPoint.register, method: .post, parameters: parameters, headers: headers )
            .responseDecodable(of: RegisterResponse.self) { response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MBCommonResponseError.self)))
             }
        }
    }
    
    func logout(completion: @escaping (MovieBookingResult<Logout>) -> Void) {
        let headers: HTTPHeaders = [.authorization(bearerToken: UDM.shared.defaults.string(forKey: "token") ?? "")]
        AF.request(MBEndPoint.register, method: .post, headers: headers )
            .responseDecodable(of: Logout.self) { response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MBCommonResponseError.self)))
             }
        }
    }
    
    func createCard(card: Card, completion: @escaping (MovieBookingResult<CardResponse>) -> Void) {
        var headers : HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            
        ]
        headers.add(.authorization(bearerToken: UDM.shared.defaults.string(forKey: "token") ?? ""))
        let parameters : Parameters = [
            "card_holder": card.cardHolder ?? "",
            "card_number": card.cardNumber ?? 0,
            "expiration_date": card.expireDate ?? "",
            "cvc": card.cardType ?? ""
        ]
        
        AF.request(MBEndPoint.createCard, method: .post, parameters: parameters, headers: headers )
            .responseDecodable(of: CardResponse.self) { response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MBCommonResponseError.self)))
             }
        }
    }
    
    func getProfile(completion: @escaping (MovieBookingResult<ProfileResponse>) -> Void) {
        let headers: HTTPHeaders = [.authorization(bearerToken: UDM.shared.defaults.string(forKey: "token") ?? "")]
        AF.request(MBEndPoint.profile, headers: headers )
            .responseDecodable(of: ProfileResponse.self) { response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MBCommonResponseError.self)))
             }
        }
    }
    
    func loginWithEmail(user: UserInfo, completion: @escaping (MovieBookingResult<RegisterResponse>) -> Void) {
        let headers : HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters : Parameters = [
            "email": user.email ?? "",
            "password": user.profileImage ?? ""
        ]
        AF.request(MBEndPoint.emailLogin, method: .post, parameters: parameters, headers: headers )
            .responseDecodable(of: RegisterResponse.self) { response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MBCommonResponseError.self)))
             }
        }
    }
    
    
    fileprivate func handleError < T, E: MBErrorModel>(
        _ response: DataResponse<T, AFError>,
        _ error: (AFError),
        _ errorBodyType : E.Type ) -> String
    {
        var respBody : String = ""
        
        var serverErrorMessage : String?
        
        var errorBody : E?
        if let respData = response.data{
            respBody = String(data: respData, encoding: .utf8) ?? "empty response body"
            errorBody = try? JSONDecoder().decode( errorBodyType, from: respData)
            serverErrorMessage = errorBody?.message
        }
        
        /// 2 - Extract debug info
        let respCode : Int = response.response?.statusCode ?? 0
        
        let sourcePath = response.request?.url?.absoluteString ?? "no url"
        
        /// 1 - Essential debug Info
        print(
            """
            ========================
            URL
            -> \(sourcePath)

            Status
            -> \(respCode)
            
            Body
            -> \(respBody)

            Underlying Error
            -> \(error.underlyingError!)
            
            Error Description
            -> \(error.errorDescription!)
            ========================
            """
        )
        
        /// 4 - Client dispaly
        return serverErrorMessage ?? error.errorDescription ?? "undefined"
    }
    
}

protocol MBErrorModel: Decodable{
    var message : String{ get }
}

class MBCommonResponseError : MBErrorModel{
    var message: String {
        return statusMessage
    }
    
    let statusMessage : String
    let statusCode : Int
    
    enum CodingKeys : String, CodingKey {
        case statusMessage = "status_message"
        case statusCode = "status_code"
    }
}

enum MovieBookingResult<T>{
    case success(T)
    case failure(String)
}
