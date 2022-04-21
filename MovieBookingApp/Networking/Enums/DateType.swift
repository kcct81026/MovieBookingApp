//
//  DateType.swift
//  MovieBookingApp
//
//  Created by KC on 08/04/2022.
//
//

//enum DateType : Int, CodingKey {
//    typealias RawValue = <#type#>
//
//   {
//    case 1 = "Su"
//    case 2 = "Mo"
//    case 3 = "Tu"
//    case 4 = "We"
//    case 5 = "Th"
//    case 6 = "Fr"
//    case 7 = "Sa"
//}
//
//
import Foundation
extension Date {
    func todayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    func todayOfSearch()-> String?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
}
