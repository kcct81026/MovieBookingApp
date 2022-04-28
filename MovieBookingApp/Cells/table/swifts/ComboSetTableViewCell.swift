//
//  ComboSetTableViewCell.swift
//  MovieBookingApp
//
//  Created by KC on 23/02/2022.
//

import UIKit

class ComboSetTableViewCell: UITableViewCell {

    @IBOutlet weak var lblMinus: UILabel!
    @IBOutlet weak var lblPlus: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var svCorner: UIStackView!
    
    
    var onTapPlus: (() -> Void) = {}
    var onTapMinus: (() -> Void) = {}

    
    var data : SnackVO?=nil{
        didSet{
            if let comboSet = data{
                lblTitle.text = comboSet.name
                lblName.text = comboSet.description
                if let price = comboSet.price{
                    lblAmount.text = "\(price) $"

                }
                lblCount.text = String(comboSet.count)
                
               
            }
          
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUpViews()
    }
    
    private func setUpViews(){
        svCorner.addBorderColor(radius: 2, color: UIColor.lightGray.cgColor, borderWidth: 0.5)

        
        lblPlus.isUserInteractionEnabled = true
        lblMinus.isUserInteractionEnabled = true
        lblPlus.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapCountPlus)))
        lblMinus.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapCountMinus)))

    }
    
    @objc func onTapCountMinus(){
        if let count = data?.count{
            if count > 0 {
                data?.count = count - 1
                onTapMinus()
            }
        }
    }
    
    @objc func onTapCountPlus(){
        if let count = data?.count{
            data?.count = count + 1
            onTapPlus()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
