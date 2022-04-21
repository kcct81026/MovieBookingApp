//
//  MBEndPoint.swift
//  MovieBookingApp
//
//  Created by KC on 05/04/2022.
//

import Foundation
import Alamofire


enum MBEndPoint : URLConvertible{
    case register
    case emailLogin
    case getUpComing
    case getCurrent
    case movieDetails(_ id: Int)
    case getCinemas
    case getTimeSlotByDay(_ day: String, _ movieId: Int)
    case getSetaing(_ day: String, _ id: Int)
    case getPaymentList
    case getSnack
    case profile
    case createCard
    case checkOut

    
    private var baseURL : String{
        return AppConstant.BASEURL
    }

    func asURL() throws -> URL {
        return url
    }

    var url: URL{
        let urlComponents = NSURLComponents(
            string: baseURL.appending(apiPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? apiPath)
        )
        if (urlComponents?.queryItems == nil){
            urlComponents!.queryItems = []
        }
        
        urlComponents!.queryItems!.append(contentsOf: [URLQueryItem(name: "token", value: UDM.shared.defaults.string(forKey: "token"))])
    
        return urlComponents!.url!
    }
    
    private var apiPath : String{
        switch self{
        case .register :
            return "/api/v1/register"
        case .emailLogin:
            return "/api/v1/email-login"
        case .getCurrent :
            return "/api/v1/movies?status=current&take=10"
        case .getUpComing :
            return "/api/v1/movies?status=comingsoon&take=10"
        case .movieDetails(let id):
            return "/api/v1/movies/\(id)"
        case .getCinemas:
            return "/api/v1/cinemas"
        case .getTimeSlotByDay(let day, let movieId):
            return "/api/v1/cinema-day-timeslots?movie_id=\(movieId)&date=\(day)"
        case .getSetaing(let day, let id):
            return "/api/v1/seat-plan?cinema_day_timeslot_id=\(id)&booking_date=\(day)"
        case .getPaymentList:
            return "/api/v1/payment-methods"
        case .getSnack:
            return "/api/v1/snacks"
        case .profile:
            return "/api/v1/profile"
        case .createCard:
            return "/api/v1/card"
        case .checkOut:
            return "/api/v1/checkout"
        }
    }
    
}



