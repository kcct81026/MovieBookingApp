//
//  EmailValidation.swift
//  MovieBookingApp
//
//  Created by KC on 04/06/2022.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

class EmailValidation {
    static func isValidEmail(_ email: String) -> Bool {
        let result = email.range(
            of: #"^\S+@\S+\.\S+$"#,
            options: .regularExpression
        )

        return result != nil
    }
}

class SeatingVOHelper {
    
    static func changingToSingleSeatingVOArray(data : [[SeatingVO]]) -> [SeatingVO]{
        var seatList =  [SeatingVO]()
        if data.count > 0  {
            let count = data.count
            UDM.shared.defaults.setValue(data[0].count, forKey: "row_count")
            for i in 0 ..< count {
                for j in 0 ..<  (data[i].count){
                        seatList.append(data[i][j])
                    
                }
            }
        }

        return seatList
    }
    
}

extension String{
    func getCustomDateFormat() -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "EEEE, MMM d"
        if let date = dateFormatterGet.date(from: self) {
            return dateFormatterPrint.string(from: date)
          //  self.labelDateTime.text = "\(dateFormatterPrint.string(from: date)) \(checkOut?.cinemaTimeSlot ?? "")"
        }
        return ""
    }
}

