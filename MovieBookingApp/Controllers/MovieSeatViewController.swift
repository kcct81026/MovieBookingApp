//
//  MovieSeatViewController.swift
//  MovieBookingApp
//
//  Created by KC on 17/02/2022.
//

import UIKit
import Alamofire
import RealmSwift

class MovieSeatViewController: UIViewController {

    @IBOutlet weak var labelChooseSeating: UILabel!
    @IBOutlet weak var labelTotalTicket: UILabel!
    @IBOutlet weak var labelDateTime: UILabel!
    @IBOutlet weak var labelCinemaName: UILabel!
    @IBOutlet weak var labelMovieName: UILabel!
    @IBOutlet weak var btnBuyTicket: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var collectionViewMovieSeats: UICollectionView!
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    private var checkOutModel : CheckOutModel = CheckOutModelImpl.shared
    private var checkOut : CheckOut?
    private var seatList =  [SeatingVO]()
    private var data : [[SeatingVO]]?
    
    private var chooseTicket = [String]()
    private var rowCount = 0
    private var price = [Int]()
    var ticketString = ""
    var totalPrice = 0
    var rowString = ""


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpViews()
        setUpRegisterCells()
        setUpDataSourceAndDelegate()
        fetchCheckOut()

        
    }
    
    private func fetchSeating(){
        checkOutModel.getSeating(day: checkOut?.bookingDate ?? "", id: checkOut?.cinemaDayTimeSlotId ?? 0){ [weak self] (result) in
            guard let self = self else {return }
            switch result{
            case .success(let result):
                
                self.data = result
                if let count = self.data?.count{
                    for i in 0 ..< count {
                        for j in 0 ..<  (self.data?[i].count ?? 0){
                            self.rowCount = self.data?[i].count ?? 0
                            if let item = self.data?[i][j]{
                                self.seatList.append(item)
                            }
                        }
                    }
                }
                
                self.setupCollectionHeight()
                self.collectionViewMovieSeats.reloadData()
                
                //self.collectionViewMovieSeats.reloadData()
            case .failure(let error):
                debugPrint(error)
            }


        }
        
        

       
    }
    
    private func setupCollectionHeight(){
        var oneHeight = 0
        if ( seatList.count % rowCount == 0){
            oneHeight = seatList.count / rowCount
        }
        else{
            oneHeight =  ( seatList.count  / rowCount) + 1
        }
        
        constraintHeight.constant = CGFloat(35 * oneHeight)
    }
    
    private func fetchCheckOut(){
        checkOutModel.getCheckOut(){ [weak self] (result) in
            guard let self = self else {return }
            switch result{
            case .success(let result):
                self.checkOut = result
                self.setupUI()
                self.fetchSeating()
            case .failure(let error):
                debugPrint(error)
            }
    
            
        }
    }
    
    private func setupUI(){
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "EEEE, MMM d"

        if let date = dateFormatterGet.date(from: checkOut?.bookingDate ?? "") {
            self.labelDateTime.text = "\(dateFormatterPrint.string(from: date)) \(checkOut?.cinemaTimeSlot ?? "")"
        }
        
        self.labelMovieName.text = self.checkOut?.movieName
        self.labelCinemaName.text = self.checkOut?.cinemaName
        
    }
    
    private func setUpViews(){
        btnBack.isUserInteractionEnabled = true
        btnBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapBack)))
        
        btnBuyTicket.addBorderColor(radius: 8, color: UIColor.clear.cgColor, borderWidth: 1)
        btnBuyTicket.isUserInteractionEnabled = true
        btnBuyTicket.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapComboSet)))
    }
    
    @objc func onTapBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func onTapComboSet(){

        
        if ticketString == "" {
            showAlert(message: "Please choose your seating!")
        }
        else{

            checkOutModel.saveCheckOut(checkout: CheckOut(
                cinemaDayTimeSlotId: checkOut?.cinemaDayTimeSlotId,
                row: rowString,
                seatNumber: ticketString,
                bookingDate: checkOut?.bookingDate,
                totalPrice: totalPrice,
                movieId: checkOut?.movieId,
                cardId: nil,
                cinemaId: checkOut?.cinemaId,
                snacks: nil,
                cinemaTimeSlot: checkOut?.cinemaTimeSlot,
                movieName: checkOut?.movieName,
                cinemaName: checkOut?.cinemaName,
                moviePoseter: checkOut?.moviePoseter,
                bookingNo: "",
                qrcode: ""
            
            ))
            
            navigateToComboSetVeiwController()
        }
        
    }
    
    private func setUpRegisterCells(){
        
        collectionViewMovieSeats.registerForCell(identifier: MovieSeatCollectionViewCell.identifier)
    }
    
    private func setUpDataSourceAndDelegate(){
        collectionViewMovieSeats.dataSource = self
        collectionViewMovieSeats.delegate = self
    }
    
    
}

extension MovieSeatViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seatList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifier: MovieSeatCollectionViewCell.identifier, indexPath: indexPath) as MovieSeatCollectionViewCell
        cell.data = seatList[indexPath.row]
        cell.onTapItem  = { seatName in
            self.chooseTicket.removeAll()
            self.price.removeAll()
            self.totalPrice = 0
            self.ticketString = ""
            for j in 0 ..< self.seatList.count{
                var ms: SeatingVO = self.seatList[j]
                if seatName == ms.seatName{
                    if ms.isSelected{
                        ms.changeSelected(value: false)
                    }
                    else{
                        ms.changeSelected(value: true)
                    }
                }
                self.seatList[j] = ms
                
                if self.seatList[j].isSelected == true{
                    self.chooseTicket.append(self.seatList[j].seatName ?? "")
                    self.price.append(self.seatList[j].price ?? 0)

                }
            }
            self.changeUI()
            self.collectionViewMovieSeats.reloadData()
        }
        return cell
    }
    
    private func changeUI(){
        var rowList = [String]()
        for j in 0 ..< chooseTicket.count{
            let fullNameArr = chooseTicket[j].components(separatedBy: "-")
            rowList.append(fullNameArr[0])
        }
        rowString = (rowList.unique().map{$0}).joined(separator: ",")
        

        ticketString = (chooseTicket.map{$0}).joined(separator: ",")
        totalPrice = price.reduce(0, +)
        
        labelTotalTicket.text = String(chooseTicket.count)
        labelChooseSeating.text = ticketString
        btnBuyTicket.setTitle( "Buy Ticket for $\(totalPrice)", for: .normal)
    }
    
    
}

extension MovieSeatViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / CGFloat(rowCount)
        let height = CGFloat(35)
        return CGSize(width: width, height: height)
    }
}


