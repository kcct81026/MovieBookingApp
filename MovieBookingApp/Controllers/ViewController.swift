//
//  ViewController.swift
//  MovieBookingApp
//
//  Created by KC on 16/02/2022.
//

import UIKit

class ViewController: UIViewController, MovieItemClickDelegate{
    
    
    
    @IBOutlet weak var lblShowing: UILabel!
    @IBOutlet weak var lblComingSoon: UILabel!
    @IBOutlet weak var collectionViewComingSoon: UICollectionView!
    @IBOutlet weak var collectionViewNowShowing: UICollectionView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    private let movieModel : MovieModel = MovieModelImpl.shared
    private let userModel: UserModel = UserModelImpl.shared
    private var comingList: [MovieResult]?
    private var currentList: [MovieResult]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        registerForCells()
        setUpSourceAndDelegates()
        setUpViews()
        fetchUpComingMovieList()
        fetchCurrentMovieList()
        saveProfile()
    }
    
    private func setUpViews(){
        labelName.text = UDM.shared.defaults.string(forKey: "name")
        let profilePath =  "\(AppConstant.BASEURL)/\(UDM.shared.defaults.string(forKey: "image") ?? "")"
        imgProfile.sd_setImage(with: URL(string: profilePath))
        
        lblShowing.setMargins(margin: 16)
        lblComingSoon.setMargins(margin: 16)
    }
  
      
      
    private func registerForCells(){
          
        collectionViewNowShowing.registerForCell(identifier: NowShowingCollectionViewCell.identifier)
        collectionViewComingSoon.registerForCell(identifier: NowShowingCollectionViewCell.identifier)

    }
      
    private func setUpSourceAndDelegates(){
        collectionViewComingSoon.dataSource = self
        collectionViewComingSoon.delegate = self
          
        collectionViewNowShowing.dataSource = self
        collectionViewNowShowing.delegate = self
          
    }
    
    func onTapMovie(id: Int) {
        navigateToMovieDetailsViewController(id: id )

    }
    
    private func saveProfile(){
        userModel.saveProfile()
    }
    
   
    
    func fetchUpComingMovieList(){
        movieModel.getUpComingMovieList{ [weak self] (result) in
            guard let self = self else { return }
            switch result{
            case .success(let data):
                self.comingList = data
                self.collectionViewComingSoon.reloadData()
            case .failure(let message):
                print(message)
            }
        }
    }
    
    func fetchCurrentMovieList(){
        movieModel.getCurrentMovieList{ [weak self] (result) in
            guard let self = self else { return }
            switch result{
            case .success(let data):
                self.currentList = data
                self.collectionViewNowShowing.reloadData()
            case .failure(let message):
                print(message)
            }
        }
    }
    
   
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewNowShowing{
            return currentList?.count ?? 0
        }
        else {
            return comingList?.count ?? 0
            
        }
            
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueCell(identifier: NowShowingCollectionViewCell.identifier, indexPath: indexPath) as! NowShowingCollectionViewCell
        
        if collectionView == collectionViewNowShowing{
            cell.data = currentList?[indexPath.row]
        }
        else {
            cell.data = comingList?[indexPath.row]

        }

        
        cell.delegate = self
        return cell

    }
    
    
}
  

extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.5, height: CGFloat(300))
    }
}


