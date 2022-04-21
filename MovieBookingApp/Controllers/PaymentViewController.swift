//
//  PaymentViewController.swift
//  MovieBookingApp
//
//  Created by KC on 24/02/2022.
//

import UIKit
import UPCarouselFlowLayout

class PaymentViewController: UIViewController {

    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var btnConfrim: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var clickAddNewCard: UIStackView!
    @IBOutlet weak var btnBack: UIButton!
    
    private var checkOut: CheckOut?
    private var checkOutModel : CheckOutModel = CheckOutModelImpl.shared
    private var userModel: UserModel = UserModelImpl.shared
    private var cardList = [Card]()
    private var currentCard : Card?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCheckOut()
        setUpViews()
        setUpRegisterCells()
        setUpDataSourceAndDelegate()
        setColletionViewHeight()
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchProfile()

    }
    
    private func fetchProfile(){
        userModel.getProfile{ (result) in
            switch result{
            case .success(let data):
                self.cardList = data
                if self.currentCard == nil {
                    self.currentCard = self.cardList.first
                }
                
                self.collectionView.reloadData()
            case .failure(let message):
                print(message)
            }
        }
    }
    
    private func fetchCheckOut(){
        checkOutModel.getCheckOut(){ [weak self] (result) in
            guard let self = self else {return }
            switch result{
            case .success(let result):
                self.checkOut = result
                self.lblTotalPrice.text = "$\(self.checkOut?.totalPrice ?? 0)"
            case .failure(let error):
                debugPrint(error)
            }
    
            
        }
        
    }
    
    
    private func setUpRegisterCells(){
        collectionView.registerForCell(identifier: CardInfoCollectionViewCell.identifier)
    }

    private func setUpDataSourceAndDelegate(){
        collectionView.dataSource = self
        collectionView.delegate = self
        //self.setupLayout()
        //collectionView.delegate = self
    }
    
    private func setUpViews(){
        btnConfrim.addBorderColor(radius: 8, color: UIColor.lightGray.cgColor, borderWidth: 1)
        btnConfrim.isUserInteractionEnabled = true
        btnConfrim.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapConfirm)))
        
        btnBack.isUserInteractionEnabled = true
        btnBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapBack)))
        
        clickAddNewCard.isUserInteractionEnabled = true
        clickAddNewCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapNewCard)))
    }
    
    @objc func onTapNewCard(){
        navigateToCardInfoFillFormVeiwController()
    }

    @objc func onTapConfirm(){
        
        if cardList.count == 0{
            self.showInfo(message: "Please add card!")
        }else{
            self.startLoading()
            
            let checkout = CheckOut(
                cinemaDayTimeSlotId: checkOut?.cinemaDayTimeSlotId,
                row: checkOut?.row,
                seatNumber: checkOut?.seatNumber,
                bookingDate: checkOut?.bookingDate,
                totalPrice: checkOut?.totalPrice,
                movieId: checkOut?.movieId,
                cardId: currentCard?.id,
                cinemaId: checkOut?.cinemaId,
                snacks: checkOut?.snacks,
                cinemaTimeSlot: checkOut?.cinemaTimeSlot,
                movieName: checkOut?.movieName,
                cinemaName: checkOut?.cinemaName,
                moviePoseter: checkOut?.moviePoseter,
                bookingNo: "",
                qrcode: ""
            
            )
            
            checkOutModel.sendCheckOut(checkout: checkout ){(result) in
                switch result{
                case .success(let data):
                    self.stopLoading()
                    if data.code == 200 {
                        self.checkOutTicket(bNo: data.data?.bookingNo ?? "", qrcode: data.data?.qrCode ?? "")
                    }
                    else{
                        self.showInfo(message: data.message ?? "unknown error!")
                    }

                case .failure(let message):
                    self.stopLoading()
                    debugPrint(message)
                    //self.showAlert(message: message)
                }

            }
                    
        }
        
    }
    
    private func checkOutTicket(bNo: String, qrcode: String){
        let checkout = CheckOut(
            cinemaDayTimeSlotId: checkOut?.cinemaDayTimeSlotId,
            row: checkOut?.row,
            seatNumber: checkOut?.seatNumber,
            bookingDate: checkOut?.bookingDate,
            totalPrice: checkOut?.totalPrice,
            movieId: checkOut?.movieId,
            cardId: currentCard?.id,
            cinemaId: checkOut?.cinemaId,
            snacks: checkOut?.snacks,
            cinemaTimeSlot: checkOut?.cinemaTimeSlot,
            movieName: checkOut?.movieName,
            cinemaName: checkOut?.cinemaName,
            moviePoseter: checkOut?.moviePoseter,
            bookingNo: bNo,
            qrcode: qrcode
        
        )
            
        checkOutModel.saveCheckOut(checkout: checkout)
        navigateToTicketVeiwController()
    }
   
    
    @objc func onTapBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setColletionViewHeight(){
        let layout = UPCarouselFlowLayout()
        layout.scrollDirection = .horizontal
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 30)
        layout.itemSize = CGSize(width: 300, height: 200)
        collectionView.collectionViewLayout = layout
       
    }
    
    fileprivate func setupLayout() {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 0)
    }
}

extension PaymentViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifier: CardInfoCollectionViewCell.identifier, indexPath: indexPath) as CardInfoCollectionViewCell
        cell.data = cardList[indexPath.row]
        return cell
    }
    
   
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()

        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size

        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        currentCard = self.cardList[indexPath.row]

    }

}


