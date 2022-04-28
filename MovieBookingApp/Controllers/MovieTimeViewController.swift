//
//  MovieTimeViewController.swift
//  MovieBookingApp
//
//  Created by KC on 17/02/2022.
//

import UIKit

class MovieTimeViewController: UIViewController {

   // Views
    @IBOutlet weak var viewContainerTimes: UIView!
    @IBOutlet weak var collectionViewDays: UICollectionView!
    @IBOutlet weak var collectionViewAvailableIn: UICollectionView!
    @IBOutlet weak var collectionSlots: UICollectionView!
    @IBOutlet weak var collectionSlotsHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightType: NSLayoutConstraint!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnConfrim: UIButton!
    
  
    private var checkOutModel : CheckOutModel = CheckOutModelImpl.shared
    private var dateList: [DateVo] = []
    private var cinemaSlots : [CinemaTimeSlot] = []
    private var dayofSearched : String = ""
    private var checkOut : CheckOut?
    private var cinema_id: Int = 0
    private var timeslot_id: Int = 0
    private var cinemaName: String = ""
    private var slotName: String = ""
    private var type : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()

    }
    
   
    private func setup(){
        viewContainerTimes.clipsToBounds = true
        viewContainerTimes.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        viewContainerTimes.layer.cornerRadius = 16
        fetchCheckOut()
        getDates()
        registerForCells()
        setUpViews()
        setUpHeightForCollectionView()
        setUpSourceAndDelegates()


    }
    
    private func fetchCheckOut(){
        checkOutModel.getCheckOut(){ [weak self] (result) in
            guard let self = self else {return }
            switch result{
            case .success(let result):
                self.checkOut = result
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    private func fetchCinemaTimeSlot(day: String){
        checkOutModel.getTimeSlotsByDay(day: day, movieId: checkOut?.movieId ?? 0){ [weak self] (result) in
            guard let self = self else { return }
            switch result{
            case .success(let resultData):
                self.stopLoading()
                
                self.cinemaSlots = resultData
                self.setupSlots()
                
            case .failure(let message):
                print(message)
            }
        }
    }
    
    private func setupSlots(){
        var height = 0
        cinemaSlots.forEach{
            if ( ( $0.timeslots?.count ?? 0) % 3 == 0){
                height += ( $0.timeslots?.count ?? 0)  / 3
            }
            else{
                height +=  (( $0.timeslots?.count ?? 0)  / 3) + 1
            }
        }
        
        collectionSlotsHeight.constant = CGFloat( (60 * height  ) + (50 * cinemaSlots.count))
        collectionSlots.reloadData()
    }
    
    private func getDates(){
        self.startLoading()
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        for i in 1 ... 7 {
            let day = cal.component(.day, from: date)
            if i == 1 {
                let dateVO = DateVo(date: day, day: date.todayOfWeek() ?? "", dayOfSearch: date.todayOfSearch() ?? "", isSelected: true)
                dateList.append(dateVO)
                dayofSearched = date.todayOfSearch() ?? ""
                fetchCinemaTimeSlot(day: date.todayOfSearch() ?? "")
            }
            else{
                let dateVO = DateVo(date: day, day: date.todayOfWeek() ?? "", dayOfSearch: date.todayOfSearch() ?? "", isSelected: false)
                dateList.append(dateVO)
            }
            date = cal.date(byAdding: .day, value: +1, to: date)!
            
        }
        collectionViewDays.reloadData()
    }
    
    private func setUpViews(){
        btnBack.isUserInteractionEnabled = true
        btnBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapBack)))
        
        btnConfrim.addBorderColor(radius: 8, color: UIColor.clear.cgColor, borderWidth: 1)
        btnConfrim.isUserInteractionEnabled = true
        btnConfrim.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapMovieSeat)))
    }
    
    @objc func onTapBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onTapMovieSeat(){
        if(self.dayofSearched == ""){
           self.showAlert(message: "Please choose date!")
        }
        else if( self.cinema_id == 0 && self.timeslot_id == 0){
            self.showAlert(message: "Please choose timeslot!")
        }
        else{
            checkOut?.cinemaDayTimeSlotId = timeslot_id
            checkOut?.bookingDate = dayofSearched
            checkOut?.cinemaTimeSlot = slotName
            checkOut?.cinemaId = cinema_id
            checkOut?.cinemaName = cinemaName
            
            
            if let checkOut = checkOut {
                checkOutModel.saveCheckOut(checkout: checkOut )

            }
            navigateToMovieSeatViewController()
        }
        
    }
    
    private func setUpHeightForCollectionView(){
        constraintHeightType.constant = CGFloat(60 * (theatreList.count / 3))
    }
      
      
      private func registerForCells(){
          
          collectionViewDays.registerForCell(identifier: DaysCollectionViewCell.identifier)
          collectionViewAvailableIn.registerForCell(identifier: TimeCollectionViewCell.identifier)
          collectionSlots.registerForCell(identifier: TimeCollectionViewCell.identifier)
          

      }
      
      private func setUpSourceAndDelegates(){
          collectionViewDays.dataSource = self
          collectionViewDays.delegate = self
          
          collectionViewAvailableIn.dataSource = self
          collectionViewAvailableIn.delegate = self
          
          collectionSlots.dataSource = self
          collectionSlots.delegate = self
          
      
      }

  }

