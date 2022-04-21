//
//  NowShowingCollectionViewCell.swift
//  MovieBookingApp
//
//  Created by KC on 21/02/2022.
//

import UIKit

class NowShowingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblGenre: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewForAll: UIView!

    @IBOutlet weak var viewForShadow: UIView!
    @IBOutlet weak var img: UIImageView!
    var delegate: MovieItemClickDelegate?=nil
    
    
    var data : MovieResult?=nil{
        didSet{
            if let movieVO = data{
                lblName.text = movieVO.originalTitle
                lblGenre.text = movieVO.genres?.map { $0}.joined(separator: ",")
                let profilePath =  "\(AppConstant.baseImageUrl)/\(movieVO.posterPath ?? "")"
                img.sd_setImage(with: URL(string: profilePath))
               
            }
          
        }
    }
    

    
    override func awakeFromNib() {
        super.awakeFromNib()

        viewForAll.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapItem)))
        
   
        setUpShadow()
}
    
    private func setUpShadow(){
        img.layer.cornerRadius = 15
        img.clipsToBounds = true
        
        viewForShadow.backgroundColor = UIColor.black
        viewForShadow.clipsToBounds = true
        viewForShadow.layer.cornerRadius = 15
        viewForShadow.layer.masksToBounds = false
        viewForShadow.layer.shadowOpacity = 0.11
        viewForShadow.layer.shadowOffset = CGSize(width: 8, height:8)
        viewForShadow.layer.shadowColor = UIColor.black.cgColor
        
    }
    
  
  
    @objc func onTapItem(){
        delegate?.onTapMovie(id: data?.id ?? 0 )
    }
}
