//
//  CastCollectionViewCell.swift
//  MovieBookingApp
//
//  Created by KC on 22/02/2022.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    var data : Cast?=nil{
        didSet{
            
            if let cast = data{
                name.text = cast.name
                let profilePath =  "\(AppConstant.baseImageUrl)/\(cast.profilePath ?? "")"
                img.sd_setImage(with: URL(string: profilePath))
                
            }
            

          
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

}
