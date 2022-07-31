//
//  MovieSeatViewController.swift
//  MovieBookingApp
//
//  Created by KC on 17/02/2022.
//

import UIKit
import Alamofire
import RealmSwift
import Combine


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
    
    private var checkOutModel : RxCheckOutModel!
    private var viewModel : RxMovieSeatViewModel!
    private var cancellables = Set<AnyCancellable>()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = RxMovieSeatViewModel(checkOutModel: RxCheckOutModelImpl.shared)
        bindViewState()
        
        setUpViews()
        setUpRegisterCells()
        setUpDataSourceAndDelegate()
        
        viewModel.fetchCheckOut()
        setupUI()
        viewModel.fetchSeating()
     
    }
    
   
    
    private func bindViewState(){
        viewModel.viewState
            .eraseToAnyPublisher()
            .print()
            .sink{ [weak self] (state) in
                guard let self = self else { return }
                switch state {
                case .sendHeight(let data) :
                    self.constraintHeight.constant = CGFloat(35 *  data)
                    self.collectionViewMovieSeats.reloadData()
                case .sendSelectedSeat:
                    self.labelTotalTicket.text = String(self.viewModel.chooseTicket.count)
                    self.labelChooseSeating.text = self.viewModel.ticketString
                    self.btnBuyTicket.setTitle( "Buy Ticket for $\(self.viewModel.totalPrice)", for: .normal)
                    self.collectionViewMovieSeats.reloadData()
                case .noSeatSelected:
                    self.showAlert(message: "Please choose your seating!")
                case .navigateToComboVCSuccess:
                    self.navigateToComboSetVeiwController()
                }
            }.store(in: &cancellables)
    }
    
   
    
    private func setupUI(){
        self.labelDateTime.text = "\(viewModel.checkOut.bookingDate?.getCustomDateFormat() ?? "") \(viewModel.checkOut.cinemaTimeSlot ?? "")"

        self.labelMovieName.text = viewModel.checkOut.movieName
        self.labelCinemaName.text = viewModel.checkOut.cinemaName
        
    }
    
    private func setUpViews(){
        btnBack.isUserInteractionEnabled = true
        btnBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapBack)))
        
        btnBuyTicket.addBorderColor(radius: 8, color: UIColor.clear.cgColor, borderWidth: 1)
        btnBuyTicket.isUserInteractionEnabled = true
        btnBuyTicket.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapComboSet)))
    }

    private func setUpRegisterCells(){
        
        collectionViewMovieSeats.registerForCell(identifier: MovieSeatCollectionViewCell.identifier)
    }
    
    private func setUpDataSourceAndDelegate(){
        collectionViewMovieSeats.dataSource = self
        collectionViewMovieSeats.delegate = self
    }
    
    
    @objc func onTapBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onTapComboSet(){
        viewModel.tapComboSet()
    }
    
}

extension MovieSeatViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.seatList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(identifier: MovieSeatCollectionViewCell.identifier, indexPath: indexPath) as MovieSeatCollectionViewCell
        cell.data = viewModel.seatList[indexPath.row]
        cell.onTapItem  = {
            self.viewModel.checkSeating()
        }
        return cell
    }
    
   
  
    
}

extension MovieSeatViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / CGFloat(viewModel.rowCount)
        let height = CGFloat(35)
        return CGSize(width: width, height: height)
    }
    
}


