//
//  RxNetworkAgent.swift
//  MovieBookingApp
//
//  Created by KC on 06/06/2022.
//

import Foundation

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

protocol RxNetworkAgentProtocol  {
    func getSeating(day: String, id: Int) -> Observable<SeatingPlanResponse>
  
}


class RxNetworkAgent : BaseNetworkAgent, RxNetworkAgentProtocol{
    
    
    static let shared = RxNetworkAgent()
    
    private override init(){
        
    }
    
    func getSeating(day: String, id: Int) -> Observable<SeatingPlanResponse> {
        let seatingDataJSON : Data = try! Data(contentsOf: BookingMockData.SeatingPlanResult.seatingPlanResultJSONUrl)
        let seatingDataResponse = try! JSONDecoder().decode(SeatingPlanResponse.self, from: seatingDataJSON)
        return Observable.just(seatingDataResponse)
//        let headers: HTTPHeaders = [.authorization(bearerToken: UDM.shared.defaults.string(forKey: "token") ?? "")]
//
//        return Observable.create { (observer) -> Disposable in
//
//            AF.request(MBEndPoint.getSetaing(day, id), headers: headers)
//                .responseDecodable(of: SeatingPlanResponse.self){ response in
//                switch response.result{
//                case .success(let data):
//                    observer.onNext(data)
//                    observer.onCompleted()
//                case .failure(let error):
//                    observer.onError(error)
//                }
//        }
//
//            return Disposables.create()
//        }
    }


    
}


class BaseNetworkAgent: NSObject {
    
    
    func handleError<T, E: MBErrorModel>(
        _ response: DataResponse<T, AFError>,
        _ error: (AFError),
        _ errorBodyType : E.Type) -> String {
        
        
        var respBody : String = ""
        
        var serverErrorMessage : String?
        
        var errorBody : E?
        if let respData = response.data {
            respBody = String(data: respData, encoding: .utf8) ?? "empty response body"
            
            errorBody = try? JSONDecoder().decode(errorBodyType, from: respData)
            serverErrorMessage = errorBody?.message
        }
        
        /// 2 - Extract debug info
        let respCode : Int = response.response?.statusCode ?? 0
        
        let sourcePath = response.request?.url?.absoluteString ?? "no url"
        
        
        /// 1 - Essential debug info
        print(
            """
             ======================
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
             ======================
            """
        )
        
        /// 4 - Client display
        return serverErrorMessage ?? error.errorDescription ?? "undefined"
        
    }
    
}

