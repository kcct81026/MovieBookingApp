//
//  UDM.swift
//  MovieBookingApp
//
//  Created by KC on 05/04/2022.
//

import Foundation
import UIKit


extension UserDefaults{
    func valueExits (forKey key:String) -> Bool{
        return object(forKey: key) != nil
    }
}

class UDM {
    static let shared = UDM()
    let defaults = UserDefaults(suiteName: "movie_app")!
    
    
}

