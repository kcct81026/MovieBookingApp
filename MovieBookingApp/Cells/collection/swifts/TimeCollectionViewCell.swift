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
    
    
    var data : Timeslot?=nil{
        didSet{
            
            if let item = data{
                lbl.text = item.startTime
                
                
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
        
    }
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
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
