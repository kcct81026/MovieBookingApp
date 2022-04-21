//
//  GenreCollectionViewCell.swift
//  MovieBookingApp
//
//  Created by KC on 06/04/2022.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var genreLabel : UILabel!
    @IBOutlet weak var view : UIView!
   // @IBOutlet weak var btn : UIButton!
    
    var data : String?=nil{
        didSet{
            if let _ = data{
                //btn.setTitle(data, for: .normal)
                genreLabel.text = data
                
            }
          
        }
    }
//self.layer.cornerRadius = radius
    override func awakeFromNib() {
        super.awakeFromNib()
        view.addBorderColor(radius: 18, color: UIColor.lightGray.cgColor, borderWidth: 1)
        
//        btn.layer.borderWidth = 1
//        btn.layer.borderColor = UIColor.red.cgColor
//        btn.layer.cornerRadius = 50
//        btn.contentEdgeInsets = UIEdgeInsets(top: 50,left: 50,bottom: 50,right: 50)
//        view.layer.borderColor = UIColor.black.cgColor
//        view.layer.borderWidth = 1
       // view.addBorderColorView(radius: 25, color: UIColor.lightGray.cgColor, borderWidth: 1)
        // Initialization code
    }

}
