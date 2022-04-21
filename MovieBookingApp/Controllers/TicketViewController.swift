//
//  TicketViewController.swift
//  MovieBookingApp
//
//  Created by KC on 25/02/2022.
//

import UIKit

class TicketViewController: UIViewController {

    @IBOutlet weak var imgQrCode: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblSeatNumber: UILabel!
    @IBOutlet weak var lblRow: UILabel!
    @IBOutlet weak var lblTicket: UILabel!
    @IBOutlet weak var lblCinemaName: UILabel!
    @IBOutlet weak var lblShowTime: UILabel!
    @IBOutlet weak var lblBookingNo: UILabel!
    @IBOutlet weak var lblMovieName: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var btnClose: UIButton!
    
    private var checkOut: CheckOut?
    private var checkOutModel : CheckOutModel = CheckOutModelImpl.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        fetchCheckOut()
        
    }
    
    private func setupViews(){
        btnClose.isUserInteractionEnabled = true
        btnClose.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapClose)))
        
        img.layer.cornerRadius = 10
        img.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
    
    private func fetchCheckOut(){
        checkOutModel.getCheckOut(){ [weak self] (result) in
            guard let self = self else {return }
            switch result{
            case .success(let result):
                self.checkOut = result
                self.setupUI()
            case .failure(let error):
                debugPrint(error)
            }
    
            
        }
        
    }
    
    private func setupUI(){
        lblMovieName.text = checkOut?.movieName
        lblBookingNo.text = checkOut?.bookingNo
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "EEEE, MMM d"

        if let date = dateFormatterGet.date(from: checkOut?.bookingDate ?? "") {
            lblShowTime.text = "\(dateFormatterPrint.string(from: date)) \(checkOut?.cinemaTimeSlot ?? "")"
        }
        
        let tickets = checkOut?.seatNumber?.split(separator: ",")
        lblTicket.text = "\(tickets?.count ?? 0)"
        
        lblCinemaName.text = checkOut?.cinemaName
        lblRow.text = checkOut?.row
        lblSeatNumber.text = checkOut?.seatNumber
        lblPrice.text = "$\(checkOut?.totalPrice ?? 0)"
        
        if let _ = checkOut?.moviePoseter{
            let profilePath =  "\(AppConstant.baseImageUrl)/\(checkOut?.moviePoseter ?? "")"
            img.sd_setImage(with: URL(string: profilePath))
        }
        
        let qrcodeImg = "\(AppConstant.BASEURL)/\(checkOut?.qrcode ?? "")".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)

        imgQrCode.sd_setImage(with: URL(string: qrcodeImg ?? ""))
    }
    
    @objc func onTapClose(){
       navigateToMainViewController()
    }
    
   

}


