//
//  CardInfoCollectionViewCell.swift
//  MovieBookingApp
//
//  Created by KC on 24/02/2022.
//

import UIKit

class CardInfoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblCardType: UILabel!
    @IBOutlet weak var lblCardExpire: UILabel!
    @IBOutlet weak var lblCardHolder: UILabel!
    @IBOutlet weak var lblCardNumber: UILabel!
    
    
    var data : Card?=nil{
        didSet{
            if let card = data{
                lblCardType.text = card.cardType
                lblCardExpire.text = card.expireDate
                lblCardHolder.text = card.cardHolder
                if (card.cardNumber?.count ?? 0) > 4{
                    let last4 = String(card.cardNumber!.suffix(4))
                    lblCardNumber.text = last4
                }
                else{
                    lblCardNumber.text = card.cardNumber
                }
               
            }
          
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
