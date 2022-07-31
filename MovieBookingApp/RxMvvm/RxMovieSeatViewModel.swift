//
//  RxMovieSeatViewModel.swift
//  MovieBookingApp
//
//  Created by KC on 04/06/2022.
//

import Foundation
import Combine
import RxSwift

enum RxMovieSeatViewState{
    case sendHeight(rowHeight: Int)
    case sendSelectedSeat
    case noSeatSelected
    case navigateToComboVCSuccess
    
}

class RxMovieSeatViewModel : RxMovieSeatViewModelType{
    var viewState: PassthroughSubject<RxMovieSeatViewState, Never> = .init()
    var rowCount: Int = UDM.shared.defaults.integer(forKey: "row_count")
    var seatList = [SeatingVO]()
    var checkOut: CheckOut = CheckOut()
    
    var chooseTicket = [String]()
    var totalPrice = 0
    var ticketString = ""
    
    private var rowString = ""
    private var checkOutModel:  RxCheckOutModel!
    private var price = [Int]()
    private var disposeBag = DisposeBag()

    
   
    init(checkOutModel: RxCheckOutModel){
        self.checkOutModel = checkOutModel
    }
    
    func fetchCheckOut() {
//        checkOutModel.getCheckOut(){ [weak self] (result) in
//            guard let self = self else {return }
//            switch result{
//            case .success(let result):
//                self.checkOut = result
//            case .failure(let error):
//                debugPrint(error)
//            }
//
//
//        }
        checkOutModel.getCheckOutObservable()
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                
                self.checkOut = result
            })
            .disposed(by: disposeBag)
    }
    
    func fetchSeating() {
        checkOutModel.getSeating(day: checkOut.bookingDate ?? "", id: checkOut.movieId ?? 0)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                
                self.seatList = result
                self.setupCollectionHeight()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupCollectionHeight(){
        var oneHeight = 0
        if ( seatList.count % rowCount == 0){
            oneHeight = seatList.count / rowCount
        }
        else{
            oneHeight =  ( seatList.count  / rowCount) + 1
        }
        
        self.viewState.send(.sendHeight(rowHeight: oneHeight))
        
    }
    
    func tapComboSet() {
        if ticketString == "" {
            viewState.send(.noSeatSelected)
        }
        else{
            self.checkOut.row = rowString
            self.checkOut.seatNumber = ticketString
            self.checkOut.totalPrice = totalPrice
            self.checkOutModel.saveCheckOut(checkout: self.checkOut )
            self.viewState.send(.navigateToComboVCSuccess)
        
        }
    }
    
    
    func checkSeating(){
        chooseTicket.removeAll()
        price.removeAll()
        totalPrice = 0
        ticketString = ""
        self.seatList.forEach{
            if $0.isSelected {
                chooseTicket.append($0.seatName ?? "")
                price.append($0.price ?? 0)

            }
        }
        
        calculatePrice()
    }
    
    private func calculatePrice(){
        var rowList = [String]()
        for j in 0 ..< chooseTicket.count{
            let fullNameArr = chooseTicket[j].components(separatedBy: "-")
            rowList.append(fullNameArr[0])
        }
        rowString = (rowList.unique().map{$0}).joined(separator: ",")
        

        ticketString = (chooseTicket.map{$0}).joined(separator: ",")
        totalPrice = price.reduce(0, +)
        
        viewState.send(.sendSelectedSeat)
        
    }
    
    
}
