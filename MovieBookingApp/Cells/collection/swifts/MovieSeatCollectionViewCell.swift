//
//  MovieSeatCollectionViewCell.swift
//  MovieBookingApp
//
//  Created by KC on 18/02/2022.
//

import UIKit

class MovieSeatCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblMovieSeatTitle: UILabel!
    @IBOutlet weak var viewContainerMovieSeat: UIView!
    
    var onTapItem: ((String) -> Void) = {_ in}
    //var delegate: MovieSeatClick?=nil
    
    var data: SeatingVO? = nil{
        didSet{
            
            if let movieSeatVO = data{
                lblMovieSeatTitle.text = movieSeatVO.symbol
                lblMovieSeatTitle.textColor = UIColor.black
                if movieSeatVO.isMovieSeatRowTitle(){
                    viewContainerMovieSeat.layer.cornerRadius = 0
                    viewContainerMovieSeat.backgroundColor = UIColor.white
                }
                else if movieSeatVO.isMovieSeatTaken(){
                    viewContainerMovieSeat.clipsToBounds = true
                    viewContainerMovieSeat.layer.cornerRadius = 4
                    viewContainerMovieSeat.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                    viewContainerMovieSeat.backgroundColor = UIColor(named: "movie_seat_taken_color") ?? UIColor.gray
                    lblMovieSeatTitle.text = ""
                }
                else if movieSeatVO.isMovieSeatAvailable(){
                    if movieSeatVO.isSelected == true{
                        viewContainerMovieSeat.clipsToBounds = true
                        viewContainerMovieSeat.layer.cornerRadius = 4
                        viewContainerMovieSeat.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                        viewContainerMovieSeat.backgroundColor = UIColor(named: "primary_color") ?? UIColor.gray
                        lblMovieSeatTitle.textColor = UIColor.white
                        lblMovieSeatTitle.text = "\(movieSeatVO.id! - 1)"

                    }
                    else{
                        viewContainerMovieSeat.clipsToBounds = true
                        viewContainerMovieSeat.layer.cornerRadius = 4
                        viewContainerMovieSeat.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                        viewContainerMovieSeat.backgroundColor = UIColor(named: "movie_seat_available_color") ?? UIColor.lightGray
                        lblMovieSeatTitle.text = ""
                    }
                }
                else{
                    lblMovieSeatTitle.text = ""
                    viewContainerMovieSeat.layer.cornerRadius = 0
                    viewContainerMovieSeat.backgroundColor = UIColor.white
                }
                
                
                
//                if movieSeatVO.isMovieSeatRowTitle(){
//                    // Title
//                    viewContainerMovieSeat.layer.cornerRadius = 0
//                    viewContainerMovieSeat.backgroundColor = UIColor.white
//                }
//                else if movieSeatVO.isMovieSeatTaken(){
//                    // Taken
//                    viewContainerMovieSeat.clipsToBounds = true
//                    viewContainerMovieSeat.layer.cornerRadius = 8
//                    viewContainerMovieSeat.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//                    viewContainerMovieSeat.backgroundColor = UIColor(named: "movie_seat_taken_color") ?? UIColor.gray
//                    lblMovieSeatTitle.text = ""
//                }
//                else if movieSeatVO.isMovieSeatAvailable(){
//                    // Available
//                    if movieSeatVO.isSelected == true{
//                        viewContainerMovieSeat.clipsToBounds = true
//                        viewContainerMovieSeat.layer.cornerRadius = 8
//                        viewContainerMovieSeat.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//                        viewContainerMovieSeat.backgroundColor = UIColor(named: "primary_color") ?? UIColor.gray
//                        lblMovieSeatTitle.textColor = UIColor.white
//                    }
//                    else{
//                        viewContainerMovieSeat.clipsToBounds = true
//                        viewContainerMovieSeat.layer.cornerRadius = 8
//                        viewContainerMovieSeat.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//                        viewContainerMovieSeat.backgroundColor = UIColor(named: "movie_seat_available_color") ?? UIColor.lightGray
//                        lblMovieSeatTitle.text = ""
//                    }
//
//                }
//                else{
//                    lblMovieSeatTitle.text = ""
//                    viewContainerMovieSeat.layer.cornerRadius = 0
//                    viewContainerMovieSeat.backgroundColor = UIColor.white
//                }
//
//
                
                
                
                if movieSeatVO.isMovieSeatAvailable(){
                    viewContainerMovieSeat.isUserInteractionEnabled = true
                }
                else{
                    viewContainerMovieSeat.isUserInteractionEnabled = false
                }
                viewContainerMovieSeat.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapSeatItem)))
            }
        
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewContainerMovieSeat.isUserInteractionEnabled = true
        viewContainerMovieSeat.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapSeatItem)))
    }
    
    @objc func onTapSeatItem(){
        onTapItem(data?.seatName ?? "")
    }
    
      
    

}
