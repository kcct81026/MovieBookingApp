//
//  DaysCollectionViewCell.swift
//  MovieBookingApp
//
//  Created by KC on 17/02/2022.
//

import UIKit

class DaysCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    
    //var onTapItem: ((Int) -> Void) = {_ in}
    
    var data : DateVo?=nil{
        didSet{
            
            if let dateVO = data{
                lblDay.text = dateVO.day
                lblDate.text = String(dateVO.date)
                
                if dateVO.isSelected{
                    lblDay.textColor = UIColor.white
                    lblDate.textColor = UIColor.white
                    lblDate.font = lblDate.font.withSize(24)
                }
                else{
                    lblDay.textColor = UIColor.lightGray
                    lblDate.textColor = UIColor.lightGray
                    lblDate.font = lblDate.font.withSize(16)
                }
                
            }
        
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
//    override var isSelected: Bool{
//        didSet{
//            if isSelected{
//                lblDay.textColor = UIColor.white
//                lblDate.textColor = UIColor.white
//                lblDate.font = lblDate.font.withSize(24)
//            }
//            else{
//                lblDay.textColor = UIColor.lightGray
//                lblDate.textColor = UIColor.lightGray
//                lblDate.font = lblDate.font.withSize(16)
//            }
//        }
//    }
   
}
