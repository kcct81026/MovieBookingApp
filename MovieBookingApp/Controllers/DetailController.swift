//
//  DetailController.swift
//  MovieBookingApp
//
//  Created by KC on 22/02/2022.
//

import UIKit

class DetailController: UIViewController {

    @IBOutlet weak var collectionViewGenres: UICollectionView!
    @IBOutlet weak var labelSummary: UILabel!
    @IBOutlet weak var labelImdb: UILabel!
    @IBOutlet weak var svRating: RatingControl!
    @IBOutlet weak var labelShowTime: UILabel!
    @IBOutlet weak var lableTitle: UILabel!
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var viewCornerDisplay: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var viewOverlay: UIView!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var btnGetTicket: UIButton!
    @IBOutlet weak var lblCast: UILabel!
    
    
    var id: Int = 0
   
    private let movieModel : MovieModel = MovieModelImpl.shared
    private let checkOutModel : CheckOutModel = CheckOutModelImpl.shared
    private var casts: [Cast]?
    private var genreList: [String]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        setUpDataSourceAndDelegate()
        setUpRegisterCells()
        self.startLoading()
        fetchMoiveDetails()
    

    }
    
    private func fetchMoiveDetails(){
        movieModel.getMovieDetailById(id: id){ [weak self] (result) in
            guard let self = self else { return }
            switch result{
                
            case .success(let resultData):
                self.casts = resultData.casts
                self.genreList = resultData.genres
                self.collectionViewGenres.reloadData()
                self.castCollectionView.reloadData()
                //self.bindData(data: resultData)
                self.movie = resultData
                self.stopLoading()

            case .failure(let message):
                self.stopLoading()
                print(message)
            }
        }
    }
    
    var movie : MovieDetailVO?=nil{
        didSet{
            if let data = movie{
                lableTitle.text = data.originalTitle
                labelSummary.text = data.overview
                labelShowTime.text = "\(String(describing: data.runtime ?? 0))"
                if let _ = data.posterPath{
                    let profilePath =  "\(AppConstant.baseImageUrl)/\(data.posterPath ?? "")"
                    imgPoster.sd_setImage(with: URL(string: profilePath))
                }
                svRating.rating = Int((data.rating ?? 0) * 0.5)
               
            }
          
        }
    }
    
    

    private func bindData(data: MovieDetailVO){
        lableTitle.text = data.originalTitle
        labelSummary.text = data.overview
        labelShowTime.text = "\(String(describing: data.runtime ?? 0))"
        if let _ = data.posterPath{
            let profilePath =  "\(AppConstant.baseImageUrl)/\(data.posterPath ?? "")"
            imgPoster.sd_setImage(with: URL(string: profilePath))
        }
        svRating.rating = Int((data.rating ?? 0) * 0.5)
        
    }
    
    private func setUpViews(){
        viewCornerDisplay.layer.cornerRadius = 20
        viewCornerDisplay.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        
        
        viewOverlay.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        lblCast.setMargins(margin: 16)
        
        btnBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapBack)))
        btnBack.isUserInteractionEnabled = true
        
        btnGetTicket.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapMovieTime)))
        btnGetTicket.isUserInteractionEnabled = true
    
        btnGetTicket.addBorderColor(radius: 8, color: UIColor.lightGray.cgColor, borderWidth: 1)
    }
    
    @objc func onTapBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onTapMovieTime(){
        //checkOutModel.saveMoiveId(id: id, movieName: movieName, poster: poster )
        let checkOut = CheckOut()
        checkOut.movieId = id
        checkOut.movieName = movie?.originalTitle
        checkOut.moviePoseter = movie?.posterPath
        checkOut.runtime = movie?.runtime
        checkOutModel.saveCheckOut(checkout: checkOut)
        navigateToMovieTimeViewController()
    }
    
    private func setUpRegisterCells(){
        
        castCollectionView.registerForCell(identifier: CastCollectionViewCell.identifier)
        collectionViewGenres.registerForCell(identifier: GenreCollectionViewCell.identifier)
    }

    private func setUpDataSourceAndDelegate(){
        collectionViewGenres.dataSource = self
        collectionViewGenres.delegate = self
        castCollectionView.dataSource = self
        castCollectionView.delegate = self

    }
}

extension DetailController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == castCollectionView{
            return casts?.count ?? 0
        }
        else{
            return genreList?.count ?? 0
        }
        
            
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == castCollectionView{
            let cell = collectionView.dequeueCell(identifier: CastCollectionViewCell.identifier, indexPath: indexPath) as CastCollectionViewCell
            cell.data = casts?[indexPath.row]
            return cell
        }
        else{
            let cell = collectionView.dequeueCell(identifier: GenreCollectionViewCell.identifier, indexPath: indexPath) as GenreCollectionViewCell
            cell.data = genreList?[indexPath.row]
            return cell
        }

      
    }
}
  

extension DetailController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == castCollectionView{
            let width = collectionView.bounds.width / 3.5
            let height = CGFloat(150)
            return CGSize(width: width, height: height)
        }
        else{
            return CGSize(width: widthOfString(text: genreList?[indexPath.row] ?? "", font: UIFont(name : "Geeza Pro Regular", size: 12) ?? UIFont.systemFont(ofSize: 12))+60, height: 50)
        }
        
        
    }
    
    func widthOfString(text:String, font:UIFont)->CGFloat{
        let fontAttributes = [NSAttributedString.Key.font : font]
        let textSize  = text.size(withAttributes: fontAttributes)
        return textSize.width
    }
}

