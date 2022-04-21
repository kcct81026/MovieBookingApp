//
//  CardVo.swift
//  MovieBookingApp
//
//  Created by KC on 06/04/2022.
//

import Foundation

class CardVO{
    var cardType: String
    var name:String
    
    init(cardType:String, name:String){
        self.cardType = cardType
        self.name = name
    }
}

class ComboSetVO{
    
    var title: String
    var name: String
    var count: Int
    var amount: Int
    
    
    init(title:String, name:String, count:Int, amount:Int){
        self.title = title
        self.name = name
        self.count = count
        self.amount = amount
    }
}




class MovieVO{
    var movieName: String
    var image: String
    var genre: String
    
    init(movieName:String, image:String, genre:String){
        self.movieName = movieName
        self.image = image
        self.genre = genre
    }
}



class MovieSeatVO{
    
    var id: Int
    var title: String
    var type: String
    var isSelected: Bool
    
    init(id:Int, title:String, type:String, isSelected:Bool){
        self.id = id
        self.title = title
        self.type = type
        self.isSelected = isSelected
    }
    
    func isMovieSeatAvailable() -> Bool{
        return type == SEAT_TYPE_AVAILABLE
    }
    
    func isMovieSeatTaken() -> Bool {
        return type == SEAT_TYPE_TAKEN
    }
    
    func isMovieSeatRowTitle() -> Bool{
        return type == SEAT_TYPE_TEXT
    }
    
  
  
    

}

