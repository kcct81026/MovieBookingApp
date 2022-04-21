//
//  Router.swift
//  MovieBookingApp
//
//  Created by KC on 20/02/2022.
//

import Foundation
import UIKit

enum StoryBoardName: String{
    case Main = "Main"
    case LaunchScreen = "LaunchScreen"
}

extension UIStoryboard{
    static func mainStoryBoard()-> UIStoryboard{
        UIStoryboard(name: StoryBoardName.Main.rawValue, bundle: nil)
    }
}

extension UIViewController{
    
    func navigateToMainViewController(){
        guard let vc = UIStoryboard.mainStoryBoard().instantiateViewController(identifier: ViewController.identifer) as? ViewController else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true)
    }
    
    func navigateToMovieTimeViewController(){
        guard let vc = UIStoryboard.mainStoryBoard().instantiateViewController(identifier: MovieTimeViewController.identifer) as? MovieTimeViewController else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true)
    }
    
    func navigateToMovieSeatViewController(){
        guard let vc = UIStoryboard.mainStoryBoard().instantiateViewController(identifier: MovieSeatViewController.identifer) as? MovieSeatViewController else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true)
    }
    
    func navigateToWelcomeViewController(){
        guard let vc = UIStoryboard.mainStoryBoard().instantiateViewController(identifier: WelcomeViewController.identifer) as? WelcomeViewController else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true)
    }
    
    func navigateToLoginVeiwController(){

        guard let vc = UIStoryboard.mainStoryBoard().instantiateViewController(identifier: LoginViewController.identifer) as? LoginViewController else {return}
        vc.modalPresentationStyle = .fullScreen
       // vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true)
    }
    
    func navigateToMovieDetailsViewController(id: Int){
//        guard let vc = UIStoryboard.mainStoryBoard().instantiateViewController(identifier: MovieDetailsViewController.identifer) as? MovieDetailsViewController else {return}
        guard let vc = UIStoryboard.mainStoryBoard().instantiateViewController(identifier: DetailController.identifer) as? DetailController else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        vc.id = id
        present(vc, animated: true)
    }
    
    func navigateToComboSetVeiwController(){
        guard let vc = UIStoryboard.mainStoryBoard().instantiateViewController(identifier: ComboSetViewController.identifer) as? ComboSetViewController else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true)
    }
    
    func navigateToPaymentVeiwController(){
        guard let vc = UIStoryboard.mainStoryBoard().instantiateViewController(identifier: PaymentViewController.identifer) as? PaymentViewController else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true)
    }
    
    func navigateToCardInfoFillFormVeiwController(){
        guard let vc = UIStoryboard.mainStoryBoard().instantiateViewController(identifier: CardInfoFillFormViewController.identifer) as? CardInfoFillFormViewController else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true)
    }
    
    func navigateToTicketVeiwController(){
        guard let vc = UIStoryboard.mainStoryBoard().instantiateViewController(identifier: TicketViewController.identifer) as? TicketViewController else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true)
    }
    
   
}

