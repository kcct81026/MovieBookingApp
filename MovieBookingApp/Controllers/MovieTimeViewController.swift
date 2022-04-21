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
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var btnConfrim: UIButton!
    
    @IBOutlet weak var collectionViewOne: UICollectionView!
    @IBOutlet weak var collectionViewTwo: UICollectionView!
    @IBOutlet weak var collectionViewThree: UICollectionView!
    
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    // Constaraints
    
    @IBOutlet weak var constraintHeightType: NSLayoutConstraint!
    
    @IBOutlet weak var constraintHeightOne: NSLayoutConstraint!
    
    @IBOutlet weak var constraintHeightThree: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightTwo: NSLayoutConstraint!
    private var cinemaOneList: [TheatreVO]?
    private var cinemaTwoList: [TheatreVO]?
    private var cinemaThreeList: [TheatreVO]?
    private var checkOutModel : CheckOutModel = CheckOutModelImpl.shared

    private var dateList: [DateVo] = []
    private var dayofSearched : String = ""
    private var checkOut : CheckOut?
    private var cinema_id: Int = 0
    private var timeslot_id: Int = 0
    private var cinemaName: String = ""
    private var slotName: String = ""
    
    
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
        fetchCinemaList()


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
    
    private func bineOneHeight(oneCount: Int, twoCount: Int, theeCount: Int){
        var oneHeight = 0
        if ( oneCount % 3 == 0){
            oneHeight = oneCount / 3
        }
        else{
            oneHeight =  (oneCount / 3) + 1
        }
        constraintHeightOne.constant = CGFloat(60 * oneHeight)
        
        var twoHeight = 0
        if ( twoCount % 3 == 0){
            twoHeight = twoCount / 3
        }
        else{
            twoHeight =  (twoCount / 3) + 1
        }
        constraintHeightTwo.constant = CGFloat(60 * twoHeight)
        
        var threeHeight = 0
        if ( theeCount % 3 == 0){
            threeHeight = theeCount / 3
        }
        else{
            threeHeight =  (theeCount / 3) + 1
        }
        constraintHeightThree.constant = CGFloat(60 * threeHeight)

    }
    
    private func fetchCinemaTimeSlot(day: String){
        checkOutModel.getTimeSlotsByDay(day: day, movieId: checkOut?.movieId ?? 0){ [weak self] (result) in
            guard let self = self else { return }
            switch result{
            case .success(let resultData):
                self.stopLoading()
                
                if resultData.count > 0{
                    self.changeToMovieType(resultData: resultData)
                }
            case .failure(let message):
                print(message)
            }
        }
    }
    
    private func changeToMovieType(resultData: [CinemaTimeSlot] ){
        
        cinemaOneList = resultData[0].timeslots?.map {
            $0.toTheatreType(cid: resultData[0].cinemaID ?? 0)
        }
        
        cinemaTwoList = resultData[1].timeslots?.map {
            $0.toTheatreType(cid: resultData[1].cinemaID ?? 0)
        }
        cinemaThreeList = resultData[2].timeslots?.map {
            $0.toTheatreType(cid: resultData[2].cinemaID ?? 0)

        }
        
        self.bineOneHeight(
            oneCount: self.cinemaOneList?.count ?? 0,
            twoCount: self.cinemaTwoList?.count ?? 0,
            theeCount: self.cinemaThreeList?.count ?? 0
        )
        
        self.collectionViewOne.reloadData()
        self.collectionViewTwo.reloadData()
        self.collectionViewThree.reloadData()
        self.collectionViewDays.reloadData()
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
    
    private func bindData(data: [CinemaVO]){
        labelOne.text = data[0].name
        labelTwo.text = data[1].name
        labelThree.text = data[2].name
        

    }
    
    private func fetchCinemaList(){
        checkOutModel.getCinemaList{ result in
            switch result{
            case .success(let resultData):
                self.bindData(data: resultData)

            case .failure(let message):
                print(message)
            }
        }
    }
    
    private func setUpViews(){
        btnBack.isUserInteractionEnabled = true
        btnBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapBack)))
        
        btnConfrim.addBorderColor(radius: 8, color: UIColor.clear.cgColor, borderWidth: 1)
        btnConfrim.isUserInteractionEnabled = true
        btnConfrim.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapMovieSeat)))
    }
    
    @objc func onTapBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func onTapMovieSeat(){
        if(self.dayofSearched == ""){
           self.showAlert(message: "Please choose date!")
        }
        else if( self.cinema_id == 0 && self.timeslot_id == 0){
            self.showAlert(message: "Please choose timeslot!")
        }
        else{
            checkOutModel.saveCheckOut(checkout: CheckOut(cinemaDayTimeSlotId: timeslot_id, row: "", seatNumber: "", bookingDate: dayofSearched, totalPrice: 0, movieId: checkOut?.movieId, cardId: 0, cinemaId: cinema_id, snacks: nil , cinemaTimeSlot: slotName, movieName: checkOut?.movieName, cinemaName: cinemaName , moviePoseter: checkOut?.moviePoseter,bookingNo: "", qrcode: "" ) )
            navigateToMovieSeatViewController()
        }
        
    }
    
    private func setUpHeightForCollectionView(){
        constraintHeightType.constant = CGFloat(60 * (theatreList.count / 3))
    }
      
      
      private func registerForCells(){
          
          collectionViewDays.registerForCell(identifier: DaysCollectionViewCell.identifier)
          collectionViewAvailableIn.registerForCell(identifier: TimeCollectionViewCell.identifier)
          collectionViewOne.registerForCell(identifier: TimeCollectionViewCell.identifier)
          collectionViewTwo.registerForCell(identifier: TimeCollectionViewCell.identifier)
          collectionViewThree.registerForCell(identifier: TimeCollectionViewCell.identifier)

      }
      
      private func setUpSourceAndDelegates(){
          collectionViewDays.dataSource = self
          collectionViewDays.delegate = self
          
          collectionViewAvailableIn.dataSource = self
          collectionViewAvailableIn.delegate = self
          
          collectionViewOne.dataSource = self
          collectionViewOne.delegate = self
          
          collectionViewTwo.dataSource = self
          collectionViewTwo.delegate = self
          
          collectionViewThree.dataSource = self
          collectionViewThree.delegate = self
          
      
      }

  }

