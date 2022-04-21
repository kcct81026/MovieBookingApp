//
//  WelcomeViewController.swift
//  MovieBookingApp
//
//  Created by KC on 20/02/2022.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var btnGetStarted: UIButton!
    @IBOutlet weak var img: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

       
        //img.alpha = 0.5
        
        btnGetStarted.addBorderColor(radius: 8, color: UIColor.lightGray.cgColor, borderWidth: 1)
        btnGetStarted.isUserInteractionEnabled = true
        let gestureRecoginizer = UITapGestureRecognizer(target: self, action: #selector(onTapView))
        btnGetStarted.addGestureRecognizer(gestureRecoginizer)
        
        
    }
    
    
    @objc func onTapView(){
        if UDM.shared.defaults.valueExits(forKey: "token"){
            navigateToMainViewController()
        }
        else{
            navigateToLoginVeiwController()

//            print("no token")
//            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let loginPage = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//            window?.rootViewController = loginPage
        }
        
       
    }

}