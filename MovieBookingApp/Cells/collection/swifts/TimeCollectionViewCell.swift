//
//  TimeCollectionViewCell.swift
//  MovieBookingApp
//
//  Created by KC on 17/02/2022.
//

import UIKit

class TimeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var viewContainerTime: UIView!
    
    var onTapItem: ((String) -> Void) = {_ in}
    
    var data : TheatreVO?=nil{
        didSet{
            
            if let theatre = data{
                lbl.text = theatre.type
                if theatre.isSelected{
                    lbl.textColor = UIColor.white
                    viewContainerTime.backgroundColor =  UIColor(named: "primary_color") ?? UIColor.white
                }
                else{
                    lbl.textColor = UIColor.black
                    viewContainerTime.backgroundColor =  UIColor.white
                }
                
            }
        
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUpViews()
        
    }
    
    private func setUpViews(){
        viewContainerTime.layer.borderColor =  #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        viewContainerTime.layer.borderWidth = 1
        viewContainerTime.layer.cornerRadius = 6
        
        viewContainerTime.isUserInteractionEnabled = true
        viewContainerTime.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapTheatre)))
    }
    
    
    @objc func onTapTheatre(){
        onTapItem(data?.type ?? "")
    }
    
   

}
