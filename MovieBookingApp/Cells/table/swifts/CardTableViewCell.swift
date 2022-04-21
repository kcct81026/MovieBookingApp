//
//  CardTableViewCell.swift
//  MovieBookingApp
//
//  Created by KC on 23/02/2022.
//

import UIKit

class CardTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCardName: UILabel!
    
    var data : PaymentVO?=nil{
        didSet{
            if let cardVO = data{
                lblTitle.text = cardVO.description
                lblCardName.text = cardVO.name
                
               
            }
          
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