extension MovieTimeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewDays{
            return dateList.count 
        }
        else if collectionView == collectionViewAvailableIn{
            return theatreList.count
        }
        else if collectionView == collectionViewOne{
            return cinemaOneList?.count ?? 0
        }
        else if collectionView == collectionViewTwo{
            return cinemaTwoList?.count ?? 0
        }
        else {
            return cinemaThreeList?.count ?? 0
        }
       
            
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewDays{
            let cell = collectionView.dequeueCell(identifier: DaysCollectionViewCell.identifier, indexPath: indexPath) as DaysCollectionViewCell
            cell.data = dateList[indexPath.row] // data binding
            cell.onTapItem  = { date in
                self.dateList.forEach{ (dateVO) in
                    if date == dateVO.date{
                        dateVO.isSelected = true
                        self.dayofSearched = dateVO.dayOfSearch
                    }
                    else{
                        dateVO.isSelected = false
                    }
                }
                self.startLoading()
                self.cinema_id = 0
                self.timeslot_id = 0
                self.cinemaName = ""
                self.slotName = ""
                self.fetchCinemaTimeSlot(day: self.dayofSearched )

            }
            return cell
            
        }
        else if collectionView == collectionViewAvailableIn{
            let cell = collectionView.dequeueCell(identifier: TimeCollectionViewCell.identifier, indexPath: indexPath) as TimeCollectionViewCell
            cell.data = theatreList[indexPath.row]
            cell.onTapItem  = { type in
                theatreList.forEach{ (theatre) in
                    if type == theatre.type{
                        theatre.isSelected = true
                    }
                    else{
                        theatre.isSelected = false
                    }
                }
                self.collectionViewAvailableIn.reloadData()
            }
            return cell
        }
        else if collectionView == collectionViewOne{
            let cell = collectionView.dequeueCell(identifier: TimeCollectionViewCell.identifier, indexPath: indexPath) as TimeCollectionViewCell
                cell.data = cinemaOneList?[indexPath.row]//.toTheatreType()
                cell.onTapItem  = { type in
                self.cinemaOneList?.forEach{ (theatre) in
                    if type == theatre.type{
                        theatre.isSelected = true
                        self.cinema_id = theatre.cinemaId
                        self.timeslot_id = theatre.id
                        self.cinemaName = self.labelOne.text ?? ""
                        self.slotName = theatre.type
                    }
                    else{
                        theatre.isSelected = false
                    }
                    self.cinemaThreeList?.forEach{ $0.isSelected = false}
                    self.cinemaTwoList?.forEach{ $0.isSelected = false}

                }
                self.collectionViewOne.reloadData()
                self.collectionViewTwo.reloadData()
                self.collectionViewThree.reloadData()
            }
            return cell
        }
        else if collectionView == collectionViewTwo{
            let cell = collectionView.dequeueCell(identifier: TimeCollectionViewCell.identifier, indexPath: indexPath) as TimeCollectionViewCell
                cell.data = cinemaTwoList?[indexPath.row]//.toTheatreType()
                cell.onTapItem  = { type in
                self.cinemaTwoList?.forEach{ (theatre) in
                    if type == theatre.type{
                        theatre.isSelected = true
                        self.cinema_id = theatre.cinemaId
                        self.timeslot_id = theatre.id
                        self.cinemaName = self.labelTwo.text ?? ""
                        self.slotName = theatre.type

                    }
                    else{
                        theatre.isSelected = false
                    }
                        self.cinemaOneList?.forEach{ $0.isSelected = false}
                        self.cinemaThreeList?.forEach{ $0.isSelected = false}

                }
                self.collectionViewOne.reloadData()
                self.collectionViewTwo.reloadData()
                self.collectionViewThree.reloadData()
            }
            return cell
            
        }
        else{
            let cell = collectionView.dequeueCell(identifier: TimeCollectionViewCell.identifier, indexPath: indexPath) as TimeCollectionViewCell
                cell.data = cinemaThreeList?[indexPath.row]//.toTheatreType()
                cell.onTapItem  = { type in
                self.cinemaThreeList?.forEach{ (theatre) in
                    if type == theatre.type{
                        theatre.isSelected = true
                        self.cinema_id = theatre.cinemaId
                        self.timeslot_id = theatre.id
                        self.cinemaName = self.labelThree.text ?? ""
                        self.slotName = theatre.type
                    }
                    else{
                        theatre.isSelected = false
                    }
                
                        self.cinemaOneList?.forEach{ $0.isSelected = false}
                        self.cinemaTwoList?.forEach{ $0.isSelected = false}

                    }
                self.collectionViewOne.reloadData()
                self.collectionViewTwo.reloadData()
                self.collectionViewThree.reloadData()
            }
            return cell
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
        
    }
}



  