extension MovieTimeViewController: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == collectionSlots {
            return cinemaSlots.count
        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewDays{
            return dateList.count
        }
        else if collectionView == collectionViewAvailableIn{
            return theatreList.count
        }
        
        else {
            guard cinemaSlots.count > 0 else {
                return 0
            }
            return cinemaSlots[section].timeslots?.count ?? 0
        }
       
       
            
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewDays{
            let cell = collectionView.dequeueCell(identifier: DaysCollectionViewCell.identifier, indexPath: indexPath) as DaysCollectionViewCell
            cell.data = dateList[indexPath.row] // data binding
            return cell
            
        }
        else if collectionView == collectionViewAvailableIn{
            let cell = collectionView.dequeueCell(identifier: TimeCollectionViewCell.identifier, indexPath: indexPath) as TimeCollectionViewCell
            cell.data = theatreList[indexPath.row]
            
            return cell
        }
        
        else {
            let cell = collectionView.dequeueCell(identifier: TimeCollectionViewCell.identifier, indexPath: indexPath) as TimeCollectionViewCell
            cell.data = cinemaSlots[indexPath.section].timeslots?[indexPath.row]
            return cell
            }
        
       
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: HeaderTimeSlotView.self), for: indexPath) as! HeaderTimeSlotView
            headerView.label.text = cinemaSlots[indexPath.section].cinema
            return headerView
        default:
            assert(false, "Invalid element type!")
        }
    }
    
}
  

extension MovieTimeViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewDays{
            return CGSize(width: 60, height: 80)
        }
        else{
            let width = collectionView.bounds.width / 3;
            let height = CGFloat(60)
            return CGSize(width: width, height: height)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionSlots{
            cinemaName =  cinemaSlots[indexPath.section].cinema ?? ""
            cinema_id = cinemaSlots[indexPath.section].cinemaID ?? 0
            timeslot_id = cinemaSlots[indexPath.section].timeslots?[indexPath.row].cinemaDayTimeslotID ?? 0
           
        }
        else if collectionView == collectionViewAvailableIn{
            type = theatreList[indexPath.row].startTime ?? ""
        }
        else{
            dayofSearched = dateList[indexPath.row].dayOfSearch
            for (index, element) in dateList.enumerated() {
                if dayofSearched == element.dayOfSearch{
                    dateList[index].isSelected = true
                }
                else{
                    dateList[index].isSelected = false
                }
            }
            self.startLoading()
            cinema_id = 0
            timeslot_id = 0
            collectionViewDays.reloadData()
            fetchCinemaTimeSlot(day: dayofSearched )
        }
    }
}



  

